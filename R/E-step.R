#E-step
mvtmixEstep = function (x, lambda, mu, sigma, nu, G, n, q) {
  
  #Expected value of Z Given X; as a matrix
  EZ_X = t(sapply(1: n, function (i) {
    sapply(1:G, function (g) {
      lambda[[g]] * dmvt(x = x[i, ], delta = mu[[g]],
                        sigma = sigma[[g]], df = nu[g], log = FALSE) /
        sum(sapply(1:G, function (j) {
          lambda[[j]] * dmvt(x = x[i, ], delta = mu[[j]],
                            sigma = sigma[[j]], df = nu[j], log = FALSE)
        }))
    })
  }))
  
  #Expected value of U given X and Z; as a vector
  EU_XZ = sapply(1:n, function (i) {
    k = which.max(EZ_X[i, ]) #estimate of k_i
    (nu[k] + q) / (nu[k] + t(x[i, ] - mu[[k]]) %*%
                          solve(sigma[[k]]) %*% (x[i, ] - mu[[k]]))
  })
  
  #Expected value of logU given X and Z; as a vector
  ElogU_XZ = sapply(1:n, function (i) {
    k = which.max(EZ_X[[i]])
    digamma(0.5 * (nu[k] + q)) + log(EU_XZ[i]) - log(0.5 * (nu[k] + q))
  })
  
  #Returning all expectations in a list
  list(EZ_X = EZ_X, EU_XZ = EU_XZ, ElogU_XZ = ElogU_XZ)
}