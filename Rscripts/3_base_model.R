# Final Project 2 ----
# Fitting for base lm model

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

# load resamples/folds and controls
load(here("data_splits/census_folds_1.rda"))
load(here("data_splits/census_folds_2.rda"))
load(here("results/keep_wflow.rda"))

# model specifications ----
base_model <-
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
base_wflow <-
  workflow() |> 
  add_model(base_model) |> 
  add_recipe(baseline_recipe)

# fit workflows/models ----
set.seed(3141)
base_fit_1 <-
  base_wflow |> 
  fit_resamples(
    resamples = census_folds_1,
    control = keep_wflow
  )

set.seed(314278)
base_fit_2 <-
  base_wflow |> 
  fit_resamples(
    resamples = census_folds_2,
    control = keep_wflow
  )


# write out results (fitted/trained workflows) ----
save(base_fit_1, file = here("results/base_fit_1.rda"))
save(base_fit_2, file = here("results/base_fit_2.rda"))


