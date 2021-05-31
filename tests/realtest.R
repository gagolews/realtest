# this is self-contained - using realtest to test itself
library("realtest")

# expect the default result postprocessor to throw an error on a failed test:
E(E(sqrt(4), P(7)), P(error=TRUE, stdout=TRUE))

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

# do not test side effects
E(sqrt(-1), NaN, sides_comparer=ignore_differences)
E(sqrt(-1), P(NaN, sides_comparer=ignore_differences))
E(E(sqrt(-1), NaN), P(error=TRUE, stdout=TRUE))  # NaN with warning != NaN only

e <- E(
    paste0(1:2, 1:3),
    .description="partial recycling",
    desired=P(
        c("11", "22", "13"),
        warning="longer object length is not a multiple of shorter object length"
    ),
    current=c("11", "22", "13"),
    undesired=P(error=TRUE)
)

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "current")
E(e[[".description"]], "partial recycling")


e <- E(sin(pi), ideal=0.0, expected=P(0.0, value_comparer=all.equal),
    .comment="well, this is not a symbolic language after all...")

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "expected")
E(startsWith(e[[".comment"]], "well"), TRUE)

