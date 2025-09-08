CREATE DATABASE ds_salaries;
USE ds_salaries;


/* creating table */
CREATE TABLE salaries (
    work_year INT,
    experience_level VARCHAR(10),
    employment_type VARCHAR(10),
    job_title VARCHAR(255),
    salary FLOAT,
    salary_currency VARCHAR(10),
    salary_in_usd FLOAT,
    employee_residence VARCHAR(10),
    remote_ratio INT,
    company_location VARCHAR(10),
    company_size VARCHAR(10)
);


/* importing data into MySQL */
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ds_salaries.csv"
INTO TABLE salaries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


/* counting total number of rows and columns */
SELECT COUNT(*) AS total_rows
FROM salaries;
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ds_salaries' AND TABLE_NAME = 'salaries';


/* checking for NULLs */
SELECT * FROM salaries;
SELECT COUNT(*) FROM salaries
WHERE salary_in_usd IS NULL OR job_title IS NULL;


/* checking for duplicates */
SELECT work_year, experience_level, employment_type, job_title,
       salary, salary_currency, salary_in_usd,
       employee_residence, remote_ratio, company_location, company_size,
       COUNT(*) as count
FROM salaries
GROUP BY work_year, experience_level, employment_type, job_title,
         salary, salary_currency, salary_in_usd,
         employee_residence, remote_ratio, company_location, company_size
HAVING count > 1;



/* deleting duplicates */
ALTER TABLE salaries ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM salaries
WHERE id IN (
    SELECT id FROM (
        SELECT s1.id
        FROM salaries s1
        JOIN salaries s2
        ON 
            s1.work_year = s2.work_year AND
            s1.experience_level = s2.experience_level AND
            s1.employment_type = s2.employment_type AND
            s1.job_title = s2.job_title AND
            s1.salary = s2.salary AND
            s1.salary_currency = s2.salary_currency AND
            s1.salary_in_usd = s2.salary_in_usd AND
            s1.employee_residence = s2.employee_residence AND
            s1.remote_ratio = s2.remote_ratio AND
            s1.company_location = s2.company_location AND
            s1.company_size = s2.company_size AND
            s1.id > s2.id
    ) AS duplicates_to_delete
);
ALTER TABLE salaries DROP COLUMN id;
SET SQL_SAFE_UPDATES = 1;



/* EXPLORATORY DATA ANALYSIS IN SQL */

/* general stats */
SELECT COUNT(*) AS total_jobs, 
	AVG(salary_in_usd) AS avg_salary 
FROM salaries;

/* 1. average salary by job_title */
SELECT job_title, ROUND(AVG(salary_in_usd),2) AS avg_salary, COUNT(*) AS total_employees
FROM salaries
GROUP BY job_title
ORDER BY avg_salary DESC;

/* 2. average salary by experience level */
SELECT experience_level, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY experience_level;

/* 3. average salary by company size */
SELECT company_size, AVG(salary_in_usd) AS avg_salary
FROM salaries
GROUP BY company_size
ORDER BY avg_salary DESC;


/* 4. top 5 highest paying countries */
SELECT company_location, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 10;

/* 5. salary trends by year */
SELECT work_year, ROUND(AVG(salary_in_usd), 2) AS avg_salary, COUNT(*) AS records
FROM salaries
GROUP BY work_year
ORDER BY work_year;

/* 6. remote ratio vs salary */
SELECT remote_ratio, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY remote_ratio
ORDER BY avg_salary DESC;


/* 7. maximum salary for all job titles */
SELECT job_title, MAX(salary_in_usd) AS max_salary
FROM salaries
GROUP BY job_title
ORDER BY max_salary DESC;


/* 8. top 10 countries by number of data roles */
SELECT employee_residence AS country, COUNT(*) AS total_roles
FROM salaries
GROUP BY employee_residence
ORDER BY total_roles DESC
LIMIT 10;


/* 9. remote work vs onsite - average salaries */
SELECT remote_ratio,
       COUNT(*) AS num_employees,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY remote_ratio
ORDER BY remote_ratio DESC;


/* 10. employment type distribution */
SELECT employment_type,
       COUNT(*) AS count,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY employment_type;


/* 11. experience level impact */
SELECT experience_level,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM salaries
GROUP BY experience_level
ORDER BY avg_salary DESC;


/* 12. most common job titles */
SELECT job_title, COUNT(*) AS job_count
FROM salaries
GROUP BY job_title
ORDER BY job_count DESC
LIMIT 10;


/* 13. count of Data Scientists by experience level */
SELECT experience_level, COUNT(*) AS count
FROM salaries
WHERE job_title = 'Data Scientist'
GROUP BY experience_level;






