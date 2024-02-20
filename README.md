# Customers-and-Products-Analysis-Using-SQL

The goal of this project is to analyze data from a sales records database for scale model cars and extract information for decision-making.

Question 1: Which products should we order more of or less of?

Question 2: How should we tailor marketing and communication strategies to customer behaviors?

Question 3: How much can we spend on acquiring new customers?

The first thing we need to do is load the database into DB browser:

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/497e3805-b567-4ea8-bfe6-e2d73541428d)

Next, we explore the data to understand what each table contains
The database schema is as follows:

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/4af36f7e-36e4-43a5-8fd3-9a7eca7a041b)

It contains eight tables:

Customers: customer data

Employees: all employee information

Offices: sales office information

Orders: customers' sales orders

OrderDetails: sales order line for each sales order

Payments: customers' payment records

Products: a list of scale model cars

ProductLines: a list of product line categories

# Question 1.  Which Products Should We Order More of or Less of?

Now that we know the database a little better, we can answer the first question: which products should we order more of or less of? This question refers to inventory reports, including low stock(i.e. product in demand) and product performance. This will optimize the supply and the user experience by preventing the best-selling products from going out-of-stock.

The low stock represents the quantity of the sum of each product ordered divided by the quantity of product in stock. We can consider the ten highest rates. These will be the top ten products that are almost out-of-stock or completely out-of-stock.

The product performance represents the sum of sales per product.

Priority products for restocking are those with high product performance that are on the brink of being out of stock.

We'll need to query for low stock and product performance for each product to display priority products for restocking. 

Below is the output for the final query:

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/638f5d58-3c30-4303-989f-165e192a08ff)

Our query showed that classic cars are the priority for restocking. They sell frequently, and they are the highest-performance products.

# Question 2. How Should We Match Marketing and Communication Strategies to Customer Behavior?

In the first part of this project, we explored products. Now we'll explore customer information by answering the second question: how should we match marketing and communication strategies to customer behaviors? This involves categorizing customers: finding the VIP (very important person) customers and those who are less engaged.

VIP customers bring in the most profit for the store.

Less-engaged customers bring in less profit.

First, we'll write a query to have the customers and products information in the same place. Then, we'll write two more queries to find the top 5 VIP's and least-engaged customers. 

The two outputs we got were the following:

VIP Customers

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/106d044e-3fd2-4150-8168-80479c00b73e)

Least Engaged Customers

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/7c1b5e59-8ef2-4015-9e67-61fe909382ec)

# Question 3. How Much Can We Spend on Acquiring New Customers?

Before answering this question, let's find the number of new customers arriving each month. That way we can check if it's worth spending money on acquiring new customers. 

We saw from a query we wrote that the number of clients has been decreasing since 2003, and in 2004, we had the lowest values. The year 2005, which is present in the database as well, isn't present in the table above, this means that the store has not had any new customers since September of 2004. This means it makes sense to spend money acquiring new customers.

To determine how much money we can spend acquiring new customers, we can compute the Customer Lifetime Value (LTV), which represents the average amount of money a customer generates. We can then determine how much we can spend on marketing.

The following is the output we got:

![image](https://github.com/youkichiba/Customers-and-Products-Analysis-Using-SQL/assets/107071042/55fea0b4-947c-46ce-9d91-e9d50702dba6)

LTV tells us how much profit an average customer generates during their lifetime with our store. We can use it to predict our future profit. So, if we get ten new customers next month, we'll earn 390,395 dollars, and we can decide based on this prediction how much we can spend on acquiring new customers.




