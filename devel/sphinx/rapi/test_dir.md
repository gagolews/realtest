# test_dir: Gather All Test Results From R Scripts

## Description

Executes all R scripts in a given directory whose names match a given pattern and gathers all test result in a single list, which you can process however you desire.

The function does not fail if some tests are not met -- you need to detect this yourself.

## Usage

``` r
test_dir(
  path = "tests",
  pattern = "^realtest-.*\\.R$",
  recursive = FALSE,
  ignore.case = FALSE
)
```

## Arguments

|               |                                                                                                      |
|---------------|------------------------------------------------------------------------------------------------------|
| `path`        | directory with scripts to execute                                                                    |
| `pattern`     | regular expression specifying the file names to execute                                              |
| `recursive`   | logical, see [`list.files`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/list.files.html) |
| `ignore.case` | logical, see [`list.files`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/list.files.html) |

## Value

Returns a list of all test results (of class `realtest_results`), each being an object of class `realtest_result`, see [`E`](E.md), with additional fields `.file`, `.line`, and `.expr`, giving the location and the source code of the test instance.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

Related functions: [`source2`](source2.md), [`summary.realtest_results`](summary.realtest_results.md)

## Examples




```r
## Not run: 
r <- test_dir("~/R/realtest/inst/realtest")
s <- summary(r)  # summary.realtest_results
print(s)  # print.realtest_results_summary
## *** realtest: test summary:
##                   
##                    good best pass fail
##   realtest-basic.R    0    0   12    0
##   realtest-named.R    1    1   12    0
## 
## *** realtest: all tests succeeded
stopifnot(!any(s[["match"]]=="fail"))  # halt if there are failed tests

## End(Not run)
```
