# Netflix Data Analysis Project 🎥

![Netflix Logo](https://github.com/ankitmahida6/Netflix-dataset/blob/main/Netflix_Logo.png)

Welcome to the **Netflix Data Analysis Project**! This project leverages PostgreSQL to analyze Netflix's dataset, providing insights into movies, TV shows, ratings, genres, and more. Whether you're a data enthusiast, a Netflix fan, or a SQL learner, this project will help you explore and understand the data behind one of the world's most popular streaming platforms.

---

## 📌 **Project Overview**

This project focuses on analyzing Netflix's dataset using PostgreSQL. The dataset includes information about movies and TV shows, such as:
- Titles
- Directors
- Cast
- Countries
- Release years
- Genres
- Ratings
- Duration

The goal is to perform **data exploration**, **cleaning**, and **analysis** to uncover trends, patterns, and insights about Netflix's content library.

---

## 🛠️ **Technologies Used**

- **Database**: PostgreSQL
- **Tools**: pgAdmin, SQL Shell (psql)
- **Dataset**: Netflix Movies and TV Shows (publicly available dataset)
- **Other Skills**: SQL queries, data cleaning, data analysis

---

## 🗂️ **Dataset Details**

The dataset used in this project contains the following columns:
- `show_id`: Unique ID for each movie/TV show
- `type`: Type of content (Movie or TV Show)
- `title`: Title of the movie/TV show
- `director`: Director(s) of the content
- `cast`: Main actors/actresses
- `country`: Country of production
- `date_added`: Date added to Netflix
- `release_year`: Year of release
- `rating`: Content rating (e.g., PG-13, TV-MA)
- `duration`: Duration of the content (in minutes or seasons)
- `listed_in`: Genres

---

## 📊 **Key Insights**

Here are some of the key insights derived from the analysis:
1. **Content Distribution**: Percentage of Movies vs. TV Shows.
2. **Top Genres**: Most popular genres on Netflix.
3. **Release Trends**: Analysis of content released over the years.
4. **Ratings Analysis**: Distribution of content ratings (e.g., PG-13, TV-MA).
5. **Top Directors and Actors**: Most frequent directors and actors in Netflix's library.
6. **Country-wise Analysis**: Countries producing the most content.

---
## 🚀 **How to Use This Project**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/ankitmahida6/Netflix-dataset/blob/main/Netflix_Dataset.csv

   # Netflix Dataset Analysis

## 📌 Overview
This repository contains SQL queries used to analyze the Netflix dataset. The queries cover various aspects, such as content distribution, long-form content identification, seasonal trends, and more.

---

## 📂 Repository Structure
```
📁 netflix-dataset-analysis
 ├── 📄 README.md  (This File)
 ├── 📂 data       (Dataset files)
 ├── 📂 queries    (SQL queries)
 ├── 📂 results    (Query output results)
```

---

## 📊 SQL Queries & Explanations

### 1️⃣ Total Number of Titles
```sql
SELECT 
	COUNT(title) AS total_titles 
FROM netflix_info;
```
🔹 **Purpose:** Provides the total count of titles in the Netflix dataset.

---

### 2️⃣ Movies vs TV Shows Distribution
```sql
SELECT 
	COUNT(*) AS total_count,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_info), 2) AS percentages
FROM netflix_info;
```
🔹 **Purpose:** Shows the distribution of Movies and TV Shows with their percentages.

---

### 3️⃣ Unique Ratings Available
```sql
SELECT 
	DISTINCT(rating) 
FROM netflix_info
ORDER BY rating;
```
🔹 **Purpose:** Lists all unique rating categories in the dataset.

---

### 4️⃣ Top 5 Countries with Most Content
```sql
SELECT 
	country,
	COUNT(*) AS total_count
FROM netflix_info
WHERE country IS NOT NULL
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;
```
🔹 **Purpose:** Identifies the top 5 countries with the most Netflix content.

---

### 5️⃣ Average Release Year by Content Type
```sql
SELECT 
	title,
	ROUND(AVG(release_year), 2) AS avg_year
FROM netflix_info
GROUP BY 1;
```
🔹 **Purpose:** Calculates the average release year for Movies and TV Shows.

---

### 6️⃣ Directors with Most Titles
```sql
SELECT 
	director,
	COUNT(title) AS total_count
FROM netflix_info
WHERE director IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
🔹 **Purpose:** Lists top 10 directors with the most titles.

---

### 7️⃣ Content Added by Year
```sql
SELECT
	TO_DATE(date_added, 'mm-dd-yyyy'),
	COUNT(*) AS total_count
FROM netflix_info
GROUP BY 1
ORDER BY 2 DESC;
```
🔹 **Purpose:** Analyzes content addition trends by year.

---

### 8️⃣ Genre Analysis for TV Shows
```sql
SELECT 
	listed_in,
	COUNT(*) AS total_show,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_info WHERE genre = 'TV Show'), 2) AS pernt
FROM netflix_info
WHERE genre = 'TV Show'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
🔹 **Purpose:** Explores the most common genres for TV Shows.

---

### 9️⃣ Long-Form Content Identification
```sql
SELECT
	title,
	genre,
	duration
FROM netflix_info
WHERE genre = 'Movie' AND CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT) > 90
   OR genre = 'TV Show' AND CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT) > 3
ORDER BY CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT) DESC;
```
🔹 **Purpose:** Finds movies over 1.5 hours and TV shows with more than 3 seasons.

---

### 🔟 Multi-Country Content
```sql
SELECT 
	title,
	COUNT(DISTINCT country) AS country_count
FROM netflix_info
WHERE country IS NOT NULL
GROUP BY 1
HAVING 2 >= 1
ORDER BY 2;
```
🔹 **Purpose:** Identifies titles available in multiple countries.

---

### 1️⃣1️⃣ Seasonal Content Distribution
```sql
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
            TO_DATE(date_added, 'MM-DD-YYYY'),  
            TO_DATE(date_added, 'Month DD, YYYY') 
        ) AS date_clean
    FROM netflix_info
    WHERE date_added IS NOT NULL
) subquery
GROUP BY season
ORDER BY titles_added;
```
🔹 **Purpose:** Analyzes content addition by season.

---

### 1️⃣2️⃣ Rating Diversity Analysis
```sql
SELECT rating, 
       COUNT(*) AS title_count,
       ROUND(AVG(release_year), 0) AS avg_release_year
FROM netflix_info 
GROUP BY rating 
ORDER BY title_count DESC;
```
🔹 **Purpose:** Provides insights into rating distribution and average release years.

---

## 🛠️ GitHub Commands for Repository Management

### 📌 Initializing Repository
```sh
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/netflix-dataset.git
git push -u origin main
```

### 📌 Pushing Changes
```sh
git add .
git commit -m "Added new SQL queries"
git push origin main
```

### 📌 Pulling Latest Updates
```sh
git pull origin main
```

### 📌 Cloning Repository
```sh
git clone https://github.com/ankitmahida6/Netflix-dataset.git
```

---

## 📢 Contributing
Feel free to fork this repository, make improvements, and submit a pull request. Contributions are welcome! 🚀

---

## 📜 License
This project is open-source and available under the MIT License.
