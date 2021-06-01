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
#' \dontrun{
#' # example error handler - report source file and line number
#' options(error=function()
#'    cat(sprintf(
#'        "Error in %s:%s.\n", Sys.getenv("__FILE__"), Sys.getenv("__LINE__")
#'    ), file=stderr()))
#' source2("script_throwing_some_errors.R", local=new.env())
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
#' @param path directory with scripts to execute
#' @param pattern regular expression specifying the file names to execute
#' @param recursive logical, see \code{\link[base]{list.files}}
#' @param ignore.case logical, see \code{\link[base]{list.files}}
#'
#' @return List of all test results, see \code{\link{E}}
#'
#' @seealso \code{\link{source2}}
#'
#' @export
test_dir <- function(
    path="tests",
    pattern="^realtest-.*\\.R",
    recursive=FALSE,
    ignore.case=FALSE
) {
    ..old.realtest_postprocessor <- getOption("realtest_postprocessor")
    on.exit(options(realtest_postprocessor=..old.realtest_postprocessor))

    results_gather <- function(r)
    {
        stopifnot_result_valid(r)  # internal

        if (is.null(.GlobalEnv[["__REALTEST_RESULTS"]]))
            .GlobalEnv[["__REALTEST_RESULTS"]] <- list()

        if (Sys.getenv("__FILE__") != "")
            r[[".file"]] <- Sys.getenv("__FILE__")

        if (Sys.getenv("__LINE__") != "")
            r[[".line"]] <- Sys.getenv("__LINE__")

        if (Sys.getenv("__EXPR__") != "")
            r[[".expr"]] <- Sys.getenv("__EXPR__")

        # push_back:
        .GlobalEnv[["__REALTEST_RESULTS"]][[
            length(.GlobalEnv[["__REALTEST_RESULTS"]])+1
        ]] <- r

        invisible(r)
    }

    options(realtest_postprocessor=results_gather)
    .GlobalEnv[["__REALTEST_RESULTS"]] <- NULL

    fs <- list.files(
        path=path, pattern=pattern, full.names=TRUE,
        ignore.case=ignore.case, recursive=recursive
    )

    for (t in fs) {
        source2(t, local=new.env())
    }

    results <- .GlobalEnv[["__REALTEST_RESULTS"]]
    .GlobalEnv[["__REALTEST_RESULTS"]] <- NULL
    results
}


#' @export
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


