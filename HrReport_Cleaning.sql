CREATE DATABASE HumanResource;

SELECT * FROM humanresource.hr;
--------------------------------------- Cleaning Data ---------------------------------------
-- rename table id
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id varCHAR(20) NUlL;

-- check type
DESCRIBE hr;

-- The birthdate, hiredate and termdate field are not clean, and they are not in the correct type
-- Clean birthdate column
SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change type
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Similar to hiredate 
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

Select hire_date from hr;

-- Termdate
SELECT termdate from hr;
-- Update value from '' to null
UPDATE hr
SET termdate = NULLIF(termdate,'')
WHERE termdate IS NOT NULL AND termdate = '';

-- update value to correct format
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL ;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


-- Add column AGE
ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

-- Check data 
SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;
-- We can see that min age is smaller than zero, that can be the error of person who Fill in information
-- Let's check how many values smaller than zero 
SELECT COUNT(*) FROM hr Where age < 0

