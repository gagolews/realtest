# R: Create a Result Descriptor by Recording Effects of an Expression Evaluation

## Description

Evaluates an expression and records its direct and indirect effects: the resulting value as well as the information whether any errors, warnings, or messages are generated and if anything on [`stdout`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stdout.html) or [`stderr`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/stderr.html) is printed.

## Usage

```r
R(expr, ...)
```

## Arguments

|        |                                               |
|--------|-----------------------------------------------|
| `expr` | a formal argument to be evaluated             |
| `...`  | further arguments to be passed to [`P`](P.md) |

## Details

There may be other side effects, such as changing the state of the random number generator, modifying options or environment variables, modifying the calling or global environment (e.g., creating new global variables), attaching objects onto the search part (e.g., loading package namespaces), or plotting, but these are not captured, at least, not in the current version of the package.

## Value

A list of class `realtest_descriptor`, see [`P`](P.md), which this function calls. The additional named component `expr` gives the expression used to generate the `value`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>

Related functions: [`E`](E.md), [`P`](P.md)

## Examples




```r
R(sum(1:10))
## $value
## [1] 55
## 
## $expr
## sum(1:10)
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
R(cat("a bit talkative, innit?"))
## $value
## NULL
## 
## $sides
## $sides$stdout
## [1] "a bit talkative, innit?"
## 
## 
## $expr
## cat("a bit talkative, innit?")
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
R(sqrt(c(-1, 0, 1, 2, 4)))
## $value
## [1]      NaN 0.000000 1.000000 1.414214 2.000000
## 
## $sides
## $sides$warning
## [1] "NaNs produced"
## 
## 
## $expr
## sqrt(c(-1, 0, 1, 2, 4))
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
R(log("aaaargh"))
## $value
## NULL
## 
## $sides
## $sides$error
## [1] "non-numeric argument to mathematical function"
## 
## 
## $expr
## log("aaaargh")
## 
## attr(,"class")
## [1] "realtest_descriptor" "realtest"
```
