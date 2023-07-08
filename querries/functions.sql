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
