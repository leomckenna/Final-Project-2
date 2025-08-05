# Final Project 2 ----
# Define and fit random forest model

# Note there is a random process in this script

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores - 1)

# load training data
load(here("data_splits/census_train.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/tree_recipe.rda"))
load(here("recipes/baseline_recipe.rda"))

# load resamples/folds and controls
load(here("data_splits/census_folds_1.rda"))
load(here("data_splits/census_folds_2.rda"))
load(here("results/keep_wflow.rda"))

# model specifications ----
rf_model <- 
  rand_forest(
    mode = "regression",
    trees = tune(), 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_wflow_1 <-
  workflow() |> 
  add_model(rf_model) |> 
  add_recipe(tree_recipe)

rf_wflow_2 <-
  workflow() |> 
  add_model(rf_model) |> 
  add_recipe(baseline_recipe)

#hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges
rf_params <- hardhat::extract_parameter_set_dials(rf_model) |> 
  update(mtry = mtry(c(1, 20))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
set.seed(12345678)
rf_tuned_1 <- 
  rf_wflow_1 |> 
  tune_grid(
    census_folds_1, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )

#set.seed(1234567)
#rf_tuned_2 <- 
#  rf_wflow_2 |> 
#  tune_grid(
#    census_folds_1, 
#    grid = rf_grid, 
#    control = control_grid(save_workflow = TRUE)
#  )

set.seed(123456)
rf_tuned_3 <- 
  rf_wflow_1 |> 
  tune_grid(
    census_folds_2, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )


#set.seed(12345)
#rf_tuned_4 <- 
#  rf_wflow_2 |> 
#  tune_grid(
#    census_folds_2, 
#    grid = rf_grid, 
#   control = control_grid(save_workflow = TRUE)
#  )

# write out results (fitted/trained workflows) ----
save(rf_tuned_1, file = here("results/rf_tuned_1.rda"))
save(rf_tuned_2, file = here("results/rf_tuned_2.rda"))
save(rf_tuned_3, file = here("results/rf_tuned_3.rda"))
save(rf_tuned_4, file = here("results/rf_tuned_4.rda"))

