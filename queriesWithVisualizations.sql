USE Excelsior_Mobile;

-- 1

-- A 

SELECT S.FirstName + ' ' + S.LastName AS 'Full Name', LMU.[Minutes], LMU.DataInMB, LMU.Texts, B.Total AS 'Total Bill'
FROM Subscriber AS S
	JOIN LastMonthUsage AS LMU
		ON S.[MIN] = LMU.[MIN]
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
ORDER BY S.FirstName + ' ' + S.LastName;

-- B

SELECT S.City, AVG(LMU.[Minutes]) AS 'AvgMinutes', AVG(LMU.DataInMB) AS 'AvgDataInMB', AVG(LMU.Texts) AS 'AvgTexts', AVG(B.Total) AS 'AvgTotalBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.City;

-- C

SELECT S.City, SUM(LMU.[Minutes]) AS 'TotalMinutes', SUM(LMU.DataInMB) AS 'TotalDataInMB', SUM(LMU.Texts) AS 'TotalTexts', SUM(B.Total) AS 'SumOfBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.City;

-- D

SELECT S.PlanName, AVG(LMU.[Minutes]) AS 'AvgMinutes', AVG(LMU.DataInMB) AS 'AvgDataInMB', AVG(LMU.Texts) AS 'AvgTexts', AVG(B.Total) AS 'AvgTotalBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.PlanName;

-- E

SELECT S.PlanName, SUM(LMU.[Minutes]) AS 'TotalMinutes', SUM(LMU.DataInMB) AS 'TotalDataInMB', SUM(LMU.Texts) AS 'TotalTexts', SUM(B.Total) AS 'SumOfBill'
FROM LastMonthUsage AS LMU
	JOIN Bill AS B
		ON LMU.[MIN] = B.[MIN]
	JOIN Subscriber AS S
		ON B.[MIN] = S.[MIN]
GROUP BY S.PlanName;