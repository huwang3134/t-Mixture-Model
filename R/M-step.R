#M-step
#if maximize_nu is FALSE then nu will be fixed
#default is true
#nu_rage is the range of nu to search (required)
mvtmixMstep = function (x, nu_range, G, n, E, maximize_nu = TRUE) {
  
  EZ_X = E$EZ_X
  EU_XZ = E$EU_XZ
  ElogU_XZ = E$ElogU_XZ
  
  #lambda parameter update  
  lambda = sapply(1: G, function (g) {
    mean(EZ_X[,g])
  })
  
  #mu parameter updates
  mu = lapply(1: G, function (g) {
    rowSums(sapply(1: n, function (i) {
      EZ_X[,g][i] * EU_XZ[i] * x[i,]
    })) /
      sum(EZ_X[,g] * EU_XZ)
  })
  
  #sigma parameter updates
  sigma = lapply(1: G, function (g) {
    vec_sum(lapply(1: n, function (i) {
      EZ_X[,g][i] * EU_XZ[i] * (x[i,] - mu[[g]]) %*% t(x[i,] - mu[[g]])
    })) /
      sum(EZ_X[,g])
  })
  
  #nu parameter updates
  if(maximize_nu == TRUE) {  
    nu = sapply(1: G, function (g) {
      line_search(f = function (nu) {
        sum(sapply(1:n, function(i) {
          EZ_X[,g][i]*(-log(gamma(nu / 2)) + 
                         (nu/2 * log(nu/2)) + (nu/2-1) * ElogU_XZ[i] - (nu/2) * EU_XZ[i])
        }))
      }, range = nu_range)
      
    })
  } else {
    nu = nu
  }
  
  #Returning all parameter updates in a list.
  list(mu = mu, sigma = sigma, nu = nu, lambda = lambda)
}