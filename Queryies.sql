--CREATE COMBINED TABLE
CREATE table appleStore_description_combined as 

SELECT * from appleStore_description1
union all 
SELECT * from appleStore_description2
union all 
SELECT * from appleStore_description3
union all 
SELECT * from appleStore_description3

**EDA**
--CHECK THE NUMBER OF UNIQUE APPS IN BOTH TABLEAPPLESTORE

SELECT COUNT(DISTINCT id) as UniqueAppIDs
from AppleStore

SELECT COUNT(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

--CHECK FOR ANY MISSING VALUES IN KEY FIELDS 

SELECT COUNT(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

SELECT COUNT(*) as MissingValues
from appleStore_description_combined
where app_desc is null

-- FIND OUT THE NUMBER OF APPS PER GENRE
	--Games And Entertainment Have High Competition.. high Demand From Users
Select prime_genre, count(*) as NumApps
from AppleStore
GROUP by prime_genre
ORDER by NumApps desc

--GET AN OVERVIEW OF THE APPS RATINGS
	--A new apps should aim for an average rating above 3.5

SELECT min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore

--Detrmine whether paid apps have higher ratings than free apps 
	-- Paid Apps Have Better Ratings
SELECT case 
			WHEn price > 0 THEN 'Paid'
            else 'Free'
       END As AppType,
       avg(user_rating) as avgRating
from AppleStore
GROUP by AppType

-- CHECK IF APPS WITH MORE SUPPORTED LANGUAGE HAVE HIGHER RATINGS
	-- App SUPPORTING between 10 and 30 LANGUAGEs have better  ratings 
SELECT CASE
			WHEN lang_num < 10 then '<10 Languages'
            WHEN lang_num BETWEEN 10 AND 30 then '10 - 30 Languages'
            else '>30 Languages'
       end as LanguagesBuckets,
       avg(user_rating) as AvgRating
FROM AppleStore
GROUP by LanguagesBuckets
order by AvgRating desc

-- CHECK GENRES WITH LOW RATINGS 
	-- Finance and  book Apps Have Low Ratings
SELECT prime_genre, avg(user_rating) as AvgRating
from AppleStore
GROUP by prime_genre
ORDER by AvgRating ASC
limit 10

-- CHECK IF THERE IS CORRELATION BETWEEN THE LENGTH OF THE APP DESCRIPTION AND USER RATING 
	--The Length of the description has a positive correlation with the user ratings  
SELECT case
			when length(app_desc) <500 then 'Short'
            when length(app_desc) BETWEEN 500 and 1000 then 'Medium'
            ELSE 'Long'
       end as descriptionLengthBucket,
       avg(a.user_rating) as AvgRating

from 
	AppleStore as a
JOIN 
	appleStore_description_combined as b 
on 
	a.id = b.id

group by descriptionLengthBucket
ORDER by AvgRating
