USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT TABLE_NAME, TABLE_ROWS AS Total_No_Rows FROM INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = "imdb";


-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT
count(*) - count(id) AS null_id,
count(*) - count(title) AS null_title, 
count(*) - count( year) AS null_year, 
count(*) - count(date_published) AS null_date_published , 
count(*) - count(duration ) AS null_duration, 
count(*) - count( country) AS null_country, 
count(*) - count(worlwide_gross_income ) AS null_worlwide_gross_income, 
count(*) - count(languages) AS null_languages, 
count(*) - count( production_company) AS null_production_company
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year(date_published) AS year, count(title) AS Per_year_Released
from movie
group by year;

SELECT month(date_published) AS month, count(title) AS Per_month_Released
from movie
group by month
order by month DESC; 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(title) AS No_movies_releasedIn_USA_In_2019
from movie
where country = "USA" AND year(date_published) = 2019;

SELECT count(title) AS No_movies_releasedIn_India_In_2019
from movie
where country = "India" AND year(date_published) = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT  DISTINCT genre
from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,count(title) as count
from genre g
inner join movie m
on g.movie_id = m.id
group by genre
order by count desc
limit 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH CTE_1
AS 
(SELECT genre,count(title) as count, title
from genre g
inner join movie m
on g.movie_id = m.id
group by title
HAVING count(title) =1
order by count
)
SELECT count(title)
from CTE_1;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT genre ,round(avg(duration)) as avg_duration
from genre g
inner join movie m
on g.movie_id = m.id
group by genre
order by avg_duration desc;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


with CTE_2 as
(SELECT genre,count(title) as movie_count
from genre g
inner join movie m
on g.movie_id = m.id
group by genre
)
SELECT genre , movie_count, RANK() OVER (ORDER BY movie_count DESC) as genre_rank
FROM CTE_2;



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |max_total_votes|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT  min(avg_rating) AS min_avg_rating,
		max(avg_rating) AS max_avg_rating,
         min(total_votes) AS min_total_votes,
		max(total_votes) AS max_total_votes,
         min(median_rating) AS min_total_votes,
		max(median_rating) AS max_avg_rating
from ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title,avg_rating,RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
from ratings r
inner join movie m
on r.movie_id = m.id
limit 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT  median_rating, count(title)
from ratings r
inner join movie m
on r.movie_id = m.id
group by median_rating
ORDER BY median_rating;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with cte_3 as
(SELECT  production_company, count(title) AS movie_count
from ratings r
inner join movie m
on r.movie_id = m.id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company
order by movie_count DESC)
select production_company,movie_count, DENSE_RANK() OVER (order by movie_count DESC) AS prod_company_rank
from cte_3;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  genre, count(title) AS movie_count 
from 	genre
		inner join
		ratings r using (movie_id) 
		inner join movie m
		on r.movie_id = m.id
WHERE country = "USA" AND total_votes > 1000 AND year = 2017 AND month(date_published) =3
group by genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  title, avg_rating ,genre
from 	genre
		inner join
		ratings r using (movie_id) 
		inner join movie m
		on r.movie_id = m.id
WHERE avg_rating > 8 AND title LIKE "The%"
GROUP BY title;
--


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT  title,median_rating, date(date_published) AS released_date
from 	genre
		inner join
		ratings r using (movie_id) 
		inner join movie m
		on r.movie_id = m.id
WHERE median_rating = 8 AND date(date_published) between 20180401 AND 20190401
GROUP BY title
ORDER BY released_date;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT  languages,total_votes
from 	genre
		inner join
		ratings r using (movie_id) 
		inner join movie m
		on r.movie_id = m.id
WHERE languages = "Italian" OR languages = "German"
GROUP BY languages
ORDER BY total_votes DESC;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select count(*) - count(id) AS id_nulls ,count(*) - count(name) AS name_nulls ,count(*) - count(height) AS height_nulls,
count(*) - count(date_of_birth) AS date_of_birth_nulls ,count(*) - count(known_for_movies) AS known_for_movies_nulls from names;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_three_genre AS
(
SELECT   genre,Count(g.movie_id) AS movie_counts
FROM     genre AS g
         JOIN     ratings r
         ON       g.movie_id = r.movie_id
         WHERE    avg_rating > 8
         GROUP BY g.genre
         ORDER BY movie_counts DESC limit 3
)
SELECT n.name AS director_name,  count(g.movie_id) AS movie_count
FROM names n
	 join director_mapping d
     on n.id = d.name_id
     join genre g
     on d.movie_id = g.movie_id
     join ratings r
     on g.movie_id = r.movie_id,
     top_three_genre
WHERE g.genre IN (top_three_genre.genre) AND avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC 
LIMIT 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT name as actor_name, count(s.movie_id) AS movie_count
 FROM names n
	  JOIN role_mapping r
      on n.id = r.name_id
	  JOIN ratings s
      ON r.movie_id = s.movie_id
WHERE median_rating >= 8 AND category = "actor"
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company as production_company, sum(total_votes) AS vote_count,
RANK() OVER (ORDER BY sum(total_votes) DESC ) AS prod_comp_rank
FROM ratings r
	JOIN movie m
    on r.movie_id = m.id
GROUP BY production_company
LIMIT 3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name as actor_name, sum(total_votes) AS total_votes,  count(s.movie_id) AS movie_count , Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actor_avg_rating,
Rank() OVER (ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) DESC, sum(total_votes) DESC) AS actor_rank
 FROM names n
	  JOIN role_mapping r
      on n.id = r.name_id
	  JOIN ratings s
      ON r.movie_id = s.movie_id
      JOIN movie m
      ON r.movie_id = m.id
WHERE country = "India" AND category = "actor" 
GROUP BY actor_name
HAVING count(s.movie_id) >= 5;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name as actress_name, sum(total_votes) AS total_votes,  count(s.movie_id) AS movie_count , Round(Sum(avg_rating*total_votes)/Sum(total_votes),2)  AS actress_avg_rating,
Rank() OVER (ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) DESC, sum(total_votes) DESC) AS actess_rank
 FROM names n
	  JOIN role_mapping r
      on n.id = r.name_id
	  JOIN ratings s
      ON r.movie_id = s.movie_id
      JOIN movie m
      ON r.movie_id = m.id
WHERE languages = "Hindi" AND category = "actress"
GROUP BY actress_name
HAVING count(s.movie_id) >= 3;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


WITH triller_summery AS
(
SELECT avg_rating, title
FROM genre g
	JOIN ratings r
    ON g.movie_id = r.movie_id
    JOIN movie m
    ON r.movie_id = m.id
WHERE genre = "thriller"
)
SELECT *,
	CASE 
		WHEN avg_rating > 8 THEN "Superhit movies"
        WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
        WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
        ELSE "Flop movies"
         END AS cate
FROM triller_summery;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


WITH summery AS
(
SELECT genre, ROUND(avg(duration),2) AS avg_duration
FROM movie m
	 JOIN genre g
     ON m.id = g.movie_id
     GROUP BY genre
)
SELECT *,
 SUM(avg_duration) OVER w1 AS running_total_duration,
AVG(avg_duration) OVER w2 moving_avg_duration
FROM summery
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
       w2 AS (ORDER BY genre ROWs 10 PRECEDING);


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genre AS
(
SELECT genre, count(id) AS movie_counts,RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM movie m
	 JOIN genre g
     ON m.id = g.movie_id
     GROUP BY genre
     ORDER BY movie_counts DESC LIMIT 3
),
top_movie AS
(
SELECT genre, year, title AS movie_name,worlwide_gross_income,
RANK() OVER (PARTITION BY genre, year ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM movie m
	 JOIN genre g
     ON m.id = g.movie_id
WHERE genre IN (SELECT DISTINCT genre FROM top_genre WHERE genre_rank<=3)
)
SELECT * 
FROM
	top_movie
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH top_prod AS
(
SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie AS m
        LEFT JOIN
    ratings AS r
		ON m.id = r.movie_id
WHERE median_rating>=8 AND m.production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY m.production_company
)
SELECT 
    *
FROM
    top_prod
WHERE
    prod_company_rank <= 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT name AS actress_name, sum(total_votes) AS total_votes, count(n.id) AS movie_count, Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
RANK() OVER (ORDER BY count(n.id) DESC ) AS actress_rank
FROM 	genre g
		JOIN ratings r
		ON g.movie_id = r.movie_id
		JOIN movie m
		ON r.movie_id = m.id
		JOIN role_mapping p
		ON m.id = p.movie_id
		JOIN names n
      ON p.name_id = n.id
WHERE genre ="drama" AND category = "actress" AND avg_rating > 8
GROUP BY actress_name
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_release AS 
(
   SELECT
      n.name,
      m.title,
      m.date_published,
      LEAD(m.date_published, 1) OVER (PARTITION BY n.name 
   ORDER BY
      m.date_published) AS next_release_date 
   FROM
      movie AS m 
      INNER JOIN
         director_mapping AS dm 
         ON m.id = dm.movie_id 
      INNER JOIN
         names AS n 
         ON dm.name_id = n.id 
   ORDER BY
      n.name 
)
,
date_diff AS
(
   SELECT
      *,
      datediff(next_release_date, date_published) AS days_diff 
   FROM
      next_release
)
,
avg_inter AS 
(
   SELECT
      AVG(days_diff) AS avginter,
      name 
   FROM
      date_diff 
   GROUP BY
      name 
)
,
director AS 
(
   SELECT
      dm.name_id AS director_id,
      n.name AS director_name,
      COUNT(*) AS number_of_movies,
      ROW_NUMBER() OVER (
   ORDER BY
      COUNT(*) DESC) AS director_rank,
      AVG(r.avg_rating) AS avg_rating,
      SUM(r.total_votes) AS total_votes,
      MIN(r.avg_rating) AS minrating,
      MAX(r.avg_rating) AS maxrating,
      SUM(m.duration) AS total_duration 
   FROM
      movie AS m 
      INNER JOIN
         ratings r 
         ON m.id = r.movie_id 
      INNER JOIN
         director_mapping AS dm 
         ON m.id = dm.movie_id 
      INNER JOIN
         names AS n 
         ON dm.name_id = n.id 
   GROUP BY
      dm.name_id 
)
SELECT
   t.director_id,
   t.director_name,
   t.number_of_movies,
   a.avginter AS avg_inter_movie_dats,
   t.avg_rating,
   t.total_votes,
   t.minrating,
   t.maxrating,
   t.total_duration 
FROM
   director AS t 
   INNER JOIN
      avg_inter AS a 
      ON t.director_name = a.name 
WHERE
   director_rank <= 9;