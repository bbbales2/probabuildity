library(tidyverse)
library(ggplot2)
library(rstan)

N = 10
model = stan_model("models/cannon.stan")

generateData = function(N) {
  m = 3.85
  g = -9.80665
  E = 8000
  angle = 45 * pi / 180
  sigma = 5
  
  a = 0.5 * g
  v0 = sqrt(2 * E / m)
  b = sin(angle) * v0
  c = 1
  
  t0 = -sqrt(b^2 / (4 * a^2) - c / a) - b / (2 * a)
  t1 = sqrt(b^2 / (4 * a^2) - c / a) - b / (2 * a)
  
  if(t0 >= 0) {
    stop("t0 should be negative (so the positive time solution is unique)")
  }
  
  py = a * t1^2 + b * t1 + c
  px = cos(angle) * v0 * t1
  px
  
  round(rnorm(N, px, sigma), 1)
}

runFit = function(y) {
  fit = sampling(model,
                 data = list(m = m,
                             g = g,
                             angle = angle,
                             N = length(y),
                             y = y),
                 chains = 4, iter = 2000)
  
  quantile(extract(fit, c("E"))$E, c(0.05, 0.25, 0.5, 0.75, 0.95))
}

maxN = 1000
y = generateData(maxN)

# Initial quantiles
runFit(y[1:10])

# Plot of convergence as we add more data
Ns = seq(log(5), log(maxN), length = 50) %>%
  exp %>%
  round %>%
  unique
out = map(Ns, ~ runFit(y[1:.x])) %>%
  do.call("rbind", .) %>%
  as.tibble %>%
  mutate(N = Ns)

out %>%
  ggplot(aes(log2(N))) +
  geom_errorbar(aes(ymin = `5%`, ymax = `95%`)) +
  ylab("E")

# Repeat experiment with second dataset
y2 = generateData(maxN)
out2 = map(Ns, ~ runFit(y2[1:.x])) %>%
  do.call("rbind", .) %>%
  as.tibble %>%
  mutate(N = Ns)

out %>%
  ggplot(aes(log2(N))) +
  geom_errorbar(aes(ymin = `5%`, ymax = `95%`)) +
  geom_errorbar(data = out2, aes(ymin = `5%`, ymax = `95%`), color = "orange") +
  ylab("E")
