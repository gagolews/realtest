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
| `value`                          | object (may of course be equipped with attributes)                                                                                                                                                                                                                                                                                                                 |
| `error, warning, message`        | [conditions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/conditions.html) expected to occur, see [`stop`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stop.html), [`warning`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/warning.html), and [`message`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/message.html) |
| `stdout, stderr`                 | character data expected on [`stdout`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stdout.html) and [`stderr`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stderr.html), respectively                                                                                                                                                       |
| `value_comparer, sides_comparer` | optional two-argument functions which may be used to override the default comparers used by [`E`](E.md)                                                                                                                                                                                                                                                            |

## Details

If `error`, `warning`, `message`, `stdout`, or `stderr` is `NULL`, then no side effect of a particular kind is included in the output.

The semantics is solely defined by the `sides_comparer`. [`E`](E.md) by default uses [`sides_similar`](comparers.md) (see its description therein), although you are free to override it manually or via a global option.

## Value

A list of class `realtest_descriptor` with named components:

-   `value`,

-   `sides` (optional) -- a list with named elements `error`, `warnings`, `messages`, `stdout`, and `stderr`; those which are missing are assumed to be equal to `NULL`,

-   `value_comparer` (optional) -- a function object,

-   `sides_comparer` (optional) -- a function object.

Other functions are free to add more named components, and do with them whatever they please.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

Related functions: [`E`](E.md), [`R`](R.md)

## Examples




```r
# the desired outcome is c(1L, 2L, 3L):
P(1:3)
## $value
## [1] 1 2 3
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
# expecting c(1L, 2L, 3L), with a warning:
P(1:3, warning=TRUE)
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
# note, however, that it is the sides_comparer that defines the semantics
```
