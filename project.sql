/* Customers table has info about customers like name, address, etc. 
Employees table has info about employess and who they report to 
Offices table has info about offices and their specific location
Orderdetails table has info about products ordered and how much as well as price
Orders table has dates of when the orders were placed and shipped
Payments table has info about when customers paid and how much they paid 
ProductLine table has descriptions of each product line
Products table has info about products like MSRP, quantity in stock, description, etc. */

SELECT 'Customers' as table_name,
13 as number_of_attributes,
COUNT(*) as number_of_rows
FROM customers

UNION ALL

SELECT 'Products' as table_name,
9 as number_of_attributes,
COUNT(*) as number_of_rows
FROM products

UNION ALL

SELECT 'ProductLines' as table_name,
4 as number_of_attributes,
COUNT(*) as number_of_rows
FROM productlines

UNION ALL

SELECT 'Orders' AS table_name, 
7 AS number_of_attribute,
COUNT(*) AS number_of_row
FROM Orders

UNION ALL

SELECT 'OrderDetails' AS table_name, 
5 AS number_of_attribute,
COUNT(*) AS number_of_row
FROM OrderDetails

UNION ALL

SELECT 'Payments' AS table_name, 
4 AS number_of_attribute,
COUNT(*) AS number_of_row
FROM Payments

UNION ALL

SELECT 'Employees' AS table_name, 
8 AS number_of_attribute,
COUNT(*) AS number_of_row
FROM Employees

UNION ALL

SELECT 'Offices' AS table_name, 
9 AS number_of_attribute,
COUNT(*) AS number_of_row
FROM Offices;

/* The code above queries each table's name, the number of attributes in each tbale, and the number of rows in each table 

Question 1: Which Products Should We Order More of or Less of?

This question refers to inventory reports, including low stock(i.e. product in demand) and product performance. 
This will optimize the supply and the user experience by preventing the best-selling products from going out-of-stock.

- The low stock represents the quantity of the sum of each product ordered divided by the quantity of product in stock.
We can consider the ten highest rates. These will be the top ten products that are almost out-of-stock or completely out-of-stock.

- The product performance represents the sum of sales per product.

- Priority products for restocking are those with high product performance that are on the brink of being out of stock.

First, We write a query to compute the low stock for each product using a correlated subquery:
*/

SELECT productCode,ROUND(SUM(quantityOrdered) * 1.0 / (SELECT quantityInStock
														FROM products p
														WHERE o.productCode = p.productCode), 2) AS low_stock
FROM orderdetails AS o
GROUP BY productCode
ORDER BY low_stock
LIMIT 10;

/* Second, We write a query to compute the product performance for each product: 
*/

SELECT productCode,
       SUM(quantityOrdered * priceEach) as product_performance
	FROM orderdetails
GROUP BY productCode
ORDER BY product_performance desc
LIMIT 10;

/* Lastly, We combine the previous queries using a Common Table Expression (CTE)
to display priority products for restocking using the IN operator:
*/ 
 
WITH low_stock AS(
SELECT productCode,ROUND(SUM(quantityOrdered) * 1.0 / (SELECT quantityInStock
														FROM products p
														WHERE o.productCode = p.productCode), 2) AS low_stock
FROM orderdetails AS o
GROUP BY productCode
ORDER BY low_stock
LIMIT 10)

SELECT 	p.productName,p.productLine,o.productCode, SUM(o.quantityOrdered  * o.priceEach) AS Product_Performance
FROM orderdetails o
JOIN products AS p
ON p.productCode = o.productCode
WHERE o.productCode IN (SELECT productCode
						FROM low_stock)
GROUP BY o.productCode
ORDER BY Product_Performance DESC;

/* Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior?

Now we'll explore customer information by answering the second question: 
how should we match marketing and communication strategies to customer behaviors? 
This involves categorizing customers: finding the VIP (very important person) customers and those who are less engaged.

- VIP customers bring in the most profit for the store.

- Less-engaged customers bring in less profit.

For example, we could organize some events to drive loyalty for the VIPs and launch a campaign for the less engaged.

We will write a query to join the products, orders, and orderdetails tables to have customers and products information in the same place.
We will compute, for each customer, the profit, 
which is the sum of quantityOrdered multiplied by priceEach minus buyPrice: SUM(quantityOrdered * (priceEach - buyPrice)). */

SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
 ORDER BY profit DESC;

/* Now we write a query to find the top five VIP customers and their country */

 WITH customer_orders AS(
 SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
 ORDER BY profit DESC
 LIMIT 5)
 
 SELECT customerName, customerNumber,contactFirstName,contactLastName, country
 FROM customers
 WHERE customerNumber IN(
						SELECT customerNumber
						FROM customer_orders);
						
/* Similar to the previous query, we write a query to find the top five least-engaged customers. */					

WITH leastcustomers AS(

SELECT o.customerNumber as customerNumber ,SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
FROM products as p
JOIN orderdetails as od
ON p.productCode = od.productCode
JOIN orders as o
ON o.orderNumber = od.orderNumber
GROUP BY customerNumber
ORDER BY profit ASC
LIMIT 5)

SELECT c.customerName,c.contactFirstName,c.contactLastName,c.country,l.profit as new_profit
FROM customers AS c
JOIN leastcustomers  AS l
ON  l.customerNumber = c.customerNumber
WHERE c.customerNumber IN(SELECT customerNumber
						FROM leastcustomers)
GROUP BY c.contactFirstName
ORDER BY new_profit			;

/* Question 3: How Much Can We Spend on Acquiring New Customers?

To determine how much money we can spend acquiring new customers, we can compute the Customer Lifetime Value (LTV), 
which represents the average amount of money a customer generates. We can then determine how much we can spend on marketing. */

WITH money_in_by_customer AS (
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS revenue
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)

SELECT AVG(mc.revenue) AS ltv
  FROM money_in_by_customer mc;
  
 
	








		
       