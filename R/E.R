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




#' @title
#' Test if Expectations are Met
#'
#' @description
#' ...
#'
#' @details
#' ...
#'
#' \code{value_comparer} and \code{sides_comparer} are 2-ary functions
#' that return TRUE if two objects are equivalent
#' and FALSE or a character string summarising the differences otherwise.
#'
#'
#' @param expr an expression to be recorded (via \code{\link{R}}) and
#'     and compared with the prototypes
#' @param ... a sequence of 1 or more prototypes constructed
#'     via \code{\link{R}} or \code{\link{P}}; objects which are not
#'     of class \code{realtest_descriptor} will be passed to \code{\link{P}}
#' @param context,description optional objects to be included in the
#'     \code{context} and \code{description} fields in the return value
#' @param value_comparer a two-argument function used to compare the
#'     values with each other, e.g., \code{\link[base]{identical}}
#'     or \code{\link[base]{all.equal}}
#' @param sides_comparer a two-argument used to compare
#'     the side effects with each other,
#'     e.g., \code{\link{maps_identical_or_TRUE}}
#' @param side names of side effects to consider
#' @param postprocessor a function to call on the generated
#'     \code{realtest_result}
#'
#' @return
#' The function creates an object of class \code{realtest_result},
#' which is a named list with the following components:
#' \itemize{
#' \item \code{object} - an object of class \code{realtest_descriptor},
#'     ultimately \code{\link{R}(expr)}
#' \item \code{prototypes} - a list of objects of class \code{realtest_descriptor}
#'     a list of descriptors passed via \code{...}
#' \item \code{matching_prototypes} - an integer vector of the indexes
#'     of prototypes matching the object (can be empty)
#' \item \code{context} - copied as-is from the argument of the same name
#' \item \code{description} - copied as-is from the argument of the same name
#' }
#' Such an object is passed to \code{postprocessor} which becomes
#' responsible for generating the return value.
#'
#' @examples
#' E(sqrt(4), 2.0)
#' E(sin(pi), 0.0, value_comparer=all.equal)  # almost-equal
#' E(sqrt(-1), P(NaN, warning=TRUE))  # a warning is expected
#' E(sample(c("head", "tail"), 1), "head", "tail")  # two prototypes
#'
#' @export
#' @rdname E
E <- function(
    expr,
    ...,
    context=getOption("realtest_context", NULL),
    description=getOption("realtest_description", NULL),
    value_comparer=getOption("realtest_value_comparer", identical),
    sides_comparer=getOption("realtest_sides_comparer", maps_identical_or_TRUE),
    sides=getOption("realtest_sides", c("error", "warning", "message", "stdout", "stderr")),
    postprocessor=getOption("realtest_postprocessor", stop_if_results_different)
) {
    this_call <- match.call()

    stopifnot(is.function(value_comparer))
    stopifnot(is.function(sides_comparer))
    stopifnot(is.function(postprocessor))

    # if (!inherits(expr, "realtest_descriptor"))  # we don't want to force eval here!
    object <- R(expr)  # will force eval inside
    object[["expr"]] <- this_call[["expr"]]

    prototypes <- list(...)
    stopifnot(length(prototypes) >= 1)

    matching_prototypes <- integer(0)  # list(...)[[NA_integer_]] is NULL
    for (i in seq_along(prototypes)) {
        if (!inherits(prototypes[[i]], "realtest_descriptor"))
            prototypes[[i]] <- P(value=prototypes[[i]])

        cmp_value <- value_comparer(object[["value"]], prototypes[[i]][["value"]])
        cmp_sides <- sides_comparer(
            unclass(object[names(object) %in% sides]),
            unclass(prototypes[[i]][names(prototypes[[i]]) %in% sides])
        )

        prototypes[[i]][["differences"]] <- c(
            if (isTRUE(cmp_value)) NULL
            else if (isFALSE(cmp_value)) "objects are different"
            else cmp_value,
            if (isTRUE(cmp_sides)) NULL
            else if (isFALSE(cmp_sides)) "side effects are different"
            else cmp_sides
        )  # setting NULL does not set
        if (is.null(prototypes[[i]][["differences"]]))
            matching_prototypes <- c(matching_prototypes, i)
    }

    ret <- structure(
        list(
            object=object,
            prototypes=prototypes,
            matching_prototypes=matching_prototypes
        ),
        class=c("realtest_result", "realtest")
    )
    ret[["context"]]             <- context      # can be NULL
    ret[["description"]]         <- description  # can be NULL

    postprocessor(ret)
}
