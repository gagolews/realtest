# kate: default-dictionary en_AU

## realtest package for R
## Copyleft (C) 2021-2023, Marek Gagolewski <https://www.gagolewski.com>
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
#' Example Object and Side Effect Comparers
#'
#' @description
#' Example two-argument functions to compare direct or indirect effects
#' of two test descriptors (see \code{\link{P}} and \code{\link{R}}).
#' These can be passed as \code{value_comparer} and \code{sides_comparer}
#' to \code{\link{E}}.
#'
#' @details
#' Notable built-in (base R) comparers include \code{\link[base]{identical}}
#' (the strictest possible)
#' and \code{\link[base]{all.equal}} (can ignore, amongst others,
#' round-off errors; note that it is an S3 generic).
#'
#' \code{ignore_differences} is a dummy comparer that always returns
#' \code{TRUE}. Hence, it does not discriminate between anything.
#'
#' \code{sides_similar} is useful when comparing side effect lists.
#' It defines the following semantics for the prototypical values:
#' \itemize{
#' \item non-existent, \code{NULL}, or \code{FALSE} -- a side effect must
#'     not occur,
#' \item \code{NA} -- ignore whatsoever,
#' \item \code{TRUE} -- a side effect occurs, but the details are irrelevant
#'    (e.g., 'some warning' as opposed to \code{"NaNs produced"})
#' \item otherwise -- a character vector with message(s) matched exactly.
#' }
#'
#' You can define any comparers of your own liking:
#' the possibilities are endless. For example:
#' \itemize{
#' \item a comparer for side effects based on regular expressions
#'     or wildcards (e.g., \code{".not converged.*"}),
#' \item a comparer that tests whether all elements in a vector are
#'     equal to \code{TRUE},
#' \item a comparer that verifies whether each element in a vector falls into
#'     a specified interval,
#' \item a comparer that ignores all the object attributes (possibly
#'     in combination with other comparers),
#' }
#' and so forth.
#'
#'
#' @param x prototype or part thereof
#' @param y object under scrutiny or part thereof
#'
#' @return
#' Each comparer should yield \code{TRUE} if the test condition
#' is considered met or anything else otherwise.
#' However, it is highly recommended that in the latter case,
#' a single string with a short
#' summary of the differences be returned, as in \code{\link[base]{all.equal}}.
#'
#' @rdname comparers
#' @export
ignore_differences <- function(x, y)
{
    TRUE  # x and y are always equal
}


# internal
maps_comparer <- function(x, y, comparer)
{
    # compares two named lists as sets of key-value pairs (order does not matter)
    # treats NULLs as empty lists
    # does not distinguish between NULL fields and missing fields

    if (is.null(x)) x <- structure(list(), names=character(0))  # empty named list
    if (is.null(y)) y <- structure(list(), names=character(0))
    stopifnot(is.list(x), !is.null(names(x)))  # is named list
    stopifnot(is.list(y), !is.null(names(y)))

    all_names <- unique(c(names(x), names(y)))  # union
    differences <- character(0)
    for (n in all_names) {
        # is.null(x[[n]]) also might mean that it's nonexistent
        cmp <- comparer(x[[n]], y[[n]])
        if (!isTRUE(cmp))
            differences <- c(differences,
                sprintf(
                    "key `%s`: %s",
                    n,
                    if (isFALSE(cmp)) "values are different" else cmp
            ))
    }

    if (length(differences) == 0) TRUE
    else differences
}


#' @rdname comparers
#' @export
sides_similar <- function(x, y)
{
    NULL_logical_or_character <- function(v, single_string=FALSE) {
        is.null(v) ||
        is.logical(v) && length(v) == 1L ||
        is.character(v) && length(v) >= 1L && all(!is.na(v)) && (!single_string || length(v) == 1L)
    }

    stopifnot_sides_valid <- function(d) {
        stopifnot(NULL_logical_or_character(d[["sides"]][["error"]], single_string=TRUE))
        stopifnot(NULL_logical_or_character(d[["sides"]][["stdout"]], single_string=TRUE))
        stopifnot(NULL_logical_or_character(d[["sides"]][["stderr"]], single_string=TRUE))
        stopifnot(NULL_logical_or_character(d[["sides"]][["warning"]]))
        stopifnot(NULL_logical_or_character(d[["sides"]][["message"]]))
        # both cannot be non-NULL (if an error occurs, there is no retval)
        if (!is.null(d[["sides"]][["error"]]) && !is.null(d[["value"]]))
            stop("there can either be an error or a value, but not both at the same time")
        invisible(TRUE)
    }

    stopifnot_sides_valid(x)
    stopifnot_sides_valid(y)

    isNA <- function(x) is.logical(x) && length(x) == 1L && is.na(x)

    side_comparer <- function(x, y) {
        if (isFALSE(x)) x <- NULL
        if (isFALSE(y)) y <- NULL
        cmp <- identical(x, y)
        if (isTRUE(cmp)) TRUE
        else if (isNA(x) || isNA(y)) TRUE  # ignore differences
        else if (isTRUE(x) && !is.null(y)) TRUE
        else if (isTRUE(y) && !is.null(x)) TRUE
        else cmp
    }

    maps_comparer(x, y, comparer=side_comparer)
}
