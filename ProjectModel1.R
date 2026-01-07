# BUAN 6356 Project
# Sanjana Jain and Elizaveta Filonova 
# Logistic Regression Implementation 

# Purpose: Predict probability of a serious injury using player-season features
# Output: Trained logistic model, evaluation metrics, ROC/AUC, partial-effect plot,
#         and model saved for deployment.

# Load dataset
# Read the cleaned dataset
library(caret)
library(gains)
library(pROC)

rm(list=ls())
set.seed(1)
myData <- read.csv("finalCleanedData.csv")

# Remove first column
myData <- myData[,-1]
myData$serious_injury <- factor(myData$serious_injury, levels=c(0,1))

# Create modeling dataset
modelData <- myData
set.seed(1)
modelData$serious_injury <- factor(modelData$serious_injury, levels = c(0,1))
# TRAIN / VALIDATION SPLIT
set.seed(1)
# Use 60% of the data for training
myIndex <- createDataPartition(modelData$serious_injury, p=0.6, list=FALSE)
trainSet <- modelData[myIndex,]
dim(trainSet)
validationSet <- modelData[-myIndex,]
dim(validationSet)

# Fit logistic model on the training subset
Model1 <- glm(
  serious_injury ~ season_games_played + season_matches_in_squad +
    fifa_rating + pace + physic,
  family = binomial,
  data = trainSet
)

# Predictions on validation set
pHat1 <- predict(Model1, validationSet, type = "response")

# Convert probabilities to class labels
yHat1 <- ifelse(pHat1 >= 0.5, 1, 0)


# Evaluation metrics
predicted_class <- factor(yHat1, levels = c(0,1))
actual_class <- factor(validationSet$serious_injury, levels =c(0,1))
confusionMatrix(predicted_class, actual_class, positive = "1")

# PARTIAL EFFECT PLOT
mGamesSeq <- seq(
  min(modelData$season_games_played, na.rm = TRUE),
  max(modelData$season_games_played, na.rm = TRUE),
  length.out = 40
)
validationSet$serious_injury <- as.numeric(as.character(validationSet$serious_injury))

gains_table <- gains(validationSet$serious_injury, pHat1)
gains_table

# Lift Chart

plot(c(0, gains_table$cume.pct.of.total*sum(validationSet$serious_injury)) ~ c(0, gains_table$cume.obs), xlab = '# of cases', ylab = "Cumulative", type = "l")
lines(c(0, sum(validationSet$serious_injury))~c(0, dim(validationSet)[1]), col="red", lty=2)

# Decile Chart 

barplot(gains_table$mean.resp/mean(validationSet$serious_injury), names.arg=gains_table$depth, xlab="Percentile", ylab="Lift", ylim=c(0, 3.0), main="Decile-Wise Lift Chart")

# ROC chart

roc_object <- roc(validationSet$serious_injury, pHat1)
plot.roc(roc_object)
auc(roc_object)
