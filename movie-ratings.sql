-- Create the database
CREATE DATABASE MovieRatingDB;

-- Switch to it
USE MovieRatingDB;

-- Create Users table
CREATE TABLE Users (
	user_id INT PRIMARY KEY,
	username VARCHAR(50)
	);

-- Create Movies table
CREATE TABLE Movies (
	movie_id INT PRIMARY KEY,
	title VARCHAR(100),
	genre VARCHAR(50),
	release_year INT
	);

-- Create Ratings table
CREATE TABLE Ratings (
	rating_id INT PRIMARY KEY,
	user_id INT,
	movie_id INT,
	rating INT CHECK (rating BETWEEN 1 AND 10),
	rating_date DATE,
	FOREIGN KEY(user_id) REFERENCES Users(user_id),
	FOREIGN KEY(movie_id) REFERENCES Movies(movie_id)
);

--Insert users
INSERT INTO Users VALUES
(1, 'moviebuff123'),
(2, 'cinemalover'),
(3, 'datafan');

--Insert movies
INSERT INTO Movies VALUES
(1, 'Inception', 'Sci-Fi', 2010),
(2, 'The Dark Knight', 'Action', 2008),
(3, 'Titanic', 'Romance', 1997);

--Insert ratings
INSERT INTO Ratings VALUES
(1, 1, 1, 9, '2023-01-15'),
(2, 1, 2, 10, '2023-01-20'),
(3, 2, 3, 8, '2023-02-10'),
(4, 3, 1, 7, '2023-02-15'),
(5, 2, 1, 8, '2023-02-20');

--Query: Average rating per movie
SELECT m.title, ROUND(AVG(r.rating),2) AS avg_rating
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;

--Query: Most active user (most ratings given)
SELECT TOP 1 u.username, COUNT(r.rating_id) AS total_ratings
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
GROUP BY u.username
ORDER BY total_ratings DESC
