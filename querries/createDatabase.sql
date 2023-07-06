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


