-- ============================================
-- THEME 11: AUDIENCE MONETIZATION FUNNEL
-- Business Pillar: Audience
-- Executive Question: How aggressively is 
-- Netflix scaling TV-MA content to drive
-- premium subscriber signups?
-- Techniques: CTE, LAG(), NULLIF(),
--             CASE WHEN, ROUND()
-- ============================================

WITH rating_yearly AS (
    SELECT
        year_added,
        COUNT(*)                                        AS total_titles,
        SUM(CASE WHEN rating = 'TV-MA'
            THEN 1 ELSE 0 END)                          AS tvma_titles,
        SUM(CASE WHEN rating IN ('TV-Y','TV-Y7',
            'TV-G','G')
            THEN 1 ELSE 0 END)                          AS kids_titles
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    AND year_added >= 2015
    AND rating IS NOT NULL
    GROUP BY year_added
),
with_percentage AS (
    SELECT
        year_added,
        total_titles,
        tvma_titles,
        kids_titles,
        ROUND(tvma_titles * 100.0 /
              NULLIF(total_titles, 0), 2)               AS tvma_pct,
        ROUND(kids_titles * 100.0 /
              NULLIF(total_titles, 0), 2)               AS kids_pct,
        -- YoY change in TV-MA
        LAG(tvma_titles) OVER
            (ORDER BY year_added)                       AS prev_tvma,
        ROUND(
            (tvma_titles - LAG(tvma_titles)
                OVER (ORDER BY year_added)) * 100.0 /
            NULLIF(LAG(tvma_titles)
                OVER (ORDER BY year_added), 0)
        , 2)                                            AS tvma_growth_pct
    FROM rating_yearly
)

SELECT
    year_added,
    total_titles,
    tvma_titles,
    kids_titles,
    tvma_pct,
    kids_pct,
    tvma_growth_pct,
    -- Monetization Label
    CASE
        WHEN tvma_pct > 40 THEN 'Aggressive Adult Push'
        WHEN tvma_pct > 30 THEN 'Moderate Adult Push'
        WHEN tvma_pct > 20 THEN 'Balanced Strategy'
        ELSE                    'Family Focused'
    END                                                 AS monetization_strategy
FROM with_percentage
ORDER BY year_added;

-- ============================================
-- KEY INSIGHT:
-- Netflix maintained consistent Moderate Adult
-- Push keeping TV-MA between 32-39% without
-- ever crossing 40% Aggressive threshold.
-- Kids content collapsed from 20.73% in 2015
-- to historic low of 7.74% in 2019 before
-- recovering to 12.82% in 2021 suggesting
-- Netflix recognized risk of abandoning
-- family subscribers entirely
-- ============================================
