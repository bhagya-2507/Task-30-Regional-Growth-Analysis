-- Task 30: Regional Growth Analysis
-- Compare regional sales growth over time using LAG().

WITH yearly_region_sales AS (
    SELECT
        Region,
        YEAR(Order_Date) AS sales_year,
        SUM(Sales) AS total_sales
    FROM Superstore
    GROUP BY Region, YEAR(Order_Date)
),
growth_analysis AS (
    SELECT
        Region,
        sales_year,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Region
            ORDER BY sales_year
        ) AS previous_year_sales
    FROM yearly_region_sales
)
SELECT
    Region,
    sales_year,
    total_sales,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS growth_percentage
FROM growth_analysis
WHERE previous_year_sales IS NOT NULL
ORDER BY Region, sales_year;
