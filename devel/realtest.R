# runs all scripts named like ./tests/realtest-*.R

library("realtest")
# Sys.setenv("__REALTEST_TEST_FAILURES"="1")


results_summarise <- function(results, label_pass="pass", label_fail="fail")
{
    s <- lapply(results, function(r) {
        if (length(r[["matches"]]) == 0)
            match_name <- label_fail
        else if (is.null(names(r[["matches"]])))
            match_name <- label_pass
        else if (names(r[["matches"]])[1] == "")
            match_name <- label_pass
        else
            match_name <- names(r[["matches"]])[1]

#         avoid_null <- function(x, other) if (is.null(x)) other else x

        c(
            list(
                call=deparse(r[["object"]][["expr"]][[1]]),
                match=match_name
            ),
            r[startsWith(names(r), ".")]
        )
    })

    common_labels <- unique(unlist(lapply(s, names)))
    s <- lapply(s, function(r) {
        for (cl in common_labels)
            if (is.null(r[[cl]])) r[[cl]] <- NA
        r
    })

    s <- do.call(rbind.data.frame, s)
    s[["match"]] <- factor(s[["match"]],
        levels=c(setdiff(s[["match"]], c(label_pass, label_fail)), c(label_pass, label_fail)))
    s
}


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
