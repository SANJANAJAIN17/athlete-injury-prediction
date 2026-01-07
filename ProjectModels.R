# BUAN 6356 Project
# Elizaveta Filonova and Sanjana Jain
# Decision Tree Model Implementation

# Reading Data
myData <- read.csv("finalCleanedData.csv")

suppressWarnings(RNGversion("3.5.3"))

library(caret)
library(gains)
library(rpart)
library(rpart.plot)
library(pROC)

options(scipen=999)# to avoid scientific notation


# Preparing Data for the model, including making the response variable a factor and removing several unnecessary columns
myData$serious_injury <- as.factor(myData$serious_injury)
modelData <- myData[,-1]

# Setting seed to ensure consistency across machines and runs
set.seed(1)

# Creating Training and Validation sets
myIndex <- createDataPartition(modelData$serious_injury, p=0.6, list=FALSE)
trainSet <- modelData[myIndex,]
dim(trainSet)
validationSet <- modelData[-myIndex,]
dim(validationSet)

# Setting seed and building decision tree and printing the results
set.seed(1)
default_tree <- rpart(serious_injury ~ season_minutes_played + season_games_played + season_matches_in_squad + age, data = trainSet, method = "class")

summary(default_tree)

prp(default_tree, type = 1, extra = 1, under = TRUE)

# Setting seed and building full decision tree
set.seed(1)

full_tree <- rpart(serious_injury ~ season_minutes_played + season_games_played + season_matches_in_squad + age, data = trainSet, method = "class", cp = 0, minsplit = 2, minbucket = 1, model = TRUE)

prp(full_tree, type = 1, extra = 1, under = TRUE)

printcp(full_tree)

# Pruning the decision tree and printing the results
pruned_tree <- prune(full_tree, cp = 0.00877193)

prp(pruned_tree, type = 1, extra = 1, under = TRUE)

predicted_prob <- predict(pruned_tree, validationSet, type="prob")
# Predicting data in the validation set using the pruned tree
predicted_class <- predict(pruned_tree, validationSet, type = "class")
# Convert both to character first
actual_class <- factor(as.character(validationSet$serious_injury))
predicted_class <- factor(as.character(predicted_class))

confusionMatrix(predicted_class, actual_class, positive = "1")

# Printing the results of the prediction as well as predicting probability and printing results

# Creating charts to evaluate performance of the model
validationSet$serious_injury <- as.numeric(as.character(validationSet$serious_injury))

gains_table <- gains(validationSet$serious_injury, predicted_prob[,2])
gains_table

# Lift Chart

plot(c(0, gains_table$cume.pct.of.total*sum(validationSet$serious_injury)) ~ c(0, gains_table$cume.obs), xlab = '# of cases', ylab = "Cumulative", type = "l")
lines(c(0, sum(validationSet$serious_injury))~c(0, dim(validationSet)[1]), col="red", lty=2)

# Decile Chart 

barplot(gains_table$mean.resp/mean(validationSet$serious_injury), names.arg=gains_table$depth, xlab="Percentile", ylab="Lift", ylim=c(0, 3.0), main="Decile-Wise Lift Chart")

# ROC chart

roc_object <- roc(validationSet$serious_injury, predicted_prob[,2])
plot.roc(roc_object)
auc(roc_object)
