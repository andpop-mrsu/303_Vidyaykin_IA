#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies m WHERE m.id IN (SELECT movie_id FROM ratings) ORDER BY year,title LIMIT 10;"
echo " "

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM users WHERE name LIKE '%% A%%' ORDER BY register_date limit 5;"
echo " "

echo "3.  Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT u.name, m.title, m."year", r.rating, DATE(r."timestamp", 'unixepoch') AS rating_date FROM ratings r JOIN users u ON u.id == r.user_id JOIN movies m ON m.id == r.movie_id ORDER BY u.name, m.title, r.rating LIMIT 50;"
echo " "

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT mov.*, tag FROM movies mov INNER JOIN tags tag ON mov.id = tag.movie_id ORDER BY year, title, tag LIMIT 40;"
echo " "

echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies WHERE year = (SELECT MAX(year) FROM movies);"
echo " "

echo "6. Найти все комедии, выпущенные после 2000 года, которые понравились мужчинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT mov.title, mov.year, COUNT(CASE mov.title WHEN mov.title THEN 1 ELSE null END) AS count_ratings FROM movies mov JOIN ratings rating ON mov.id = rating.movie_id JOIN users user ON rating.user_id = user.id WHERE year > 2000 AND genres LIKE '%%Comedy%%' AND gender == 'male' AND rating.rating >= 4.5 GROUP BY title  ORDER BY year, title;"
echo " "

echo "7. Провести анализ занятий (профессий) пользователей - вывести количество пользователей для каждого рода занятий. Найти самую распространенную и самую редкую профессию посетитетей сайта."
echo --------------------------------------------------
echo "Количество пользователей для каждого рода занятий"
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT() AS count_users FROM users u GROUP BY u.occupation ORDER BY count_users "
echo "Самая распространенная профессия посетитетей сайта"
sqlite3 movies_rating.db -box -echo "SELECT occupation, MAX(count_user) as max FROM ( SELECT occupation, COUNT() as count_user FROM users u GROUP BY u.occupation)"
echo "Самая редкуя профессия посетитетей сайта"
sqlite3 movies_rating.db -box -echo "SELECT occupation, MIN(count_user) as max FROM ( SELECT occupation, COUNT() as count_user FROM users u GROUP BY u.occupation)"