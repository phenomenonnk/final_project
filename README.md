# final-project

Project  - german cats from autoscout24-germany-dataset - Kaggle

Targets of the Final Project

Data analysis of the cars dataset
Exploring the data - Exploring the characteristics of cars using Business Intelligence tools
Use statistical methods, python libraries and different coding techniques
Building a machine learning model to predict the prices of cars based on features provided in the dataset
Comparing the accuracies of different models and finding the model that best fits our data
Understanding insights and trends in the dataset like which factors are responsible for higher car prices
Creating fictional scenarios
Visualizing the explored data
Answering SQL questions
Plotting plots and charts in Tableau


Background: working as an analyst for a car company.
The company wants to build a machine learning model to predict the selling prices of cars based on a 
variety of features on which the value of the car is evaluated.

Objective: The task is to build a model that will predict the price of a car based on features provided in the dataset.
The senior management also wants to explore the characteristics of the cars using some business intelligence tools. 
One of those parameters include understanding which factors are responsible for higher value.

Data: The data set consists of information on 46405 cars. The dataset web-scraped from AutoScout24 and
contains info about cars like model, mileage, horse power, etc
These are the definitions of data columns provided:
- mileage: how many kilometers the car has traveled
- make: the make of the car, for example BMW, VW, Toyota
- model: the model of the car, for example yaris (from Toyota yaris)
- fuel_type: the type of fuel, for example electric, gasoline, diesel
- gearbox: the type of the gearbox: manual, automatic or semi-automatic
- offer_type: the type of the offer, for example used, pre-registered
- price: the price of the car
- hp: the horse power of the car
- year: the year of the car's first registratio


I also upload the presentation where you can find the process and you
can find comments and notes in Jupyter notebook so you can understand the exact process in detail.

I compare different models, in the initial dataset fitting Linear Regression and Random Forest.
In a processed dataset (without outliers-over the 95th percentile and with bucketing some columns)
fitting Min-Max scaling+Linear Regression, Standar scaling+Linear Regression, Normalization+Linear
Regression, K Nearest Neighbors and  Random Forest–Scaled by MinMax Scaler (best approach).
Best approach: Combination of Random Forest in the processed (without outliers and bucketed)
dataset + MinMax scaling the numerical part. Metrics Random Forest in the processed dataset
r2 score is:  0.938, RMSE is: 46.208, MAE is: 1432.703 and MSE is: 2135.204


here are the tableau material
story of the final project tableau
https://public.tableau.com/app/profile/nikolaos.k./viz/Final_project_Story/Story-FinalProject?publish=yes

dashboard of the final project tableau
https://public.tableau.com/app/profile/nikolaos.k./viz/Final_project_Dashboard/Dashboard-FinalProject?publish=yes