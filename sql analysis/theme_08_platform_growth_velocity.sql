-- ============================================
-- THEME 8: PLATFORM GROWTH VELOCITY
-- Business Pillar: Growth
-- Executive Question: Is content acquisition 
-- accelerating, peaking or dying?
-- Techniques: CTE, LAG(), LEAD(),
--             SUM() OVER(), NULLIF(),
--             Running Total, YoY Growth %
-- ============================================

WITH yearly_content AS (
    SELECT
        year_added,
        COUNT(*)                        AS total_titles
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    GROUP BY year_added
),
growth_analysis AS (
    SELECT
        year_added,
        total_titles,
        -- Previous year count
        LAG(total_titles) OVER
            (ORDER BY year_added)       AS prev_year_titles,
        -- Running total
        SUM(total_titles) OVER
            (ORDER BY year_added)       AS cumulative_titles,
        -- YoY Growth %
        ROUND(
            (total_titles - LAG(total_titles)
                OVER (ORDER BY year_added))
            * 100.0 /
            NULLIF(LAG(total_titles)
                OVER (ORDER BY year_added), 0)
        , 2)                            AS yoy_growth_pct
    FROM yearly_content
)

SELECT
    year_added,
    total_titles,
    prev_year_titles,
    cumulative_titles,
    yoy_growth_pct,
    -- Business Label
    CASE
        WHEN yoy_growth_pct > 50   THEN 'Hyper Growth'
        WHEN yoy_growth_pct > 20   THEN 'Strong Growth'
        WHEN yoy_growth_pct > 0    THEN 'Slow Growth'
        WHEN yoy_growth_pct = 0    THEN 'Flat'
        ELSE                            'Decline'
    END                             AS growth_stage
FROM growth_analysis
ORDER BY year_added;

-- ============================================
-- KEY INSIGHT:
-- Netflix experienced 3 consecutive years of
-- Hyper Growth 2015-2017 peaking at +420% in
-- 2016. Platform peaked in 2019 with 2016 new
-- titles. COVID triggered first ever consecutive
-- decline in 2020 (-6.8%) and 2021 (-20.28%)
-- Cumulative library still reached 8794 titles
-- by end of 2021
-- ============================================
