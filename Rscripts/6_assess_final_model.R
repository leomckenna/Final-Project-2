# Final project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(knitr)

# handle common conflicts
tidymodels_prefer()

#load testing data
load(here("data_splits/census_test.rda"))

#load model
load(here("results/rf_tuned_1.rda"))
load(here("results/final_fit.rda"))

# assessing models performance
final_metrics <- metric_set(rmse, mae, mape, rsq)

rf_metrics <- census_test |> 
  bind_cols(predict(final_fit, census_test)) |> 
  select(.pred, income) |> 
  final_metrics(truth = income, estimate = .pred) |> 
  kable()

# plotting the predicted observations by the observed observations

final_predict <- census_test |> 
  bind_cols(predict(final_fit, census_test)) |> 
  select(.pred, income) 

prediction_graph <- final_predict |> 
  ggplot(aes(x = log10(income), y = log10(.pred))) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Income (log10)", x = "Actual Income (log10)") +
  coord_obs_pred()

ggsave(prediction_graph, file = here("figures/prediction_graph.png"))
save(rf_metrics, file = here("figures/rf_metrics.rda"))
