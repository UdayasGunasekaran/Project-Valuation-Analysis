-- Creating Table

USE netflix;
SHOW TABLES;
CREATE TABLE IF NOT EXISTS PROJECT_VALUATION_ANALYSIS (
    COMPANY VARCHAR(50),
    VALUATION_B VARCHAR(50),
    DATA_JOINED DATE,
    COUNTRY VARCHAR(50),
    CITY VARCHAR(50),
    FIRST_CATEGORY_INDUSTRY VARCHAR(70),
    SECOND_CATEGORY_INDUSTRY VARCHAR(50),
    THIRD_CATEGORY_INDUSTRY VARCHAR(50),
    FIRST_CATEGORY_INVESTOR VARCHAR(50),
    SECOND_CATEGORY_INVESTOR VARCHAR(50),
    THIRD_CATEGORY_INVESTOR VARCHAR(50),
    FOURTH_CATEGORY_INVESTOR VARCHAR(50)
);

-- Check the Uploaded data

SELECT 
    *
FROM
    netflix.project_valuation_analysis;

-- Handling Missing Data

SELECT 
    *
FROM
    netflix.project_valuation_analysis
WHERE
    COMPANY IS NULL
        OR VALUATION_IN_BILLION IS NULL
        OR DATE_JOINED IS NULL
        OR COUNTRY IS NULL
        OR CITY IS NULL
        OR FIRST_CATEGORY_INDUSTRY IS NULL
        OR SECOND_CATEGORY_INDUSTRY IS NULL
        OR THIRD_CATEGORY_INDUSTRY IS NULL
        OR FIRST_CATEGORY_INVESTOR IS NULL
        OR SECOND_CATEGORY_INVESTOR IS NULL
        OR THIRD_CATEGORY_INVESTOR IS NULL
        OR FOURTH_CATEGORY_INVESTOR IS NULL;

-- Identifying Duplicate rows

SELECT 
    COMPANY,
    VALUATION_IN_BILLION,
    DATE_JOINED,
    COUNTRY,
    CITY,
    FIRST_CATEGORY_INDUSTRY,
    SECOND_CATEGORY_INDUSTRY,
    THIRD_CATEGORY_INDUSTRY,
    FIRST_CATEGORY_INVESTOR,
    SECOND_CATEGORY_INVESTOR,
    THIRD_CATEGORY_INVESTOR,
    FOURTH_CATEGORY_INVESTOR,
    COUNT(*) AS count
FROM
    netflix.project_valuation_analysis
GROUP BY COMPANY , VALUATION_IN_BILLION , DATE_JOINED , COUNTRY , CITY , FIRST_CATEGORY_INDUSTRY , SECOND_CATEGORY_INDUSTRY , THIRD_CATEGORY_INDUSTRY , FIRST_CATEGORY_INVESTOR , SECOND_CATEGORY_INVESTOR , THIRD_CATEGORY_INVESTOR , FOURTH_CATEGORY_INVESTOR
HAVING COUNT(*) > 1;

-- Removing Duplicate rows

DELETE FROM netflix.project_valuation_analysis 
WHERE
    (COMPANY , VALUATION_IN_BILLION,
    DATE_JOINED,
    COUNTRY,
    CITY,
    FIRST_CATEGORY_INDUSTRY,
    SECOND_CATEGORY_INDUSTRY,
    THIRD_CATEGORY_INDUSTRY,
    FIRST_CATEGORY_INVESTOR,
    SECOND_CATEGORY_INVESTOR,
    THIRD_CATEGORY_INVESTOR,
    FOURTH_CATEGORY_INVESTOR) NOT IN (SELECT 
        COMPANY,
            VALUATION_IN_BILLION,
            DATE_JOINED,
            COUNTRY,
            CITY,
            FIRST_CATEGORY_INDUSTRY,
            SECOND_CATEGORY_INDUSTRY,
            THIRD_CATEGORY_INDUSTRY,
            FIRST_CATEGORY_INVESTOR,
            SECOND_CATEGORY_INVESTOR,
            THIRD_CATEGORY_INVESTOR,
            FOURTH_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis
    GROUP BY COMPANY , VALUATION_IN_BILLION , DATE_JOINED , COUNTRY , CITY , FIRST_CATEGORY_INDUSTRY , SECOND_CATEGORY_INDUSTRY , THIRD_CATEGORY_INDUSTRY , FIRST_CATEGORY_INVESTOR , SECOND_CATEGORY_INVESTOR , THIRD_CATEGORY_INVESTOR , FOURTH_CATEGORY_INVESTOR);
    
-- Overview of Data --    
    
SELECT 
    *
FROM
    netflix.project_valuation_analysis
LIMIT 10;

-- Total Number of Companies --

SELECT 
    COUNT(*) AS total_companies
FROM
    netflix.project_valuation_analysis;

 
-- Companies Founded Each Year --

SELECT 
    YEAR(DATE_JOINED) AS year, COUNT(*) AS company_count
FROM
    netflix.project_valuation_analysis
GROUP BY year
ORDER BY year;


-- Companies per Country --

SELECT 
    COUNTRY, COUNT(*) AS company_count
FROM
    netflix.project_valuation_analysis
GROUP BY COUNTRY
ORDER BY company_count DESC;

-- Top 10 Highest Valued Companies --

SELECT 
    COMPANY, VALUATION_IN_BILLION
FROM
    netflix.project_valuation_analysis
ORDER BY VALUATION_IN_BILLION DESC
LIMIT 10;

-- Industry Distribution --

SELECT 
    'First Category' AS categorical_data,
    FIRST_CATEGORY_INDUSTRY AS industry_type,
    COUNT(*) AS industry_count
FROM
    netflix.project_valuation_analysis
WHERE
    FIRST_CATEGORY_INDUSTRY IS NOT NULL
GROUP BY FIRST_CATEGORY_INDUSTRY 
UNION ALL SELECT 
    'Second Category' AS categorical_data,
    SECOND_CATEGORY_INDUSTRY AS industry_type,
    COUNT(*) AS industry_count
FROM
    netflix.project_valuation_analysis
WHERE
    SECOND_CATEGORY_INDUSTRY IS NOT NULL
GROUP BY SECOND_CATEGORY_INDUSTRY 
UNION ALL SELECT 
    'Third Category' AS categorical_data,
    THIRD_CATEGORY_INDUSTRY AS industry_type,
    COUNT(*) AS industry_count
FROM
    netflix.project_valuation_analysis
WHERE
    THIRD_CATEGORY_INDUSTRY IS NOT NULL
GROUP BY THIRD_CATEGORY_INDUSTRY
ORDER BY industry_count DESC;

-- Top 5 Industry (Irrespective of industry type) --

WITH industry_counts AS (
    SELECT
        FIRST_CATEGORY_INDUSTRY AS industry_type,
        COUNT(*) AS industry_count
    FROM
        netflix.project_valuation_analysis
    WHERE
        FIRST_CATEGORY_INDUSTRY IS NOT NULL
    GROUP BY
        FIRST_CATEGORY_INDUSTRY
    UNION ALL
    SELECT
        SECOND_CATEGORY_INDUSTRY AS industry_type,
        COUNT(*) AS industry_count
    FROM
        netflix.project_valuation_analysis
    WHERE
        SECOND_CATEGORY_INDUSTRY IS NOT NULL
    GROUP BY
        SECOND_CATEGORY_INDUSTRY
    UNION ALL
    SELECT
        THIRD_CATEGORY_INDUSTRY AS industry_type,
        COUNT(*) AS industry_count
    FROM
        netflix.project_valuation_analysis
    WHERE
        THIRD_CATEGORY_INDUSTRY IS NOT NULL
    GROUP BY
        THIRD_CATEGORY_INDUSTRY
)
SELECT industry_type, industry_count
FROM industry_counts
ORDER BY industry_count DESC
LIMIT 5;

-- Investor Category Analysis --

SELECT 
    'First Category' AS categorical_data,
    FIRST_CATEGORY_INVESTOR AS investor_type,
    COUNT(*) AS investor_count
FROM
    netflix.project_valuation_analysis
WHERE
    FIRST_CATEGORY_INVESTOR IS NOT NULL
GROUP BY FIRST_CATEGORY_INVESTOR 
UNION ALL SELECT 
    'Second Category' AS categorical_data,
    SECOND_CATEGORY_INVESTOR AS investor_type,
    COUNT(*) AS investor_count
FROM
    netflix.project_valuation_analysis
WHERE
    SECOND_CATEGORY_INVESTOR IS NOT NULL
GROUP BY SECOND_CATEGORY_INVESTOR 
UNION ALL SELECT 
    'Third Category' AS categorical_data,
    THIRD_CATEGORY_INVESTOR AS investor_type,
    COUNT(*) AS investor_count
FROM
    netflix.project_valuation_analysis
WHERE
    THIRD_CATEGORY_INVESTOR IS NOT NULL
GROUP BY THIRD_CATEGORY_INVESTOR
ORDER BY categorical_data ASC;

-- Top 5 Investor (Irrespective of Investor type) --

WITH CombinedData AS (
    SELECT 
        FIRST_CATEGORY_INVESTOR AS investor,
        COUNT(*) AS investor_count
    FROM netflix.project_valuation_analysis
    WHERE FIRST_CATEGORY_INVESTOR IS NOT NULL
    GROUP BY FIRST_CATEGORY_INVESTOR
    UNION ALL
    SELECT 
        SECOND_CATEGORY_INVESTOR AS investor,
        COUNT(*) AS investor_count
    FROM netflix.project_valuation_analysis
    WHERE SECOND_CATEGORY_INVESTOR IS NOT NULL
    GROUP BY SECOND_CATEGORY_INVESTOR
    UNION ALL
    SELECT 
        THIRD_CATEGORY_INVESTOR AS investor,
        COUNT(*) AS investor_count
    FROM netflix.project_valuation_analysis
    WHERE THIRD_CATEGORY_INVESTOR IS NOT NULL
    GROUP BY THIRD_CATEGORY_INVESTOR
),
RankedData AS (
    SELECT 
        investor,
        SUM(investor_count) AS total_investor_count,
        ROW_NUMBER() OVER (ORDER BY SUM(investor_count) DESC) AS Investor_rank
    FROM CombinedData
    GROUP BY investor
)
SELECT 
    investor, total_investor_count
FROM
    RankedData
WHERE
    Investor_rank <= 5
ORDER BY Investor_rank ASC;

-- Yearly Company Growth Trend --

SELECT 
    YEAR(DATE_JOINED) AS year, COUNT(*) AS company_count
FROM
    netflix.project_valuation_analysis
GROUP BY year
ORDER BY year;

-- Companies by City --

SELECT 
    CITY, COUNT(*) AS company_count
FROM
    netflix.project_valuation_analysis
GROUP BY CITY
ORDER BY company_count DESC;

-- Companies with Multiple Investors --

SELECT 
    COMPANY, COUNT(*) AS investor_count
FROM
    (SELECT 
        COMPANY, FIRST_CATEGORY_INVESTOR AS investor
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, SECOND_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, THIRD_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, FOURTH_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis) AS investors_data
GROUP BY COMPANY
ORDER BY investor_count DESC
LIMIT 10;

-- Industry-wise Valuation Analysis --

SELECT 
    FIRST_CATEGORY_INDUSTRY,
    AVG(CAST(VALUATION_IN_BILLION AS DECIMAL)) AS avg_valuation
FROM
    netflix.project_valuation_analysis
GROUP BY FIRST_CATEGORY_INDUSTRY
ORDER BY avg_valuation DESC;

-- Top Companies with Year-over-Year Valuation Growth -- 

SELECT COMPANY, YEAR(DATE_JOINED) AS year, 
       VALUATION_IN_BILLION, 
       LAG(VALUATION_IN_BILLION) OVER (PARTITION BY COMPANY ORDER BY DATE_JOINED) AS prev_valuation,
       (VALUATION_IN_BILLION - LAG(VALUATION_IN_BILLION) OVER (PARTITION BY COMPANY ORDER BY DATE_JOINED)) AS valuation_growth
FROM netflix.project_valuation_analysis;

-- Industry Growth Over Time --

SELECT YEAR(DATE_JOINED) AS year,
       SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END) AS total_industry_count,
       LAG(SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END)) 
       OVER (ORDER BY YEAR(DATE_JOINED)) AS prev_industry_count,
       SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END) -
       LAG(SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END))
       OVER (ORDER BY YEAR(DATE_JOINED)) AS industry_growth,
       CASE 
           WHEN LAG(SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                        CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                        CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END)) 
           OVER (ORDER BY YEAR(DATE_JOINED)) > 0 THEN
               ROUND(
                   (SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                        CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                        CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END) -
                    LAG(SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                             CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                             CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END))
                    OVER (ORDER BY YEAR(DATE_JOINED))) /
                   LAG(SUM(CASE WHEN FIRST_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                            CASE WHEN SECOND_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END +
                            CASE WHEN THIRD_CATEGORY_INDUSTRY IS NOT NULL THEN 1 ELSE 0 END)) 
                   OVER (ORDER BY YEAR(DATE_JOINED)) * 100, 2)
           ELSE NULL
       END AS industry_growth_percentage
FROM netflix.project_valuation_analysis
GROUP BY YEAR(DATE_JOINED)
ORDER BY YEAR(DATE_JOINED);

-- Companies with Most Diverse Investments

SELECT 
    COMPANY, COUNT(DISTINCT investor) AS investor_count
FROM
    (SELECT 
        COMPANY, FIRST_CATEGORY_INVESTOR AS investor
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, SECOND_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, THIRD_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, FOURTH_CATEGORY_INVESTOR
    FROM
        netflix.project_valuation_analysis) AS investors_data
GROUP BY COMPANY
ORDER BY investor_count DESC
LIMIT 10;

-- Ranking Companies Within Industries --

SELECT COMPANY, FIRST_CATEGORY_INDUSTRY AS INDUSTRY_CATEGORY, VALUATION_IN_BILLION,
       RANK() OVER (PARTITION BY FIRST_CATEGORY_INDUSTRY ORDER BY CAST(VALUATION_IN_BILLION AS DECIMAL) DESC) AS rank_within_industry
FROM netflix.project_valuation_analysis

UNION ALL

SELECT COMPANY, SECOND_CATEGORY_INDUSTRY AS INDUSTRY_CATEGORY, VALUATION_IN_BILLION,
       RANK() OVER (PARTITION BY SECOND_CATEGORY_INDUSTRY ORDER BY CAST(VALUATION_IN_BILLION AS DECIMAL) DESC) AS rank_within_industry
FROM netflix.project_valuation_analysis

UNION ALL

SELECT COMPANY, THIRD_CATEGORY_INDUSTRY AS INDUSTRY_CATEGORY, VALUATION_IN_BILLION,
       RANK() OVER (PARTITION BY THIRD_CATEGORY_INDUSTRY ORDER BY CAST(VALUATION_IN_BILLION AS DECIMAL) DESC) AS rank_within_industry
FROM netflix.project_valuation_analysis

ORDER BY INDUSTRY_CATEGORY, rank_within_industry;

-- To verify whether the data is unique or there's an issue with the ranking logic

SELECT 
    FIRST_CATEGORY_INDUSTRY, COUNT(*) AS company_count
FROM
    netflix.project_valuation_analysis
GROUP BY FIRST_CATEGORY_INDUSTRY
ORDER BY company_count DESC;


-- check for duplicate valuations in each industry with:

SELECT 
    FIRST_CATEGORY_INDUSTRY, VALUATION_IN_BILLION, COUNT(*)
FROM
    netflix.project_valuation_analysis
GROUP BY FIRST_CATEGORY_INDUSTRY , VALUATION_IN_BILLION
ORDER BY FIRST_CATEGORY_INDUSTRY;

-- Outlier Detection in Valuation --

SELECT 
    COMPANY, 
    FIRST_CATEGORY_INDUSTRY, 
    SECOND_CATEGORY_INDUSTRY, 
    THIRD_CATEGORY_INDUSTRY, 
    VALUATION_IN_BILLION, 
    AVG(CAST(VALUATION_IN_BILLION AS DECIMAL)) OVER (
        PARTITION BY FIRST_CATEGORY_INDUSTRY, SECOND_CATEGORY_INDUSTRY, THIRD_CATEGORY_INDUSTRY
    ) AS avg_industry_valuation
FROM 
    netflix.project_valuation_analysis
WHERE 
    CAST(VALUATION_IN_BILLION AS DECIMAL) > (
        SELECT AVG(CAST(VALUATION_IN_BILLION AS DECIMAL)) 
        FROM netflix.project_valuation_analysis
    );
    
-- Most Active Cities for Startups --
    
SELECT CITY, COUNT(*) AS company_count,
	RANK() OVER (ORDER BY COUNT(*) DESC) AS city_rank
FROM netflix.project_valuation_analysis
GROUP BY CITY
ORDER BY city_rank;

-- Investor Portfolio Analysis --

SELECT 
    investor,
    COUNT(DISTINCT COMPANY) AS company_count,
    AVG(CAST(VALUATION_IN_BILLION AS DECIMAL)) AS avg_valuation
FROM
    (SELECT 
        COMPANY, FIRST_CATEGORY_INVESTOR AS investor, VALUATION_IN_BILLION
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, SECOND_CATEGORY_INVESTOR, VALUATION_IN_BILLION
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, THIRD_CATEGORY_INVESTOR, VALUATION_IN_BILLION
    FROM
        netflix.project_valuation_analysis UNION ALL SELECT 
        COMPANY, FOURTH_CATEGORY_INVESTOR, VALUATION_IN_BILLION
    FROM
        netflix.project_valuation_analysis) AS investors_data
GROUP BY investor
ORDER BY company_count DESC , avg_valuation DESC;