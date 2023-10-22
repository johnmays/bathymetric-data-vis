object_type <- function(obj) {
  # Since I am new to R, I am unsure if there is a better way to check object
  # type, but in my cursory research, it seems like the answer is no... so for
  # now, I will keep this handy function around that just runs through is.
  if (is.vector(obj)) {
    "vector"
  }else if (is.factor(obj)) {
    "factor"
  }else if (is.list(obj)) {
    "list"
  }else if (is.matrix(obj)) {
    "matrix"
  }else if (is.array(obj)) {
    "array"
  }else if (is.data.frame(obj)) {
    "data frame"
  }else {
    "unsure"
  }
}