/*								SQL Pizza Case study/ Pizza Project

Tables:
 orders        =>  order_id          | date          | time
 order_details =>  order_details_id	 | order_id	     | pizza_id	 | quantity
 pizza_types   =>  pizza_type_id     | name          | category  | ingredients
 pizzas        =>  pizza_id          | pizza_type_id | size      | price
 

Task:
1- Retrieve the total number of orders placed and the Total of Quantity
2- Calculate the total revenue generated from pizza sales.
3- Identify the highest-priced pizza.
4- Identify the most common pizza size ordered.
5- List the top 5 most ordered pizza types along with their quantities.
6- Join the necessary tables to find the total quantity of each pizza category ordered.
7- Determine the distribution of orders by hour of the day.
8- Determine the distribution and total of orders from each day
9- Group the orders by date and calculate the average number of pizzas ordered per day.
10- Determine the top 3 most ordered pizza types based on revenue.

*/

-- 1- Retrieve the total number of orders placed and the Total of Quantity

select count(distinct orders.order_id) as TotalOrder,
	   SUM(order_details.quantity) as SumQuantity
from orders
join order_details
	ON orders.order_id = order_details.order_id

-- 2- Calculate the total revenue generated from pizza sales.

select cast(sum(quantity * price)  as decimal (10,2)) TTPrice
from order_details
join pizzas
	ON order_details.pizza_id = pizzas.pizza_id

-- 3- Identify the highest-priced pizza.

select top 1 pizza_id, cast(pizzas.price as decimal (10,2)) As TTPrice
  from pizzas
  order by cast(price As decimal (10,2)) desc

-- 4- Identify the most common pizza size ordered.

select pizzas.size, count( distinct order_details.order_id) TTOrder, SUM(quantity) TTQuantity
  from pizzas
  Join order_details
	ON order_details.pizza_id=pizzas.pizza_id
Group by size
order by TTOrder desc

-- 5- List the top 5 most ordered pizza types along with their quantities.

select  top 5 pizza_types.name , sum(order_details.quantity) as TTQuantity
from pizza_types
join pizzas
	ON pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
	On order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.name
order by TTQuantity desc

-- 6- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) TTQuantity
from order_details
join pizzas
	ON pizzas.pizza_id=order_details.pizza_id
join pizza_types
	ON pizza_types.pizza_type_id=pizzas.pizza_type_id
Group by category
order by TTQuantity desc

-- 7- Determine the distribution of orders by hour of the day.

select DATEPART(hour, time) As Hours, COUNT(distinct order_id) as CountOrder
from orders
Group by DATEPART(hour, time)
order by 'CountOrder' desc

-- 8- Determine the distribution and total of orders from each day

select CONVERT(date, (orders.date)) as 'day', count(distinct order_id) as 'TTOrders'
from orders
group by orders.date
order by orders.date

-- 9- Group the orders by date and calculate the average number of pizzas ordered per day.

select cast(AVG([TTQuantity]) as decimal (10,2)) as AVGPIZZA from 
	(
	select orders.date, sum(order_details.quantity) as TTQuantity
	from order_details
	join orders
		ON orders.order_id=order_details.order_id
	group by orders.date
	) as HOTPizza

-- 10- Determine the top 3 most ordered pizza types based on revenue.

	select top 3 pizza_types.name, cast(SUM(pizzas.price * order_details.quantity) as decimal(7,2)) as TT
from pizza_types
join pizzas
	ON pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
	ON order_details.pizza_id=pizzas.pizza_id
group by name
order by TT desc

