-- Retrieve the team names and their corresponding project count
select
    t.team_name,
    count(tp.project_id) as project_count
from
    application.teams t
    left join application.team_project tp on t.id = tp.team_id
group by
    t.team_name;

--Retrieve the projects managed by the managers whose first name starts with "J" or "D"
select
    p.name as project_name,
    e.first_name as manager_first_name,
    e.last_name AS manager_last_name
from
    application.projects p
    join application.employees e on p.id = e.manager_id
where
    e.first_name like 'J%'
    or e.first_name like 'D%';

-- Retrieve all the employees (both directly and indirectly) working under Andrew Martin
with recursive subordinates as (
    select
        id,
        first_name,
        last_name,
        manager_id
    from
        application.employees
    where
        first_name = 'Andrew'
        and last_name = 'Martin'
    union
    all
    select
        e.id,
        e.first_name,
        e.last_name,
        e.manager_id
    from
        application.employees e
        inner join subordinates s on s.id = e.manager_id
)
select
    *
from
    subordinates;

--Retrieve all the employees (both directly and indirectly) working under Robert Brown
with recursive subordinates as (
    select
        id,
        first_name,
        last_name,
        manager_id
    from
        application.employees
    where
        first_name = 'Robert'
        and last_name = 'Brown'
    union
    all
    select
        e.id,
        e.first_name,
        e.last_name,
        e.manager_id
    from
        application.employees e
        inner join subordinates s on s.id = e.manager_id
)
select
    *
from
    subordinates;

--Retrieve the average hourly salary for each title
select
    t.name as title_name,
    avg(e.hourly_salary) as average_hourly_salary
from
    application.titles t
    join application.employees e on t.id = e.title_id
group by
    t.name;

--Retrieve the employees who have a higher hourly salary than their
-- respective team's average hourly salary
with team_avg_salary as (
    select
        team,
        avg(hourly_salary) as avg_hourly_salary
    from
        application.employees
    group by
        team
)
select
    e.first_name,
    e.last_name,
    e.hourly_salary,
    t.team_name,
    tas.avg_hourly_salary
from
    application.employees e
    join application.teams t on e.team = t.id
    join team_avg_salary tas on e.team = tas.team
where
    e.hourly_salary > tas.avg_hourly_salary;

--Retrieve the projects that have more than 3 teams assigned to them
select
    p.name as project_name,
    count(tp.team_id) as team_count
from
    application.projects p
    join application.team_project tp ON p.id = tp.project_id
group by
    p.name
having
    count(tp.team_id) > 3;

--same querry using "where" instead of "having"
select
    p.name as project_name,
    count(tp.team_id) as team_count
from
    application.projects p
    join application.team_project tp ON p.id = tp.project_id
where
    (
        select
            count(distinct team_id)
        from
            application.team_project
        where
            project_id = p.id
    ) > 3
group by
    p.name;

--Retrieve the total hourly salary expense for each team
select
    t.team_name,
    sum(e.hourly_salary) as total_hourly_salary_expense
from
    application.teams t
    join application.employees e on t.id = e.team
group by
    t.team_name;