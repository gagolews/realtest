# this is self-contained - using realtest to test itself
library("realtest")

# prototype must be provided:
E(E(sqrt(4)), P(error="provide at least one prototype"))

E(sqrt(4), P(2.0))
E(sqrt(4), 2.0)  # equivalent to the above

# almost-equal (round-off errors)
E(sin(pi), 0.0, value_comparer=all.equal)

# two equally okay possible outcomes:
E(sample(c("head", "tail"), 1), "head", "tail")

# a warning is expected
E(sqrt(-1), P(NaN, warning=TRUE))
E(1:2 * c(1, 10, 100), P(c(1, 20, 100), warning=TRUE))

# do not test side effects
E(sqrt(-1), NaN, sides_comparer=ignore_differences)
E(sqrt(-1), P(NaN, sides_comparer=ignore_differences))
