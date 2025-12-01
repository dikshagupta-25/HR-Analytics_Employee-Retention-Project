use hr_analytics;

CREATE TABLE EmployeeData (
    EmployeeID INT,
    MonthlyIncome DECIMAL(10,2),
    MonthlyRate DECIMAL(10,2),
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime ENUM('Yes', 'No'),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,
    Age INT,
    Attrition ENUM('Yes', 'No'),
    BusinessTravel VARCHAR(50),
    DailyRate DECIMAL(10,2),
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender ENUM('Male', 'Female', 'Other'),
    HourlyRate DECIMAL(10,2),
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(50)
);

set global local_infile = 1;
set session local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

show variables like 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Downloads/HR Analysis CSV.csv'
INTO TABLE employeedata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * from employeedata;
select count(EmployeeID) from employeedata;
show tables;

-- 1.) Average Attrition rate for all Departments
SELECT Department,
       CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) * 100, 2), ' %') 
       as Attrition_Rate
FROM employeedata
GROUP BY Department;

-- 2.)Average Hourly rate of Male Research Scientist
SELECT CONCAT(FORMAT(AVG(HourlyRate), 2), ' %') as AvgHourlyRatePercentage
FROM employeedata 
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';

-- 3.) Attrition rate Vs Monthly income stats
SELECT 
    CASE
        WHEN MonthlyIncome < 10000 THEN '<10K'
        WHEN MonthlyIncome BETWEEN 10000 AND 19999 THEN '10K–20K'
        WHEN MonthlyIncome BETWEEN 20000 AND 29999 THEN '20K–30K'
        WHEN MonthlyIncome BETWEEN 30000 AND 39999 THEN '30K–40K'
        WHEN MonthlyIncome BETWEEN 40000 AND 49999 THEN '40K–50K'
        ELSE '50K+'
    END AS Income_Band,

    CONCAT(ROUND(COUNT(*) / 1000, 2), ' K') AS Total_Employees,

    CONCAT(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / 1000, 2), ' K') AS Attrited_Employees,

    CONCAT(
        ROUND(
            (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
            2
        ), ' %'
    ) AS Attrition_Rate_Percent

FROM Employeedata
GROUP BY 
    CASE
        WHEN MonthlyIncome < 10000 THEN '<10K'
        WHEN MonthlyIncome BETWEEN 10000 AND 19999 THEN '10K–20K'
        WHEN MonthlyIncome BETWEEN 20000 AND 29999 THEN '20K–30K'
        WHEN MonthlyIncome BETWEEN 30000 AND 39999 THEN '30K–40K'
        WHEN MonthlyIncome BETWEEN 40000 AND 49999 THEN '40K–50K'
        ELSE '50K+'
    END
ORDER BY MIN(MonthlyIncome);


-- 4.) Average working years for each Department
SELECT 
    Department,
    CONCAT(ROUND(AVG(TotalWorkingYears), 2), ' Years') AS avg_working_years
FROM employeedata
GROUP BY Department;

-- 5.) Job Role Vs Work life balance
SELECT 
    JobRole,
    REPEAT('⭐', ROUND(AVG(WorkLifeBalance))) AS avg_work_life_balance
FROM employeedata
GROUP BY JobRole;

-- 6.) Attrition rate Vs Year since last promotion relation
SELECT
    CASE
        WHEN YearsSinceLastPromotion < 10 THEN '<10'
        WHEN YearsSinceLastPromotion < 20 THEN '<20'
        WHEN YearsSinceLastPromotion < 30 THEN '<30'
        ELSE '<40'
    END AS Promotion_Band,

    concat(round(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2)," %"
    ) AS Attrition_Rate

FROM Employeedata
GROUP BY
    CASE
        WHEN YearsSinceLastPromotion < 10 THEN '<10'
        WHEN YearsSinceLastPromotion < 20 THEN '<20'
        WHEN YearsSinceLastPromotion < 30 THEN '<30'
        ELSE '<40'
    END
ORDER BY MIN(YearsSinceLastPromotion);

 -- 7.) Departmentwise No of Employees
SELECT 
Department,
CONCAT(ROUND(SUM(EmployeeCount)/1000, 2), ' K') AS Emp_Count
FROM employeedata
GROUP BY Department;

-- 8.) Count of Employees based on Educational Fields
SELECT 
    EducationField,
    CONCAT(ROUND(SUM(EmployeeCount) / 1000, 2), ' K') AS Total_Employee
FROM employeedata
GROUP BY EducationField;

-- 9.) Gender based Percentage of Employee
SELECT 
    Gender, 
    CONCAT(FORMAT((COUNT(Gender) * 100.0 / (SELECT COUNT(*) FROM employeedata)), 2), ' %') 
        AS Employees_rate
FROM employeedata
GROUP BY Gender;

-- 10.)Deptarment / Job Role wise job satisfaction
SELECT 
    JobRole,
    REPEAT('⭐', ROUND(AVG(JobSatisfaction))) AS JobSatisfaction
FROM employeedata
GROUP BY JobRole;

-- 11.) Total employees based on marital status
SELECT 
    MaritalStatus,
    CONCAT(ROUND(COUNT(EmployeeID) / 1000, 2), ' K') AS Total_Employees
FROM employeedata
GROUP BY MaritalStatus;












 









