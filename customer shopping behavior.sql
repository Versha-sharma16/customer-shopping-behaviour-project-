create database customer_behavior;
SELECT * FROM cleaned_data;
# total revenue according to gender 
select gender, sum(purchase_amount) as revenue
from cleaned_data
group by gender;




SELECT customer_id, purchase_amount
FROM cleaned_data
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount) 
    FROM cleaned_data
);

#top 5 products with highest avg review rating 
select item_purchased, avg(review_rating)
from cleaned_data
group by item_purchased
order by avg(review_rating) desc
limit 5;

#compare the avg product amount between standard and express shipping 

select shipping_type,
avg(purchase_amount)
from cleaned_data
where shipping_type in ('standard', 'express')
group by shipping_type
;

#do subsribed customer paid more? compare avg spend and total revenue between subscriber and non - subscriber
select subscription_status,
count(customer_id) as total_customer,
round(avg (purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from cleaned_data
group by subscription_status 
order by total_revenue, avg_spend desc
;

-- which 5 products hav the highest percentage of purchase  with discount applied 
select item_purchased,
ROUND(100* sum(CASE WHEN discount_applied = 'Yes' THEN 1.0 ELSE 0 END) / count(*) ,2) AS discount_rate
from cleaned_data
group by item_purchased 
order by discount_rate desc
limit 5;

-- 07. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment.
WITH cleaned_data AS (
select customer_id, previous_purchases,
CASE 
    when previous_purchases = 1 THEN 'NEW'
    when previous_purchases between 2 and 10 then 'returning'
    else 'loyal'
    end as customer_segment 
from cleaned_data
)
select customer_segment, count(*) as "Number Of Customer"
    from cleaned_data
    group by customer_segment;
    
-- what are the top 3 most purahsed product within each category 

with items_count as(
select item_purchased, category,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from cleaned_data
group by category, item_purchased)

select item_purchased, category, total_orders, item_rank
from items_count
where item_rank <= 3;


-- are customers who are repeat buyers (more than 5 previous purchase) also likely to subscribe 

select
    case 
    when previous_purchases > 5 then 'repeat_buyers '
    else 'non_repeat_buyers'
    end customer_type, subscription_status,
    count(*) as total_customer
from cleaned_data
group by customer_type, subscription_status;

-- what is the revenue contribution of  each age group 
select age_group,
    sum(purchase_amount) as revenue
from cleaned_data
group by age_group
order by revenue desc;
    
    


# top products with highest discount usage 
select item_purchased,
    count(*) as discounted_item
from cleaned_data
where discount_applied = 'yes'
group by item_purchased
order by (discounted_item) desc
limit 5; 


# customer who purchase before and how many times 
select previous_purchases,
    count(customer_id) as total_customer
from cleaned_data
group by previous_purchases
order by previous_purchases desc;

#5. Most Popular Payment Method
select payment_method,
    COUNT(*) AS transaction_method
from cleaned_data
group by payment_method
order by transaction_method desc;

