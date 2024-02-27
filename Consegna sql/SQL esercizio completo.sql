Create SCHEMA Toys_Group
Create TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(255) NOT NULL
);

CREATE TABLE State (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(255) NOT NULL,
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    RegionID INT,
    SaleDate DATE,
    Quantity INT,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

-- Inserimento dati nella tabella Category
INSERT INTO Category VALUES (1, 'Action Figures');
INSERT INTO Category VALUES (2, 'Board Games');

-- Inserimento dati nella tabella Product
INSERT INTO Product VALUES (101, 'Superhero Action Figure', 1);
INSERT INTO Product VALUES (102, 'Board Game A', 2);

-- Inserimento dati nella tabella Region
INSERT INTO Region VALUES (282, 'WestEurope');
INSERT INTO Region VALUES (379, 'SouthEurope');

-- Inserimento dati nella tabella State
INSERT INTO State VALUES (1001, 'France', 282);
INSERT INTO State VALUES (1002, 'Germany', 282);
INSERT INTO State VALUES (1003, 'Italy', 379);
INSERT INTO State VALUES (1004, 'Greece', 379);

-- Inserimento dati nella tabella Sales
INSERT INTO Sales VALUES (10001, 101, 1001, '2024-02-27', 10, 150.00);
INSERT INTO Sales VALUES (10002, 102, 1003, '2024-02-28', 5, 80.00);

-- Unicità delle Chiavi Primarie:
-- 1
SELECT COUNT(DISTINCT CategoryID) = COUNT(*) AS UniqueCategoryIDs FROM Category;

-- 2
SELECT COUNT(DISTINCT ProductID) = COUNT(*) AS UniqueProductIDs FROM Product;

 -- Prodotti Venduti e il Fatturato Totale per Anno:
 SELECT p.ProductName, YEAR(s.SaleDate) AS SaleYear, SUM(s.Amount) AS TotalRevenue
FROM Product p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName, YEAR(s.SaleDate);

-- Fatturato Totale per Stato per Anno:
SELECT r.RegionName, s.StateName, YEAR(sa.SaleDate) AS SaleYear, SUM(sa.Amount) AS TotalRevenue
FROM Region r
JOIN State s ON r.RegionID = s.RegionID
JOIN Sales sa ON s.StateID = sa.RegionID
GROUP BY r.RegionName, s.StateName, YEAR(sa.SaleDate)
ORDER BY YEAR(sa.SaleDate) ASC, TotalRevenue DESC;

-- dentificare la Categoria di Articoli più Richiesta:
SELECT c.CategoryName, SUM(s.Quantity) AS TotalQuantitySold
FROM Category c
JOIN Product p ON c.CategoryID = p.CategoryID
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY c.CategoryName
ORDER BY TotalQuantitySold DESC
LIMIT 1;

-- Prodotti Invenduti:
-- 1
SELECT p.ProductName
FROM Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;
-- 2
SELECT ProductName
FROM Product
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Sales);

-- Prodotti con la Rispettiva Ultima Data di Vendita:
SELECT p.ProductName, MAX(s.SaleDate) AS LastSaleDate
FROM Product p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;
