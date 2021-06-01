library("realtest")

# a bunch of unmet test instances
if (identical(Sys.getenv("__REALTEST_TEST_FAILURES"), "1")) {
    E(sqrt(2), 7)
    E(sqrt(-1), P(NaN))
    E(stop("aaargh"), P(error=TRUE))
}
