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
#' Object and Side Effects Comparers
#'
#' @description
#' return TRUE or FALSE or error message....
#' \code{\link[base]{identical}}
#' \code{\link[base]{all.equal}}
#' \code{identical_or_TRUE}....
#' \code{maps_identical_or_TRUE}...
#' \code{maps_comparer} compares two named lists as sets of key-value pairs (order does not matter)
#' treats NULLs as empty lists
#' does not distinguish between NULL fields and missing fields
#'
#' @rdname comparers
#' @export
ignore_differences <- function(x, y)
{
    TRUE  # side effects in descriptor x are equal to that of y
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



#' @rdname comparers
#' @export
maps_comparer <- function(x, y, element_comparer)
{
    if (is.null(x)) x <- structure(list(), names=character(0))  # empty named list
    if (is.null(y)) y <- structure(list(), names=character(0))
    stopifnot(is.list(x), !is.null(names(x)))  # is named list
    stopifnot(is.list(y), !is.null(names(y)))

    all_names <- unique(c(names(x), names(y)))  # union
    differences <- character(0)
    for (n in all_names) {
        # is.null(x[[n]]) also might mean that it's nonexistent
        cmp <- element_comparer(x[[n]], y[[n]])
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
        element_comparer=identical_or_TRUE
    )
}
