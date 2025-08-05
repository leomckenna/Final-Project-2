# Final Project 2 ----
# Define and fit lasso model

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
lm_model <-
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_1 <-
  workflow() |> 
  add_model(lm_model) |> 
  add_recipe(linear_recipe)

lm_wflow_2 <-
  workflow() |> 
  add_model(lm_model) |> 
  add_recipe(sink_recipe)

# fit workflows/models ----
set.seed(1234)
lm_fit_1 <-
  lm_wflow_1 |> 
  fit_resamples(
    resamples = census_folds_1,
    control = keep_wflow
  )

set.seed(12345)
lm_fit_2 <-
  lm_wflow_2 |> 
  fit_resamples(
    resamples = census_folds_1,
    control = keep_wflow
  )

set.seed(1010101)
lm_fit_3 <-
  lm_wflow_1 |> 
  fit_resamples(
    resamples = census_folds_2,
    control = keep_wflow
  )

set.seed(111000)
lm_fit_4 <-
  lm_wflow_2 |> 
  fit_resamples(
    resamples = census_folds_2,
    control = keep_wflow
  )


# write out results (fitted/trained workflows) ----
save(lm_fit_1, file = here("results/lm_fit_1.rda"))
save(lm_fit_2, file = here("results/lm_fit_2.rda"))
save(lm_fit_3, file = here("results/lm_fit_3.rda"))
save(lm_fit_4, file = here("results/lm_fit_4.rda"))
