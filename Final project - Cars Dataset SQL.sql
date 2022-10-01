/* -- creating the database with the name german_cars
create database if not exists german_cars;

-- creating the table german_cars_autoscout24
create table german_cars_autoscout24 (
`mileage` int DEFAULT NULL, -- AS PRIMARY KEY
`make` char(25) DEFAULT NULL,
`model` varchar(25) DEFAULT NULL,
`fuel` varchar(25) DEFAULT NULL,
`gear` varchar(25) DEFAULT NULL,
`offertype` varchar(25) DEFAULT NULL,
`price` int DEFAULT NULL,
`hp` int DEFAULT NULL,
`year` int DEFAULT NULL
);

import dataset from a csv file, right click on the table german_cars_autoscout24 > Table Data Import Wizard
*/

-- Use german_cars database and check if the data was imported correctly
use german_cars;

-- some general queries
 
-- Select all the data from table `autoscout24_germany_dataset` to check if the data was imported correctly
select * from german_cars.autoscout24_germany_dataset;

--  Use sql query to find how many rows of data you have.
select count(*) as number_of_rows from german_cars.autoscout24_germany_dataset;

-- Get the unique values of makes from the car dataset.
select distinct make as makes from german_cars.autoscout24_germany_dataset;

-- Get unique list of possible fuel_types of the car dataset.
select distinct fuel as possible_fuel_types from german_cars.autoscout24_germany_dataset;

-- Find out how many different models does the car dataset have?
select count(distinct model) as "distinct number of models in the dataset" from german_cars.autoscout24_germany_dataset; 

-- Find out how many different gear types does the car dataset have?
select count(distinct gear) as "distinct number of gear types in the dataset" from german_cars.autoscout24_germany_dataset; 
-- Check the distinct gear types
select distinct(gear) as possible_gear_types from german_cars.autoscout24_germany_dataset;

-- Select all the cars with mileage > avg(mileage) ordered by price.
select * from german_cars.autoscout24_germany_dataset
where mileage > (select avg(mileage) from german_cars.autoscout24_germany_dataset)
order by mileage desc;

-- Select all the semi-automatic cars from the year 2012 ordered by mileage
select * from german_cars.autoscout24_germany_dataset
where year = 2012 and gear = 'semi-automatic'
order by mileage asc;

-- Get all possible pairs of gear types and fuel types.
select distinct ga1.gear from german_cars.autoscout24_germany_dataset as ga1;
select distinct ga2.fuel from german_cars.autoscout24_germany_dataset as ga2;
-- all possible pairs of gear types and fuel types
select * from (
	select distinct ga1.gear from german_cars.autoscout24_germany_dataset as ga1
) sub1
cross join (
	select distinct ga2.fuel from german_cars.autoscout24_germany_dataset as ga2
    join german_cars.autoscout24_germany_dataset as ga1 on ga1.mileage=ga2.mileage
) sub2
order by fuel;

-- find the top10 most expensive cars
select * from german_cars.autoscout24_germany_dataset
order by price desc
limit 10;

-- find the top10 most mileaged cars
select * from german_cars.autoscout24_germany_dataset
order by mileage desc
limit 10;

-- checking some opportunities of used cars with good characteristics and low prices
select * from german_cars.autoscout24_germany_dataset
where price < 10000 and mileage < 50000 and offerType = 'Used' and hp > 100 and year >= 2017
order by price asc;

-- Which of the models has the longest name?
select model as 'model with the longest name', max(length(model)) as 'number of letters (with the gaps)' from german_cars.autoscout24_germany_dataset
where length(model)=(select max(length(model)) from german_cars.autoscout24_germany_dataset);

-- which of the makes have price outliers, check the first 20 expensive makes 
select make, avg(price) as average_price from german_cars.autoscout24_germany_dataset
group by make
order by average_price desc
limit 20;

-- help for bucketing
-- Which makes appear less than 35 times in the dataset? 
select make,count(make) as quantity_of_makes from german_cars.autoscout24_germany_dataset
group by 1 -- 1 instead of make
having quantity_of_makes<35;

-- Which models appear less than 20 times in the dataset? 
select model,count(model) as quantity_of_models from german_cars.autoscout24_germany_dataset
group by 1 -- 1 instead of model
having quantity_of_models<20;

-- What's the average price per offer type
select offerType, count(offerType) as quantity_of_cars_per_offertype, avg(price) as average_price_per_offertype from german_cars.autoscout24_germany_dataset
group by 1; -- 1 instead of offerType

-- What's the average price per fuel type and gear
select fuel, gear, count(fuel) as quantity_of_cars_per_fueltype_and_gear, avg(price) as average_price_per_fueltype_and_gear from german_cars.autoscout24_germany_dataset
group by 1,2 -- 1, 2 instead of fuel and gear
order by 4 desc; -- 4 instead of average_price_per_fueltype_and_gear

-- What's the average mileage per fuel type
select fuel, count(fuel) as quantity_of_cars_per_fueltype, avg(mileage) as average_mileage_per_fueltype from german_cars.autoscout24_germany_dataset
group by 1; -- 1 instead of fuelType

-- What's the average price per year. Round off the average price to two decimal places
select year, round(avg(price),2) as average_price_per_year from german_cars.autoscout24_germany_dataset
group by 1; -- 1 instead of year

-- Rank cars by price (filter out the rows that have nulls or 0s in length column).
select *, rank() over (order by price) as 'rank by price' -- we could also use dense_rank() or row_number() instead of rank()
from german_cars.autoscout24_germany_dataset
where price <> " " or price !=0; 

-- getting the percent rank from every obserbation
select *, round(percent_rank() over (partition by year order by price),2) as 'percent rank'
from german_cars.autoscout24_germany_dataset;

-- For each model, list price that is the same in different models.
select make, model, price, count(price) as number_of_cars_with_the_same_price, row_number() over(order by count(price) desc) as ranking_list
from german_cars.autoscout24_germany_dataset
group by price
order by number_of_cars_with_the_same_price desc;

-- getting a dataset with price less than 42450
select * from german_cars.autoscout24_germany_dataset
where price < 42450
order by price asc;

-- Use the case statement to create 3 new columns classifying existing mileage per car 
-- in 3 categories: low_mileage, medium_mileage and high_mileage based on their milage.
select make, model, price, mileage, 
	   avg(case when mileage >= 0 and mileage < 50000 then 1 else 0 end) as 'low_mileage', 
	   avg(case when mileage>= 50000 and mileage < 200000 then 1 else 0 end) as 'medium_mileage',
	   avg(case when mileage >= 200000 then 1 else 0 end) as 'high_mileage'
from german_cars.autoscout24_germany_dataset
group by mileage
order by price asc;

-- Your manager wants to find out the cars whose prices are three times more than the average of all the cars in the database and are outliers.
select * from german_cars.autoscout24_germany_dataset
where price > (select avg(price)*3 from german_cars.autoscout24_germany_dataset);

-- Since this is something that the senior management is regularly interested in,
-- create a view called `cars_with_higher_than_triple_average_price` of the same query.
create view cars_with_higher_than_triple_average_price as
select * from german_cars.autoscout24_germany_dataset
where price > (select avg(price)*3 from german_cars.autoscout24_germany_dataset);

-- Let's help the Volkswagen manager with the dataset

-- Find the names of Volkswagen models (this query will help us, I do believe that the manager knows the names of the models)
select distinct(model) as Volkswagen_models from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen';

-- Select all the cars with the following characteristics: 'Volkswagen', Golf, Automatic, Gasoline, less than 100000 km from the years 2012-2013
-- ordered by hp
select * from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and
model = 'Golf' and
gear = 'Automatic' and 
fuel = 'Gasoline' and 
mileage < 100000 and
year in (2012, 2013)
order by hp asc;

-- How many Volkswagen Golf are in the dataset?
select count(*) as number_of_Volkswagen_Golf from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and model = 'Golf';

-- looking for the lowest and highest mileage for the Volkswagen Tiguan?
select min(mileage) as lowest_mileage_tiguan, max(mileage) as highest_mileage_tiguan from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and model = 'Tiguan';

-- What's the average price of Volkswagen Scirocco?
select avg(price) as 'average price of Volkswagen Scirocco' from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and model = 'Scirocco';

-- How many Volkswagen T5 cost more than 9000?
select count(*) as 'number of Volkswagen T5 that cost more than 9000' from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and model = 'T5' and price > 9000;

-- Get the Volkswagen models formatted like the following format:  a_volkswagen_t5_has_10000_km, ordered by mileage .
select concat('a_volkswagen_', lower(model),'_has_',mileage,'_km') as 'formatted phrase' from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen'
order by mileage desc;

-- get every Volkswagen T5 and T6 Caravelle obserbation with only their price
select make, model, price from german_cars.autoscout24_germany_dataset
where model in ('T5','T6 Caravelle')
order by price desc;

-- Get all models with T6 in the model name.
select * from german_cars.autoscout24_germany_dataset
where model like '%T6%';

-- Get all models which model name ends with multivan.
select * from german_cars.autoscout24_germany_dataset
where model like '%multivan';

-- get every model which contain the regular expression 'marok'
select * from german_cars.autoscout24_germany_dataset
where model regexp 'marok';

-- How many cars per Volkswagen models exist in the database and what is the average price per model 
select make, model, count(model) as 'number per model', avg(price) as 'average price' from german_cars.autoscout24_germany_dataset
-- where make = 'Volkswagen'
group by model
having make = 'Volkswagen' -- having after group by 
order by 3 desc; -- 3 onstead of count(model)

-- Show the list of all the Volkswagen cars that are not Golf.
select * from german_cars.autoscout24_germany_dataset
where make = 'Volkswagen' and model != 'Golf';

-- A new car manufacturer manufactures yesterday one only piece of car and he sells it.
-- The mame of the make is Kosni, the mame of the model is Raskar, the fuel type is Electric, the gear type Automatic, it has 580 hp 
-- and it costs 250000. Update the database accordingly.
 insert into german_cars.autoscout24_germany_dataset values
(0 ,'Kosni','Raskar','Electric','Automatic', 'New', 250000, 580, 2022);
select * from german_cars.autoscout24_germany_dataset
where make = 'Kosni';
-- The car is sold, so we should delete it from the database
-- Delete the previous car from the table
delete from german_cars.autoscout24_germany_dataset
where make = 'Kosni';
-- checking if the car exists in the dataset
select * from german_cars.autoscout24_germany_dataset
where make = 'Kosni';