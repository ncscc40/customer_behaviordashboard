create table zepto(sku_id serial primary key,
Category varchar(120),	
name varchar(120) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice	numeric(8,2),
weightInGms	integer,
outOfStock	boolean,
quantity integer
);
select * from zepto
limit 5
--count of rows
select count(*)from zepto
--sample data 
select * from zepto
limit 10
-- null values
select * from zepto
where sku_id is null 
or category is null
or mrp is null 
or discountpercent is null 
or availablequantity is null 
or discountedsellingprice is null 
or weightingms is null 
or outofstock is null 
or quantity is null;
--checking outofstock and in stock--
select outofstock,count(sku_id)as total
from zepto
group by outofstock;
-- diff product category--
select distinct category  from zepto
order by category;
--products names present multiple times--
select name, count(sku_id) from zepto 
group by name 
order by count(sku_id) desc
-- data cleaning--


--product with o price--
select * from zepto 
where mrp=0 or discountedsellingprice=0
--delecting the mrp=0--
delete from zepto 
where mrp= 0
--convert paisa into rupees--
update zepto
set mrp=mrp/100.0,discountedsellingprice=discountedsellingprice/100.0
-- we are checking the updated or not--
select mrp,discountedsellingprice from zepto limit 10


--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountpercent from zepto
order by discountpercent desc
limit 10
--What are the Products with High MRP but Out of Stock
select distinct name,mrp from zepto
where outofstock='true'and mrp>300
order by mrp desc
--checking outofstock and in stock 
select outofstock,count(outofstock)as total from zepto 
group by outofstock
----Q3.Calculate Estimated Revenue for each category--
select category,
sum(discountedsellingprice*availablequantity)as total_revenue from zepto
group by category
order by total_revenue
--Q4. Find all products where MRP is greater than 500 and discount is less than 10%
select  distinct(name),mrp, discountpercent from zepto 
where mrp>500 and discountpercent<10
order by mrp desc,discountpercent desc
. ---Identify the top 5 categories offering the highest average discount percentage.
select category,round(avg(discountpercent),2)as avgper 
from zepto group by category 
order by avgper desc
limit 10
--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,
--round(discountedsellingprice/weightingms),2) 
round((discountedsellingprice/weightingms),2)
as price_per_gram
from zepto 
where weightingms>=100
order by price_per_gram desc
--7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightingms,
case when weightingms<1000 then 'low'
      when weightingms<5000 then 'mediam'
	  when weightingms>2500 then 'bulk'
	  else 'bulk'
	  end as categories
	  from zepto
	  order by weightingms desc
--Q8.What is the Total Inventory Weight Per Category
select category,sum(weightingms*availablequantity) as total
from zepto 
group by category
order by total