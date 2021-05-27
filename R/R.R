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
#' Create a Test Descriptor by Recording Effects of a Call
#'
#' @description
#' Evaluates an expression and records its result as well as
#' whether it generates any errors, warnings, or messages
#' if it prints anything on
#' \code{\link[base]{stdout}} or \code{\link[base]{stderr}}.
#'
#' @details
#' There may be other side effects, like changing the state of
#' a random number generator or plotting, but these are not captured.
#'
#' @param expr a formal argument to be evaluated
#'
#'
#' @return
#' See \code{\link{P}}, which this function calls.
#'
#' @seealso
#' \code{\link{E}}, \code{\link{P}}
#'
#' @examples
#' R(sum(1:10))
#' R(cat("a bit talkative, innit?"))
#' R(sqrt(c(-1, 0, 1, 2, 4)))
#' R(log("aaaargh"))
#'
#' @export
#' @rdname R
R <- function(expr)
{
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

    P(value=.value, error=.error, warning=.warning, message=.message,
        stdout=.stdout, stderr=.stderr)
}
