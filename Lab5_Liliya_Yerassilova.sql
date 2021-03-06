--1. Show the cities of agents booking an order for a customer whose id is 'c002'. 
--Use joins; no subqueries. 


SELECT a.city
FROM   orders o,
       agents a, 
       customers c
WHERE  o.aid = a.aid
  AND  c.cid = o.cid
  AND  c.cid = 'c002';
  
  

  
--2. Show the ids of products ordered through any agent who makes at least one order 
--for a customer in Dallas, sorted by pid from highest to lowest. Use joins; no subqueries. 


SELECT DISTINCT p.pid
FROM orders o1 INNER JOIN customers c ON c.city = 'Dallas' AND o1.cid = c.cid
               INNER JOIN orders o2 ON o1.aid = o2.aid
               INNER JOIN products p ON o2.pid = p.pid
GROUP BY p.pid
ORDER BY pid DESC;




--3. Show the names of customers who have never placed an order. Use a subquery. 


SELECT DISTINCT name
FROM customers
WHERE cid NOT IN (SELECT cid
                  FROM orders
                  );




--4. Show the names of customers who have never placed an order. Use an outer join.

 
SELECT c.name
FROM customers c LEFT OUTER JOIN orders o ON o.cid = c.cid
WHERE ordnum is null;




--5. Show the names of customers who placed at least one order through an agent 
--in their own city, along with those agent(s') names. 


SELECT DISTINCT c.name, a.name
FROM orders o INNER JOIN customers c ON o.cid = c.cid
              INNER JOIN agents a ON o.aid = a.aid
WHERE a.city = c.city;




--6. Show the names of customers and agents living in the same city, along with the name 
--of the shared city, regardless of whether or not the customer has ever placed an order 
--with that agent. 


SELECT c.name, a.name, c.city, a.city
FROM customers c,
     agents a
WHERE a.city = c.city;


--7. Show the name and city of customers who live in the city that makes the fewest 
--different kinds of products. (Hint: Use count and group by on the Products table.)


SELECT name, city
FROM customers
WHERE city IN  (SELECT city
                FROM products
                GROUP BY city
                ORDER BY count(city)
                LIMIT 1
                );





