# P: Manually Create a Test Descriptor Prototype

## Description

Allows for formulating expectations like \'the desired outcome is `c(1, 2, 3)`, with a warning\' or \'an error should occur\'.

## Usage

```r
P(
  value = NULL,
  error = NULL,
  warning = NULL,
  message = NULL,
  stdout = NULL,
  stderr = NULL,
  value_comparer = NULL,
  sides_comparer = NULL
)
```

## Arguments

|                                  |                                                                                                                                                                                                                                                                                                                                                                    |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `value`                          | object (may be equipped with attributes)                                                                                                                                                                                                                                                                                                                           |
| `error, warning, message`        | [conditions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/conditions.html) expected to occur, see [`stop`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stop.html), [`warning`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/warning.html), and [`message`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/message.html) |
| `stdout, stderr`                 | character data expected on [`stdout`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stdout.html) and [`stderr`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stderr.html), respectively                                                                                                                                                       |
| `value_comparer, sides_comparer` | optional two-argument functions which may be used to override the default comparers used by [`E`](E.md)                                                                                                                                                                                                                                                            |

## Details

`error`, `warning`, `message`, `stdout`, and `stderr` may be one of:

-   `NULL` or `FALSE` -- no side effect of a particular kind is expected;

-   `TRUE` -- an effect is expected to occur (but details are irrelevant, e.g., a function throws a warning);

-   character vector -- a specific message/output is desired.

Note that only one error can occur per a function call, hence `error` can only be a single string (or `NULL` or `TRUE`). When an error is expected, the `value` must be `NULL`.

Typically, messages, warnings, and errors are written to [`stderr`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stderr.html), but these are considered separately here. In other words, the expected `stderr` should not include the anticipated diagnostic messages.

## Value

A list of class `realtest_descriptor` with named components:

-   `value`,

-   `sides` (optional) -- a list with named elements `error`, `warnings`, `messages`, `stdout`, and `stderr`; those which are missing are assumed to be equal to `NULL`,

-   `value_comparer` (optional) -- a function object,

-   `sides_comparer` (optional) -- a function object,

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

Related functions: [`E`](E.md), [`R`](R.md)

## Examples




```r
P(1:3)  # the desired outcome is c(1L, 2L, 3L)
## $value
## [1] 1 2 3
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
P(error=TRUE)  # expecting an error
## $value
## NULL
## 
## $sides
## $sides$error
## [1] TRUE
## 
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
P(1:3, warning=TRUE)  # expecting c(1L, 2L, 3L), with a warning
## $value
## [1] 1 2 3
## 
## $sides
## $sides$warning
## [1] TRUE
## 
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
```
