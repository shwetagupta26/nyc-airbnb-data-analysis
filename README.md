# Regression Analysis of NYC Airbnb Data

## Overview

For this project I have decided to use The NYC Airbnb dataset from Kaggle.com. Airbnb is a short version of it is original name AirBedandBreakfast.com and today it has become one of a kind service that is used and recognized by the whole world. Airbnb’s are becoming increasingly popular places for travelers of all ages to stay. Families, business professionals and solo travelers are all turning to Airbnb as an alternative to a traditional hotel room. The flexibility of price, options of amenities as well as spread out location make them an appealing option for travelers.These millions of listings generate lot of data that can be analyzed and used for business decisions, understanding of customers & providers behavior and performance on the platform. 

## Goal

The idea of picking a property can seem daunting, however with careful analysis and data, determining neighborhood price can be narrowed down to make decision making easier. The aim of the project is to analyse the diffrent features and build ML model to predict price.  


## About the Dataset

The Datset is about Airbnb listings for different hosts in the boroughs of NYC. It Consist of 48895 observatuon with 16 variable. 
It offers detailed information regarding the price, number of reviews per month and its availability throughout the year.

![Data_Overview](https://user-images.githubusercontent.com/53157141/110054900-f3a8f700-7d29-11eb-893c-8f6ec74894ba.JPG)

## Methods Used

1. Descriptive statistics and data exploration
2. Data Preporcessing
3. Building and comparing Machine Learning Model. Built the following models
    * Linear Regression 
    * RandomForest
    * Gradient Boosting 
4. Optimizing the model : Performed full grid search to optimize the model by tuning its hyperparameter.

## Insights

* The output variable 'price' is heavliy skewed resulting in poor performnce of the Linear model.

![Price_skew](https://user-images.githubusercontent.com/53157141/110054934-0a4f4e00-7d2a-11eb-9807-95871aabe7f0.png)

* After imputing the missing values, removing outliers and transforming (lograthmic transformation) the output variable, Linear model accuracy improved.

![Linear_log_linear](https://user-images.githubusercontent.com/53157141/110055744-86966100-7d2b-11eb-99f8-769cfb570710.JPG)

* Using Ensemble method the accuracy was further improved.

* By Binning the price into low, medium and High groups, achieved the highest model accuracy of 70%.



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

Random Forest model gives us the best score in R2 as well as MSE. However, running time of the Random Forest model is more than other models.

## What can be Done to improve accuracy

* Collect more data with more variables.
* Models can be trained in lots of parameters to see which one is best. Since it took so much time, I did not train in every possible of combination.
* Try SVM and Neural Netwroks.
