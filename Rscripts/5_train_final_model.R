# Final project ----
# Training final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)

# handle common conflicts
tidymodels_prefer()

#load training data
load(here("data_splits/census_train.rda"))

#load model
load(here("results/rf_tuned_1.rda"))

# finalize workflow ----
final_wflow <- rf_tuned_1 |> 
  extract_workflow() |>  
  finalize_workflow(select_best(rf_tuned_1, metric = "rmse"))

# train final model ----
# set seed
set.seed(123456789)
final_fit <- fit(final_wflow, census_train)

#save best model
save(final_fit, file = here("results/final_fit.rda"))

