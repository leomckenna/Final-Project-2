# L06 Model Tuning ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/census_train.rda"))

# build recipes
#kitchen sink recipe
sink_recipe <- 
  recipe(income ~ ., data = census_train) |> 
  step_rm(income_err, income_per_cap, income_per_cap_err, county_id, county) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_interact(terms = ~ poverty:c(child_poverty, unemployment)) |> 
  step_interact(terms = ~ total_pop:c(women, men, voting_age_citizen)) |> 
  step_interact(terms = ~ self_employed:work_at_home) |> 
  step_corr(all_numeric_predictors(), threshold = 0.7) |> 
  step_center(all_numeric_predictors()) |> 
  step_scale(all_numeric_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_impute_linear(all_numeric_predictors())

# View the "kitchen sink" recipes
sink_recipe |> 
 prep() |> 
 bake(new_data = NULL) |> 
 glimpse()

# simple recipe for baseline model
baseline_recipe <- 
  recipe(income ~ ., data = census_train) |> 
  step_rm(income_err, income_per_cap, income_per_cap_err, county_id, county, state) |> 
  step_corr(all_numeric_predictors(), threshold = 0.7) |> 
  step_zv(all_predictors()) 

# View the baselines recipes
baseline_recipe |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()


# tree based recipe
tree_recipe <- 
  recipe(income ~ ., data = census_train) |> 
  step_rm(income_err, income_per_cap, income_per_cap_err, county_id, county, state) |> 
  step_corr(all_numeric_predictors(), threshold = 0.7) |> 
  step_center(all_numeric_predictors()) |> 
  step_scale(all_numeric_predictors()) |> 
  step_zv(all_predictors())

# View the tree recipe
tree_recipe |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()


# linear based recipe
linear_recipe <- 
  recipe(income ~ ., data = census_train) |> 
  step_rm(income_err, income_per_cap, income_per_cap_err, county_id, county) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_corr(all_numeric_predictors(), threshold = 0.7) |> 
  step_center(all_numeric_predictors()) |> 
  step_scale(all_numeric_predictors()) |> 
  step_zv(all_predictors())

# save recipes
save(sink_recipe, file = here("recipes/sink_recipe.rda"))
save(baseline_recipe, file = here("recipes/baseline_recipe.rda"))
save(tree_recipe, file = here("recipes/tree_recipe.rda"))
save(linear_recipe, file = here("recipes/linear_recipe.rda"))


