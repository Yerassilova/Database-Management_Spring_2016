--1. Display the name and city of customers who live in any city that makes the most
--different kinds of products. (There are two cities that make the most different
--products. Return the name and city of customers from either one of those.)

SELECT name, city
FROM customers
WHERE city IN  (SELECT city
                FROM products
                GROUP BY city
                ORDER BY count(city) desc
                LIMIT 1                
                );
                




--2. Display the names of products whose priceUSD is strictly above the average priceUSD,
--in reverse-alphabetical order.

SELECT name
FROM products
WHERE priceUSD > (SELECT AVG(priceUSD) AS Average
                   FROM products                                     
                );





--3. Display the customer name, pid ordered, and the total for all orders, sorted by total
--from high to low.


SELECT c.name, o.pid, o.totalUSD
FROM orders o,
     customers c
WHERE c.cid = o.cid
ORDER BY o.totalUSD DESC;





--4. Display all customer names (in alphabetical order) and their total ordered, and
--nothing more. Use coalesce to avoid showing NULLs.

SELECT name, coalesce(sum(qty),0)
FROM customers c LEFT OUTER JOIN orders o ON c.cid = o.cid
GROUP BY name, city
ORDER BY name





--5. Display the names of all customers who bought products from agents based in Tokyo
--along with the names of the products they ordered, and the names of the agents who
--sold it to them.

SELECT c.name, p.name, a.name
FROM orders o,
     customers c,
     agents a,
     products p
WHERE a.city = 'Tokyo'
  and o.cid = c.cid
  and o.aid = a.aid
  and o.pid = p.pid;





--6. Write a query to check the accuracy of the dollars column in the Orders table. This
--means calculating Orders.totalUSD from data in other tables and comparing those
--values to the values in Orders.totalUSD. Display all rows in Orders where
--Orders.totalUSD is incorrect, if any.

SELECT o.ordnum, (o.qty*p.priceUSD)  - (  (o.qty*p.priceUSD)  *  (c.discount)/100 ) AS MyCount
FROM orders o,
     customers c,
     products p
WHERE c.cid = o.cid
  AND p.pid = o.pid
  AND (o.qty*p.priceUSD)  - (  (o.qty*p.priceUSD)  *  (c.discount)/100 ) != o.totalUSD;





--7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give
--example queries in SQL to demonstrate. (Feel free to use the CAP2 database to make
--your points here.)

--Left Outer Join takes all the values from left hand table and shows the matches with the right hand table, 
--if they exist. If there is no match, it shows NULL. 
--In this case, we get all the rows from the left table, and matching ones from the right table. 
--In the example of CAP 3 database, if I use left outer join and 
--declare customer table as the left table, I can use a query to see which customer did not place any orders. 
--The query would look like: 

SELECT c.name, c.cid, o.cid, o.ordnum
FROM customers c LEFT OUTER JOIN orders o ON o.cid = c.cid;

--This way, I can see all the customer, and their corresponding order numbers, and if there are any customers 
--who didn’t order anything, I see the name and cid of the customer and NULLs for the order number. 
--In total, I get 15 rows back, in which I can see that Weyland is the customer in the database that did not order anything. 

--Right Outer Join is almost the same thing, just the opposite. 
--It takes all the values from the right hand table and matches with the left hand table and if there is no match, it displays NULLs. 
--Continuing from the previous query, I can switch and ask to see all the order numbers and see the names and cids of the 
--corresponding customers. It is unlikely to have an order number without having a customer name and cid, which is why, in the query below, 
--I don’t get any NULLs and can see all the 14 rows of orders and their corresponding customer info:

SELECT c.name, c.cid, o.cid, o.ordnum
FROM customers c RIGHT OUTER JOIN orders o ON o.cid = c.cid;


