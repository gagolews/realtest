# runs all scripts named like ./tests/realtest-*.R

library("realtest")
# Sys.setenv("__REALTEST_TEST_FAILURES"="1")



r <- test_dir("tests")
s <- results_summarise(r)


cat("*** realtest: test summary:\n")
print(table(s[[".file"]], s[["match"]]))
cat("\n")

fails <- s[s[["match"]] == "fail", ]
if (nrow(fails) == 0) {
    cat("*** realtest: all tests succeeded\n")
} else {
    cat("*** realtest: failed test details:\n")
    print(fails)
    cat("\n")
    stop("some test failed")
}
