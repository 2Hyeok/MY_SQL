create database moviedb;

use moviedb;
create table movietbl
(movie_id int,
 movie_title varchar(30),
 movie_director varchar(20),
 movie_star varchar(20),
 movie_script longtext,
 movie_film longblob
 ) default charset=utf8mb4;
 
 desc movietbl;
 
 insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨', load_file('C:/Users/BIT/Desktop/sql/Movies/Schindler.txt'),
																 load_file('C:/Users/BIT/Desktop/sql/Movies/Schindler.mp4'));

select * from movietbl;