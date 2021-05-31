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


# internal function - validates a realtest_descriptor
# stops on error
stopifnot_descriptor_valid <- function(d)
{
    stopifnot(inherits(d, "realtest_descriptor"))
    stopifnot(is.list(d), !is.null(names(d)))
    stopifnot("value" %in% names(d))  # required field
    stopifnot(is.null(d[["value_comparer"]]) || is.function(d[["value_comparer"]]))
    stopifnot(is.null(d[["sides_comparer"]]) || is.function(d[["sides_comparer"]]))
    stopifnot(is.null(d[["expr"]]) || is.language(d[["expr"]]) ||
        is.atomic(d[["expr"]]) && length(d[["expr"]]) == 1)

    NULL_TRUE_or_character <- function(v, single=FALSE) {
        is.null(v) ||
        isTRUE(v)  ||
        is.character(v) && length(v) >= 1 && (!single || length(v) == 1)
    }

    stopifnot(is.null(d[["sides"]]) || is.list(d[["sides"]]))
    stopifnot(NULL_TRUE_or_character(d[["sides"]][["error"]], single=TRUE))
    stopifnot(NULL_TRUE_or_character(d[["sides"]][["warning"]]))
    stopifnot(NULL_TRUE_or_character(d[["sides"]][["message"]]))
    stopifnot(NULL_TRUE_or_character(d[["sides"]][["stdout"]]))
    stopifnot(NULL_TRUE_or_character(d[["sides"]][["stderr"]]))

    if (!is.null(d[["sides"]][["error"]]) && !is.null(d[["value"]])) {
        # both cannot be non-NULL (if an error occurs, there is no retval)
        stop("there can either be an error or a value, not both at the same time")
    }

    invisible(TRUE)
}


# internal function - validates a realtest_result
# stops on error
stopifnot_result_valid <- function(r)
{
    stopifnot(inherits(r, "realtest_result"))
    stopifnot(is.list(r))
    stopifnot(c("object", "prototypes", "matches") %in% names(r))

    stopifnot_descriptor_valid(r[["object"]])
    for (p in r[["prototypes"]])
        stopifnot_descriptor_valid(p)

    m <- r[["matches"]]
    stopifnot(is.numeric(m))
    stopifnot(length(m) == 0 || (min(m) >= 1 && max(m) <= length(r[["prototypes"]])))

    stopifnot(!is.null(r[["object"]][["expr"]]))

    invisible(TRUE)
}
