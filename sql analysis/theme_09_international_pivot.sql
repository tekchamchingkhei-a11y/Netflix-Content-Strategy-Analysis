-- ============================================
-- THEME 9: THE INTERNATIONAL PIVOT
-- Business Pillar: Growth
-- Executive Question: In what exact year did 
-- Netflix shift from US-centric to Global?
-- Techniques: CTE, LAG(), CASE WHEN,
--             NULLIF(), SUM() OVER()
-- ============================================

WITH yearly_country AS (
    SELECT
        year_added,
        COUNT(*)                                    AS total_titles,
        SUM(CASE WHEN country = 'United States'
            THEN 1 ELSE 0 END)                      AS us_titles,
        SUM(CASE WHEN country != 'United States'
            AND country != 'Unknown'
            THEN 1 ELSE 0 END)                      AS international_titles
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    AND year_added >= 2015
    GROUP BY year_added
),
with_percentage AS (
    SELECT
        year_added,
        total_titles,
        us_titles,
        international_titles,
        ROUND(us_titles * 100.0 /
              NULLIF(total_titles, 0), 2)            AS us_pct,
        ROUND(international_titles * 100.0 /
              NULLIF(total_titles, 0), 2)            AS international_pct,
        LAG(ROUND(international_titles * 100.0 /
              NULLIF(total_titles, 0), 2))
              OVER (ORDER BY year_added)             AS prev_international_pct
    FROM yearly_country
)

SELECT
    year_added,
    total_titles,
    us_titles,
    international_titles,
    us_pct,
    international_pct,
    prev_international_pct,
    -- Year over Year international change
    ROUND(international_pct -
          prev_international_pct, 2)                AS intl_pct_change,
    -- Pivot Label
    CASE
        WHEN international_pct > us_pct THEN 'International Dominant'
        WHEN us_pct > international_pct THEN 'US Dominant'
        ELSE                                 'Balanced'
    END                                              AS platform_focus
FROM with_percentage
ORDER BY year_added;

-- ============================================
-- KEY INSIGHT:
-- Netflix flipped from US Dominant (60.98%)
-- to International Dominant (58.78%) in a
-- single year 2016 — one of the most decisive
-- strategic pivots in streaming history.
-- International dominance held for 6 consecutive
-- years peaking at 65.43% in 2018. Combined
-- with Theme 6 and Theme 8 findings 2016
-- emerges as Netflix's single most important
-- strategic year
-- ============================================
