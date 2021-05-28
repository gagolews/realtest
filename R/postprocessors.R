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
#' Fail on Unmet Expectations
#'
#' @description
#' Calls \code{\link[base]{str}(r)} and throws an error
#' if an expectation is not met, i.e., when \code{r[["matching_prototypes"]]}
#' is of length 0.
#'
#' @details
#' Can be used as a result postprocessor in \code{\link{E}}.
#'
#' The user can create a function \code{str.realtest_result}
#' implementing the pretty printing of an error message.
#'
#' @param r object of class \code{realtest_result}, see \code{\link{E}}
#'
#' @return
#' Returns \code{r}, invisibly.
#'
#' @rdname postprocessors
#' @export
stop_if_results_different <- function(r)
{
    realtest:::stopifnot_result_valid(r)

    if (length(r[["matching_prototypes"]]) >= 1)
        return(invisible(r))

    str(r)  # you can define str.realtest_result
    stop("the object does not match the prototype(s)")
}
