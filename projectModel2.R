# BUAN 6356 Project
# Elizaveta Filonova and Sanjana Jain
# KNN Model Implementation

suppressWarnings(RNGversion("3.5.3"))

# Install packages / libraries

install.packages(c('caret', 'gains', 'pROC'))

library(caret)
library(gains)
library(pROC)


myData <- read.csv("finalCleanedData.csv")
View(myData)

# Part c:
# Use the Scale function to standardize numerical variables and
# Store the standardized data in a new data frame
myData$serious_injury <- as.factor(myData$serious_injury)
modelData <- myData[,-1]
myData1 <- as.data.frame(scale(myData[1:10]))

# Append the orginal serious_injury variable to this new data frame

myData1$serious_injury <- myData$serious_injury



# Use the as.factor function go convert the target variable (serious_injury) to a Categorical variable

myData1$serious_injury <- as.factor(myData1$serious_injury)

View(myData1)

# Part - d: Partition the data


set.seed(1)
myIndex <- createDataPartition(myData1$serious_injury, p=0.6, list = FALSE)
trainSet <- myData1[myIndex,]
validationSet <- myData1[-myIndex,]

dim(trainSet)
dim(validationSet)


myCtrl <- trainControl(method="cv", number=10)


# Use the expand.grid function to specify possible k values from 1 to 10 and store results

myGrid <- expand.grid(.k=c(1:10))
set.seed(1)
KNN_fit <- train(serious_injury ~ season_minutes_played + season_games_played + season_matches_in_squad + age, data=trainSet, method = "knn", trControl=myCtrl, tuneGrid = myGrid)
KNN_fit


KNN_Class <- predict(KNN_fit, newdata = validationSet)

# Use the ConfusionMatrix function to create CM

confusionMatrix(KNN_Class, validationSet$serious_injury, positive = '1')


KNN_Class_prob <- predict(KNN_fit, newdata = validationSet, type='prob')
KNN_Class_prob


confusionMatrix(as.factor(ifelse(KNN_Class_prob[,2]>0.403, '1', '0')), validationSet$serious_injury, positive = '1')

# Part k:
# Create a cumulative gains table and a cumulative lift chart. 
# For this, convert the serious_injury variable to numeric data form as required by gains package


validationSet$serious_injury <- as.numeric(as.character(validationSet$serious_injury))

# """We generate the cumulative gains lift table using the gains function. The gains function requires 
# two arguments: actual class memberships and predicted target class probabilities, both in numerical form. Enter:"""

# Part L: Generate gains lift table

gains_table <- gains(validationSet$serious_injury, KNN_Class_prob[,2])
gains_table


# Part - m: Use the plot function to create cumulative lift chart

plot(c(0, gains_table$cume.pct.of.total*sum(validationSet$serious_injury))~c(0, gains_table$cume.obs), xlab = "# of cases", ylab = "Cumulative", main="Cumulative Lift Chart", type="l")

lines(c(0, sum(validationSet$serious_injury))~c(0, dim(validationSet)[1]), col="red", lty=2)

# Part - N: 
# Create the decile chart using the barplot function
# To plot the decile-wise lift chart, we use the barplot function to plot a bar chart. Enter:"""

barplot(gains_table$mean.resp/mean(validationSet$serious_injury), names.arg=gains_table$depth, xlab="Percentile", ylab="Lift", ylim=c(0,3), main="Decile-Wise Lift Chart")

# Part - O:
# Use the roc function to plot the ROC curve

roc_object<- roc(validationSet$serious_injury, KNN_Class_prob[,2])
plot.roc(roc_object)
auc(roc_object)

