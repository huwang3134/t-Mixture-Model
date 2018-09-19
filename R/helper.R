#returns the vector sum of a list of vectors 
vec_sum = function(list_of_vec) {
  n = length(list_of_vec)
  p = length(list_of_vec[[1]])
  sum = vector(length = p)
  for (i in 1:n) {
    sum = sum + list_of_vec[[i]]
  }
  sum
}

#line search function
#f must be a univariate function
#range is a vector of variables to search
line_search = function (f, range) {
  opt = range[1]
  if (length(range) == 1) {
    opt
  }
  n = length(range)
  for (i in 2:n) {
    if (f(range[i]) > f(opt)) {
      opt = range[i]
    }
  }
  opt
}
