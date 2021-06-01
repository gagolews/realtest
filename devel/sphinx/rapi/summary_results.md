# summary\_results: Summarise and Display Test Results

## Description

An example (write your own which will better suit your needs) way to summarise the results returned by `test_dir`.

## Usage

```r
## S3 method for class 'realtest_results_summary'
print(x, label_fail = "fail", ...)

## S3 method for class 'realtest_results'
summary(object, label_pass = "pass", label_fail = "fail", ...)
```

## Arguments

|              |                                                                                                     |
|--------------|-----------------------------------------------------------------------------------------------------|
| `x`          | object returned by `summary.realtest_results`                                                       |
| `label_fail` | single string labelling failed test cases                                                           |
| `...`        | currently ignored                                                                                   |
| `object`     | list of objects of class `realtest_result`, see [`E`](https://realtest.gagolewski.com/rapi/E.html). |
| `label_pass` | single string denoting the default name for unnamed prototypes                                      |

## Value

`print.realtest_results_summary` returns `x`, invisibly.

`summary.realtest_results` return an object of class `realtest_results_summary` which is a data frame summarising the test results, featuring the following columns:

-   `call` -- name of the function tested,

-   `match` -- the name of the first matching prototype, `label_pass` if it is unnamed or `label_fail` if there is no match,

-   `.file` (optional) -- name of the source file which defined the expectation,

-   `.line` (optional) -- line number,

-   `.expr` (optional) -- source code of the whole tested expression.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

[`test_dir`](https://realtest.gagolewski.com/rapi/test_dir.html)

## Examples




```r
r <- test_dir("~/R/realtest/tests")
s <- summary(r)  # summary.realtest_results
print(s)  # print.realtest_results_summary
## *** realtest: test summary:
##                                                   
##                                                    current good pass fail
##   /home/gagolews/R/realtest/tests/realtest-basic.R       0    0    8    0
##   /home/gagolews/R/realtest/tests/realtest-named.R       1    1    6    0
## 
## *** realtest: all tests succeeded
stopifnot(sum(s[["match"]]=="fail") == 0)  # halt if there are failed tests
```