library("realtest")

# expect the default result postprocessor to throw an error on a failed test:
if (is.null(getOption("realtest_postprocessor"))) {
    E(E(sqrt(4), P(7)), P(error=TRUE, stdout=TRUE))
    E(E(sqrt(-1), NaN), P(error=TRUE, stdout=TRUE))  # NaN with warning != NaN only
}


# a dummy and easy going postprocessor that does not complain about failures
E(TRUE, FALSE, postprocessor=function(r) invisible(r))
