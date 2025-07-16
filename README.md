**SQL Query Execution Order (Gerçek Çalışma Sırası)**

| **Adım** | **SQL Kısmı** | **Açıklama** |
| --- | --- | --- |
| 1   | **FROM** | Tablo(lar) belirlenir ve JOIN’ler uygulanır. |
| 2   | **ON** | JOIN işlemi varsa, eşleşme şartları uygulanır. |
| 3   | **JOIN** | İlgili tablolar birleştirilir. |
| 4   | **WHERE** | Tabloya uygulanan filtrelemeler yapılır. |
| 5   | **GROUP BY** | Veriler gruplandırılır. |
| 6   | **WITH CUBE / ROLLUP** | İstatistiksel toplamlar hesaplanır (opsiyonel). |
| 7   | **HAVING** | Gruplar üzerinde filtre uygulanır. |
| 8   | **SELECT** | Sadece istenen sütunlar seçilir. |
| 9   | **DISTINCT** | Seçilen satırlar arasında tekrarlı olanlar ayıklanır. |
| 10  | **ORDER BY** | Sonuçlar sıralanır. |
| 11  | **LIMIT / OFFSET / TOP** | (Veya SQL Server'da TOP) Belirli sayıda sonuç getirilir. |

SELECT name, COUNT(\*)

FROM customers

WHERE city = 'Ankara'

GROUP BY name

HAVING COUNT(\*) > 1

ORDER BY name;

Gerçekte motorun yaptığı:

FROM customers

WHERE city = 'Ankara'

GROUP BY name

HAVING COUNT(\*) > 1

SELECT name, COUNT(\*)

ORDER BY name

**🔹 1. SELECT, WHERE, ORDER BY**

1. Customers tablosundan sadece CompanyName ve City sütunlarını getir.

SELECT CompanyName, City FROM Customers

1. Employees tablosunda London’da yaşayan çalışanları listele.

SELECT \* FROM Employees WHERE City='London'

1. Products tablosunda fiyatı 100'den büyük ürünleri azalan fiyata göre sırala.

SELECT \* FROM Products WHERE UnitPrice>100 ORDER BY UnitPrice DESC

1. Ürün adı "çikolata" kelimesini içeren ürünleri getir.

SELECT \* FROM Products WHERE ProductName like '%chocolate%'

1. Orders tablosundan 1997 yılında verilen siparişleri seç.

SELECT \* FROM Orders WHERE OrderDate BETWEEN '1997-01-01' and '1997-12-31'

**🔹 2. JOIN Türleri (INNER, LEFT, RIGHT, FULL)**

1. Siparişlerin müşteri adlarıyla birlikte listelendiği bir sorgu yaz (INNER JOIN).

SELECT Orders.OrderID, Customers.CompanyName, Orders.OrderDate FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID

1. Sipariş yapmamış müşterileri listele (LEFT JOIN).

SELECT Customers.CustomerID, Customers.CompanyName, Orders.OrderID FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID WHERE Orders.OrderID IS NULL

1. Product isimlerini kategori isimleriyle beraber getir. (RIGHT JOIN)

SELECT P.ProductID, P.ProductName, C.CategoryName, P.UnitPrice, P.UnitsInStock FROM Categories C RIGHT JOIN Products P ON P.CategoryID = C.CategoryID

1. Hem sipariş yapan hem yapmayan müşterileri tek sorguda listele (FULL OUTER JOIN).

SELECT C.CustomerID, C.CompanyName, O.OrderID, O.OrderDate FROM Customers C FULL JOIN Orders O ON C.CustomerID = O.CustomerID

1. Birden fazla JOIN içeren bir sorgu kur (örneğin: Orders → Customers → Shippers).

SELECT T.TerritoryID, T.TerritoryDescription, E.EmployeeID, E.FirstName, E.LastName FROM Territories T LEFT JOIN EmployeeTerritories ET ON T.TerritoryID = ET.TerritoryID LEFT JOIN Employees E ON E.EmployeeID = ET.EmployeeID;

**🔹 3. GROUP BY, HAVING**

1. Her şehirdeki müşteri sayısını listele.

SELECT Country, City, COUNT(\*) AS CustomerCount FROM Customers GROUP BY Customers.Country, Customers.City ORDER BY COUNT(\*) DESC

1. 3’ten fazla sipariş veren müşterileri listele.

SELECT C.CustomerID, C.CompanyName, COUNT(\*) AS OrderCount FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID GROUP BY C.CustomerID, C.CompanyName HAVING COUNT(\*) > 10

1. Her çalışan kaç farklı müşteriyle çalışmış, hesapla.

SELECT EmployeeID, COUNT(DISTINCT CustomerID) FROM Orders GROUP BY EmployeeID

1. Her kategorideki toplam ürün sayısını getir.

SELECT COUNT(\*) FROM Products GROUP BY CategoryID

1. Sadece toplam satış tutarı 100000’in üzerinde olan çalışanları listele.

SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName AS NameSurname, SUM(OD.Quantity \* OD.UnitPrice) AS TotalSales FROM Orders O JOIN Employees E ON E.EmployeeID = O.EmployeeID JOIN \[Order Details\] OD ON O.OrderID = OD.OrderID GROUP BY O.EmployeeID, E.FirstName + ' ' + E.LastName HAVING SUM(OD.Quantity \* OD.UnitPrice) > 100000

**🔹 4. ALT SORGU (Subquery)**

1. Fiyatı, tüm ürünlerin ortalamasından yüksek olan ürünleri listele.
2. "Beverages" kategorisindeki ürünleri getirmek için alt sorgu kullan.
3. En pahalı ürünün bilgilerini alt sorguyla bul.
4. En çok sipariş verilen ürünü tespit et.
5. Kategorisine göre ortalamanın üzerinde olan ürünleri getir.

**🔹 5. CASE WHEN**

1. Ürünleri fiyatına göre "Ucuz", "Orta", "Pahalı" olarak etiketle.
2. Sipariş durumuna göre (shipped, cancelled, pending) bir durum açıklaması oluştur.
3. Stok miktarı 0 olanları "Tükenmiş" olarak göster.
4. Müşterilerin kredi puanına göre risk seviyesi belirle.
5. Satış miktarına göre prim hesaplayan CASE WHEN ifadesi yaz.

**🔹 6. STRING, DATE, MATH Fonksiyonları**

1. Tüm müşteri isimlerini büyük harfe çevir.
2. Orders tablosunda sipariş tarihinden yıl ve ay bilgilerini çıkar.
3. Bugün ile müşteri kayıt tarihi arasındaki gün farkını hesapla.
4. Fiyatı virgülden sonra 2 basamak olacak şekilde yuvarla.
5. ProductName uzunluğu 10 karakterden fazla olanları getir.

**🔹 7. VIEW, INDEX, TEMP TABLE**

1. Sık kullanılan bir müşteri listesi için VIEW oluştur.
2. City sütunu için bir INDEX oluştur ve sorgu farkını gözlemle.
3. Siparişi olmayan müşterileri #GeçiciTablo içine kaydet.
4. Satış yapan çalışanların ad-soyad ve toplam satışını içeren VIEW oluştur.
5. Aynı sorguyu hem VIEW hem TEMP TABLE ile yaz, farklarını gözle.

**🔹 8. CTE (Common Table Expression)**

1. CTE kullanarak en çok sipariş alan 5 ürünü listele.
2. Recursive CTE ile 1’den 10’a kadar sayıları üret.
3. Her çalışanın toplam satışını CTE içinde hesapla.
4. Müşteri başına yapılan ortalama siparişi hesaplayan CTE yaz.
5. CTE ile birden fazla kez kullanılan bir alt sorguyu tekrar etmeden kullan.

**🔹 9. INSERT, UPDATE, DELETE**

1. Yeni bir müşteri ekle.
2. Var olan bir müşterinin şehir bilgisini güncelle.
3. Siparişi iptal edilen müşteri kaydını sil.
4. Aynı anda birden fazla ürünü ekleyen bir INSERT yaz.
5. Fiyatı 0 olan ürünleri silmek için sorgu yaz.

**🔹 10. Stored Procedure ve Function**

1. Tüm siparişleri listeleyen bir stored procedure yaz.
2. Bir ürün adı parametre olarak alıp detaylarını dönen bir fonksiyon oluştur.
3. Tüm çalışanlara ait maaş ortalamasını dönen bir fonksiyon yaz.
4. Yeni müşteri ekleyen bir sp_InsertCustomer prosedürü oluştur.
5. Fiyat ve adet girildiğinde toplam tutarı hesaplayan fonksiyon yaz.

**🔹 11. PIVOT / UNPIVOT**

1. Siparişlerin yıl bazında dağılımını PIVOT kullanarak göster.
2. Ürünlerin her çeyrekteki satış miktarlarını sütunlara dök.
3. Bir öğrencinin ders notlarını satırlardan sütunlara çevir.
4. UNPIVOT ile kolonları satıra dönüştür (örn: anket sonuçları).
5. Aynı veriyi hem GROUP BY hem PIVOT ile çöz, karşılaştır.

**🔹 12. Window Functions (ROW_NUMBER, RANK)**

1. En pahalı 5 ürünü sıralama ile birlikte getir.
2. Aynı fiyata sahip ürünlerde RANK() ve DENSE_RANK() farkını göster.
3. Her müşterinin yaptığı siparişlerde sipariş sırasını numaralandır.
4. Her şehirdeki ilk müşteriyi ROW_NUMBER() ile bul.
5. Satışları bölgelere göre sıralayıp her bölgenin en iyi 3 çalışanını bul.

**🔹 13. Performans ve Optimizasyon**

1. SELECT \* ile SELECT alan1, alan2 farkını Execution Plan ile gözlemle.
2. Filtreleme için hangi sütunlarda index işe yarıyor?
3. IN, EXISTS ve JOIN performanslarını karşılaştır.
4. Sorgu planlarını analiz ederek yavaş çalışan bir sorguyu iyileştir.
5. WITH (NOLOCK) kullanımı nedir? Ne zaman dikkatli olunmalı?

66\. Customers ve Suppliers tablolarındaki tüm şehirleri tekrarsız şekilde listele.

67\. Yukarıdaki şehirleri tekrar edenleri de göstererek listele.

68\. Employees tablosunda FirstName olan tüm isimleri, Customers tablosundaki ContactName ile birleştir.

69\. UNION ile birleştirilmiş bir sonuç kümesinde sadece "Ankara" geçen kayıtları filtrele.

70\. UNION sonucu üzerinde sıralama (ORDER BY) uygula.