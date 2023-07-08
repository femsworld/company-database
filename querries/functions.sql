-- FUNCTION: application.track_working_hours(integer, integer, numeric)

-- DROP FUNCTION IF EXISTS application.track_working_hours(integer, integer, numeric);

CREATE OR REPLACE FUNCTION application.track_working_hours(
	p_employee_id integer,
	p_project_id integer,
	p_total_hours numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
  track_working_hours numeric;
  total_hours_returned numeric;
begin
  if not exists (
    select 1 from application.employees where id = p_employee_id
  ) then
    raise exception 'Employee with ID % does not exist.', p_employee_id;
  end if;

  if not exists (
    select 1 from application.projects where id = p_project_id
  ) then
    raise exception 'Project with ID % does not exist.', p_project_id;
  end if;

  insert into application.hour_tracking (employee_id, project_id, total_hours)
  values (p_employee_id, p_project_id, p_total_hours)
  returning total_hours into total_hours_returned;

  raise notice 'Working hours tracked successfully for Employee ID % on Project ID %.',
    p_employee_id,
    p_project_id;

  return total_hours_returned;
end;
$BODY$;

ALTER FUNCTION application.track_working_hours(integer, integer, numeric)
    OWNER TO postgres;


-- Create a function `create_project_with_teams` to create a project 
-- and assign teams to that project simultaneously. Test this function

CREATE FUNCTION application.create_project_with_teams(IN p_project_name character varying, IN p_client character varying, IN p_start_date date, IN p_deadline date, IN p_team_ids integer[])
    RETURNS void
    LANGUAGE 'plpgsql'
    
AS $BODY$
declare
    project_id integer;
	team_id integer;
begin
    insert into application.projects (name, client, start_date, deadline)
    values (p_project_name, p_client, p_start_date, p_deadline)
    returning id into project_id;

    foreach team_id in array p_team_ids loop
        insert into application.team_project (team_id, project_id)
        values (team_id, project_id);
    end loop;

    raise notice 'Project "%", ID % created successfully with teams: %', p_project_name, project_id, p_team_ids;
end;
$BODY$;

ALTER FUNCTION application.create_project_with_teams(character varying, character varying, date, date, integer[])
    OWNER TO postgres;