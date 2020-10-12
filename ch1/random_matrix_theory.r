M <- 10000
N <- 4

random_splitting <- function(n) {
  # part 1
  m <- matrix(data = rnorm(n^2), nrow = n)
  msym <- m + t(m)
  # part 2
  msym <- sign(msym)
  mid <- n / 2
  e <- rev(eigen(msym, symmetric = TRUE, only.values = TRUE)$values)
  e[mid + 1] - e[mid]
}

# wigner <- function(l) (l / 8) * exp( -(l^2) / 16 )
wigner <- function(l) (pi * l / 2) * exp( -pi * (l^2) / 4 )

ensemble <- replicate(M, random_splitting(N))
normalized <- ensemble / mean(ensemble)
hist(normalized, freq = FALSE, breaks = 50)
curve(wigner, from = 0, to = 20, add = TRUE)
