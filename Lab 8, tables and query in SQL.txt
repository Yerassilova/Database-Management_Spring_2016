DROP TABLE IF EXISTS guild_winners;
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS actors;

DROP TABLE IF EXISTS actors_in_movies;
DROP TABLE IF EXISTS directors_in_movies;

DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS people;


-- People --
CREATE TABLE people (
  pid         char(4) not null,
  first_name  text,
  last_name   text,
  DOB_YYYY_MM_DD         date,
 primary key(pid)
);


-- Actors --
CREATE TABLE actors (
  aid            char(3) not null references people(pid),
  hair_color     text,
  eye_color      text,
  height_inches  integer,
  weight_lbs     integer,
 primary key(aid)
);        


-- Directors --
CREATE TABLE directors (
  did                char(3) not null references people(pid),
  film_school        text,
  spouse_first_name  text,
  spouse_last_name text, 
 primary key(did)
);


-- Guild Winners -- 
CREATE TABLE guild_winners (
  pid          char(3) not null references people(pid),
  year_won     integer,    
  as_star      boolean,
  as_director  boolean,
 primary key(pid)
);


-- Movies--
CREATE TABLE movies (
  mid                char(5) not null,
  name               text,
  year_released      integer, 
 primary key(mid)
);


-- Actors_in_movies--
CREATE TABLE actors_in_movies (
  pid              char(3) not null references people(pid),
  mid              char(3) not null references movies(mid),
  mpaa_rating      char(5),
 primary key(pid, mid)
);


-- Directors_in_movies--
CREATE TABLE directors_in_movies (
  pid                  char(3) not null references people(pid),
  mid                  char(3) not null references movies(mid),
  domestic_sales$      integer, 
 primary key(pid, mid)
);



-- SQL statements for loading example data: --

-- People --
INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('1', 'Sean', 'Connery', '08/25/1930');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('2', 'Honor', 'Blackman', '08/22/1925');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('3', 'Ben', 'Affleck', '08/15/1972');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('4', 'Johnny', 'Depp', '06/09/1963');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('5', 'Keira', 'Knightley', '03/26/1985');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('6', 'Guy', 'Hamilton', '09/16/1922');

INSERT INTO people( pid, first_name, last_name, DOB_YYYY_MM_DD )
  VALUES('7', 'Gore', 'Verbinski', '03/16/1964');


--Actors--
INSERT INTO actors( aid, hair_color, eye_color, height_inches, weight_lbs )
  VALUES('1', null, null, null, null);

INSERT INTO actors( aid, hair_color, eye_color, height_inches, weight_lbs )
  VALUES('2', 'grey', 'blue', 66, 125);

INSERT INTO actors( aid, hair_color, eye_color, height_inches, weight_lbs )
  VALUES('3', 'black', 'black', 76, 216);

INSERT INTO actors( aid, hair_color, eye_color, height_inches, weight_lbs )
  VALUES('4', 'brown', 'brown', 70, 157);

INSERT INTO actors( aid, hair_color, eye_color, height_inches, weight_lbs )
  VALUES('5', 'brown', 'brown', 67, 119);


--Directors--
INSERT INTO directors( did, film_school, spouse_first_name, spouse_last_name )
  VALUES('3', null, null, null);

INSERT INTO directors( did, film_school, spouse_first_name, spouse_last_name )
  VALUES('6', null, 'Naomi', 'Chance');

INSERT INTO directors( did, film_school, spouse_first_name, spouse_last_name )
  VALUES('7', 'UCLA Film School', null, null);



--Guild Winners--
INSERT INTO guild_winners( pid, year_won, as_star, as_director )
  VALUES('3', 2012, 'yes', 'no');

INSERT INTO guild_winners( pid, year_won, as_star, as_director )
  VALUES('4', 2015, 'yes', 'yes');

INSERT INTO guild_winners( pid, year_won, as_star, as_director )
  VALUES('7', 2012, 'no', 'no');



--Movies--
INSERT INTO movies( mid, name, year_released )
  VALUES('M01', 'Goldfinger', 1964);

INSERT INTO movies( mid, name, year_released )
  VALUES('M02', 'Argo', 2012);

INSERT INTO movies( mid, name, year_released )
  VALUES('M03', 'Pirates of the Caribbean: The Curse of the Black Pearl', 2003);




--Actors_in_movies--
INSERT INTO actors_in_movies( pid, mid, mpaa_rating )
  VALUES('1', 'M01', 'PG');

INSERT INTO actors_in_movies( pid, mid, mpaa_rating )
  VALUES('2', 'M01', 'PG');

INSERT INTO actors_in_movies( pid, mid, mpaa_rating )
  VALUES('3', 'M02', 'R');

INSERT INTO actors_in_movies( pid, mid, mpaa_rating )
  VALUES('4', 'M03', 'PG-13');

INSERT INTO actors_in_movies( pid, mid, mpaa_rating )
  VALUES('5', 'M03', 'PG-13');




--Directors_in_movies--
INSERT INTO directors_in_movies( pid, mid, domestic_sales$ )
  VALUES('3', 'M02', 136025503);

INSERT INTO directors_in_movies( pid, mid, domestic_sales$ )
  VALUES('6', 'M01', 51081062);

INSERT INTO directors_in_movies( pid, mid, domestic_sales$ )
  VALUES('7', 'M03', 305411224);



-- check --

select *
from people;

select *
from actors;

select *
from directors;

select *
from guild_winners;

select *
from movies;

select *
from actors_in_movies;

select *
from directors_in_movies;
----------------------------------------------------------------------

--Working on query show all the directors with whom actor “Sean Connery” has worked: --
--1--
select p.pid
from people p
where first_name = 'Sean'
  and last_name = 'Connery';

--2--
select a.mid
from people p,
actors_in_movies a
where a.pid = p.pid
 and p.pid = '1';


--3--
select distinct d.pid
from directors_in_movies d,
     actors_in_movies a
where a.mid = d.mid
  and a.mid = 'M01';


--4--
select p.first_name, p.last_name
from people p,
     directors_in_movies d
where d.pid = p.pid
  and d.pid = '6';


-----------------------------------------------------------

--Final Query to show all the directors with whom actor “Sean Connery” has worked: --

select p.first_name, p.last_name
from people p,
     directors_in_movies d
where d.pid = p.pid
  and d.pid in ( select distinct d.pid
                 from directors_in_movies d,
                      actors_in_movies a
                 where a.mid = d.mid
                   and a.mid in ( select a.mid
                                  from people p,
                                       actors_in_movies a
                                  where a.pid = p.pid
                                    and p.pid in (select p.pid
                                                  from people p
                                                  where first_name = 'Sean'
                                                    and last_name = 'Connery'
                                                  )
                                  )
                     );  






