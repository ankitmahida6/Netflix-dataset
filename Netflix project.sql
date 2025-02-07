-- Netflix dataset project
select * from netflix_info;
-- 20 SQL Questions for Netflix Dataset Project

-- Beginner Level Questions
-- 1. Total Number of Titles
select 
	count(title) as total_titles 
from netflix_info;

-- Answer: Provides the total count of titles in the Netflix dataset.


-- 2. Movies vs TV Shows Distribution
select 
	count(*) AS total_count,
	round(count(*) * 100.0 / (select count(*) from netflix_info), 2) as percentages
from netflix_info;

-- Answer: Shows the distribution of Movies and TV Shows with their percentages.


-- 3. Unique Ratings Available
select 
	distinct(rating) 
from netflix_info
order by rating;

-- Answer: Lists all unique rating categories in the dataset.


-- Intermediate Level Questions
-- 4. Top 5 Countries with Most Content
select 
	country,
	count(*) as total_count
from netflix_info
where country is not null
group by country
order by 2 desc
limit 5;

-- Answer: Identifies the top 5 countries with the most Netflix content.


-- 5. Average Release Year by Content Type
select 
	title,
	ROUND(avg(release_year), 2) as avg_year
from netflix_info
group by 1;

-- Answer: Calculates the average release year for Movies and TV Shows.


-- 6. Directors with Most Titles

select 
	director,
	count(title) as total_count
from netflix_info
where director is not null
group by 1
order by 2 desc
limit 10;

-- Answer: Lists top 10 directors with the most titles.


-- Advanced Level Questions
-- 7. Content Added by Year

select
	to_date(date_added, 'mm-dd-yyyy'),
	count(*) as total_count
from netflix_info
group by 1
order by 2 desc;

-- Answer: Analyzes content addition trends by year.


-- 8. Genre Analysis for TV Shows

select 
	listed_in,
	count(*) as total_show,
	round(count(*) * 100.0 / (select count(*) from netflix_info where genre = 'TV Show'), 2) as pernt
from netflix_info
where genre = 'TV Show'
group by 1
order by 2 desc
limit 5;

select * from netflix_info;

SELECT listed_in, 
       COUNT(*) as show_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_info WHERE genre = 'TV Show'), 2) as percentage
FROM netflix_info 
WHERE genre = 'TV Show' 
GROUP BY listed_in 
ORDER BY show_count DESC 
LIMIT 5;

-- Answer: Explores the most common genres for TV Shows.

-- 9. Long-Form Content Identification

select
	title,
	genre,
	duration
from netflix_info
where genre = 'Movie' and cast(regexp_replace(duration, '[^0-9]', '','g') as int) > 90
or genre = 'TV Show' and cast(regexp_replace(duration, '[^0-9]', '','g') as int) > 3
order by cast(regexp_replace(duration, '[^0-9]', '','g') as int) desc;

-- Answer: Finds movies over 1.5 hours and TV shows with more than 3 seasons.


-- Expert Level Questions
-- 10. Multi-Country Content

select 
	title,
	count(distinct country) as country_count
from netflix_info
where country is not null
group by 1
having 2 >= 1
order by 2;

-- Answer: Identifies titles available in multiple countries.


-- 11. Seasonal Content Distribution

SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM date_clean) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM date_clean) IN (3, 4, 5) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date_clean) IN (6, 7, 8) THEN 'Rain'
        ELSE 'Autumn'
    END AS season,
    COUNT(*) AS titles_added
FROM (
    SELECT 
        COALESCE( 
            TO_DATE(date_added, 'MM-DD-YYYY'),  -- First try MM-DD-YYYY format
            TO_DATE(date_added, 'Month DD, YYYY') -- If that fails, try Month DD, YYYY
        ) AS date_clean
    FROM netflix_info
    WHERE date_added IS NOT NULL
) subquery
GROUP BY season
ORDER BY titles_added;

-- Answer: Analyzes content addition by season.

-- 12. Rating Diversity Analysis

SELECT rating, 
       COUNT(*) as title_count,
       ROUND(AVG(release_year), 0) as avg_release_year
FROM netflix_info 
GROUP BY rating 
ORDER BY title_count DESC;

-- Answer: Provides insights into rating distribution and average release years.


-- Complex Analytical Queries
-- 13. Content Trends Over Decades

SELECT 
	CASE 
		WHEN release_year between 1950 AND 1959 THEN '1950s'
		WHEN release_year between 1960 and 1969 then '1960s'
		WHEN release_year between 1970 and 1979 then '1970s'
		WHEN release_year between 1980 and 1989 then '1980s'
		WHEN release_year between 2000 and 2010 then '2000s'
		else '2010s and later'
	end as decades,
	count(*) as total_count,
	round(count(*) * 100 / (select count(*) from netflix_info), 0) as percnt
from netflix_info
group by 1
order by 2 desc;

-- Answer: Tracks content distribution across different decades.


-- 14. International Content Analysis

select 
	case 
		when country is null then 'unknown'
		else country
	end as content_country,
	count(*) as total_content,
	round(count(*) * 100 / (select count(*) from netflix_info), 0) as percents,
	round(avg(release_year), 0) as avg_year
from netflix_info
group by 1
order by 2 desc;

-- Answer: Provides insights into international content distribution.


-- 15. Director Productivity

select 
	director, 
	count(*) as total_content,
	round(avg(release_year), 0) as avg_year
from netflix_info
where director is not null
group by 1
order by 2 desc
limit 10;

-- Answer: Identifies most productive directors.
