-- ============================================
-- THEME 5: CONTENT SEASONALITY
-- Business Pillar: Growth
-- Executive Question: Does Netflix weaponize 
-- holiday months to spike content drops?
-- Techniques: CTE, RANK(), CASE WHEN,
--             GROUP BY, ORDER BY
-- ============================================

WITH monthly_content AS (
    SELECT
        month_added,
        COUNT(*) AS total_titles
    FROM netflix_cleaned
    WHERE month_added IS NOT NULL
    GROUP BY month_added
)

SELECT
    month_added,
    total_titles,
    RANK() OVER (ORDER BY total_titles DESC) AS ranking,
    CASE
        WHEN month_added = 1  THEN 'January'
        WHEN month_added = 2  THEN 'February'
        WHEN month_added = 3  THEN 'March'
        WHEN month_added = 4  THEN 'April'
        WHEN month_added = 5  THEN 'May'
        WHEN month_added = 6  THEN 'June'
        WHEN month_added = 7  THEN 'July'
        WHEN month_added = 8  THEN 'August'
        WHEN month_added = 9  THEN 'September'
        WHEN month_added = 10 THEN 'October'
        WHEN month_added = 11 THEN 'November'
        ELSE                       'December'
    END AS month_name,
    CASE
        WHEN month_added IN (7, 8)       THEN 'Summer Peak'
        WHEN month_added IN (11, 12)     THEN 'Holiday Season'
        WHEN month_added IN (1, 2)       THEN 'Post Holiday Drought'
        WHEN month_added IN (3, 4, 5)    THEN 'Spring Push'
        ELSE                                  'Regular Month'
    END AS season_strategy
FROM monthly_content
ORDER BY total_titles DESC;

-- ============================================
-- KEY INSIGHT:
-- Netflix peaks in July (827 titles) confirming
-- deliberate summer strategy not the commonly
-- assumed January push. February is weakest
-- month with only 563 titles — clear post
-- holiday content drought. Q3 is strongest
-- quarter overall
-- ============================================
