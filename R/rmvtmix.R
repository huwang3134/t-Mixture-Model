library(mvtnorm)

#generate values from a finite mixture of multivariate t's
rmvtmix = function(n, lambda, mu, sigma, nu) {
  G = length(lambda)
  t(sapply(1:n, function(i) {
    Zi = sample(x = 1:G, size = 1 ,prob = lambda)
    rmvt(n = 1, delta = mu[[Zi]], sigma = sigma[[Zi]], df = nu[Zi])
  }))
}