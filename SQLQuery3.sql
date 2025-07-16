--1. Customers tablosundan sadece CompanyName ve City sütunlarýný getir.
SELECT CompanyName, City FROM Customers

--2. Employees tablosunda Ýstanbul’da yaþayan çalýþanlarý listele.
SELECT * FROM Employees WHERE City='London'

--3. Products tablosunda fiyatý 100'den büyük ürünleri azalan fiyata göre sýrala.
SELECT * FROM Products WHERE UnitPrice>100 ORDER BY  UnitPrice DESC

--4. Ürün adý "çikolata" kelimesini içeren ürünleri getir.
SELECT * FROM Products WHERE ProductName like '%chocolate%'

--5. Orders tablosundan 1997 yýlýnda verilen sipariþleri seç.
SELECT * FROM Orders WHERE OrderDate BETWEEN '1997-01-01' and '1997-12-31'

--6. Sipariþlerin müþteri adlarýyla birlikte listelendiði bir sorgu yaz (INNER JOIN).
SELECT o.OrderID, c.CompanyName, o.OrderDate FROM Orders AS o JOIN Customers AS c ON o.CustomerID = c.CustomerID
SELECT o.OrderID, c.CompanyName, o.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID

--7. Sipariþ yapmamýþ müþterileri listele (LEFT JOIN).
SELECT Customers.CustomerID, Customers.CompanyName, Orders.OrderID FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID WHERE Orders.OrderID IS NULL
SELECT * FROM Customers WHERE CustomerID not in (select CustomerID from Orders)

--8. Product isimlerini kategori isimleriyle beraber getir.
SELECT P.ProductID, P.ProductName, C.CategoryName, P.UnitPrice, P.UnitsInStock FROM Categories C RIGHT JOIN Products P ON P.CategoryID = C.CategoryID

--9. Hem sipariþ yapan hem yapmayan müþterileri tek sorguda listele (FULL OUTER JOIN).
SELECT C.CustomerID, C.CompanyName, O.OrderID, O.OrderDate FROM Customers C FULL JOIN Orders O ON C.CustomerID = O.CustomerID

--10. Birden fazla JOIN içeren bir sorgu kur.
SELECT E.EmployeeID, E.FirstName, E.LastName, ET.TerritoryID, T.TerritoryDescription FROM Employees E 
LEFT JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID 
LEFT JOIN Territories T ON ET.TerritoryID = T.TerritoryID

SELECT T.TerritoryID, T.TerritoryDescription, E.EmployeeID, E.FirstName, E.LastName FROM Territories T 
LEFT JOIN EmployeeTerritories ET ON T.TerritoryID = ET.TerritoryID 
LEFT JOIN Employees E ON E.EmployeeID = ET.EmployeeID;

--11. Her þehirdeki müþteri sayýsýný listele.
SELECT Country, City, COUNT(*) AS CustomerCount FROM Customers GROUP BY Customers.Country, Customers.City ORDER BY COUNT(*) DESC

--12. 10'dan fazla sipariþ veren müþterileri listele.
SELECT C.CustomerID, C.CompanyName, COUNT(*) AS OrderCount FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID GROUP BY C.CustomerID, C.CompanyName HAVING COUNT(*) > 10
SELECT CustomerID, COUNT(*) FROM Orders GROUP BY CustomerID HAVING COUNT(*) > 10

--13. Her çalýþan kaç farklý müþteriyle çalýþmýþ, hesapla.
SELECT EmployeeID, COUNT(DISTINCT CustomerID) FROM Orders GROUP BY EmployeeID

--14. Her kategorideki toplam ürün sayýsýný getir.
SELECT COUNT(*) FROM Products GROUP BY CategoryID

--15. Sadece toplam satýþ tutarý 5000’in üzerinde olan çalýþanlarý listele.
SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName AS NameSurname, SUM(OD.Quantity * OD.UnitPrice) AS TotalSales FROM Orders O 
JOIN Employees E ON E.EmployeeID = O.EmployeeID 
JOIN [Order Details] OD ON O.OrderID = OD.OrderID 
GROUP BY O.EmployeeID, E.FirstName + ' ' + E.LastName HAVING SUM(OD.Quantity * OD.UnitPrice) > 100000

--16. Fiyatý, tüm ürünlerin ortalamasýndan yüksek olan ürünleri listele.
SELECT * FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

--17. "Beverages" kategorisindeki ürünleri getirmek için alt sorgu kullan.
SELECT * FROM Products WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages')

--18. En pahalý ürünün bilgilerini alt sorguyla bul.
SELECT * FROM Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)

--19. En çok sipariþ verilen ürünü tespit et.
SELECT * FROM Products WHERE UnitsOnOrder = (SELECT MAX(UnitsOnOrder) FROM Products)

--20. Kategorisine göre ortalamanýn üzerinde olan ürünleri getir.
SELECT * FROM Products P WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = P.CategoryID)