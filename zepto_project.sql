DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPrecent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedsellingprice NUMERIC(8,2),
    weightIngms INTEGER,
    outstock BOOLEAN,
    quantity INTEGER
);

-- data exploriation--
SELECT COUNT(*) FROM zepto;
--sample data
SELECT * FROM ZEPTO LIMIT 10;
-- null values 
SELECT * FROM ZEPTO 
WHERE name IS NULL
OR
 mrp IS NULL
OR
 category IS NULL
OR
 discountprecent IS NULL
OR
 discountedsellingprice IS NULL
OR
 availablequantity IS NULL
OR
 weightingms IS NULL
OR
 outstock IS NULL
OR
 quantity IS NULL;
--different product categories 
SELECT DISTINCT category FROM zepto 
ORDER BY category;
--product in stock vs out of stock
SELECT outstock, COUNT(sku_id)
FROM zepto 
GROUP BY outstock;
--product names present multiple times
SELECT name,COUNT(sku_id) as "number of SKUs"
FROM zepto 
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;
--data cleaning 

--products with price =0
SELECT * FROM ZEPTO 
WHERE mrp=0 OR discountedsellingprice =0;
DELETE FROM ZEPTO
WHERE mrp =0;

--conver paise to rupees
UPDATE zepto
SET mrp =mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;
SELECT mrp,discountedsellingprice FROM zepto
 -- few business insights
 --Q1.find the top best-value products based on the discount percentage
 SELECT DISTINCT name,mrp,discountprecent FROM zepto
 ORDER BY discountprecent DESC
 LIMIT 10;
  --Q2 what are the products with high MRP but outstock
SELECT DISTINCT name,mrp,outstock FROM zepto
WHERE outstock = TRUE and mrp >300
ORDER BY mrp DESC;
--Q3 calculate estimated revenue for each category 
SELECT category,SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto 
GROUP BY category
ORDER BY total_revenue;
--Q4 find all products where MRP,is greater than 500rs and discount is less than 10%
SELECT DISTINCT name,mrp,discountprecent FROM zepto
WHERE mrp >500 AND discountprecent < 10
ORDER BY mrp DESC,discountprecent DESC;
--Q5 Identitfy the top 5 categories offering the highest average discount percentage
SELECT category, ROUND(AVG(discountprecent),2) AS avg_discount FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5 ;
--Q6 find the price per gram for products above 100g and sort by best value
SELECT name,weightingms, discountedsellingprice, ROUND(discountedsellingprice/weightingms,2) AS price_per_gram FROM Zepto
WHERE weightingms >=100
ORDER BY price_per_gram;
 --Q7. Group the product categories like low,medium,bulk.
 SELECT DISTINCT name,weightingms,
 CASE WHEN weightingms <1000 THEN 'Low'
 WHEN weightingms <5000 THEN 'Medium'
 ELSE 'bulk'
 END AS weight_category FROM zepto;
 --Q8 what is the total Inventory weight per category
 SELECT category,
 SUM(weightingms*availablequantity) AS total_weight
 FROM Zepto
 GROUP BY category
 ORDER BY total_weight;
 





