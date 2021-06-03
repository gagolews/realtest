# comparers: Example Object and Side Effect Comparers

## Description

Two-argument functions to compare direct or indirect effects of two test descriptors (see [`P`](P.md) and [`R`](R.md)). These can be passed as `value_comparer` and `sides_comparer` to [`E`](E.md).

## Usage

```r
ignore_differences(x, y)

identical_or_TRUE(x, y)

maps_identical_or_TRUE(x, y)
```

## Arguments

|     |                                       |
|-----|---------------------------------------|
| `x` | prototype or part thereof             |
| `y` | object under scrutiny or part thereof |

## Details

Notable built-in (base R) comparers include [`identical`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/identical.html) (the strictest possible) and [`all.equal`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/all.equal.html) (can ignore, amongst others, round-off errors).

`ignore_differences` is a dummy comparer that always returns `TRUE`. Hence, it does not discriminate between anything.

`identical_or_TRUE` is useful when comparing particular side effects, where is assumed that a value `TRUE` represents the occurrence of a condition, but without going into any details (e.g., some warning).

`maps_identical_or_TRUE` propagates `identical_or_TRUE` on each element of a given named list (treated as an unordered set of key-value pairs) and aggregates the results.

You can define any comparer of your own liking: the possibilities are endless. For example:

-   a comparer for side effects based on regular expressions,

-   a comparer that tests whether all elements in a vector are equal to `TRUE`,

-   a comparer that verifies whether each element falls into a specified interval,

-   a comparer that ignores all the object attributes (possibly in combination with other comparers),

and so forth.

## Value

Each comparer should yield `TRUE` if the test condition is considered met or anything else otherwise. However, it is highly recommended that in the latter case, a single string with a short summary of the differences is returned, as in [`all.equal`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/all.equal.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/)

## See Also

The official online manual of <span class="pkg">realtest</span> at <https://realtest.gagolewski.com/>
