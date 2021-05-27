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


#' @export
side_effects_identical <- function(x, y, element_comparer=identical)
{
    # error, warning, message, stderr, stdout -- all except the "value" field
    compare_maps(
        x, y,
        element_comparer=element_comparer
    )
}


#' @export
side_effects_ignored <- function(x, y)
{
    TRUE  # side effects in descriptor x are equal to that of y
}




# compares two named lists as sets of key-value pairs (order does not matter)
# treats NULLs as empty lists
# does not distinguish between NULL fields and missing fields
compare_maps <- function(x, y, element_comparer=identical)
{
    if (is.null(x)) x <- structure(list(), names=character(0))  # empty named list
    if (is.null(y)) y <- structure(list(), names=character(0))
    stopifnot(is.list(x), !is.null(names(x)))  # is named list
    stopifnot(is.list(y), !is.null(names(y)))

    all_names <- unique(c(names(x), names(y)))  # union
    for (n in all_names) {
        # is.null(x[[n]]) also might mean that it's nonexistent
        if (!isTRUE(element_comparer(x[[n]], y[[n]])))
            return(FALSE)
    }

    TRUE
}

identical(1, 1L)
identical(1, c(a=1))
all.equal(1, c(a=1))
all.equal(1, 1L)
all.equal(1, structure(1, attrib="present"))
all.equal(sin(pi), 0)

unattr <- function(x) { attributes(x) <- NULL; x }

all.equal(structure(1, attrib1="one", attrib2="two"), structure(1, attrib2="two", attrib1="one"))
identical(structure(1, attrib1="one", attrib2="two"), structure(1, attrib2="two", attrib1="one"))


#' @title
#' ...
#'
#' @description
#' ...
#'
#' @details
#' ...
#'
#' @param ...
#'
#'
#' @return
#' ...
#'
#' @examples
#' # ...
#'
#' @export
#' @rdname E
E <- function(
    expr,
    ...,
    context=NULL,
    description=NULL,
    value_comparer=identical,
    side_effects_comparer=side_effects_identical
) {
    this_call <- match.call()

    if (is.null(context)) {
        # name or expression, e.g., pkg::fun or anonymous function
        context <- deparse(this_call[["expr"]][[1]])
    }
    stopifnot(is.character(context), length(context) == 1, !is.na(context))

    if (isFALSE(side_effects_comparer) || is.null(side_effects_comparer))
        side_effects_comparer <- side_effects_ignored
    else if (isTRUE(side_effects_comparer))
        side_effects_comparer <- side_effects_identical
    stopifnot(is.function(side_effects_comparer))


    object <- R(expr)  # will force eval inside
    prototypes <- list(...)

    matching_prototype <- NA_integer_  # list(...)[[NA_integer_]] is NULL
    for (i in seq_along(prototypes)) {
        if (!inherits(prototypes[[i]], "realtest_descriptor"))
            prototypes[[i]] <- P(value=prototypes[[i]])
        if (isTRUE(value_comparer(object[["value"]], prototypes[[i]][["value"]]))) {
            if (side_effects_comparer(
                unclass(object[names(object) != "value"]),
                unclass(prototypes[[i]][names(prototypes[[i]]) != "value"])
            )) {
                matching_prototype <- i
                break
            }
        }
    }

    ret <- list()
    ret[["expr"]] <- this_call[["expr"]]
    if (!is.null(context))     ret[["context"]]     <- context
    if (!is.null(description)) ret[["description"]] <- description
    ret[["object"]] <- object
    ret[["matching_prototype"]] <- prototypes[[matching_prototype]]
    ret
}


# print(E(7))
# print(E(sum(1:10, 7, pi)))  # val
# print(E(1:10 * 2))  # val
# print(E(head(ToothGrowth)))  # val with attribs
# print(E(stringx::printf(":)")))  # stdout
# print(E(stringx::sprintf("%d%d", 1:2, 1:3)))  # warning
# print(E(base::sprintf("%d%d", 1:2, 1:3)))  # error
# print(E(stringx::sprintf("%d%d%d", 1:2, 1:3)))  # warning+error
