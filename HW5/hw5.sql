--1. Выберите заказчиков из Германии, Франции и Мадрида, выведите их название, страну и адрес.
--SELECT 
--CustomerName
--,Country
--,Address
--FROM Customers
--WHERE Country in ('Germany', 'France', 'Spain')

--2. Выберите топ 3 страны по количеству заказчиков, выведите их названия и количество записей.
--SELECT TOP 3
--Country
--,COUNT(Country) AS CountCustomers
--FROM Customers
--GROUP BY Country
--ORDER BY CountCustomers DESC

--3. Выберите перевозчика, который отправил 10-й по времени заказ, выведите его название, и дату отправления.
--SELECT * FROM
--(
--	SELECT
--	ROW_NUMBER() OVER (ORDER BY OrderDate ASC) AS rownumber
--	,[sh].ShipperName
--	,[o].OrderDate
--	FROM [dbo].[Orders] AS [o]
--	INNER JOIN Shippers AS [sh]
--	ON [sh].ShipperID = [o].ShipperID
--) AS foo
--WHERE rownumber = 10

--4. Выберите самый дорогой заказ, выведите список товаров с их ценами.
	-- группирую данные по стоимости каждого заказа
--WITH AllPrice AS (
--	SELECT
--    od.OrderID
--	,SUM(CONVERT(FLOAT,p.[Price])) AS ProductsPrice
--	FROM OrderDetails AS od
--	INNER JOIN Products AS p
--	ON od.ProductID = p.ProductID
--	GROUP BY (od.OrderID)
--)
--SELECT
--	p.ProductName
--	,p.Price
--FROM OrderDetails AS od
--INNER JOIN Products AS p
--ON od.ProductID = p.ProductID
--WHERE od.OrderID = (SELECT TOP 1 OrderID FROM AllPrice ORDER BY ProductsPrice DESC)

--5. Какой товар больше всего заказывали по количеству единиц товара, выведите его название и количество единиц в каждом из заказов.
--SELECT TOP 1
--ProductID
--FROM OrderDetails
--GROUP BY (ProductID)
--ORDER BY SUM(CONVERT(FLOAT, Quantity)) DESC

--SELECT
--od.OrderID
--,od.Quantity
--FROM OrderDetails AS od
--INNER JOIN Products AS p
--ON od.ProductID = p.ProductID
--WHERE p.ProductID = (
--	SELECT TOP 1
--    ProductID
--	FROM OrderDetails
--	GROUP BY (ProductID)
--	ORDER BY SUM(CONVERT(FLOAT, Quantity)) DESC
--)

--6. Выведите топ 5 поставщиков по количеству заказов, выведите их названия, страну, контактное лицо и телефон.
--WITH top5 AS(
--SELECT TOP 5
--	  sup.SupplierID
--  FROM OrderDetails AS od
--  INNER JOIN Products AS p
--  on od.ProductID = p.ProductID
--  INNER JOIN Suppliers AS sup
--  ON p.SupplierID = sup.SupplierID
--  GROUP BY sup.SupplierID
--  ORDER BY COUNT(sup.SupplierID) DESC
--)

--SELECT
--SupplierName
--,Country
--,ContactName
--,Phone
--FROM Suppliers
--WHERE SupplierID IN (SELECT * FROM top5)

--7. Какую категорию товаров заказывали больше всего по стоимости в Бразилии, выведите страну, название категории и сумму.

--WITH JoinedTable AS (
--	SELECT
--	c.Country
--	,CONVERT(FLOAT, od.Quantity)*CONVERT(FLOAT, p.Price) AS ResProductPrice
--	,cat.CategoryName
--	FROM Orders				AS o
--	INNER JOIN OrderDetails AS od	ON o.OrderID = od.OrderID
--	INNER JOIN Customers	AS c	ON o.CustomerID = c.CustomerID
--	INNER JOIN Products		AS p	ON od.ProductID = p.ProductID
--	INNER JOIN Categories	AS cat  ON p.CategoryID = cat.CategoryID
--)

--SELECT
--CategoryName
--,SUM(ResProductPrice) AS CategoryFullPrice
--FROM JoinedTable
--WHERE Country = 'Brazil'
--GROUP BY CategoryName
--ORDER BY CategoryFullPrice DESC
  
--8. Какая разница в стоимости между самым дорогим и самым дешевым заказом из США.
--WITH t AS (
--	SELECT
--	o.OrderID	
--	,SUM(CONVERT(FLOAT, od.Quantity)*CONVERT(FLOAT, p.Price)) AS ResPrice
--	FROM Orders				AS o
--	INNER JOIN OrderDetails AS od ON o.OrderID = od.OrderID
--	INNER JOIN Customers	AS c  ON o.CustomerID = c.CustomerID
--	INNER JOIN Products		AS p  ON od.ProductID = p.ProductID
--	WHERE c.Country = 'USA'
--	GROUP BY o.OrderID
--)

--SELECT
--MAX(ResPrice) AS MaxOrderPrice
--,MIN(ResPrice) AS MinOrderPrice
--,MAX(ResPrice) - MIN(ResPrice) AS PriceDifference
--FROM t

--9. Выведите количество заказов у каждого их трех самых молодых сотрудников, а также имя и фамилию во второй колонке.
--WITH GroupedEmployers AS (
--	SELECT
--	o.EmployeeID
--	,COUNT(o.EmployeeID) AS CountOfOrders
--	FROM Orders				AS o
--	INNER JOIN Employees	AS emp ON o.EmployeeID = emp.EmployeeID
--	GROUP BY o.EmployeeID
--)

--SELECT
--CountOfOrders
--,emp.FirstName + ' ' + emp.LastName AS EmployeeFullName
--FROM Employees				AS emp
--INNER JOIN GroupedEmployers AS gemp ON  emp.EmployeeID = gemp.EmployeeID
--WHERE emp.EmployeeID IN (
--		SELECT TOP 3 EmployeeID
--		FROM Employees
--		ORDER BY BirthDate DESC
--)
--10. Сколько банок крабового мяса всего было заказано

--SELECT
--ProductID,
--SUM(CONVERT(FLOAT, Quantity)) AS ProductCount
--FROM OrderDetails
--WHERE ProductID = (
--		SELECT 
--		ProductID
--		FROM Products
--		WHERE ProductName LIKE '%crab%'
--	)
--GROUP BY ProductID
