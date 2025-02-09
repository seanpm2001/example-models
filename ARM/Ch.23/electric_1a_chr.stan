data {
  int<lower=0> N;
  int<lower=0> n_grade;
  int<lower=0> n_grade_pair;
  int<lower=0> n_pair;
  array[N] int<lower=1, upper=n_grade> grade;
  array[n_pair] int<lower=1, upper=n_grade_pair> grade_pair;
  array[N] int<lower=1, upper=n_pair> pair;
  vector[N] treatment;
  vector[N] y;
}
parameters {
  vector[n_pair] eta_a;
  vector<lower=0, upper=100>[n_grade_pair] sigma_a;
  vector<lower=0, upper=100>[n_grade] sigma_y;
  vector[n_grade_pair] mu_a;
  vector[n_grade] b;
}
transformed parameters {
  vector[n_pair] a;
  vector<lower=0>[N] sigma_y_hat;
  vector[N] y_hat;
  
  for (i in 1 : n_pair) {
    a[i] = 100 * mu_a[grade_pair[i]] + sigma_a[grade_pair[i]] * eta_a[i];
  }
  
  for (i in 1 : N) {
    y_hat[i] = a[pair[i]] + b[grade[i]] * treatment[i];
    sigma_y_hat[i] = sigma_y[grade[i]];
  }
}
model {
  mu_a ~ normal(0, 1);
  eta_a ~ normal(0, 1);
  b ~ normal(0, 100);
  y ~ normal(y_hat, sigma_y_hat);
}
