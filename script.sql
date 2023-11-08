use employees_mod;

select year(d.from_date) as calendar_year, e.gender as gender, count(e.emp_no) as num_employees
from t_dept_emp d
join t_employees e on d.emp_no=e.emp_no
group by calendar_year, gender
having calendar_year >= 1990
order by calendar_year, gender;

select d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calendar_year,
case 
	when year(dm.to_date)>=calendar_year and year(dm.from_date)<=calendar_year then 1 else 0 end as active_status
from (select year(hire_date) as calendar_year from t_employees group by calendar_year) as e
cross join
t_dept_manager dm 
join 
t_departments d on dm.dept_no=d.dept_no
join
t_employees ee on ee.emp_no= dm.emp_no
order by dm.emp_no,calendar_year;

select e.gender,d.dept_name,round(avg(s.salary),2) as average_salary,year(s.from_date) as calendar_year
from t_salaries s
join
t_employees e on s.emp_no=e.emp_no
join
t_dept_emp de on de.emp_no=e.emp_no
join
t_departments d on d.dept_no = de.dept_no
group by d.dept_no,e.gender,calendar_year
having calendar_year<=2002
order by d.dept_no;

DELIMITER $$
create procedure filter_salary(IN p_min_sal float, in p_max_sal float)
begin
	select e.gender,d.dept_name,avg(s.salary) as average_salary
    from
    t_salaries s
    join
    t_employees e on s.emp_no =e.emp_no
    join
    t_dept_emp de on de.emp_no = e.emp_no
    join 
    t_departments d on d.dept_no=de.dept_no
    where s.salary between p_min_sal and p_max_sal
    group by d.dept_no, e.gender;
end $$
delimiter ;

call filter_salary(50000,90000);

