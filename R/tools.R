# kate: default-dictionary en_AU

## realtest package for R
## Copyleft (C) 2021, Marek Gagolewski <https://www.gagolewski.com>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details. You have received
## a copy of the GNU General Public License along with this program.


# let's keep it simple, less is better
# think thrice before adding anything here

# below are a few ideas of the functions
# some users might want to add to their projects

# unattr <- function(x)
# {
#     attributes(x) <- NULL
#     x
# }


# ignore_attributes <- function(comparer=getOption("realtest_value_comparer", identical))
# {
#     function(x, y) comparer(unattr(x), unattr(y))
# }


# all_equal <- function(x, y)
# {
#     r <- (x == y)  # `==` can be overloaded based on class(x)
#     if (length(r) == 0) return("comparison with `==` yields an empty vector")
#     # TODO: what about the attributes?
#     all(r)
# }


# in_interval <- function(x, y)
# {
#     r <- ((x[1] <= y) & (y <= x[2]))
#     if (length(r) == 0) return("comparison yields an empty vector")
#     # TODO: what about the attributes?
#     all(r)
# }




#' @title
#' Read and Evaluate Code from an R Script
#'
#' @description
#' A simplified alternative to \code{\link[base]{source}},
#' which additionally sets some environment variables whilst
#' executing a series of expressions to ease debugging.
#'
#' @details
#' The function sets/updates the following environment variables while
#' evaluating consecutive expressions:
#' \itemize{
#'    \item \code{__FILE__} -- path to current file,
#'    \item \code{__LINE__} -- line number where the currently executed
#'        expression begins,
#'    \item \code{__EXPR__} -- source code defining the expression.
#' }
#'
#'
#' @param file usually a file name, see \code{\link[base]{parse}}
#' @param local specifies the environment where expressions
#'     will be evaluated, see \code{\link[base]{source}}
#'
#' @return This function returns nothing.
#'
#' @examples
#' \donttest{
#' # example error handler - report source file and line number
#' old_option_error <- getOption("error")
#' options(error=function()
#'    cat(sprintf(
#'        "Error in %s:%s.\n", Sys.getenv("__FILE__"), Sys.getenv("__LINE__")
#'    ), file=stderr()))
#' # now call source2() to execute an R script that throws some errors...
#' options(error=old_option_error)  # cleanup
#' }
#'
#' @export
source2 <- function(file, local=FALSE)
{
    on.exit({
        Sys.setenv("__FILE__"="")
        Sys.setenv("__LINE__"="")
        Sys.setenv("__EXPR__"="")
    })

    if (isTRUE(local)) local <- parent.frame()
    else if (isFALSE(local)) local <- globalenv()
    stopifnot(is.environment(local))

    p <- parse(file=file, keep.source=TRUE)
    Sys.setenv("__FILE__"=file)

    s <- attr(p, "srcref")

    for (i in seq_along(p)) {
        Sys.setenv("__LINE__"=s[[i]][1])  # lines s[[i]][1]:s[[i]][3]
        Sys.setenv("__EXPR__"=paste0(as.character(s[[i]]), collapse="\n"))
        eval(p[[i]], envir=local)
    }

    invisible(NULL)
}


#' @title
#' Gather All Test Results From R Scripts
#'
#' @description
#' Executes all R scripts in a given directory whose names match a given
#' pattern and gathers all test result in a single list,
#' which you can process however you desire.
#'
#' The function does not fail if some tests are not met -- you need
#' to detect this yourself.
#'
#' @param path directory with scripts to execute
#' @param pattern regular expression specifying the file names to execute
#' @param recursive logical, see \code{\link[base]{list.files}}
#' @param ignore.case logical, see \code{\link[base]{list.files}}
#'
#' @return Returns a list of all test results
#' (of class \code{realtest_results}),
#' each being an object of class \code{realtest_result}, see \code{\link{E}},
#' with additional fields \code{.file}, \code{.line}, and \code{.expr},
#' giving the location and the source code of the test instance.
#'
#' @examples
#' \donttest{
#' r <- test_dir("~/R/realtest/tests")
#' s <- summary(r)  # summary.realtest_results
#' print(s)  # print.realtest_results_summary
#' stopifnot(sum(s[["match"]]=="fail") == 0)  # halt if there are failed tests
#' }
#'
#' @seealso Related functions:
#' \code{\link{source2}}, \code{\link{summary.realtest_results}}
#'
#' @rdname test_dir
#' @export
test_dir <- function(
    path="tests",
    pattern="^realtest-.*\\.R",
    recursive=FALSE,
    ignore.case=FALSE
) {
    ..old.realtest_postprocessor <- getOption("realtest_postprocessor")
    on.exit(options(realtest_postprocessor=..old.realtest_postprocessor))

    ..realtest_results <- list()

    results_gather <- function(r)
    {
        stopifnot_result_valid(r)  # internal

        stopifnot(is.list(..realtest_results))

        if (Sys.getenv("__FILE__") != "")
            r[[".file"]] <- Sys.getenv("__FILE__")

        if (Sys.getenv("__LINE__") != "")
            r[[".line"]] <- Sys.getenv("__LINE__")

        if (Sys.getenv("__EXPR__") != "")
            r[[".expr"]] <- Sys.getenv("__EXPR__")

        # push_back:
        ..realtest_results[[length(..realtest_results) + 1]] <<- r

        invisible(r)
    }

    options(realtest_postprocessor=results_gather)

    fs <- list.files(
        path=path, pattern=pattern, full.names=TRUE,
        ignore.case=ignore.case, recursive=recursive
    )

    for (t in fs) {
        # we need the caller's envir as parent,
        # not the local function's envir whose parent is namespace:realtest
        source2(t, local=new.env(parent=parent.frame()))
    }

    structure(
        ..realtest_results,
        class=c("realtest_results", "realtest")
    )
}


#' @title
#' Summarise and Display Test Results
#'
#' @description
#' An example (write your own which will better suit your needs)
#' way to summarise the results returned by \code{test_dir}.
#'
#'
#' @param object list of objects of class \code{realtest_result},
#'     see \code{\link{E}}.
#' @param x object returned by \code{summary.realtest_results}
#' @param ... currently ignored
#' @param label_pass single string denoting the default name for
#'    unnamed prototypes
#' @param label_fail single string labelling failed test cases
#'
#' @return
#' \code{print.realtest_results_summary} returns \code{x}, invisibly.
#'
#' \code{summary.realtest_results} returns an object of class
#' \code{realtest_results_summary} which is a data frame summarising
#' the test results, featuring the following columns:
#' \itemize{
#' \item \code{call} -- name of the function tested,
#' \item \code{match} -- the name of the first matching prototype,
#'    \code{label_pass} if it is unnamed or \code{label_fail} if
#'    there is no match,
#' \item \code{.file} (optional) -- name of the source file which
#'    defined the expectation,
#' \item \code{.line} (optional) -- line number,
#' \item \code{.expr} (optional) -- source code of the whole tested expression.
#' }
#'
#'
#' @examples
#' \donttest{
#' r <- test_dir("~/R/realtest/tests")
#' s <- summary(r)  # summary.realtest_results
#' print(s)  # print.realtest_results_summary
#' stopifnot(sum(s[["match"]]=="fail") == 0)  # halt if there are failed tests
#' }
#'
#' @seealso Related functions:
#' \code{\link{test_dir}}
#'
#' @rdname summary.realtest_results
#' @aliases print.realtest_results_summary
#' @export
print.realtest_results_summary <- function(x, label_fail="fail", ...)
{
    stopifnot(is.data.frame(x))
    stopifnot(c("match") %in% names(x))

    cat("*** realtest: test summary:\n")
    if (!is.null(x[[".file"]]))
        print(table(x[[".file"]], x[["match"]]))
    else
        print(table(x[["match"]]))
    cat("\n")

    fails <- x[x[["match"]] == label_fail, , drop=FALSE]
    if (nrow(fails) == 0) {
        cat("*** realtest: all tests succeeded\n")
    } else {
        cat("*** realtest: failed test details:\n")
        fails2 <- fails[,
            !(names(fails) %in% ".expr") & !sapply(fails, function(x) all(is.na(x))),
            drop=FALSE]
        print.data.frame(fails2)
        cat("\n")
    }

    invisible(x)
}


#' @rdname summary.realtest_results
#' @export
summary.realtest_results <- function(object, label_pass="pass", label_fail="fail", ...)
{
    stopifnot(is.character(label_pass), length(label_pass) == 1)  # TODO: NA ok?
    stopifnot(is.character(label_fail), length(label_fail) == 1)  # TODO: NA ok?
    stopifnot(is.list(object), length(object) >= 1)

    s <- lapply(object, function(r) {
        stopifnot_result_valid(r)
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

    structure(
        s,
        class=c("realtest_results_summary", "realtest", "data.frame")
    )
}


