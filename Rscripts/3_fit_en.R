# Final Project 2 ----
# Define and fit en model

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
load(here("recipes/linear_recipe.rda"))
load(here("recipes/sink_recipe.rda"))

# load resamples/folds and controls
load(here("data_splits/census_folds_1.rda"))
load(here("data_splits/census_folds_2.rda"))
load(here("results/keep_wflow.rda"))

# model specifications ----
en_model <- 
  linear_reg(penalty = tune(), 
             mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("regression")
  

# define workflows ----
en_wflow_1 <-
  workflow() |> 
  add_model(en_model) |> 
  add_recipe(linear_recipe)

en_wflow_2 <-
  workflow() |> 
  add_model(en_model) |> 
  add_recipe(sink_recipe)

#hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(en_model)

# change hyperparameter ranges
en_params <- hardhat::extract_parameter_set_dials(en_model) |> 
  update(penalty = penalty(c(0, 1)),
         mixture = mixture(c(0, 1))) 

# build tuning grid
en_grid <- grid_regular(en_params, levels = 5)


# fit workflows/models ----
set.seed(31415926)
en_tuned_1 <- 
  en_wflow_1 |> 
  tune_grid(
    census_folds_1, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(3141592)
en_tuned_2 <- 
  en_wflow_2 |> 
  tune_grid(
    census_folds_1, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(3141598)
en_tuned_3 <- 
  en_wflow_1 |> 
  tune_grid(
    census_folds_2, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

set.seed(3141597)
en_tuned_4 <- 
  en_wflow_2 |> 
  tune_grid(
    census_folds_2, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )


# write out results (fitted/trained workflows) ----
save(en_tuned_1, file = here("results/en_tuned_1.rda"))
save(en_tuned_2, file = here("results/en_tuned_2.rda"))
save(en_tuned_3, file = here("results/en_tuned_3.rda"))
save(en_tuned_4, file = here("results/en_tuned_4.rda"))
