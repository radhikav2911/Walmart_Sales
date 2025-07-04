select * from walmart


-- Q1.Find different payment methods, number of transactions, and quantity sold by payment method¶
SELECT 
	payment_method, 
	count (*) as no_transactions, 
	sum(quantity) as no_quanity_sold 
	from walmart 
	group by payment_method

-- Q2: Identify the highest-rated category in each branch. Display the branch, category, and average rating
SELECT DISTINCT ON (branch)
    branch,
    category,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY branch, category
ORDER BY branch, avg_rating DESC

--Q3: a) Identify the busiest day for each branch based on the number of transactions
	--b) Identify the busiest month for each branch based on the number of transactions

--A
SELECT * from 
	(SELECT 
		branch,
		TO_CHAR(TO_DATE(date,'DD/MM/YY'), 'DAY') as day_name,
		COUNT (*) as no_transactions,
		RANK() over(partition by branch order by count(*) desc) as rank	
	FROM walmart
	GROUP BY 1,2)
where rank = 1

--B
SELECT * from 
	(SELECT 
		branch,
		TO_CHAR(TO_DATE(date,'DD/MM/YY'), 'Month') as month_name,
		COUNT (*) as no_transactions,
		RANK() over(partition by branch order by count(*) desc) as rank
	FROM walmart
	GROUP BY 1,2)
where rank = 1


--Q4: Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT 
payment_method, 
SUM(quantity) as no_quantity_sold
FROM walmart
GROUP BY payment_method

--Q5: Deteremine the avg,max amd min rating of category of each city.List the city, avg_rating, min_rating and max_rating?

SELECT
	city,
	category,
	avg(rating) as avg_rating, 
	min(rating) as min_rating, 
	max(rating) as max_rating
FROM walmart
Group by city, category


-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.
--(unit_price * quantity * profit_margin) as total_profit
SELECT
category,  sum(total * profit_margin) as profit 
From walmart
group by category
order by profit desc

-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

WITH cte 
AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1, 2
)
SELECT *
FROM cte
WHERE rank = 1

-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT
	branch,
CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC


