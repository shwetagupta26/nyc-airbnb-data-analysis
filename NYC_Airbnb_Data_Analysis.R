
#For this project I am using The NYC Airbnb datasets from Kaggle.com
# changing the working directory
getwd()
setwd("~/shweta/FallA_2019/Data Mining Application/Week 1")

library(ggplot2)
library(corrplot)
library(dplyr)
library(tidyverse)
library(ggthemes)
library(GGally)
library(ggExtra)
library(caret)
library(glmnet)
library(corrplot)
library(leaflet)
library(kableExtra)
library(RColorBrewer)
library(plotly)
library(rpart)

# Reading the input csv file
airbnbdata <-  read.csv("AB_NYC_2019.csv")
View(airbnbdata)

# summary statistics of the data
summary(airbnbdata)

# data type of each column
str(airbnbdata)

#plot to compare the diffrent neighbourhood_group

ggplot(data=airbnbdata, aes(x=neighbourhood_group,fill=neighbourhood_group)) +
  geom_bar(stat="count",colour="black")

ggplot(data=airbnbdata, aes(x=room_type,fill=neighbourhood_group)) +
  geom_bar(stat="count",colour="black")

# fetching month from the review date and storing it in coloumn ReviewMonth
airbnbdata.reviewmonth <- as.Date(airbnbdata$last_review)
airbnbdata.reviewmonth <- months(airbnbdata.reviewmonth)
airbnbdata$reviewmonth <- airbnbdata.reviewmonth

# to get the frequency table of months
table(airbnbdata$reviewmonth)

# graph depicting counts of booking in each month
ggplot(data = airbnbdata)+ geom_bar(aes(x=reviewmonth))

# plot to see the distribution in neighbourhood month wise.
ggplot(data = airbnbdata)+ geom_bar(aes(x=neighbourhood_group, fill=reviewmonth))

# plot for price
ggplot(airbnbdata, aes(x=price)) + geom_histogram(aes(y = ..density..), colour =
                                                    "black", fill = "white") +
  geom_density(alpha = .2, fill = "#FF6666")

ggplot(airbnbdata, aes(x=neighbourhood_group, y=price,fill=neighbourhood_group))+ geom_boxplot(
  outlier.colour = "red",
  outlier.shape = 1,
  outlier.size = 4
)

# map for the boroughs
pal <- colorFactor(palette = c("red", "green", "blue", "purple", "yellow"), domain = airbnbdata$neighbourhood_group)

leaflet(data = airbnbdata) %>% addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%  addCircleMarkers(~longitude, ~latitude, color = ~pal(neighbourhood_group), weight = 1, radius=1, fillOpacity = 0.1, opacity = 0.1,
                                                                                                            label = paste("Name:", airbnbdata$name)) %>% 
  addLegend("bottomright", pal = pal, values = ~neighbourhood_group,
            title = "Neighbourhood groups",
            opacity = 1
  )

# below shows the missing data 
# for review_per_month 21% data is missing. Rest for all the other attributes
# there is no missing data.

install.packages(VIM)
library(VIM)
aggr_plot <-
  aggr(
    finaldata,
    col = c('navyblue', 'red'),
    numbers = TRUE,
    sortVars = TRUE,
    labels = names(data),
    cex.axis = .5,
    gap = 0.5,
    cex.numbers=0.8,
    ylab = c("Histogram of missing data", "Pattern")
  )

# co-relationmatrix

x <-airbnbdata%>%
  select(
    latitude,
    longitude,
    price,
    minimum_nights,
    number_of_reviews,
    calculated_host_listings_count,
    availability_365
  )
x<-cor(x)
corrplot(x, method="number")

#--------------------------------------------------------------------------------
# Linear regression to predict price
#--------------------------------------------------------------------------------

set.seed(1)

#-filtering out data data, do not consider the records with price =0
price_data <- airbnbdata %>%
  select(price,neighbourhood_group,host_id,room_type,minimum_nights
         ,number_of_reviews,latitude ,longitude, availability_365
         ,calculated_host_listings_count)%>%filter(price!=0)

summary(price_data)

# splitting data into training and testing data
row.number <- sample(x=1:nrow(price_data), size=0.75*nrow(price_data))
traindata = price_data[row.number,]
testdata = price_data[-row.number,]

# building linear model using all the predictors
linmodel <- lm(price~.,data = traindata)
summary(linmodel)
# another way of building model
first_model <- train(price ~ latitude + longitude + room_type + minimum_nights  + availability_365 + neighbourhood_group, data = traindata, method = "lm")
summary(first_model)
plot(first_model$finalModel)

# predicting values of Price for the libear model using test data
predicted_price_sat_model <- predict(linmodel, newdata = testdata)
predicted_price_sat_model
observed_price_sat_model <- testdata$price

# Calculating R2
SSE <- sum((observed_price_sat_model - predicted_price_sat_model) ^ 2)
SST <- sum((observed_price_sat_model - mean(observed_price_sat_model)) ^ 2)
r2.lin.model <- 1 - SSE/SST

#calcualting MSE
mean((predicted_price_sat_model -observed_price_sat_model)^2)

#RMSE:
rmse.sat.model <-
  sqrt(mean((
    predicted_ys_sat_model - observed_ys_sat_model
  ) ^ 2))

# log transformationa and removing outlier.

newpricedata <- price_data%>%filter(price <quantile(price_data$price,0.9)&price > quantile(price_data$price,0.1))

row.number <- sample(x=1:nrow(newpricedata), size=0.75*nrow(newpricedata))
newtraindata = newpricedata[row.number,]
newtestdata = newpricedata[-row.number,]

library(MASS)
# bulinding logistic linear model
secondmodel <- lm(log(price)~.,data=newtraindata)
summary(secondmodel)
plot(secondmodel)

# predicting values of Price for the linear logistic model using test data
predicted_price_new_model <- predict(secondmodel, newdata = newtestdata)
predicted_price_new_model<- exp(predicted_price_new_model)
observed_price_new_model <- newtestdata$price

plot(predicted_price_new_model)
qqnorm( beaver2$temp[beaver2$activ==0], main='Inactive')

# Calculating R2
SSE <- sum((observed_price_new_model - predicted_price_new_model) ^ 2)
SST <- sum((observed_price_new_model - mean(observed_price_new_model)) ^ 2)
r2.new.model <- 1 - (SSE/SST)
r2.new.model

#RMSE:
rmse.new.model <-
  sqrt(mean((
    predicted_price_new_model - observed_price_new_model
  ) ^ 2))

rmse.new.model

# co-relation betwen the actuals and predicted values
actuals_preds <- data.frame(cbind(actuals=observed_price_new_model, predicted=predicted_price_new_model))  # make actuals_predicteds dataframe.
correlation_accuracy <- cor(actuals_preds) # 61.68%
plot(correlation_accuracy)
head(actuals_preds)

# plotting the predicted and observed values -- fairly its linear.
fin<- tibble(observed = observed_price_new_model, predicted =predicted_price_new_model)
ggplot(data=fin, aes(x=predicted_price_new_model, y= observed_price_new_model)) +
  geom_point()+geom_abline(slope=1,intercept = 0,color='red',linetype=2)


#---------------------------------------------------------------

install.packages("glmnet")
library(glmnet)


set.seed(12345)
train_x <- model.matrix(price~., traindata)[,-1]
train_y <- traindata$price

test_x <- model.matrix(price~., testdata)[,-1]
test_y <- testdata$price

set.seed(12345)
cv_lasso_model <-
  cv.glmnet(
    train_x,
    train_y,
    alpha = 1,
    nlambda = 100,
    lambda.min.ratio = 0.0001
  )
plot(cv_lasso_model)
plot( cv_lasso_model$glmnet.fit, "norm",   label=TRUE)

best_lambda_min <- cv_lasso_model$lambda.min
best_lambda_1se <- cv_lasso_model$lambda.1se


lasso_mod <-
  glmnet(train_x,
         train_y,
         alpha = 1,
         nlambda = 100,
         lambda.min.ratio = 0.0001)

plot(lasso_mod,xvar="lambda",label=TRUE) 

best_coeffs <- predict(lasso_mod, s=best_lambda_min, type="coefficients")[1:8, ]

predicted_y <- predict(lasso_mod, s = best_lambda_min, newx = test_x)
predicted_y
test_y
#predictin accuracy/error:
# Sum of Squares Total and Error
sst <- sum((mean(test_y) - test_y)^2)
sse <- sum((predicted_y - test_y)^2)

# R squared
rsq <- 1 - (sse / sst)
rsq

#MSE
mean((predicted_y -test_y)^2)

# co-relation betwen the actuals and predicted values

actuals_preds_lasso <- data.frame(cbind(actuals=test_y, predicteds=predicted_y))  # make actuals_predicteds dataframe.
correlation_accuracy <- cor(actuals_preds_lasso) # 61.68%
# changing the working directory
getwd()
setwd("~/shweta/FallA_2019/Data Mining Application/Week 1")

install.packages('rsample')
library(ggplot2)
library(dplyr)
library(caret)
library(rpart)
library(tidyr)
library(rsample)
library(randomForest)


# Reading the input csv file
airbnbdata <-  read.csv("AB_NYC_2019.csv")
View(airbnbdata)

# summary statistics of the data
summary(airbnbdata)

# data type of each column
str(airbnbdata)

# ------------------------------
# Tree MODEL
# ------------------------------

unique(price_data$neighbourhood_group)
str(price_data)
airbnbdata$dummy_neighbourhood <-
  ifelse(
    airbnbdata$neighbourhood_group == 'Manhattan',
    yes = 1,
    ifelse(
      airbnbdata$neighbourhood_group == 'Brooklyn',
      yes = 2,
      ifelse(
        airbnbdata$neighbourhood_group == 'Queens',
        yes = 3,
        ifelse(
          airbnbdata$neighbourhood_group == 'Staten Island',
          yes = 4,
          ifelse(airbnbdata$neighbourhood_group == 'Bronx', yes = 5, no=0)
        )
      )
    )
  )


unique(price_data$room_type)

airbnbdata$dummy_room_type <-
  ifelse(
    airbnbdata$room_type == 'Private room',
    yes = 1,
    ifelse(
      airbnbdata$room_type == 'Entire home/apt',
      yes = 2,
      ifelse(
        airbnbdata$room_type == 'Shared room ',
        yes = 3, no=0)
    )
  )

finaldata <- airbnbdata %>%
  select(price,dummy_neighbourhood,host_id,dummy_room_type,minimum_nights
         ,number_of_reviews,latitude ,longitude, availability_365
         ,calculated_host_listings_count)%>%filter(price!=0)
nrow(finaldata)

# removing outliers , considering only vlaue lying between .1 to .9 quantile
finaldata <- finaldata%>%filter(price <quantile(finaldata$price,0.9)&price > quantile(finaldata$price,0.1))
str(finaldata)

#--------------------------------
#increasing the memory
------------------------------------
gc()
memory.size()
memory.size(TRUE)
memory.limit()
memory.limit(size=2500000)

closeAllConnections()

# splitting data into training and testing data

row.number <- sample(x=1:nrow(finaldata), size=0.75*nrow(finaldata))
traindata = finaldata[row.number,]
testdata = finaldata[-row.number,]

# ------------------------------
# Decision Tree
# ------------------------------
library(caret)

dectreemodfit <- train(price~.,method="rpart",data=traindata)
trainpriceobserved <- traindata$price
# plot tree 
library(rattle)
fancyRpartPlot(dectreemodfit$finalModel)  

# another way of building tree
library(rpart.plot)
r<- rpart(price~.,traindata,method="class")
rpart.plot(r,type=4,extra=101)


#finding traing error
trainpricepred <- predict(dectreemodfit,newdata=traindata)
trainpriceobserved <- traindata$price
mean((trainpriceobserved-trainpricepred)^2)
sqrt(1439.53)
# predicting value for test data
predictedprice<-predict(dectreemodfit,newdata=testdata)
obserevd <- testdata$price

#testing error
mean((predictedprice-obserevd)^2)


# ------------------------------
#Random Forest
# ------------------------------
ptm <- proc.time()
s <- randomForest(price~dummy_neighbourhood+host_id+dummy_room_type+minimum_nights+
                       number_of_reviews+latitude+longitude+availability_365+
                       calculated_host_listings_count, 
                     data = traindata, 
                     ntree = 500)

# number of trees with lowest MSE
which.min(fit2$mse)
## [1] 491

# RMSE of this optimal random forest
sqrt(fit2$mse[which.min(fit2$mse)])

plot(fit2)

---------------------------------------------------------------------
#tunning for mtry, feature selection
---------------------------------------------------------------------
  
f <- setdiff(names(traindata), "price")

set.seed(123)
m2 <- tuneRF(
  x          = traindata[f],
  y          = traindata$price,
  ntreeTry   = 491,
  mtryStart  = 2,
  stepFactor = 1.5,
  improve    = 0.05,
  trace      = FALSE      # to not show real-time progress 
)


-------------------------------------------------------------------------
  
  #creating random forest model with tunedparameter , ntrees= 491, mtr=2
--------------------------------------------------------------------------
  
  rfmodel <-
  randomForest(price ~ dummy_neighbourhood + host_id + dummy_room_type + minimum_nights +
      number_of_reviews + latitude + longitude + availability_365 +
      calculated_host_listings_count,
    data = traindata,
    ntree = 491,
    mtry = 2
  )

# predicting the price for test data using the rf model
rfpredictedprice <- predict(rfmodel,newdata =testdata)
mean((rfpredictedprice - testdata$price)^2)
--------------------------------------------------------------------------
  
---------------------------------------------------------------------------
# K fold cross validation
----------------------------------------------------------------------------
  
library(randomForest)
library(caret)
library(e1071)
library(rfUtilities)
# Define the control

(rf.cv <- rf.crossValidation(rfmodel, traindata[f], 
                              p=0.10, n=99, ntree=344))
par(mfrow=c(2,2))
plot(rf.cv)  
plot(rf.cv, stat = "mse")
plot(rf.cv, stat = "var.exp")
plot(rf.cv, stat = "mae")

---------------------------------------------------------------
#Full grid serach
-------------------------------------------------------------
  
library(ranger)

# to log the the time to build ranger forest
system.time(
    rf_ranger <- ranger(
      formula   = price ~ ., 
      data      = traindata, 
      num.trees = 500,
      mtry      = floor(length(f) / 3)
    )
  )

# setting the paramteres
hyper_grid <- expand.grid(
  mtry       = seq(1, 9, by = 1),
  node_size  = seq(3, 9, by = 2),
  sampe_size = c(.50, .60, .70, .80),
  OOB_RMSE   = 0
)

# looping the model through the hyperparamters
for(i in 1:nrow(hyper_grid)) {
  
  # train model
  model <- ranger(
    formula         = price ~ ., 
    data            = traindata, 
    num.trees       = 491,
    mtry            = hyper_grid$mtry[i],
    min.node.size   = hyper_grid$node_size[i],
    sample.fraction = hyper_grid$sampe_size[i],
    seed            = 123,
    importance      = 'impurity'
  )
  
  # add OOB error to grid
  hyper_grid$OOB_RMSE[i] <- sqrt(model$prediction.error)
}

hyper_grid %>% 
  dplyr::arrange(OOB_RMSE) %>%
  head(10)

model

model$variable.importance


OOB_RMSE <- vector(mode = "numeric", length = 100)

for(i in seq_along(OOB_RMSE)) {
  
  optimal_ranger <- ranger(
    formula         = price ~ ., 
    data            = traindata, 
    num.trees       = 491,
    mtry            = 2,
    min.node.size   = 3,
    sample.fraction = .8,
    importance      = 'impurity'
  )
  
  OOB_RMSE[i] <- sqrt(optimal_ranger$prediction.error)
}

optimal_ranger$variable.importance %>% 
  tidy() %>%
  dplyr::arrange(desc(x)) %>%
  dplyr::top_n(25) %>%
  ggplot(aes(reorder(names, x), x)) +
  geom_col() +
  coord_flip() +
  ggtitle("Top 25 important variables")

-------------------------------------------------------------------------
# Gradient Boosted Classification Trees
--------------------------------------------------------------------------
library(gbm) 
library(xgboost)   

set.seed(123)
gbmmodel <- train(price~ ., data = traindata, method = "xgbTree",
               trControl = trainControl("cv", number = 10)
)
plot(gbmmodel)

max(gbmmodel$results$Rsquared)

# predicting the price for test data using the rf model
gbmpredictedprice <- predict(gbmmodel,newdata =testdata)
mean((gbmpredictedprice - testdata$price)^2)

---------------------------------------------------------------------------
#binning
  #--------------------------------------------------------------


library(arules)
p<-(finaldata$price)

discretize(p, method = "interval", breaks = 3) 

View(regdata)

finaldata$pricecategory <- 
  ifelse(
    between( finaldata$price, 50, 123),
    yes = 'Low',
    ifelse(
      between( finaldata$price, 124, 195),
      yes = 'Medium',no='High'
    )
  )


regdata <- finaldata[,-1]
regdata$pricecategory <- factor(regdata$pricecategory)
row.number <- sample(x=1:nrow(regdata), size=0.75*nrow(regdata))
traindata = regdata[row.number,]
testdata = regdata[-row.number,]



# ------------------------------
# Decision Tree
# ------------------------------
library(caret)

dectreemodfit <- train(pricecategory~.,method="rpart",data=traindata)
trainpriceobserved <- traindata$pricecategory
# plot tree 
library(rattle)
fancyRpartPlot(dectreemodfit$finalModel)  


predictdt<-predict(dectreemodfit,newdata=testdata)
obserevd <- testdata$pricecategory
table(predictdt,obserevd) # can show the table in PPT

mean(predictdt == obserevd) # we are able to predict 51% correctly

confusionMatrix(observed, predictdt)
----------------------------------------------------------------------
  # creating model
  modfitrf <- train(pricecategory~ .,method="rf",data=traindata)
summary(modfitrf)

# predicting the quality
predrf  <- predict(modfitrf,testdata)
observed <- testdata$pricecategory

# accuracy measure
table(predrf, observed) # can show the table in PPT
mean(predrf == observed) # we are able to predict 50% correctly

confusionMatrix(observed, predrf)


library(gbm) 
library(xgboost)   

set.seed(123)
gbmmodel <- train(pricecategory~ ., data = traindata, method = "xgbTree",
                  trControl = trainControl("cv", number = 10)
)
# predicting the price
predrf  <- predict(modfitrf,testdata)
observed <- testdata$pricecategory

# accuracy measure
table(predrf, observed) # can show the table in PPT
mean(predrf == observed) # we are able to predict 70% correctly

confusionMatrix(observed, predrf)

