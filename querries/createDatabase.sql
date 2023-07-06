-- Creating employees table
-- Table: application.employees

-- DROP TABLE IF EXISTS application.employees;

CREATE TABLE IF NOT EXISTS application.employees
(
    id integer NOT NULL DEFAULT nextval('application.employees_id_seq'::regclass),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric(8,2) NOT NULL,
    title_id integer NOT NULL,
    manager_id integer,
    team integer,
    CONSTRAINT employees_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.employees
    OWNER to "Femi";


-- Creating hour_tracking table
-- Table: application.hour_tracking

-- DROP TABLE IF EXISTS application.hour_tracking;

CREATE TABLE IF NOT EXISTS application.hour_tracking
(
    employee_id integer NOT NULL,
    project_id integer,
    total_hours integer NOT NULL,
    CONSTRAINT employee_id_fk FOREIGN KEY (employee_id)
        REFERENCES application.employees (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT project_id_fk FOREIGN KEY (project_id)
        REFERENCES application.projects (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.hour_tracking
    OWNER to "Femi";


-- Creating projects table
-- Table: application.projects

-- DROP TABLE IF EXISTS application.projects;

CREATE TABLE IF NOT EXISTS application.projects
(
    id integer NOT NULL DEFAULT nextval('application.projects_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    client character varying COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.projects
    OWNER to "Femi";



-- Creating team_project table
-- Table: application.team_project

-- DROP TABLE IF EXISTS application.team_project;

CREATE TABLE IF NOT EXISTS application.team_project
(
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT project_id_fk FOREIGN KEY (project_id)
        REFERENCES application.projects (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.team_project
    OWNER to "Femi";


-- Creating teams table
-- Table: application.teams

-- DROP TABLE IF EXISTS application.teams;

CREATE TABLE IF NOT EXISTS application.teams
(
    id integer NOT NULL DEFAULT nextval('application.teams_id_seq'::regclass),
    team_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    location character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT teams_pkey PRIMARY KEY (id),
    CONSTRAINT team_name_unique UNIQUE (team_name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.teams
    OWNER to "Femi";