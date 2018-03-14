library(tidyverse)
library(ggplot2)
library(rstan)

m = 3.85
g = -9.80665
E = 8000
angle = 45 * pi / 180
N = 10
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

y = rnorm(N, px, sigma)

fit = stan("models/cannon.stan",
           data = list(m = m,
                       g = g,
                       angle = angle,
                       N = N,
                       y = y),
           chains = 1, iter = 2000)
