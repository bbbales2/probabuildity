library(tidyverse)
library(ggplot2)
library(rstan)
library(GGally)
library(shinystan)

source("formatters.R")

fit = readRDS("jackie_data/fit.rds")

extract(fit, pars = c("n", "p")) %>%
  as.tibble %>%
  ggpairs(lower = list(continuous = point_plots))
