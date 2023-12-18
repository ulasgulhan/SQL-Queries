WITH CategoryStats AS (
    SELECT
        dbo.Categories.CategoryID,
        dbo.Categories.CategoryName,
        AVG(dbo.Products.UnitPrice) AS [Average Unit Price],
        MAX(dbo.Products.UnitPrice) AS [Max Unit Price],
        MIN(dbo.Products.UnitPrice) AS [Min Unit Price],
        ROW_NUMBER() OVER (PARTITION BY dbo.Categories.CategoryID ORDER BY dbo.Products.UnitPrice DESC) AS PriceDescRank,
        ROW_NUMBER() OVER (PARTITION BY dbo.Categories.CategoryID ORDER BY dbo.Products.UnitPrice ASC) AS PriceAscRank,
        dbo.Products.ProductName,
        dbo.Products.UnitPrice
    FROM
        dbo.Categories
    LEFT JOIN
        dbo.Products ON dbo.Categories.CategoryID = dbo.Products.CategoryID
    GROUP BY
        dbo.Categories.CategoryID, dbo.Categories.CategoryName, dbo.Products.ProductName, dbo.Products.UnitPrice
)
SELECT
    CategoryID,
    CategoryName,
    AVG([Average Unit Price]) AS [Average Unit Price],
    MAX([Max Unit Price]) AS [Max Unit Price],
    MIN([Min Unit Price]) AS [Min Unit Price],
    MAX(CASE WHEN PriceDescRank = 1 THEN ProductName END) AS [Most Expensive Product],
    MAX(CASE WHEN PriceAscRank = 1 THEN ProductName END) AS [Cheapest Product]
FROM
    CategoryStats
GROUP BY
    CategoryID, CategoryName;