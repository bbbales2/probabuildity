library(tidyverse)
library(ggplot2)

N = 1000

mu = 0.0
s = 1.0

dx = 0.1

getSamples = function(x0, dx) {
  x = x0
  xs = rep(0, N)
  accepts = 0
  for(i in 1:N) {
    xn = rnorm(1, x, dx)
    accept_ratio = exp(dnorm(xn, mu, s, log = TRUE) - dnorm(x, mu, s, log = TRUE))
    #accept_ratio = exp(dgamma(xn, shape = 2, scale = 2, log = TRUE) - dgamma(x, shape = 2, scale = 2, log = TRUE))
    r = runif(1)
    #cat(xn, ", ", x, " - ", dnorm(xn, mu, s), ", ", dnorm(x, mu, s), " - ", r, " ? ", accept_ratio, "\n")
    if(r < accept_ratio) {
      x = xn
      accepts = accepts + 1
      #cat("accept\n")
    }
    xs[i] = x
  }
  
  list(ts = 1:N, xs = xs, accepts = accepts / N, sdx = dx) %>%
    as.tibble
}

# exploration.png
map(seq(0.2, 0.8, length = 4), ~ getSamples(0.0, .)) %>%
  bind_rows %>%
  ggplot(aes(ts, xs)) +
  geom_point() +
  facet_grid(sdx ~ ., labeller = "label_both")

# mixing.png
map(seq(0.2, 0.8, length = 4), ~ getSamples(16.0, .)) %>%
  bind_rows %>%
  ggplot(aes(ts, xs)) +
  geom_point() +
  facet_grid(sdx ~ ., labeller = "label_both")

# acceptance_rate.png
map(seq(0.2, 2.0, length = 50), function(sdx) {
    list(sdx = sdx, accepts = getSamples(0.0, sdx) %>% pull(accepts) %>% unique)
  }) %>%
  bind_rows %>%
  ggplot(aes(sdx, accepts)) +
  geom_point() +
  geom_line() +
  ylab("Acceptance rate") +
  xlab("Standard deviation of proposal jump")
