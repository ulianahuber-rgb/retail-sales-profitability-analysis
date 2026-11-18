USE Retail_Sales_Analysis;
GO

-- Overall Sales Performance

SELECT
    COUNT(*) AS Total_Sales_Lines,

    COUNT(DISTINCT [Order ID]) AS Total_Orders,

    SUM(Quantity) AS Total_Units,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin,

    ROUND(
        SUM(Sales) / NULLIF(COUNT(DISTINCT [Order ID]), 0),
        2
    ) AS Average_Order_Value

FROM dbo.Orders;

-- Sales Performance by Category

SELECT
    Category,

    COUNT(DISTINCT [Order ID]) AS Total_Orders,

    SUM(Quantity) AS Total_Quantity,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin

FROM dbo.Orders

GROUP BY Category

ORDER BY Total_Sales DESC;

-- Loss-Making Subcategories

SELECT
    Category,
    [Sub-Category],

    COUNT(DISTINCT [Order ID]) AS Total_Orders,

    SUM(Quantity) AS Total_Quantity,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        AVG(Discount) * 100,
        2
    ) AS Average_Discount,

    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin

FROM dbo.Orders

GROUP BY
    Category,
    [Sub-Category]

HAVING SUM(Profit) < 0

ORDER BY Total_Profit ASC;

-- Regional Sales Performance with SQL JOIN

SELECT
    o.Region,
    p.[Regional Manager],

    COUNT(DISTINCT o.[Order ID]) AS Total_Orders,

    SUM(o.Quantity) AS Total_Units,

    ROUND(SUM(o.Sales), 2) AS Total_Sales,

    ROUND(SUM(o.Profit), 2) AS Total_Profit,

    ROUND(
        SUM(o.Profit) * 100.0 /
        NULLIF(SUM(o.Sales), 0),
        2
    ) AS Profit_Margin

FROM dbo.Orders AS o

INNER JOIN dbo.People AS p
    ON o.Region = p.Region

GROUP BY
    o.Region,
    p.[Regional Manager]

ORDER BY Total_Profit DESC;

-- Central Region Profitability by Category

SELECT
    Region,
    Category,

    COUNT(DISTINCT [Order ID]) AS Total_Orders,

    SUM(Quantity) AS Total_Quantity,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        AVG(Discount) * 100.0,
        2
    ) AS Average_Discount,

    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin

FROM dbo.Orders

WHERE Region = 'Central'

GROUP BY
    Region,
    Category

ORDER BY Total_Profit ASC;

-- Loss-Making Subcategories - Central Region

SELECT
    Category,
    [Sub-Category],

    COUNT(DISTINCT [Order ID]) AS Total_Orders,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        AVG(Discount) * 100.0,
        2
    ) AS Average_Discount,

    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin

FROM dbo.Orders

WHERE Region = 'Central'

GROUP BY
    Category,
    [Sub-Category]

HAVING SUM(Profit) < 0

ORDER BY Total_Profit ASC;

-- Bottom 10 Least Profitable Products

WITH product_performance AS (
    SELECT
        [Product ID] AS Product_ID,
        [Product Name] AS Product_Name,
        Category,

        COUNT(DISTINCT [Order ID]) AS Total_Orders,

        SUM(Quantity) AS Total_Quantity,

        ROUND(SUM(Sales), 2) AS Total_Sales,

        ROUND(SUM(Profit), 2) AS Total_Profit,

        ROUND(
            SUM(Profit) * 100.0 /
            NULLIF(SUM(Sales), 0),
            2
        ) AS Profit_Margin

    FROM dbo.Orders

    GROUP BY
        [Product ID],
        [Product Name],
        Category
)

SELECT TOP 10 *
FROM product_performance

WHERE Total_Profit < 0

ORDER BY Total_Profit ASC;

-- Rank least profitable products by category

WITH product_performance AS (
    SELECT
        [Product ID] AS Product_ID,
        [Product Name] AS Product_Name,
        Category,

        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit

    FROM dbo.Orders

    GROUP BY
        [Product ID],
        [Product Name],
        Category
),

ranked_products AS (
    SELECT
        Product_ID,
        Product_Name,
        Category,
        Total_Sales,
        Total_Profit,

        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Profit ASC
        ) AS Profit_Rank,

        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Profit ASC
        ) AS Dense_Profit_Rank

    FROM product_performance

    WHERE Total_Profit < 0
)

SELECT
    Category,
    Product_ID,
    Product_Name,

    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Total_Profit, 2) AS Total_Profit,

    Profit_Rank,
    Dense_Profit_Rank

FROM ranked_products

WHERE Profit_Rank <= 3

ORDER BY
    Category,
    Profit_Rank,
    Product_ID;

