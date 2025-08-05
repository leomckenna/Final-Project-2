# Final Project 2 Progress Memo 1 ----
# Initial Data quality & complexity check

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(gt)

# handle common conflicts
tidymodels_prefer()

# read in and clean data 
county_data <- read_csv(here("data/acs2017_county_data.csv")) |> 
  janitor::clean_names()

# Checking missingness
county_data |> 
  naniar::miss_var_summary() |> 
  filter(n_miss > 0) |> 
  gt() |> 
  tab_header(
    title = "Summary of Missing Values",
    subtitle = "Variables with Missing Values"
  )

#There is one missing observation in the entire data set, so missingness will not be a problem for prediction.

## inspect target variable ----
county_data |> 
  skimr::skim_without_charts(income)

# The data seems to follow the trend we would expect of income in the US - with an average of around
# 50,000 dollars and the highest value being around 130,000

# analyzing distribution
p1 <- county_data |> 
  ggplot(aes(income)) +
  geom_density(color = "black", fill = "darkred") +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  labs(x = "County Average Income", title = "Density Plot of Income")

p2 <- county_data |> 
  ggplot(aes(income)) +
  geom_boxplot() + 
  theme_void()

p2/p1 +
  plot_layout(heights = unit(c(1, 5), c("cm", "null")))

# As we would expect, the income follows a pretty standard normal distribution around the mean of
# 48,995, with a standard deviation of 13,877. Both the box plot and density plot confirm the fact that
# no transformation for this variable will needed. 

## inspecting entire data set ----
county_data |> 
  count()

#We have 3220 observations - meaning that there is data from 3,220 different US counties. This should be
# plenty to make a predictive model. For exmaple, if I were to use the normal amount of strata, there would be

0.8*3220 

# 2576 observations for training, and thus 644 observations with which to test our trained model. 
# There are also 

county_data |> 
  ncol()

# 37 columns which should give us plenty of features for this model
# There are also

county_data |> 
  select(where(is.numeric)) |> 
  names()

# 35 numeric variables, and 

county_data |> 
  select(!where(is.numeric)) |> 
  names()

# two categorical variables - simply the state and the county within the state.
# On inspection, I realized that there are three variables, namely income_per_cap, income_per_cap_err, and
# income_err that should be removed for prediction as they could lead to issues with multicollinearity

# removing unneeded variables
county_data <- county_data |> 
  select(-c(income_err, income_per_cap, income_per_cap_err))





