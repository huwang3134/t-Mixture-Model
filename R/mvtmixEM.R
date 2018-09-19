#EM algorithm
#max_iterations is the maximum number of iterations
#requires max_iterations > 1
#convergence is checked using the log likelihood and the specified tolerance level, tolerance
#maximize_nu is a boolean where, if TRUE, nu is maximized using line search over the values specified in nu_range
#if FALSE, nu is fixed

#lambda is a vector of the component probabilities
#mu is a list of the mean vectors
#sigma is a list of the covariance matricies
#nu is a vector of the degrees of freedom
#G is the number of components of the mixture model
#q is the dimension of the mixture model
#x is a data frame of the data

#returns a list of lambda, mu, sigma, nu, loglik
#loglik is a vector of the complete data log likelihood at each iteration

suppressMessages(library(here))

source(here::here("R/helper.R"))
source(here::here("R/mvtmixll.R"))
source(here::here("R/M-step.R"))
source(here::here("R/E-step.R"))

mvtmixEM = function(x, lambda, mu, sigma, nu, 
                  nu_range, tolerance = 0.1, max_iterations = 100, maximize_nu = TRUE) {
  require(mvtnorm)
  x = as.matrix(x)
  
  n = nrow(x)
  G = length(lambda)
  q = length(mu[[1]])
  loglik = vector(length = max_iterations)
  
  loglik[1] = mvtmixll(x = x, mu = mu, sigma = sigma, nu = nu,
                      lambda = lambda, n = n)
  
  for(i in 2:max_iterations) {
    E = mvtmixEstep(x = x, mu = mu, sigma = sigma, nu = nu, lambda = lambda,
                  G = G, n = n, q = q)
    M = mvtmixMstep(x = x, G = G, n = n,
                  nu_range = nu_range, E = E, maximize_nu = maximize_nu)
    
    mu = M$mu
    sigma = M$sigma
    nu = M$nu
    lambda = M$lambda
    
    loglik[i] = mvtmixll(x = x, mu = mu, sigma = sigma, nu = nu, 
                        lambda = lambda, n = n)
    
    if(abs(loglik[i] - loglik[i-1]) < tolerance) {
      break
    }
    
    loglik = loglik[1:i]
    
  }
  list(lambda = lambda, mu = mu, sigma = sigma, nu = nu, loglik = loglik)
}