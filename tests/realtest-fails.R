library("realtest")

# a bunch of unmet test instances
if (identical(Sys.getenv("__REALTEST_TEST_FAILURES"), "1")) {
    E(sqrt(2), 7)
    E(sqrt(-1), P(NaN))
    E(1:2 * c(1, 10, 100), P(c(1, 20, 100)))
    E(1:2 * c(1, 10, 100), P(c(1, 20, 100000), warning=TRUE))
    E(stop("aaargh"), P(error=TRUE))
}
