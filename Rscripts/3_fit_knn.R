# Final Project 2 ----
# Define and fit k nearest neighbors model

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
load(here("recipes/baseline_recipe.rda"))
load(here("recipes/tree_recipe.rda"))

# load resamples/folds and controls
load(here("data_splits/census_folds_1.rda"))
load(here("data_splits/census_folds_2.rda"))
load(here("results/keep_wflow.rda"))

# model specifications ----
knn_model <-
  nearest_neighbor(neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# define workflows ----
knn_wflow_1 <-
  workflow() |> 
  add_model(knn_model) |> 
  add_recipe(tree_recipe)

knn_wflow_2 <-
  workflow() |> 
  add_model(knn_model) |> 
  add_recipe(baseline_recipe)

#hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_model)

# change hyperparameter ranges
knn_params <- hardhat::extract_parameter_set_dials(knn_model) 

# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
set.seed(12345678)
knn_tuned_1 <- 
  knn_wflow_1 |> 
  tune_grid(
    census_folds_1, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(1234567)
knn_tuned_2 <- 
  knn_wflow_2 |> 
  tune_grid(
    census_folds_1, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(123456)
knn_tuned_3 <- 
  knn_wflow_1 |> 
  tune_grid(
    census_folds_2, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )


set.seed(12345)
knn_tuned_4 <- 
  knn_wflow_2 |> 
  tune_grid(
    census_folds_2, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )


# write out results (fitted/trained workflows) ----
save(knn_tuned_1, file = here("results/knn_tuned_1.rda"))
save(knn_tuned_2, file = here("results/knn_tuned_2.rda"))
save(knn_tuned_3, file = here("results/knn_tuned_3.rda"))
save(knn_tuned_4, file = here("results/knn_tuned_4.rda"))

