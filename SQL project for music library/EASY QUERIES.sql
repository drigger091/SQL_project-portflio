--- Question set1 easy
use custom

-- who is the senior most employee on job title?

SELECT TOP 1 *
FROM employee
ORDER BY levels DESC;

-- which countries have the most invoices?

select COUNT(*) as c , billing_country from invoice 
Group by billing_country
order by c desc

-- what are top 3 values of total invoices?
select top 3 total, billing_country from invoice
order by total desc

-- which city has the best customers?  we would  like to throw a promotional music festival in the city we have made the most money. write a query
-- that returns one city that has the highest sum of invoices totals. Return both the cityname & sum of all invoice totals?

select sum(customer_id) as number_of_customers , sum(total) as invoice_total , billing_city 
from invoice
Group By billing_city
order by invoice_total desc

--- who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- write a query that returns the person who has spent the most money

select * from customer
select * from invoice

select top 1 customer.customer_id ,customer.first_name, customer.last_name , SUM(invoice.total) as total from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc



SELECT TOP 1 customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total DESC;

