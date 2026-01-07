# Athlete Injury Prediction

## Project Overview
This project focuses on predicting the risk of serious injury among professional athletes using data analytics and machine learning techniques. The goal is to support proactive decision-making related to training, workload management, and injury prevention.

## Business Problem
Athletes are exposed to high physical workloads, and injuries can significantly impact team performance and player availability. Traditional injury prevention methods are often reactive. This project uses historical player data to identify high-risk injury profiles before injuries occur.

## Dataset
- 1,300+ player-season records
- Features include workload metrics, physical attributes, and performance indicators
- Target variable: **Serious Injury**
  - 1 = More than 48 days injured in a season
  - 0 = 48 days or fewer

## Methods & Models
- Logistic Regression
- Decision Tree (Pruned)
- K-Nearest Neighbors (KNN)

## Key Steps
- Data cleaning and feature selection to prevent data leakage
- Train/validation split (60/40)
- Model evaluation using accuracy, sensitivity, specificity, ROC-AUC
- Interpretation of results to support business decisions

## Key Insights
- Higher game exposure increases injury risk
- Age and workload are strong predictors
- Interpretable models (decision trees) help translate insights to non-technical stakeholders

## Tools & Technologies
R, Machine Learning, Data Analytics, Predictive Modeling

## Outcome
The models help classify athletes as high-risk or low-risk, enabling proactive training adjustments and injury prevention strategies.

## Author
Sanjana Suchit Jain  
MS Business Analytics & AI, UT Dallas

