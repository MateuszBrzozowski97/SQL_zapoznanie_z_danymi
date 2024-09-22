--10 produktów o najwy¿szej wartoœci sprzeda¿y
SELECT TOP 10 p.Name AS ProductName, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSales DESC;

--lista produktów przecenionych
SELECT *
FROM Sales.SpecialOffer;

--sumowania sprzeda¿y produktów, które by³y objête specjalnymi ofertami, metoda wykorzystuj¹ca podzapytanie w klauzuli where
SELECT p.Name AS ProductName, 
       SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.ProductID IN (
    SELECT sop.ProductID
    FROM Sales.SpecialOfferProduct sop
    JOIN Sales.SpecialOffer so ON sop.SpecialOfferID = so.SpecialOfferID
)
GROUP BY p.Name
ORDER BY TotalSales DESC;


--Podsumowanie obni¿ki z wykorzystaniem CASE
SELECT Description,DiscountPct,
	   CASE WHEN DiscountPct <= 0.2 THEN 'Niewielka_Obnizka'
			WHEN DiscountPct <= 0.4 THEN 'Duza_Obnizka'
			ELSE 'Mega_Rabat'
		END AS 'Status_Obnizki'
FROM Sales.SpecialOffer


--Pobranie danych dla konkretnego typu obni¿ki z wykorzystaniem widoku
CREATE VIEW Obnizka AS 
SELECT Description,DiscountPct,
	   CASE WHEN DiscountPct <= 0.2 THEN 'Niewielka_Obnizka'
			WHEN DiscountPct <= 0.4 THEN 'Duza_Obnizka'
			ELSE 'Mega_Rabat'
		END AS 'Status_Obnizki'
FROM Sales.SpecialOffer

SELECT *
FROM Obnizka
WHERE Status_Obnizki = 'Mega_Rabat'


--ile dni trwa³a promocja i kiedy dana promocja by³a dostêpna
SELECT Description,
	   FORMAT(StartDate, 'dd-MM-yyyy') AS StartDate,
	   FORMAT(EndDate, 'dd-MM-yyyy') AS FormattedEndDate,
       DATEDIFF(day, StartDate, EndDate) AS DiscountDuration
FROM Sales.SpecialOffer;
