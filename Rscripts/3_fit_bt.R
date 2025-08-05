# Final Project 2 ----
# Define and fit bt tree model

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
bt_model <-
  boost_tree(
    mode = "regression",
    learn_rate = tune(), 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("xgboost")

# define workflows ----
bt_wflow_1 <-
  workflow() |> 
  add_model(bt_model) |> 
  add_recipe(tree_recipe)

bt_wflow_2 <-
  workflow() |> 
  add_model(bt_model) |> 
  add_recipe(baseline_recipe)

#hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)

# change hyperparameter ranges
bt_params <- hardhat::extract_parameter_set_dials(bt_model) |> 
  update(learn_rate = learn_rate(c(-5, -0.2)),
         mtry = mtry(c(1, 10))) 

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
set.seed(31415926)
bt_tuned_1 <- 
  bt_wflow_1 |> 
  tune_grid(
    census_folds_1, 
    grid = bt_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(3141592)
bt_tuned_2 <- 
  bt_wflow_2 |> 
  tune_grid(
    census_folds_1, 
    grid = bt_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(87478)
bt_tuned_3 <- 
  bt_wflow_1 |> 
  tune_grid(
    census_folds_2, 
    grid = bt_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(97479)
bt_tuned_4 <- 
  bt_wflow_2 |> 
  tune_grid(
    census_folds_2, 
    grid = bt_grid, 
    control = control_grid(save_workflow = TRUE)
  )


# write out results (fitted/trained workflows) ----
save(bt_tuned_1, file = here("results/bt_tuned_1.rda"))
save(bt_tuned_2, file = here("results/bt_tuned_2.rda"))
save(bt_tuned_3, file = here("results/bt_tuned_3.rda"))
save(bt_tuned_4, file = here("results/bt_tuned_4.rda"))
