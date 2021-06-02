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
#' Create a Result Descriptor by Recording Effects of an Expression Evaluation
#'
#'
#' @description
#' Evaluates an expression and records its direct and indirect effects:
#' the resulting value as well as the information whether any errors,
#' warnings, or messages are generated and if anything on
#' \code{\link[base]{stdout}} or \code{\link[base]{stderr}} is printed.
#'
#'
#' @details
#' There may be other side effects, such as changing the state of
#' the random number generator, modifying options or environment variables,
#' modifying the calling or global environment (e.g., creating new global
#' variables), attaching objects onto the search part (e.g., loading
#' package namespaces), or plotting, but these are not captured,
#' at least, not in the current version of the package.
#'
#' @param expr a formal argument to be evaluated
#' @param ... further arguments to be passed to \code{\link{P}}
#'
#'
#' @return
#' A list of class \code{realtest_descriptor},
#' see \code{\link{P}}, which this function calls.
#' The additional named component \code{expr} gives the
#' expression used to generate the \code{value}.
#'
#' @seealso Related functions:
#' \code{\link{E}}, \code{\link{P}}
#'
#' @examples
#' R(sum(1:10))
#' R(cat("a bit talkative, innit?"))
#' R(sqrt(c(-1, 0, 1, 2, 4)))
#' R(log("aaaargh"))
#'
#' @importFrom utils capture.output
#' @export
#' @rdname R
R <- function(expr, ...)
{
    this_call <- match.call()

    .warning <- NULL
    .message <- NULL
    .error <- NULL
    .stderr <- capture.output(type="message",
        .stdout <- capture.output(type="output",
            .value <- tryCatch(
                withCallingHandlers(
                expr,  # force eval
                warning = function(cond) {
                    if (inherits(cond, "warning")) {
                        .warning <<- c(.warning, trimws(cond$message))
                        tryInvokeRestart("muffleWarning")
                    }
                    invisible(NULL)
                },
                message = function(cond) {
                    if (inherits(cond, "message")) {
                        .message <<- c(.message, trimws(cond$message))
                        tryInvokeRestart("muffleMessage")
                    }
                    invisible(NULL)
                }
            ),
            error = function(cond) {
                if (inherits(cond, "error")) {
                    .error <<- cond$message
                }
                invisible(NULL)
            })
        )
    )

    if (length(.stdout) == 0) .stdout <- NULL
    if (length(.stderr) == 0) .stderr <- NULL

    ret <- P(
        value=.value,
        error=.error,
        warning=.warning,
        message=.message,
        stdout=.stdout,
        stderr=.stderr,
        ...
    )

    ret[["expr"]] <- this_call[["expr"]]

    ret
}
