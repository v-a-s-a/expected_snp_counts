data {
  // study metadata
  int<lower=0> N; // number of studies
  int<lower=0> P; // number of platforms
  
  //study data
  vector<lower=0>[N] y; // study SNP count
  matrix[N, P] X; // one-hot encoding of study platform
}

transformed data {
  vector[N] y_std; // standardize SNP counts
  y_std = (y - mean(y)) / sd(y);
}

parameters {
  real sigma_var_tmp; // unbounded variance of platform SNP count variance
  real mu_var_tmp; // unbounded variance of platform SNP count mean
  
  real theta; // effect of platform on SNP count variance
  real beta; // effect of platform on mean SNP count
  
  vector[P] mu_star; // average SNP count
  vector<lower=0>[P] sigma; // SNP count variance
}

transformed parameters {
  real<lower=0> sigma_var;
  real<lower=0> mu_var;
  vector[P] mu;
  
  // positive variance parameters
  sigma_var = fabs(sigma_var_tmp);
  mu_var = fabs(mu_var_tmp);
  
  // platform effects
  mu = mu_var * mu_star + beta;
}

model {
  // priors
  //   pulled from recommendations in Stan wiki
  //   https://github.com/stan-dev/stan/wiki/Prior-Choice-Recommendations
  sigma_var_tmp ~ cauchy(0, 25);
  mu_var_tmp ~ cauchy(0, 25);
  theta ~ student_t(3, 0, 3);
  beta ~ student_t(3, 0, 3);
  // beta ~ normal(0, 5);
  
  // non-centered platform effects
  mu_star ~ std_normal();
  
  // likelihood
  sigma ~ lognormal(theta, sigma_var); // hierarchical platform variances
  y_std ~ normal(X * mu, X * sigma); // SNP counts
}

// posterior predictive checks taken from the stan user guide:
// https://mc-stan.org/docs/2_19/stan-users-guide/applications-of-pseudorandom-number-generation.html
generated quantities {
  vector[N] y_tilde;
  for (i in 1:N) {
    y_tilde[i] = normal_rng(X[i] * mu, X[i] * sigma);
  }
}

