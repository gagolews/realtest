# runs all scripts named like ./tests/realtest-*.R

library("realtest")
# Sys.setenv("__REALTEST_TEST_FAILURES"="1")

r <- test_dir("tests")
s <- summary(r)
print(s)
stopifnot(sum(s[["match"]]=="fail") == 0)  # halt if there are failed tests
