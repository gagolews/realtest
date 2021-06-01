# postprocessors: Example Test Result Postprocessors

## Description

Test result postprocessors are used in [`E`](https://realtest.gagolewski.com/rapi/E.html). `failstop` calls `str(r)` and throws an error if an expectation is not met, i.e., when `r[["matches"]]` is of length 0.

## Usage

```r
failstop(r)
```

## Arguments

|     |                                                                                           |
|-----|-------------------------------------------------------------------------------------------|
| `r` | object of class `realtest_result`, see [`E`](https://realtest.gagolewski.com/rapi/E.html) |

## Details

These are example postprocessors. You are encouraged to write your own ones that will suit your own needs. Explore their source code for some inspirations. It\'s an open source (and free!) project after all.

For `failstop`, you can always create a function `str.realtest_result` implementing the pretty printing of an error message.

## Value

Returns `r`, invisibly.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>
