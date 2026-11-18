-- Create database for Retail Sales Analysis

USE master;
GO

IF DB_ID('Retail_Sales_Analysis') IS NULL
    CREATE DATABASE Retail_Sales_Analysis;
GO

-- Select Retail Sales database

USE Retail_Sales_Analysis;
GO

-- Create People table

IF OBJECT_ID('dbo.People', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.People (
        Region NVARCHAR(50) NOT NULL,
        [Regional Manager] NVARCHAR(100) NOT NULL,

        CONSTRAINT PK_People PRIMARY KEY (Region)
    );
END;
GO

-- Create Returns table

IF OBJECT_ID('dbo.Returns', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Returns (
        [Order ID] NVARCHAR(50) NOT NULL,
        Returned NVARCHAR(10) NOT NULL,

        CONSTRAINT PK_Returns PRIMARY KEY ([Order ID])
    );
END;
GO

-- Create Orders table

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders (

        [Row ID] INT NOT NULL,
        [Order ID] NVARCHAR(50) NOT NULL,
        [Order Date] DATE NOT NULL,
        [Ship Date] DATE NOT NULL,
        [Ship Mode] NVARCHAR(50),
        [Customer ID] NVARCHAR(50),
        [Customer Name] NVARCHAR(150),
        [Segment] NVARCHAR(50),
        [Country/Region] NVARCHAR(50),
        [City] NVARCHAR(100),
        [State/Province] NVARCHAR(100),
        [Postal Code] NVARCHAR(20),
        [Region] NVARCHAR(50),
        [Product ID] NVARCHAR(50),
        [Category] NVARCHAR(100),
        [Sub-Category] NVARCHAR(100),
        [Product Name] NVARCHAR(500),
        [Sales] DECIMAL(19,6),
        [Quantity] INT,
        [Discount] DECIMAL(9,6),
        [Profit] DECIMAL(19,6),

        CONSTRAINT PK_Orders PRIMARY KEY ([Row ID])
    );
END;
GO

-- Insert clean People data

INSERT INTO dbo.People (
    Region,
    [Regional Manager]
)
SELECT
    Region,
    [Regional Manager]
FROM dbo.People_Import
WHERE Region <> 'Region'
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.People
      WHERE dbo.People.Region = dbo.People_Import.Region
  );
GO

-- Verify People table
SELECT *
FROM dbo.People;

-- Insert clean Returns data

INSERT INTO dbo.Returns (
    [Order ID],
    Returned
)
SELECT
    ri.Order_ID,
    ri.Returned
FROM dbo.Returns_Import AS ri

WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Returns AS r
    WHERE r.[Order ID] = ri.Order_ID
);
GO

-- Check numeric conversion errors

SELECT
    COUNT(*) AS Total_Rows,

    COUNT(DISTINCT Row_ID) AS Unique_Row_IDs,

    SUM(CASE
        WHEN Sales IS NOT NULL
         AND TRY_CONVERT(DECIMAL(19,6), Sales) IS NULL
        THEN 1 ELSE 0
    END) AS Sales_Errors,

    SUM(CASE
        WHEN Discount IS NOT NULL
         AND TRY_CONVERT(DECIMAL(9,6), Discount) IS NULL
        THEN 1 ELSE 0
    END) AS Discount_Errors,

    SUM(CASE
        WHEN Profit IS NOT NULL
         AND TRY_CONVERT(DECIMAL(19,6), Profit) IS NULL
        THEN 1 ELSE 0
    END) AS Profit_Errors

FROM dbo.Orders_Import;

-- Validate imported financial data

SELECT
    COUNT(*) AS Total_Rows,

    ROUND(
        SUM(TRY_CONVERT(DECIMAL(19,6), Sales)),
        2
    ) AS Total_Sales,

    ROUND(
        SUM(TRY_CONVERT(DECIMAL(19,6), Profit)),
        2
    ) AS Total_Profit,

    SUM(
        CASE
            WHEN Order_Date IS NULL
              OR Ship_Date IS NULL
            THEN 1 ELSE 0
        END
    ) AS Missing_Required_Dates

FROM dbo.Orders_Import;

-- Transfer data to final Orders table

IF NOT EXISTS (SELECT 1 FROM dbo.Orders)
BEGIN

    INSERT INTO dbo.Orders (
        [Row ID],
        [Order ID],
        [Order Date],
        [Ship Date],
        [Ship Mode],
        [Customer ID],
        [Customer Name],
        [Segment],
        [Country/Region],
        [City],
        [State/Province],
        [Postal Code],
        [Region],
        [Product ID],
        [Category],
        [Sub-Category],
        [Product Name],
        [Sales],
        [Quantity],
        [Discount],
        [Profit]
    )

    SELECT
        Row_ID,
        Order_ID,
        Order_Date,
        Ship_Date,
        Ship_Mode,
        Customer_ID,
        Customer_Name,
        Segment,
        Country_Region,
        City,
        State_Province,
        Postal_Code,
        Region,
        Product_ID,
        Category,
        Sub_Category,
        Product_Name,
        TRY_CONVERT(DECIMAL(19,6), Sales),
        Quantity,
        TRY_CONVERT(DECIMAL(9,6), Discount),
        TRY_CONVERT(DECIMAL(19,6), Profit)

    FROM dbo.Orders_Import;

END
ELSE
BEGIN
    PRINT 'Orders table already contains data. Import skipped.';
END;
GO

-- Verify final Orders table

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT [Row ID]) AS Unique_Row_IDs,
    COUNT(DISTINCT [Order ID]) AS Unique_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.Orders;

-- Check returned orders without matching orders

SELECT COUNT(*) AS Unmatched_Returns
FROM dbo.Returns AS r
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Orders AS o
    WHERE o.[Order ID] = r.[Order ID]
);
-- Check orders without matching regional managers

SELECT COUNT(*) AS Unmatched_Regions
FROM dbo.Orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.People AS p
    WHERE o.Region = p.Region
);

-- Create relationship between Orders and People

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Orders_People'
      AND parent_object_id = OBJECT_ID('dbo.Orders')
)
BEGIN
    ALTER TABLE dbo.Orders
    WITH CHECK
    ADD CONSTRAINT FK_Orders_People
    FOREIGN KEY (Region)
    REFERENCES dbo.People(Region);
END;
GO

-- Verify foreign key

SELECT
    name AS Foreign_Key_Name,
    OBJECT_NAME(parent_object_id) AS Table_Name,
    OBJECT_NAME(referenced_object_id) AS Referenced_Table,
    is_disabled,
    is_not_trusted
FROM sys.foreign_keys
WHERE name = 'FK_Orders_People';