This folder contains 11 Rscript files :

- `1_initial_setup.R`: Initial set up including loading cleaning, scaling and splitting data
- `2_recipes.R`: Contains work for all recipes
- `3_base_model.R`: Fitting of the baseline linear model
- `3_tune_bt.R`: Fitting and tuning of the boosted tree model
- `3_tune_en.R`: Fitting and tuning of the elastic net model
- `3_tune_knn.R`: Fitting and tuning of the k nearest neighbors model
- `3_tune_lasso.R`: Fitting and tuning of the lasso model
- `3_tune_rf.R`: Fitting and tuning of the random forest model
- `4_model_analysis.R`: Contains all analysis and prediction
- `5_train_final_model.R` : Training of the final random forest model
- `6_assess_final_model.R` : Assessment of the final model on the training set