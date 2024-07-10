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
#' Manually Create a Test Descriptor Prototype
#'
#' @description
#' Allows for formulating expectations like 'the desired outcome is
#' \code{c(1, 2, 3)}, with a warning' or 'an error should occur'.
#'
#' @details
#' If \code{error}, \code{warning}, \code{message}, \code{stdout}, or
#' \code{stderr} are \code{NULL}, then no side effects of particular
#' kinds are included in the output.
#'
#' The semantics is solely defined by the \code{sides_comparer}.
#' \code{\link{E}} by default uses \code{\link{sides_similar}}
#' (see its description therein), although you are free to override
#' it manually or via a global option.
#'
#'
#'
#' @param value object (may of course be equipped with attributes)
#' @param error,warning,message \link{conditions} expected to occur,
#'    see \code{\link[base]{stop}}, \code{\link[base]{warning}}, and
#'    \code{\link[base]{message}}
#' @param stdout,stderr character data expected on
#'    \code{\link[base]{stdout}}
#'    and \code{\link[base]{stderr}}, respectively
#' @param value_comparer,sides_comparer optional two-argument functions
#'    which may be used to override the default comparers
#'    used by \code{\link{E}}
#'
#' @return
#' A list of class \code{realtest_descriptor}
#' with named components:
#' \itemize{
#' \item \code{value},
#' \item \code{sides} (optional) -- a list with named elements
#'     \code{error}, \code{warnings},
#'     \code{messages}, \code{stdout}, and \code{stderr};
#'     those which are missing are assumed to be equal to \code{NULL},
#' \item \code{value_comparer} (optional) -- a function object,
#' \item \code{sides_comparer} (optional) -- a function object.
#' }
#' Other functions are free to add more named components, and do with them
#' whatever they please.
#'
#'
#' @seealso Related functions:
#' \code{\link{E}}, \code{\link{R}}
#'
#' @examples
#' # the desired outcome is c(1L, 2L, 3L):
#' P(1:3)
#' # expecting c(1L, 2L, 3L), with a warning:
#' P(1:3, warning=TRUE)
#' # note, however, that it is the sides_comparer that defines the semantics
#'
#' @export
#' @rdname P
P <- function(
    value=NULL,
    error=NULL, warning=NULL, message=NULL,
    stdout=NULL, stderr=NULL,
    value_comparer=NULL, sides_comparer=NULL
) {
    ret <- structure(
        list(
            value=value  # always included
        ),
        class=c("realtest_descriptor", "realtest")
    )


    sides <- NULL
    sides[["error"]]   <- error
    sides[["warning"]] <- warning
    sides[["message"]] <- message
    sides[["stdout"]]  <- stdout
    sides[["stderr"]]  <- stderr

    # if NULL, they won't be added at all:
    ret[["sides"]] <- sides
    ret[["value_comparer"]] <- value_comparer
    ret[["sides_comparer"]] <- sides_comparer

    stopifnot_descriptor_valid(ret)  # internal function

    ret
}
