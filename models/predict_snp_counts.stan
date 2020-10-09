data {
  // study metadata
  int<lower=0> P; // number of platforms
  int<lower=0> N_draws; // number of posterior parameter samples
  
  // parameter samples
  matrix[N_draws, P] mu;
  matrix<lower=0>[N_draws, P] sigma;
  
  //study data
  real<lower=0> y; // study SNP count
  vector[P] X; // one-hot encoding of study platform
}

parameters {
  
}

model {
  
}

// posterior predictive checks taken from the stan user guide:
// https://mc-stan.org/docs/2_19/stan-users-guide/applications-of-pseudorandom-number-generation.html
generated quantities {
  vector[N_draws] y_tilde;
  vector[N_draws] y_loglik;

  for (i in 1:N_draws) {
    y_tilde[i] = normal_rng(dot_product(X, mu[i]), dot_product(X, sigma[i]));
    y_loglik[i] = normal_lpdf(y | dot_product(X, mu[i]), dot_product(X, sigma[i]));
  }
}

