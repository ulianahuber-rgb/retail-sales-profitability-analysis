USE Retail_Sales_Analysis;
GO

-- Overall Return Rate Analysis

SELECT
    COUNT(DISTINCT o.[Order ID]) AS Total_Orders,

    COUNT(DISTINCT r.[Order ID]) AS Returned_Orders,

    ROUND(
        COUNT(DISTINCT r.[Order ID]) * 100.0 /
        NULLIF(COUNT(DISTINCT o.[Order ID]), 0),
        2
    ) AS Return_Rate

FROM dbo.Orders AS o

LEFT JOIN dbo.Returns AS r
    ON o.[Order ID] = r.[Order ID];

    -- Return Rate by Region

SELECT
    o.Region,

    COUNT(DISTINCT o.[Order ID]) AS Total_Orders,

    COUNT(DISTINCT r.[Order ID]) AS Returned_Orders,

    CAST(
        COUNT(DISTINCT r.[Order ID]) * 100.0 /
        NULLIF(COUNT(DISTINCT o.[Order ID]), 0)
        AS DECIMAL(5,2)
    ) AS Return_Rate

FROM dbo.Orders AS o

LEFT JOIN dbo.Returns AS r
    ON o.[Order ID] = r.[Order ID]

GROUP BY o.Region

ORDER BY Return_Rate DESC;

-- Return Rate by Category

SELECT
    o.Category,

    COUNT(DISTINCT o.[Order ID]) AS Total_Orders,

    COUNT(DISTINCT r.[Order ID]) AS Returned_Orders,

    CAST(
        COUNT(DISTINCT r.[Order ID]) * 100.0 /
        NULLIF(COUNT(DISTINCT o.[Order ID]), 0)
        AS DECIMAL(5,2)
    ) AS Return_Rate

FROM dbo.Orders AS o

LEFT JOIN dbo.Returns AS r
    ON o.[Order ID] = r.[Order ID]

GROUP BY o.Category

ORDER BY Return_Rate DESC;

-- Final Database Validation

SELECT
    (SELECT COUNT(*)
     FROM dbo.Orders) AS Total_Sales_Lines,

    (SELECT COUNT(DISTINCT [Order ID])
     FROM dbo.Orders) AS Total_Orders,

    (SELECT COUNT(*)
     FROM dbo.Returns) AS Total_Returns,

    (SELECT COUNT(*)
     FROM dbo.People) AS Total_Managers,

    (SELECT COUNT(*)
     FROM dbo.Orders AS o
     WHERE NOT EXISTS (
         SELECT 1
         FROM dbo.People AS p
         WHERE o.Region = p.Region
     )) AS Unmatched_Regions,

    (SELECT COUNT(*)
     FROM dbo.Returns AS r
     WHERE NOT EXISTS (
         SELECT 1
         FROM dbo.Orders AS o
         WHERE o.[Order ID] = r.[Order ID]
     )) AS Unmatched_Returns;