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
    stopifnot(is.list(d))
    stopifnot("value" %in% names(d))
    stopifnot(is.null(d[["error"]])    || isTRUE(d[["error"]])    || is.character(d[["error"]])    && length(d[["error"]])   == 1)
    stopifnot(is.null(d[["warning"]])  || isTRUE(d[["warning"]])  || is.character(d[["warning"]])  && length(d[["warning"]]) >= 1)
    stopifnot(is.null(d[["message"]])  || isTRUE(d[["message"]])  || is.character(d[["message"]])  && length(d[["message"]]) >= 1)
    stopifnot(is.null(d[["stdout"]])   || isTRUE(d[["stdout"]])   || is.character(d[["stdout"]])   && length(d[["stdout"]])  >= 1)
    stopifnot(is.null(d[["stderr"]])   || isTRUE(d[["stderr"]])   || is.character(d[["stderr"]])   && length(d[["stderr"]])  >= 1)

    if (!is.null(d$error) && !is.null(d$value)) {
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
    stopifnot(c("object", "prototypes", "matching_prototypes")  %in% names(r))

    stopifnot_descriptor_valid(r[["object"]])
    for (p in r[["prototypes"]])
        stopifnot_descriptor_valid(p)

    m <- r[["matching_prototypes"]]
    stopifnot(is.null(m) || is.numeric(m))
    stopifnot(length(m) == 0 || (min(m) >= 1 && max(m) <= length(r[["prototypes"]])))

    stopifnot(!is.null(r[["object"]][["expr"]]))

    invisible(TRUE)
}

