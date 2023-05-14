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
#' Create a Result Descriptor by Recording Effects of an Expression Evaluation
#'
#' @description
#' Evaluates an expression and records its direct and indirect effects:
#' the resulting value as well as the information whether any errors,
#' warnings, or messages are generated and if anything is printed on
#' \code{\link[base]{stdout}} or \code{\link[base]{stderr}}.
#'
#' @details
#' Note that messages, warnings, and errors are typically written to
#' \code{\link[base]{stderr}}, but these are considered separately here.
#' In other words, when testing expectations with \code{\link{E}},
#' e.g., the reference \code{stderr} should not include the anticipated
#' diagnostic messages.
#'
#' There may be other side effects, such as changing the state of
#' the random number generator, modifying options or environment variables,
#' modifying the calling or global environment (e.g., creating new global
#' variables), attaching objects onto the search part (e.g., loading
#' package namespaces), or plotting, but these will not be captured,
#' at least, not by the current version of the \pkg{realtest} package.
#'
#' @param expr expression to be evaluated
#'
#' @param ... further arguments to be passed to \code{\link{P}}
#'
#' @param envir environment where \code{expr} is to be evaluated
#'
#'
#' @return
#' A list of class \code{realtest_descriptor},
#' see \code{\link{P}}, which this function calls.
#' The additional named component \code{expr} gives the
#' expression that generated the \code{value}.
#' Moreover, \code{args} gives a named list of objects
#' that appeared in \code{expr} (not including functions called).
#'
#' If an effect of particular kind does not occur,
#' it is not included in the resulting list.
#' \code{stdout}, \code{stderr}, and \code{error} are at most single strings.
#'
#' When an error occurs, \code{value} is \code{NULL}.
#'
#'
#' @seealso Related functions:
#' \code{\link{E}}, \code{\link{P}}
#'
#' @examples
#' y <- 1:10; R(sum(y^2))
#' R(cat("a bit talkative, innit?"))
#' R(sqrt(c(-1, 0, 1, 2, 4)))
#' R(log("aaaargh"))
#' R({
#'     cat("STDOUT"); cat("STDERR", file=stderr()); message("MESSAGE");
#'     warning("WARNING"); warning("WARNING AGAIN"); cat("MORE STDOUT");
#'     message("ANOTHER MESSAGE"); stop("ERROR"); y; "NO RETURN VALUE"
#' })
#'
#' @importFrom utils capture.output
#' @export
#' @rdname R
R <- function(expr, ..., envir=parent.frame())
{
    this_call <- match.call()

    .warning <- NULL
    .message <- NULL
    .error <- NULL
    .stderr <- capture.output(type="message",
        .stdout <- capture.output(type="output",
            .value <- tryCatch(
                withCallingHandlers(
                    eval(this_call[["expr"]], envir=envir), # force eval
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
                }
            )
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


    get_vars <- function(e) {
        # all.vars(e) would also return `stringx` and `test` in:
        # e <- expression(f(2+3, stringx::test, 3*5+f(2, y^2)-z))[[1]]

        all_names <- character(0)
        .get_vars_rec <- function(e) {
            if (is.call(e)) {
                e <- as.list(e)
                if (e[[1]] != "::")
                    for (ei in e[-1]) .get_vars_rec(ei)
            }
            else if (is.symbol(e)) {
                all_names[length(all_names) + 1] <<- as.character(e)
            }
        }
        .get_vars_rec(e)
        unique(all_names)
    }

    args <- get_vars(ret[["expr"]])
    ret[["args"]] <- if (length(args) == 0) NULL else mget(args, envir=envir, inherits=TRUE)

    ret
}
