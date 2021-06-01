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
#' Example Object and Side Effect Comparers
#'
#' @description
#' Two-argument functions to compare direct or indirect effects
#' of two test descriptors (see \code{\link{P}} and \code{\link{R}}).
#' These can be passed as \code{value_comparer} and \code{sides_comparer}
#' to \code{\link{E}}.
#'
#'
#' @details
#' Notable built-in (base R) comparers include \code{\link[base]{identical}}
#' (the strictest possible)
#' and \code{\link[base]{all.equal}} (can ignore, amongst others,
#' round-off errors).
#'
#' \code{ignore_differences} is a dummy comparer that always returns
#' \code{TRUE}. Hence, it does not discriminate between anything.
#'
#' \code{identical_or_TRUE} is useful when comparing particular side effects,
#' where is assumed that a value \code{TRUE} represents the occurrence
#' of a condition, but without going into any details
#' (e.g., some warning).
#'
#' \code{maps_identical_or_TRUE} propagates \code{identical_or_TRUE}
#' on each element of a given named list (treated as an unordered set
#' of key-value pairs) and aggregates the results.
#'
#' You can define any comparer of your own liking:
#' the possibilities are endless. For example:
#' \itemize{
#' \item a comparer for side effects based on regular expressions,
#' \item a comparer that tests whether all elements in a vector are
#'     equal to \code{TRUE},
#' \item a comparer that verifies whether each element falls into
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
#' summary of the differences is returned, as in \code{\link[base]{all.equal}}.
#'
#' @rdname comparers
#' @export
ignore_differences <- function(x, y)
{
    TRUE  # x and y are always equal
}


#' @rdname comparers
#' @export
identical_or_TRUE <- function(x, y)
{
    cmp <- identical(x, y)
    if (isTRUE(cmp)) TRUE
    else if (isTRUE(x) && !is.null(y)) TRUE
    else if (isTRUE(y) && !is.null(x)) TRUE
    else cmp
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
maps_identical_or_TRUE <- function(x, y)
{
    maps_comparer(
        x, y,
        comparer=identical_or_TRUE
    )
}
