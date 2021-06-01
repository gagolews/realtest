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
#' Manually Create a Test Descriptor Prototype
#'
#' @description
#' Allows for formulating expectations like 'the desired outcome is
#' \code{c(1, 2, 3)}, with a warning' or 'an error should occur'.
#'
#' @details
#' \code{error}, \code{warning}, \code{message}, \code{stdout}, and
#' \code{stderr} may be one of:
#' \itemize{
#'     \item \code{NULL} or \code{FALSE} -- no side effect of a particular
#'        kind is expected;
#'     \item \code{TRUE} -- an effect is expected to occur
#'        (but details are irrelevant, e.g., a function throws a warning);
#'     \item character vector -- a specific message/output is desired.
#' }
#' Note that only one error can occur per a function call, hence
#' \code{error} can only be a single string (or \code{NULL} or \code{TRUE}).
#' When an error is expected, the \code{value} must be \code{NULL}.
#'
#' Typically, messages, warnings, and errors are written to
#' \code{\link[base]{stderr}},
#' but these are considered separately here. In other words, the
#' expected \code{stderr} should not include the anticipated diagnostic
#' messages.
#'
#'
#' @param value object (may be equipped with attributes)
#' @param error,warning,message \link{conditions} expected to occur,
#'    see \code{\link[base]{stop}}, \code{\link[base]{warning}}, and
#'    \code{\link[base]{message}}
#' @param stdout,stderr character data expected on
#'    \code{\link[base]{stdout}}
#'    and \code{\link[base]{stderr}}, respectively
#' @param value_comparer,sides_comparer optional two-argument functions
#'    which may be used to override the default comparers used by \code{\link{E}}
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
#' \item \code{sides_comparer} (optional) -- a function object,
#' }
#'
#' @seealso
#' \code{\link{E}}, \code{\link{R}}
#'
#' @examples
#' P(1:3)  # the desired outcome is c(1L, 2L, 3L)
#' P(error=TRUE)  # expecting an error
#' P(1:3, warning=TRUE)  # expecting c(1L, 2L, 3L), with a warning
#'
#' @export
#' @rdname P
P <- function(
    value=NULL,
    error=NULL, warning=NULL, message=NULL, stdout=NULL, stderr=NULL,
    value_comparer=NULL, sides_comparer=NULL
) {
    sides <- NULL
    if (!is.null(error)   && !isFALSE(error))   sides[["error"]]   <- error
    if (!is.null(warning) && !isFALSE(warning)) sides[["warning"]] <- warning
    if (!is.null(message) && !isFALSE(message)) sides[["message"]] <- message
    if (!is.null(stdout)  && !isFALSE(stdout))  sides[["stdout"]]  <- stdout
    if (!is.null(stderr)  && !isFALSE(stderr))  sides[["stderr"]]  <- stderr

    ret <- structure(
        list(
            value=value
        ),
        class=c("realtest_descriptor", "realtest")
    )

    # if NULL, they won't be added at all:
    ret[["sides"]] <- sides
    ret[["value_comparer"]] <- value_comparer
    ret[["sides_comparer"]] <- sides_comparer

    stopifnot_descriptor_valid(ret)  # internal function

    ret
}
