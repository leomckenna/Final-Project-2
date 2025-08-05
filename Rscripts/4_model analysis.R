# Final project ----
# Analysis of tuned and trained models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)
library(knitr)
library(ggpubr)

# handle common conflicts
tidymodels_prefer()

# load tuned models
list.files(
  here("results/"),
  "1.rda",
  full.names = TRUE
) |> 
  map(load, envir = .GlobalEnv)

list.files(
  here("results/"),
  "2.rda",
  full.names = TRUE
) |> 
  map(load, envir = .GlobalEnv)

list.files(
  here("results/"),
  "3.rda",
  full.names = TRUE
) |> 
  map(load, envir = .GlobalEnv)

list.files(
  here("results/"),
  "4.rda",
  full.names = TRUE
) |> 
  map(load, envir = .GlobalEnv)

# all model results
model_results_1 <- as_workflow_set(
  base_5 = base_fit_2,
  rf_tree_5 = rf_tuned_3,
  rf_base_5 = rf_tuned_4,
  bt_tree_5 = bt_tuned_3,
  bt_base_5 = bt_tuned_4,
  knn_tree_5 = knn_tuned_3,
  knn_base_5 = knn_tuned_4,
  en_linear_5 = en_tuned_3,
  en_sink_5 = en_tuned_4,
  lm_linear_5 = lm_fit_3,
  lm_sink_5 = lm_fit_4
)

model_results_2 <- as_workflow_set(
  base_10 = base_fit_1,
  rf_tree_10 = rf_tuned_1,
  rf_base_10 = rf_tuned_2,
  bt_tree_10 = bt_tuned_1,
  bt_base_10 = bt_tuned_2,
  knn_tree_10 = knn_tuned_1,
  knn_base_10 = knn_tuned_2,
  en_linear_10 = en_tuned_1,
  en_sink_10 = en_tuned_2,
  lm_linear_10 = lm_fit_1,
  lm_sink_10 = lm_fit_2
)

model_results_3 <- as_workflow_set(
  base_5 = base_fit_2,
  rf_tree_5 = rf_tuned_3,
  rf_base_5 = rf_tuned_4,
  bt_tree_5 = bt_tuned_3,
  bt_base_5 = bt_tuned_4,
  knn_tree_5 = knn_tuned_3,
  knn_base_5 = knn_tuned_4
)

model_results_4 <- as_workflow_set(
  base_10 = base_fit_1,
  rf_tree_10 = rf_tuned_1,
  rf_base_10 = rf_tuned_2,
  bt_tree_10 = bt_tuned_1,
  bt_base_10 = bt_tuned_2,
  knn_tree_10 = knn_tuned_1,
  knn_base_10 = knn_tuned_2
)

model_results_5 <- as_workflow_set(
  base_5 = base_fit_2,
  en_linear_5 = en_tuned_3,
  en_sink_5 = en_tuned_4,
  lm_linear_5 = lm_fit_3,
  lm_sink_5 = lm_fit_4,
)

model_results_6 <- as_workflow_set(
  base_10 = base_fit_1,
  en_linear_10 = en_tuned_1,
  en_sink_10 = en_tuned_2,
  lm_linear_10 = lm_fit_1,
  lm_sink_10 = lm_fit_2
)
  
model_results_7 <- as_workflow_set(
  rf_tree_5 = rf_tuned_3,
  rf_base_5 = rf_tuned_4,
)

model_results_8 <- as_workflow_set(
  rf_tree_10 = rf_tuned_1,
  rf_base_10 = rf_tuned_2,
)

results_table_1 <- model_results_1 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct() |> 
  kable()

results_table_2 <- model_results_2 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct() |> 
  kable()

results_table_3 <- model_results_3 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) 

results_table_4 <- model_results_4 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) 

all_tree_results <- bind_rows(results_table_3, results_table_4) |> 
  kable()

results_table_5 <- model_results_5 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct()

results_table_6 <- model_results_6 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct()

all_linear_results <- bind_rows(results_table_5, results_table_6) |> 
  kable()

results_table_7 <- model_results_7 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct()

results_table_8 <- model_results_8 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  distinct()

all_rf_results <- bind_rows(results_table_7, results_table_8) |> 
  kable()

base_rsq <- base_fit_1 |> 
  collect_metrics() |> 
  filter(.metric == "rsq") |> 
  slice_min(mean) |> 
  select(mean, std_err, n) |> 
  kable()
  

#Plotting results
results_figure_1 <- model_results_1 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_2 <- model_results_2 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_3 <- model_results_3 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_4 <- model_results_4 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_5 <- model_results_5 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_6 <- model_results_6 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_7 <- model_results_7 |> 
  autoplot(metric = "rmse", select_best = TRUE)

results_figure_8 <- model_results_8 |> 
  autoplot(metric = "rmse", select_best = TRUE)

folds_plot <- ggarrange(results_figure_3, results_figure_4, 
          ncol = 2, labels = c("A", "B"))

lm_plot <- ggarrange(results_figure_5, results_figure_6, 
          ncol = 2, labels = c("A", "B"))

rf_plot <- ggarrange(results_figure_7, results_figure_8, 
                           ncol = 2, labels = c("A", "B"))

# Selecting best models
rf_best <- bind_rows(
  select_best(rf_tuned_1, metric = "rmse"),
  select_best(rf_tuned_2, metric = "rmse"),
  select_best(rf_tuned_3, metric = "rmse"),
  select_best(rf_tuned_4, metric = "rmse")
) |> 
  kable()

bt_best <- bind_rows(
  select_best(bt_tuned_1, metric = "rmse"),
  select_best(bt_tuned_2, metric = "rmse"),
  select_best(bt_tuned_3, metric = "rmse"),
  select_best(bt_tuned_4, metric = "rmse")
) |> 
  kable()

en_best <- bind_rows(
  select_best(en_tuned_1, metric = "rmse"),
  select_best(en_tuned_2, metric = "rmse"),
  select_best(en_tuned_3, metric = "rmse"),
  select_best(en_tuned_4, metric = "rmse")
) |> 
  kable()

knn_best <- bind_rows(
  select_best(knn_tuned_1, metric = "rmse"),
  select_best(knn_tuned_2, metric = "rmse"),
  select_best(knn_tuned_3, metric = "rmse"),
  select_best(knn_tuned_4, metric = "rmse")
) |> 
  kable()


save(results_table_1, file = here("figures/results_table_1.rda"))
save(results_table_2, file = here("figures/results_table_2.rda"))

save(all_tree_results, file = here("figures/all_tree_results.rda"))
save(all_linear_results, file = here("figures/all_linear_results.rda"))
save(all_rf_results, file = here("figures/all_rf_results.rda"))
save(base_rsq, file = here("figures/base_rsq.rda"))
save(rf_best, file = here("figures/rf_best.rda"))
save(bt_best, file = here("figures/bt_best.rda"))
save(en_best, file = here("figures/en_best.rda"))
save(knn_best, file = here("figures/knn_best.rda"))
ggsave(folds_plot, file = here("figures/folds_plot.png"))
ggsave(lm_plot, file = here("figures/lm_plot.png"))
ggsave(rf_plot, file = here("figures/rf_plot.png"))
ggsave(results_figure_1, file = here("figures/results_figure_1.png"))
ggsave(results_figure_2, file = here("figures/results_figure_2.png"))
ggsave(results_figure_3, file = here("figures/results_figure_3.png"))
ggsave(results_figure_4, file = here("figures/results_figure_4.png"))
ggsave(results_figure_5, file = here("figures/results_figure_5.png"))
