# test\_dir: Gather All Test Results From R Scripts

## Description

Executes all R scripts in a given directory whose names match a given pattern and gathers all test result in a single list, which you can process however you desire.

The function does not fail if some tests are not met -- you need to detect this yourself.

## Usage

```r
test_dir(
  path = "tests",
  pattern = "^realtest-.*\\.R",
  recursive = FALSE,
  ignore.case = FALSE
)
```

## Arguments

|               |                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------|
| `path`        | directory with scripts to execute                                                                      |
| `pattern`     | regular expression specifying the file names to execute                                                |
| `recursive`   | logical, see [`list.files`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/list.files.html) |
| `ignore.case` | logical, see [`list.files`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/list.files.html) |

## Value

Returns a list of all test results (of class `realtest_results`), each being an object of class `realtest_result`, see [`E`](https://realtest.gagolewski.com/rapi/E.html), with additional fields `.file`, `.line`, and `.expr`, giving the location and the source code of the test instance.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

[`source2`](https://realtest.gagolewski.com/rapi/source2.html), [`summary.realtest_results`](https://realtest.gagolewski.com/rapi/summary.realtest_results.html)

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