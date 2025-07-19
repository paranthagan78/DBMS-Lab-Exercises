REM Employees Relation
REM ******************

REM 9. Display first name, job id and salary of all the employees.
REM **************************************************************

SELECT FIRST_NAME, JOB_ID, SALARY FROM Employees;

REM 10. Display the id, name(first & last), salary and annual salary of all the employees. 
REM Sort the employees by first name. Label the columns as shown below:
REM (EMPLOYEE_ID, FULL NAME, MONTHLY SAL, ANNUAL SALARY)
REM ***********************************************************************************

SELECT EMPLOYEE_ID AS "EMPLOYEE_ID",
CONCAT(CONCAT(FIRST_NAME, ' '),  LAST_NAME) AS "FULL_NAME",
SALARY AS "MONTHLY SAL",
SALARY * 12 AS "ANNUAL SALARY"
FROM Employees
ORDER BY FIRST_NAME; 

REM  11. List the different jobs in which the employees are working for.
REM  **************************************************************

SELECT DISTINCT JOB_ID FROM EMPLOYEES;

REM 12. Display the id, first name, job id, salary and commission of employees who are 
REM earning commissions.
REM *******************************************************************************

SELECT EMPLOYEE_ID, FIRST_NAME, 
JOB_ID, SALARY, COMMISSION_PCT
FROM Employees
WHERE COMMISSION_PCT IS NOT NULL;

REM 13. Display the details (id, first name, job id, salary and dept id) of employees who are MANAGERS
REM **************************************************************************************************

SELECT EMPLOYEE_ID, FIRST_NAME,
SALARY, DEPARTMENT_ID
FROM Employees 
WHERE JOB_ID LIKE '%MAN' OR JOB_ID LIKE '%MGR';

REM 14. Display the details of employees other than sales representatives (id, first name,
REM hire date, job id, salary and dept id) who are hired after ‘01-May-1999’ or whose
REM salary is at least 10000.
REM **************************************************************************************

SELECT EMPLOYEE_ID, FIRST_NAME,
HIRE_DATE, JOB_ID,
SALARY, DEPARTMENT_ID 
FROM Employees
WHERE JOB_ID <> 'SA_REP' AND 
((HIRE_DATE > TO_DATE('01-MAY-1999', 'dd-MON-yyyy')) OR
SALARY > 10000);

REM 15. Display the employee details (first name, salary, hire date and dept id) whose
REM salary falls in the range of 5000 to 15000 and his/her name begins with any of
REM characters (A,J,K,S). Sort the output by first name.
REM ***********************************************************************************

SELECT FIRST_NAME, SALARY,
HIRE_DATE, DEPARTMENT_ID
FROM Employees
WHERE ((SALARY BETWEEN 5000 AND 15000) AND 
(
(FIRST_NAME LIKE 'A%') OR 
(FIRST_NAME LIKE 'J%') OR 
(FIRST_NAME LIKE 'K%') OR 
(FIRST_NAME LIKE 'S%')
)
)
ORDER BY FIRST_NAME;

REM 16. Display the experience of employees in no. of years and months who were hired
REM after 1998. Label the columns as: (EMPLOYEE_ID, FIRST_NAME, HIRE_DATE, EXP-YRS,
REM EXP-MONTHS)
REM *********************************************************************************

SELECT EMPLOYEE_ID AS "EMPLOYEE_ID",
FIRST_NAME AS "FIRST_NAME",
HIRE_DATE AS "HIRE_DATE", 
ROUND((SYSDATE - HIRE_DATE)/365, 0) AS "EXP-YRS",
ROUND((MOD((SYSDATE - HIRE_DATE ), 365)/30), 0) AS "EXP-MONTHS"
FROM Employees
WHERE HIRE_DATE >= TO_DATE('01-JAN-1998', 'dd-MON-yyyy');

REM 17. Display the total number of departments.
REM ****************************************

SELECT COUNT(DISTINCT DEPARTMENT_ID) FROM EMPLOYEES;

REM 18. Show the number of employees hired by year-wise. Sort the result by year-wise.
REM **********************************************************************************

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS HIRE_YEAR,
COUNT(*) AS NUM_OF_EMPLOYEES
FROM Employees
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY HIRE_YEAR;

REM 19. Display the minimum, maximum and average salary, number of employees for
REM each department. Exclude the employee(s) who are not in any department.
REM Include the department(s) with at least 2 employees and the average salary is
REM more than 10000. Sort the result by minimum salary in descending order
REM *****************************************************************************

SELECT DEPARTMENT_ID,
MIN(SALARY) AS MIN_SALARY,
MAX(SALARY) AS MAX_SALARY,
AVG(SALARY) AS AVERAGE_SALARY,
COUNT(*) AS NUM_OF_EMPLOYEES
FROM Employees
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 2 AND AVG(SALARY) > 10000
ORDER BY MIN(SALARY) DESC;