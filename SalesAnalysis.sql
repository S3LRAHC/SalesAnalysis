------ Task 0: Removing NULL rows, non-2019 data, & combining tables into one table

DELETE FROM Sales_September_2019 WHERE Order_ID IS NULL; -- Change this based on table

SELECT * INTO dbo.Sales2019 FROM dbo.Sales_January_2019 -- Create new table based off January sales

INSERT INTO Sales2019
SELECT * FROM Sales_December_2019 -- Change this for inserting different sales month

DELETE FROM Sales2019 WHERE YEAR(Order_Date) <> 2019

------ Task 1: Determining monthly revenue to find best month of sales

SELECT MONTH(Order_Date) AS Month, SUM(Quantity_Ordered * Price_Each) AS [Monthly Revenue] 
FROM Sales2019
GROUP BY MONTH(Order_Date)
ORDER BY [Monthly Revenue] DESC

-- Ans: December is the month with highest monthly revenue at $4,613,443.32

------ Task 2: Finding city with highest number of sales

SELECT 
	SUBSTRING(Purchase_Address, 
	CHARINDEX(',', Purchase_Address) + 2,
	CHARINDEX(',', Purchase_Address, CHARINDEX(',', Purchase_Address) + 1) - CHARINDEX(',', Purchase_Address) - 2) AS City, 
	SUM(Quantity_Ordered * Price_Each) AS [City Revenue]
FROM Sales2019
GROUP BY SUBSTRING(Purchase_Address, 
	CHARINDEX(',', Purchase_Address) + 2,
	CHARINDEX(',', Purchase_Address, CHARINDEX(',', Purchase_Address) + 1) - CHARINDEX(',', Purchase_Address) - 2)
ORDER BY [City Revenue] DESC

-- Ans: City with highest sales is San Fransisco with $8,262,203.87

------ Task 3: Finding best time to display advertisements to increase likelihood of customer buying product

SELECT DATEPART(HOUR, Order_Date) AS OrderHour, COUNT(Order_ID) AS NumOrders
FROM Sales2019
GROUP BY DATEPART(HOUR, Order_Date)
ORDER BY NumOrders DESC

-- Ans: Peak sales occur at 7pm or 12pm. Begin showing advertisements a couple hours before like 5pm or 10am
--		as this is when sales rate is increasing

------ Task 4: Finding products that are most often sold together

SELECT A.Product AS Item_Bought, B.Product AS Bought_With, COUNT(*) AS Num_Orders
FROM Sales2019 A
INNER JOIN Sales2019 B
ON A.Order_ID = B.Order_ID AND A.Product <> B.Product 
GROUP BY A.Product, B.Product
ORDER BY Num_Orders DESC

-- Ans: Phones and charging cables were most often sold together

------ Task 5: Finding the product that sold the most

SELECT Product, SUM(Quantity_Ordered) AS NumSales, Price_Each AS Price
FROM Sales2019
GROUP BY Product, Price_Each
ORDER BY NumSales DESC

-- Ans: AAA batteries sold the most
