# source2: Read and Evaluate Code from an R Script

## Description

A simplified alternative to [`source`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/source.html), which additionally sets some environment variables whilst executing a series of expressions to ease debugging.

## Usage

``` r
source2(file, local = FALSE)
```

## Arguments

|         |                                                                                                                                                    |
|---------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| `file`  | usually a file name, see [`parse`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/parse.html)                                             |
| `local` | specifies the environment where expressions will be evaluated, see [`source`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/source.html) |

## Details

The function sets/updates the following environment variables while evaluating consecutive expressions:

-   `__FILE__` -- path to the current file,

-   `__LINE__` -- line number where the currently executed expression begins,

-   `__EXPR__` -- source code defining the expression.

## Value

This function returns nothing.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

## Examples




```r
# example error handler - report source file and line number
old_option_error <- getOption("error")
options(error=function()
   cat(sprintf(
       "Error in %s:%s.\n", Sys.getenv("__FILE__"), Sys.getenv("__LINE__")
   ), file=stderr()))
# now call source2() to execute an R script that throws some errors...
options(error=old_option_error)  # cleanup
```
