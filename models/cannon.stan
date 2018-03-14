data {
  real g;
  real m;
  real angle;
  int N;
  vector[N] y;
}

parameters {
  real<lower=0.0> E;
  real<lower=0.0> sigma;
}

transformed parameters {
  real a = 0.5 * g;
  real v0 = sqrt(2 * E / m);
  real b = sin(angle) * v0;
  real c = 1.0;
  real t1 = sqrt(b^2 / (4 * a^2) - c / a) - b / (2 * a);
}

model {
  sigma ~ normal(0.0, 5.0);

  y ~ normal(cos(angle) * v0 * t1, sigma);
}
