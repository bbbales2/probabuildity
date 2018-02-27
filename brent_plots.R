library(tidyverse)
library(ggplot2)
library(rstan)
library(GGally)

source("formatters.R")

fit = read_stan_csv(c('brent_data/cmsx4.20modes.13.csv',
                      'brent_data/cmsx4.20modes.14.csv',
                      'brent_data/cmsx4.20modes.15.csv',
                      'brent_data/cmsx4.20modes.16.csv'))

fit = read_stan_csv(c('brent_data/ti.30modes.13.csv',
                      'brent_data/ti.30modes.14.csv',
                      'brent_data/ti.30modes.15.csv',
                      'brent_data/ti.30modes.16.csv'))

s = extract(fit)

#pm <- ggpairs(tips, mapping = aes(color = sex), columns = c("total_bill", "time", "tip"),
#              diag = list(continuous = my_dens))

s[c('c11', 'a', 'c44')] %>%
  as.tibble %>%
  ggpairs(lower = list(continuous = point_plots))
