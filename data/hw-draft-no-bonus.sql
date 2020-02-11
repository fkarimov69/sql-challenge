-- -- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- -- Link to schema: https://app.quickdatabasediagrams.com/#/d/gffhY9
-- -- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
-- DROP TABLE department CASCADE;
-- DROP TABLE dept_employee CASCADE;
-- DROP TABLE dept_manager CASCADE;
-- DROP TABLE employee CASCADE;
-- DROP TABLE salaries CASCADE;
-- DROP TABLE titles CASCADE;
-- DROP TABLE dept_emplpyee CASCADE;

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "titles" (
    "emp_id" int   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "department" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_department" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_employee" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "employee" (
    "emp_no" int   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employee" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employee" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_id" FOREIGN KEY("emp_id")
REFERENCES "employee" ("emp_no");

ALTER TABLE "dept_employee" ADD CONSTRAINT "fk_dept_employee_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employee" ("emp_no");

ALTER TABLE "dept_employee" ADD CONSTRAINT "fk_dept_employee_dept_no" FOREIGN KEY("dept_no")
REFERENCES "department" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "department" ("dept_no");

--List employee number, last name, first name, gender, and salary
SELECT em.emp_no,em.last_name,em.first_name, em.gender, sa.salary
FROM employee em
	JOIN  salaries sa ON em.emp_no=sa.emp_no;
	
--List employees who were hired in 1986.
SELECT emp_no,last_name,first_name,date_part('year',hire_date) FROM employee
	WHERE date_part('year',hire_date)= 1986;
	
--List the manager of each department with the following information:
--department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

SELECT dm.dept_no, d.dept_name, dm.emp_no, em.last_name, em.first_name,de.from_date, de.to_date FROM employee em
	JOIN dept_manager dm ON em.emp_no=dm.emp_no
	JOIN department d ON dm.dept_no=d.dept_no
	JOIN dept_employee de ON de.emp_no=em.emp_no;
	
--List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT em.emp_no, em.last_name, em.first_name, d.dept_name FROM employee em
	JOIN dept_employee de ON em.emp_no=de.emp_no
	JOIN department d ON de.dept_no=d.dept_no;
	
--List all employees whose first name is "Hercules" and last names begin with "B."

SELECT emp_no,last_name,first_name FROM employee
	WHERE first_name LIKE 'Hercules'
	AND last_name LIKE 'B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
--option 1
SELECT em.emp_no,em.last_name,em.first_name FROM employee em
	--JOIN dept_employee de ON em.emp_no=de.emp_no
	--JOIN department d ON de.dept_no=d.dept_no
		WHERE em.emp_no IN
		(SELECT de.emp_no FROM dept_employee de
		 	WHERE de.dept_no IN
		 		(SELECT d.dept_no FROM department d
				 	WHERE d.dept_name LIKE 'Sales'));

--option 2
SELECT em.emp_no,em.last_name,em.first_name,d.dept_name FROM employee em
	JOIN dept_employee de ON em.emp_no=de.emp_no
	JOIN department d ON de.dept_no=d.dept_no
		WHERE d.dept_name LIKE 'Sales';
		
--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT em.emp_no,em.last_name,em.first_name,d.dept_name FROM employee em
	JOIN dept_employee de ON em.emp_no=de.emp_no
	JOIN department d ON de.dept_no=d.dept_no
		WHERE d.dept_name IN ('Sales','Development');
		
--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name, COUNT(last_name) counts FROM employee
GROUP BY last_name
ORDER BY counts DESC;
--SELECT last_name,first_name FROM employee
--where last_name like 'Breugel'
