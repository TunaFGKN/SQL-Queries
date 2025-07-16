--1. Customers tablosundan sadece CompanyName ve City s�tunlar�n� getir.
SELECT CompanyName, City FROM Customers

--2. Employees tablosunda �stanbul�da ya�ayan �al��anlar� listele.
SELECT * FROM Employees WHERE City='London'

--3. Products tablosunda fiyat� 100'den b�y�k �r�nleri azalan fiyata g�re s�rala.
SELECT * FROM Products WHERE UnitPrice>100 ORDER BY  UnitPrice DESC

--4. �r�n ad� "�ikolata" kelimesini i�eren �r�nleri getir.
SELECT * FROM Products WHERE ProductName like '%chocolate%'

--5. Orders tablosundan 1997 y�l�nda verilen sipari�leri se�.
SELECT * FROM Orders WHERE OrderDate BETWEEN '1997-01-01' and '1997-12-31'

--6. Sipari�lerin m��teri adlar�yla birlikte listelendi�i bir sorgu yaz (INNER JOIN).
SELECT o.OrderID, c.CompanyName, o.OrderDate FROM Orders AS o JOIN Customers AS c ON o.CustomerID = c.CustomerID
SELECT o.OrderID, c.CompanyName, o.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID

--7. Sipari� yapmam�� m��terileri listele (LEFT JOIN).
SELECT Customers.CustomerID, Customers.CompanyName, Orders.OrderID FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID WHERE Orders.OrderID IS NULL
SELECT * FROM Customers WHERE CustomerID not in (select CustomerID from Orders)

--8. Product isimlerini kategori isimleriyle beraber getir.
SELECT P.ProductID, P.ProductName, C.CategoryName, P.UnitPrice, P.UnitsInStock FROM Categories C RIGHT JOIN Products P ON P.CategoryID = C.CategoryID

--9. Hem sipari� yapan hem yapmayan m��terileri tek sorguda listele (FULL OUTER JOIN).
SELECT C.CustomerID, C.CompanyName, O.OrderID, O.OrderDate FROM Customers C FULL JOIN Orders O ON C.CustomerID = O.CustomerID

--10. Birden fazla JOIN i�eren bir sorgu kur.
SELECT E.EmployeeID, E.FirstName, E.LastName, ET.TerritoryID, T.TerritoryDescription FROM Employees E 
LEFT JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID 
LEFT JOIN Territories T ON ET.TerritoryID = T.TerritoryID

SELECT T.TerritoryID, T.TerritoryDescription, E.EmployeeID, E.FirstName, E.LastName FROM Territories T 
LEFT JOIN EmployeeTerritories ET ON T.TerritoryID = ET.TerritoryID 
LEFT JOIN Employees E ON E.EmployeeID = ET.EmployeeID;

--11. Her �ehirdeki m��teri say�s�n� listele.
SELECT Country, City, COUNT(*) AS CustomerCount FROM Customers GROUP BY Customers.Country, Customers.City ORDER BY COUNT(*) DESC

--12. 10'dan fazla sipari� veren m��terileri listele.
SELECT C.CustomerID, C.CompanyName, COUNT(*) AS OrderCount FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID GROUP BY C.CustomerID, C.CompanyName HAVING COUNT(*) > 10
SELECT CustomerID, COUNT(*) FROM Orders GROUP BY CustomerID HAVING COUNT(*) > 10

--13. Her �al��an ka� farkl� m��teriyle �al��m��, hesapla.
SELECT EmployeeID, COUNT(DISTINCT CustomerID) FROM Orders GROUP BY EmployeeID

--14. Her kategorideki toplam �r�n say�s�n� getir.
SELECT COUNT(*) FROM Products GROUP BY CategoryID

--15. Sadece toplam sat�� tutar� 5000�in �zerinde olan �al��anlar� listele.
SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName AS NameSurname, SUM(OD.Quantity * OD.UnitPrice) AS TotalSales FROM Orders O 
JOIN Employees E ON E.EmployeeID = O.EmployeeID 
JOIN [Order Details] OD ON O.OrderID = OD.OrderID 
GROUP BY O.EmployeeID, E.FirstName + ' ' + E.LastName HAVING SUM(OD.Quantity * OD.UnitPrice) > 100000

--16. Fiyat�, t�m �r�nlerin ortalamas�ndan y�ksek olan �r�nleri listele.
SELECT * FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

--17. "Beverages" kategorisindeki �r�nleri getirmek i�in alt sorgu kullan.
SELECT * FROM Products WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages')

--18. En pahal� �r�n�n bilgilerini alt sorguyla bul.
SELECT * FROM Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)

--19. En �ok sipari� verilen �r�n� tespit et.
SELECT * FROM Products WHERE UnitsOnOrder = (SELECT MAX(UnitsOnOrder) FROM Products)

--20. Kategorisine g�re ortalaman�n �zerinde olan �r�nleri getir.
SELECT * FROM Products P WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = P.CategoryID)