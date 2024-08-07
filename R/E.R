# kate: default-dictionary en_AU

## realtest package for R
## Copyleft (C) 2021-2024, Marek Gagolewski <https://www.gagolewski.com>
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




#' @title
#' Test Which Expectations are Met
#'
#' @description
#' Performs a unit test and summarises the results.
#'
#' @details
#' Each expression in the R language has a range of possible effects.
#' The direct effect corresponds to the value generated by evaluating
#' the expression. Side effects may include errors, warnings, text printed
#' out on the console, etc., see \code{\link{P}} and \code{\link{R}}.
#'
#'
#' Arguments passed via \code{...} whose names do not start with
#' a dot should be objects of class \code{realtest_descriptor}
#' (otherwise they are passed to \code{\link{P}}). They define the
#' prototypes against which the object generated by \code{expr}
#' will be tested.
#'
#' \code{value_comparer} and \code{sides_comparer} are 2-ary functions
#' that return \code{TRUE} if two objects/side effect lists are equivalent
#' and a character string summarising the differences (or any other kind
#' or object) otherwise.
#'
#' A test case is considered met, whenever
#' \code{value_comparer(prototype[["value"]], object[["value"]])} and
#' \code{sides_comparer(prototype[["sides"]], object[["sides"]])}
#' are both \code{TRUE} for some \code{prototype}.
#' The comparers may be overridden on a per-prototype basis, though.
#' If \code{prototype[["value_comparer"]]} or
#' \code{prototype[["sides_comparer"]]} are defined, these are used
#' instead.
#'
#'
#' @param expr an expression to be recorded (via \code{\link{R}}) and
#'     and compared with the prototypes
#' @param ... a sequence of 1 or more (possibly named) prototypes constructed
#'     via \code{\link{R}} or \code{\link{P}} (objects which are not
#'     of class \code{realtest_descriptor} will be passed to \code{\link{P}});
#'     arguments whose names start with a dot (like \code{.label=value})
#'     can be used to introduce metadata (e.g., additional details
#'     in natural language)
#' @param value_comparer a two-argument function used (unless overridden
#'     by the prototype) to compare the values with each other,
#'     e.g., \code{\link[base]{identical}}
#'     or \code{\link[base]{all.equal}}
#' @param sides_comparer a two-argument function used (unless overridden
#'     by the prototype) to compare the side effects (essentially: two lists)
#'     with each other, e.g., \code{\link{sides_similar}}
#'     or \code{\link{ignore_differences}}
#' @param postprocessor a function to call on the generated
#'     \code{realtest_result}, e.g., \code{\link{failstop}}
#'
#'
#' @return
#' The function creates an object of class \code{realtest_result},
#' which is a named list with at least the following components:
#' \itemize{
#' \item \code{object} -- an object of class \code{realtest_descriptor},
#'     ultimately \code{\link{R}(expr)},
#' \item \code{prototypes} -- a (possibly named) list of objects of class
#'     \code{realtest_descriptor} that were passed via \code{...},
#' \item \code{matches} -- a (possibly empty) numeric vector of the indexes
#'     of the prototypes matching the object (can be named),
#' \item \code{.dotted.names} -- copied as-is
#'     from the arguments of the same name.
#' }
#' This object is then passed to the \code{postprocessor} which itself becomes
#' responsible for generating the output value to
#' be returned by the current function (and, e.g., throwing an error
#' if the test fails).
#'
#' @examples
#' # the default result postprocessor throws an error on a failed test:
#' E(E(sqrt(4), P(7)), P(error=TRUE, stdout=TRUE))
#' E(sqrt(4), 2.0)  # the same as E(sqrt(4), P(2.0))
#' E(sin(pi), 0.0, value_comparer=all.equal)  # almost-equal
#' E(
#'   sample(c("head", "tail"), 1),
#'   .description="this call has two possible outcomes",
#'   "head",  # first prototype
#'   "tail"   # second prototype
#' )
#' E(sqrt(-1), P(NaN, warning=TRUE))  # a warning is expected
#' E(sqrt(-1), NaN, sides_comparer=ignore_differences) # do not test side effects
#' E(sqrt(-1), P(NaN, warning=NA))  # ignore warnings
#' E(
#'   paste0(1:2, 1:3),                  # expression to test - concatenation
#'   .description="partial recycling",  # info - what behaviour are we testing?
#'   best=P(                            # what we yearn for (ideally)
#'     c("11", "22", "13"),
#'     warning=TRUE
#'   ),
#'   pass=c("11", "22", "13"),          # this is the behaviour we have now
#'   bad=P(error=TRUE)                  # avoid regression
#' )
#' e <- E(sin(pi), best=0.0, pass=P(0.0, value_comparer=all.equal),
#'   .comment="well, this is not a symbolic language after all...")
#' print(e)
#'
#' @seealso Related functions:
#' \code{\link{P}}, \code{\link{R}}, \code{\link{test_dir}}
#'
#' @export
#' @rdname E
E <- function(
    expr,
    ...,
    value_comparer=getOption("realtest_value_comparer", identical),
    sides_comparer=getOption("realtest_sides_comparer", sides_similar),
    postprocessor=getOption("realtest_postprocessor", failstop)
) {
    this_call <- match.call()

    stopifnot(is.function(value_comparer))
    stopifnot(is.function(sides_comparer))
    stopifnot(is.function(postprocessor))

    # if (!inherits(expr, "realtest_descriptor"))  # we don't want to force eval here!
#     object <- R(expr, envir=parent.frame())  # will force eval inside
#     object[["expr"]] <- this_call[["expr"]]

    object <- eval(call("R", this_call[["expr"]], envir=parent.frame()))

    prototypes <- list(...)
    which_metadata <- if (is.null(names(prototypes))) rep(FALSE, length(prototypes))
                      else startsWith(names(prototypes), ".")
    metadata <- prototypes[which_metadata]
    prototypes <- prototypes[!which_metadata]
    if (length(prototypes) == 0) stop("provide at least one prototype")

    matches <- integer(0)  # list(...)[[NA_integer_]] is NULL
    for (i in seq_along(prototypes)) {
        if (!inherits(prototypes[[i]], "realtest_descriptor"))
            prototypes[[i]] <- P(value=prototypes[[i]])

        vcmp <- prototypes[[i]][["value_comparer"]]
        if (is.null(vcmp)) vcmp <- value_comparer

        scmp <- prototypes[[i]][["sides_comparer"]]
        if (is.null(scmp)) scmp <- sides_comparer

        cmp_value <- vcmp(prototypes[[i]][["value"]], object[["value"]])
        cmp_sides <- scmp(prototypes[[i]][["sides"]], object[["sides"]])

        prototypes[[i]][["differences"]] <- c(

            if (isTRUE(cmp_value)) NULL   # setting NULL does not set anything
            else if (isFALSE(cmp_value)) "objects are different"
            else cmp_value,

            if (isTRUE(cmp_sides)) NULL   # setting NULL does not set anything
            else if (isFALSE(cmp_sides)) "side effects are different"
            else cmp_sides

        )

        if (is.null(prototypes[[i]][["differences"]]))
            matches <- c(matches, i)
    }

    names(matches) <- names(prototypes)[matches]  # works if is.null(names) too

    ret <- structure(
        c(
            list(
                object=object,
                prototypes=prototypes,
                matches=matches
            ),
            metadata
        ),
        class=c("realtest_result", "realtest")
    )

    postprocessor(ret)  # may, for example, call stopifnot if matches are empty
}
