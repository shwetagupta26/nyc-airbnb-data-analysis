# Regression Analysis of NYC Airbnb Data
## Overview
For this project I have decided to use The NYC Airbnb dataset from Kaggle.com. Airbnb is a short version of it is original name AirBedandBreakfast.com and today it has become one of a kind service that is used and recognized by the whole world. Guests and hosts use Airbnb to expand on travelling possibilities and present a more unique and personalized tourism experiences. These millions of listings generate lot of data that can be analyzed and used for business decisions, understanding of customers & providers behavior and performance on the platform. This dataset offers us with all the information we could use to find out more about guests hosts, geographical availability, necessary metrics to make predictions and draw conclusions.  

## Goal
The aim of the project is to analyse the diffrent features and build ML model to predict price.


## About the Dataset
The Datset consist of 4895 observatuon and has been updated since 2008 until 2019 this year and is about Airbnb listings for different hosts in the boroughs of NYC. It offers detailed information regarding the price, number of reviews per month and its availability throughout the year.

## Approach

1. Implemented descriptive statistics and visualization techniques to understand the data.
2. Performed data cleansing to remove outliers and normalize skewed data.
3. Implemented Linear Regression and Tree regression using randomForest, Gradient Boosting to predict price.
4. Performed full grid search to optimize the model by tuning its hyperparameter. Achieved an accuracy of 60%.

## Model Comparison

Model	| Model Accuracy
------| --------------
Gradient Boost Tree(binning price) |	0.70
Random Forest |	0.54
Random Forest (Grid Search)	| 0.53
Gradient Boost Tree	| 0.52
Linear Regression(log transformed price)	| 0.48
Decision Tree |	0.40
Liner Regression | 0.09


## Conclusion
In this project, I tried to make predictions with different Regression models and compared their metric results. Ensemble learning performed better than the other models. Futher by tuning the model's hyperparameter, I was able to imporve the model accuracy.
