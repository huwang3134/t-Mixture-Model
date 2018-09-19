#complete data log likelihood
mvtmixll = function (x, lambda, mu, sigma, nu, n) {
  G = length(lambda)
  sum(sapply(1:n, function (i) {
    log(sum(sapply(1:G, function (g) {
      lambda[[g]] * dmvt(x = x[i, ], delta = mu[[g]], 
                        sigma = sigma[[g]], df = nu[g], log = FALSE)
    })))
  }))
}

