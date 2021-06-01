library("realtest")


# named prototypes, retval:
e <- E(
    paste0(1:2, 1:3),
    .description="partial recycling",
    best=P(
        c("11", "22", "13"),
        warning="longer object length is not a multiple of shorter object length"
    ),
    current=c("11", "22", "13"),
    bad=P(error=TRUE)
)

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "current")
E(e[[".description"]], "partial recycling")

# named prototypes cont'd:
e <- E(sin(pi), best=0.0, good=P(0.0, value_comparer=all.equal),
    .comment="well, this is not a symbolic language after all...")

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "good")
E(startsWith(e[[".comment"]], "well"), TRUE)
