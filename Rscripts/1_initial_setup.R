# Final Project 2 Progress Memo 1 ----
# Initial Data quality & complexity check

# Note there is a random process in this script

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(ggcorrplot)
library(patchwork)
library(cowplot)

# handle common conflicts
tidymodels_prefer()

# read in and clean data 
census_data <- read_csv(here("data/acs2017_county_data.csv")) |> 
  janitor::clean_names() 

# short eda
# analyzing distribution
p1 <- census_data |> 
  ggplot(aes(income)) +
  geom_density(color = "black", fill = "darkred") +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  labs(x = "County Average Income")

p2 <- census_data |> 
  ggplot(aes(income)) +
  geom_boxplot() + 
  theme_void() +
  labs(title = "Box and Density Plot for Income")

income_plot <- plot_grid(p2, p1, ncol = 1, align = "v")

ggsave(income_plot, file = here("figures/income_plot.png"))

census_corr <- census_train |> 
  select(-c(income_err, income_per_cap, income_per_cap_err, county_id, county, service, mean_commute, )) |> 
  select(where(is.numeric)) |> 
  na.omit()

cor_matrix <- cor(census_corr)

corr_plot <-ggcorrplot(cor_matrix, 
           hc.order = TRUE, 
           type = "upper", 
           outline.col = "white", 
           lab_size = 3
)

ggsave(corr_plot, file = here("figures/corr_plot.png"))

# Checking missingness
missing_summary <- census_train |> 
  naniar::miss_var_summary() |> 
  filter(n_miss > 0) 

#initial split
# prop = 0.8
census_split <- census_data |> 
  initial_split(prop = 0.8, strata = income)

census_train <- census_split |> training()
census_test <- census_split |> testing()

# folding data (resamples) 
# set seed for original stratification
set.seed(1162055095)
census_folds_1 <- census_train |> 
  vfold_cv(v = 10, repeats = 5, strata = income)

# set seed for 5-fold cross-validation
set.seed(20481)
census_folds_2 <- census_train |> 
  vfold_cv(v = 5, repeats = 5, strata = income)


# set up controls for fitting resample
keep_wflow <- control_resamples(save_pred = TRUE, save_workflow = TRUE)

# write out split, train, test, and fold data
save(census_train, file = here("data_splits/census_train.rda"))
save(census_split, file = here("data_splits/census_split.rda"))
save(census_test, file = here("data_splits/census_test.rda"))
save(census_folds_1, file = here("data_splits/census_folds_1.rda"))
save(census_folds_2, file = here("data_splits/census_folds_2.rda"))
save(keep_wflow, file = here("results/keep_wflow.rda"))


