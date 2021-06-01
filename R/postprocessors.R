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
#' Example Test Result Postprocessors
#'
#' @description
#' Test result postprocessors are used in \code{\link{E}}.
#' \code{failstop} calls \code{\link[utils]{str}(r)}
#' and throws an error if an expectation is not met, i.e.,
#' when \code{r[["matches"]]} is of length 0.
#'
#' @details
#' These are example postprocessors. You are encouraged to write your
#' own ones that will suit your own needs. Explore their source code
#' for some inspirations. It's an open source (and free!) project after all.
#'
#' For \code{failstop}, you can always create a function
#' \code{str.realtest_result} implementing the pretty printing of an error
#' message.
#'
#' @param r object of class \code{realtest_result}, see \code{\link{E}}
#'
#' @return
#' Returns \code{r}, invisibly.
#'
#' @importFrom utils str
#' @rdname postprocessors
#' @export
failstop <- function(r)
{
    stopifnot_result_valid(r)  # internal function

    if (length(r[["matches"]]) >= 1)
        return(invisible(r))

    str(r)  # you can define str.realtest_result
    stop("the object does not match the prototype(s)")
}
