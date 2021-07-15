library("realtest")

# named prototypes, retval:
e <- E(
    paste0(1:2, 1:3),
    .description="partial recycling",
    best=P(
        c("11", "22", "13"),
        warning=TRUE
    ),
    pass=c("11", "22", "13"),
    bad=P(error=TRUE)
)

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "pass")
E(e[[".description"]], "partial recycling")


# named prototypes cont'd:
e <- E(sin(pi), best=0.0, good=P(0.0, value_comparer=all.equal),
    .comment="well, this is not a symbolic language after all...")

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "good")
E(startsWith(e[[".comment"]], "well"), TRUE)


# unnamed prototype match:
e <- E(sin(pi), best=0.0, P(0.0, value_comparer=all.equal))

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), "")


# two matches:
e <- E(1, best=1, 1)

E(inherits(e, "realtest_result"), TRUE)
E(names(e[["matches"]]), c("best", ""))
