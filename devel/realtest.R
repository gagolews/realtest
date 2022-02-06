# This file is part of the 'realtest' project.
# Copyleft (c) 2021-2022, Marek Gagolewski <https://www.gagolewski.com>

# runs all scripts named like ./tests/realtest-*.R

library("realtest")
# Sys.setenv("__REALTEST_TEST_FAILURES"="1")

r <- test_dir("inst/realtest")
s <- summary(r)
print(s)
stopifnot(all(s[["match"]] != "fail"))  # halt if there are failed tests
