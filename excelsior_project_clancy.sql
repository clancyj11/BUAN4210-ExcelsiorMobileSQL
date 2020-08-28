/*

Project 1: Excelsior Mobile Report
Joey Clancy

*/

-- Select the Excelsior_Mobile Database
USE Excelsior_Mobile;

-- QUERIES WITH CORRESPONDING VISUALIZATIONS

-- 1

-- A 

SELECT S.FirstName + ' ' + S.LastName AS 'Full Name', LMU.[Minutes], LMU.DataInMB, LMU.Texts, B.Total AS 'Total Bill'
FROM Subscriber AS S
	JOIN LastMonthUsage AS LMU
		ON S.[MIN] = LMU.[MIN]
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
ORDER BY S.FirstName + ' ' + S.LastName;

-- Shows each user's minutes, data usage, texts and total bills

-- B

SELECT S.City, AVG(LMU.[Minutes]) AS 'AvgMinutes', AVG(LMU.DataInMB) AS 'AvgDataInMB', AVG(LMU.Texts) AS 'AvgTexts', AVG(B.Total) AS 'AvgTotalBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.City;

-- Shows the average plan data for each city

-- C

SELECT S.City, SUM(LMU.[Minutes]) AS 'TotalMinutes', SUM(LMU.DataInMB) AS 'TotalDataInMB', SUM(LMU.Texts) AS 'TotalTexts', SUM(B.Total) AS 'SumOfBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.City;

-- Shows total plan data for each city

-- D

SELECT S.PlanName, AVG(LMU.[Minutes]) AS 'AvgMinutes', AVG(LMU.DataInMB) AS 'AvgDataInMB', AVG(LMU.Texts) AS 'AvgTexts', AVG(B.Total) AS 'AvgTotalBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.PlanName;

-- Shows average plan data for each plan

-- E

SELECT S.PlanName, SUM(LMU.[Minutes]) AS 'TotalMinutes', SUM(LMU.DataInMB) AS 'TotalDataInMB', SUM(LMU.Texts) AS 'TotalTexts', SUM(B.Total) AS 'SumOfBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.PlanName;

-- Shows total plan data for each plan



-- QUERIES WITHOUT CORRESPONDING VISUALIZATIONS

-- 1 --

-- A

SELECT TOP 2 City, COUNT(City) 
AS 'Top Cities'
FROM Subscriber
GROUP BY City
ORDER BY COUNT(City) DESC;

-- Returns the two cities with the most subscribers

-- B

SELECT TOP 3 City, COUNT(City)
AS 'Cities to Increase Marketing'
FROM Subscriber
GROUP BY City
ORDER BY COUNT(City) ASC;

-- Returns the cities with the least number of subscribers

-- C

SELECT TOP 3 PlanName, COUNT(PlanName)
AS 'Frequency'
FROM Subscriber
GROUP BY PlanName
ORDER BY COUNT(PlanName) DESC;

/*
Shows which plans we should market 
the most based on the number of people who have 
them (independent of which city they live in).
*/

-- 2 --

-- A

SELECT [Type] AS 'Device Type', COUNT([Type]) AS 'Number of Users'
FROM Device
GROUP BY [Type]
ORDER BY COUNT([Type]) DESC;

-- Returns what kind of device our customers are using

-- B

SELECT S.LastName, S.FirstName, D.[Type]
FROM Subscriber AS S
	JOIN DirNums AS DN
		ON S.MDN = DN.MDN
	JOIN Device AS D
		ON DN.IMEI = D.IMEI
GROUP BY S.LastName, D.[Type], S.FirstName
HAVING D.[Type] = 'Apple';

/*
From the previous query (2A), we know that the least common device 
type is from Apple. The query above uses an explicit double join 
to return which customers are using these Apple devices.
*/

-- C

SELECT S.LastName, S.FirstName, D.YearReleased
FROM Subscriber AS S
	JOIN DirNums AS DN
		ON S.MDN = DN.MDN
	JOIN Device AS D
		ON DN.IMEI = D.IMEI
WHERE D.YearReleased < '2018'
ORDER BY D.YearReleased DESC;

-- Query shows which users have devices released before 2018
-- Tried using GETDATE() but YearReleased in an integer
-- Would have been DATEADD(year, -4, GETDATE())

-- 3

-- If theres a city that uses a lot of data
-- but none of our customers in that city are using unlimited plan

-- A

SELECT TOP 3 S.City, SUM(LMU.DataInMB) AS 'TotalCityUsageMB'
FROM Subscriber AS S
	JOIN LastMonthUsage AS LMU
		ON S.MIN = LMU.MIN
GROUP BY S.City
ORDER BY SUM(LMU.DataInMB) DESC;

-- B

-- There was definitely a better way to do this but I couldn't figure it out
-- I tried using a condition WHERE City = ... OR ... OR ...
-- but it returned all users in the city regardless of the plan type

SELECT S.FirstName + ' ' + S.LastName AS 'Name', S.PlanName, S.City
FROM Subscriber AS S
GROUP BY S.City, S.FirstName + ' ' + S.LastName, S.PlanName
HAVING S.PlanName NOT LIKE '%Data%' AND S.City LIKE '%Oly%'
ORDER BY S.PlanName DESC;

SELECT S.FirstName + ' ' + S.LastName AS 'Name', S.PlanName, S.City
FROM Subscriber AS S
GROUP BY S.City, S.FirstName + ' ' + S.LastName, S.PlanName
HAVING S.PlanName NOT LIKE '%Data%' AND S.City LIKE '%Bell%'
ORDER BY S.PlanName DESC;

SELECT S.FirstName + ' ' + S.LastName AS 'Name', S.PlanName, S.City
FROM Subscriber AS S
GROUP BY S.City, S.FirstName + ' ' + S.LastName, S.PlanName
HAVING S.PlanName NOT LIKE '%Data%' AND S.City LIKE '%Sea%'
ORDER BY S.PlanName DESC;

-- Bellevue is the only high data usage city with no users using an unlimited plan

-- 4

-- A

SELECT TOP 1 S.FirstName + ' ' + S.LastName AS 'Full Name', B.Total AS 'Total Bill'
FROM Subscriber AS S
	JOIN Bill AS B
		ON S.[MIN] = B.[MIN]
GROUP BY S.FirstName + ' ' + S.LastName, B.Total
ORDER BY B.Total DESC;

-- Returns user with most expensive bill

-- B

SELECT TOP 1 S.PlanName, SUM(B.Total) AS 'Revenue'
FROM Subscriber AS S
	JOIN Bill AS B
		ON S.[MIN] = B.[MIN]
GROUP BY S.PlanName
ORDER BY Revenue DESC;

-- Shows that the UnlPrime plan generates the most revenue of all the plans

-- 5

-- A

SELECT TOP 1 LEFT(DN.MDN,3) AS 'AreaCode', SUM(LMU.[Minutes]) AS 'TotalMinutes'
FROM DirNums AS DN
	JOIN Subscriber AS S
		ON DN.MDN = S.MDN
	JOIN LastMonthUsage AS LMU
		ON S.MIN = LMU.MIN
GROUP BY LEFT(DN.MDN,3)
ORDER BY TotalMinutes DESC;

-- Shows that the 306 area code uses the most minutes

-- B

SELECT S.City, SUM(LMU.[Minutes]) AS 'TotalMinutes', VAR(LMU.[Minutes]) AS 'Variance Minutes'
FROM LastMonthUsage AS LMU
	JOIN Subscriber AS S
		ON LMU.[MIN] = S.[MIN]
GROUP BY S.City
HAVING SUM(LMU.[Minutes]) BETWEEN 200 AND 700 AND VAR(LMU.[Minutes]) IS NOT NULL
ORDER BY VAR(LMU.[Minutes]) DESC;

-- Returns the city with highest variance in minutes, out of all cities
-- with minute usage between 200 and 700.

-- Bellevue ends up with the highest variance in minutes usage.