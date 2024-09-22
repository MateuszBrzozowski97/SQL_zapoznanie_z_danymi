SELECT TOP (1000) [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2019].[Production].[Product];



/*lista produktów z cenami*/
SELECT Name, ProductNumber, ListPrice
FROM Production.Product
ORDER BY ListPrice desc;

/*lista produktów z cenami,produkty tylko zawieracj¹ce s³owo Mountain i cene katalogowa od 1000*/
SELECT Name, ProductNumber, ListPrice
FROM Production.Product
WHERE Name LIKE '%Mountain%' AND ListPrice >=1000
ORDER BY ListPrice desc;

/*zapoznanie z nowymi tabelami*/
SELECT *
FROM Production.ProductCategory;

SELECT *
FROM Production.ProductSubcategory;

/*przyporz¹dkowanie produktów do podkategorii*/
SELECT ps.Name, pp.Name, pp.ProductNumber, pp.ListPrice
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID=ps.ProductSubcategoryID
ORDER BY ListPrice desc;

/* œredni¹ cenê produktów dla ka¿dej podkategorii*/
SELECT ps.Name, AVG(pp.ListPrice) AS AveragePrice
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID=ps.ProductSubcategoryID
GROUP BY ps.Name;


/* œredni¹ cenê produktów dla podkategorii zawierajacej s³owo Mountain*/
SELECT ps.Name, AVG(pp.ListPrice) AS AveragePrice
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID=ps.ProductSubcategoryID
WHERE ps.Name LIKE '%Mountain%'
GROUP BY ps.Name;

/* uzyskanie nazwy kategorii, podkategorii oraz œredni¹ cenê produktów*/
SELECT pc.Name AS CategoryName, 
       ps.Name AS SubcategoryName, 
       AVG(pp.ListPrice) AS AveragePrice
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, ps.Name;


/* uzyskanie nazwy kategorii, podkategorii, nazwy produktu oraz cenê produktów posortowanych w okreslony sposob*/
SELECT pc.Name AS CategoryName, 
       ps.Name AS SubcategoryName,
       pp.ProductNumber,
       pp.ListPrice AS Price
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
ORDER BY CategoryName DESC ,SubcategoryName DESC, pp.ProductNumber DESC, pp.ListPrice DESC;

/*sprawdzenie jacy sprzedawcy, sprzedawali okreslone produkty*/
SELECT pc.Name AS CategoryName, 
       ps.Name AS SubcategoryName,
       pp.ProductNumber,
       pp.ListPrice AS Price,
       sp.BusinessEntityID AS SalesPersonID, 
       p.FirstName + ' ' + p.LastName AS SalesPersonName
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
ORDER BY CategoryName DESC, SubcategoryName DESC, pp.ProductNumber DESC, pp.ListPrice DESC;


/*ró¿nica pomiêdzy cen¹ katalogow¹ a rzeczywist¹ sprzeda¿¹ dla ka¿dego sprzedawcy, z podzia³em na kategorie i podkategorie produktów*/
SELECT p.FirstName + ' ' + p.LastName AS SalesPersonName,
	   pc.Name AS CategoryName, 
       ps.Name AS SubcategoryName,
       SUM(pp.ListPrice) AS Price,
	   SUM(sod.LineTotal) AS TotalSales
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName + ' ' + p.LastName, pc.Name, ps.Name 
ORDER BY CategoryName DESC, SubcategoryName DESC;

/* produkty,które zosta³y sprzedane z rabatem lub po ni¿szych cenach ni¿ pocz¹tkowo zak³adano w cenniku*/
SELECT p.FirstName + ' ' + p.LastName AS SalesPersonName,
	   pc.Name AS CategoryName, 
       ps.Name AS SubcategoryName,
       SUM(pp.ListPrice) AS Price,
	   SUM(sod.LineTotal) AS TotalSales
FROM Production.Product pp
JOIN Production.ProductSubcategory ps ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName + ' ' + p.LastName, pc.Name, ps.Name 
HAVING SUM(pp.ListPrice) > SUM(sod.LineTotal)
ORDER BY CategoryName DESC, SubcategoryName DESC;


/*Nowa Analiza Sprzedawca*/
SELECT *
FROM Sales.SalesPerson;

SELECT *
FROM Person.Person;

SELECT *
FROM Sales.SalesOrderHeader;

SELECT *
FROM Sales.SalesOrderDetail;

/*Wszyscy sprzedawcy którzy na imie maj¹ Rob lub Dylan*/
SELECT DISTINCT CONCAT(FirstName, ' ', LastName) AS SalesPersonName
FROM Person.Person
WHERE FirstName IN ('Rob','Dylan');

/*1.œrednia wartoœæ zamówienia realizowana przez sprzedawcê*/
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName, AVG(soh.TotalDue) AS AverageOrderValue
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY p.FirstName, p.LastName;

/*2.ile ka¿dy sprzedawca sprzeda³ w sumie*/
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY p.FirstName, p.LastName;

/*stworzenie widoków do zapytañ 1 i 2 i wyswietlenie danych*/
CREATE VIEW AverageOrder1 AS
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName, 
       AVG(soh.TotalDue) AS AverageOrderValue
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY p.FirstName, p.LastName;


CREATE VIEW TotalSales2 AS
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName, 
       SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY p.FirstName, p.LastName;


SELECT a.SalesPersonName,
	   a.AverageOrderValue,
	   b.TotalSales
FROM AverageOrder1 a
JOIN TotalSales2 b ON a.SalesPersonName=b.SalesPersonName


/*opcja bez tworzenia widoków*/
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName, 
       (SELECT AVG(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE soh.SalesPersonID = sp.BusinessEntityID) AS AverageOrderValue,
       (SELECT SUM(sod.LineTotal)
        FROM Sales.SalesOrderDetail sod
        JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
        WHERE soh.SalesPersonID = sp.BusinessEntityID) AS TotalSales
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID;

/*Podstawowa Analiza*/
/*Analiza sprzeda¿y z podzia³em na lata i miesiace*/
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;


/*Analiza sprzeda¿y z podzia³em na lata i miesiace z wykorzystaniem podzapytania w celu storzenia kolumny podsumowuj¹cej dany rok*/
WITH MonthlySales AS (
    SELECT YEAR(OrderDate) AS Year, 
           MONTH(OrderDate) AS Month, 
           SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT Year, 
       Month, 
       TotalSales,
       SUM(TotalSales) OVER (PARTITION BY Year) AS TotalYearSales
FROM MonthlySales
ORDER BY Year, Month;

