# This file is part of the 'realtest' project.
# Copyleft (c) 2021-2023, Marek Gagolewski <https://www.gagolewski.com/>

# Runs all unit tests for the package

# this package is self-contained - using realtest to test itself

this_package <- "realtest"

set.seed(123)
library(this_package, character.only=TRUE)
if (require("realtest", quietly=TRUE)) {
    f <- file.path(path.package(this_package), "realtest")
    r <- test_dir(f, ".*\\.R$")
    s <- summary(r)
    print(s)
    stopifnot(all(s[["match"]] != "fail"))
}
