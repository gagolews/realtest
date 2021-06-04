# What Is New in *realtest*

> Note that the package API is still in its infancy and hence subject to change.
> Comments and suggestions are welcome.


## 0.1.2.9xxx (to be >= 0.1.3)

* [NEW FEATURE] `sides_comparer` is now solely responsible for
  defining the semantics of side effect prototypes, therefore
  `P` performs only non-invasive sanity checks of its arguments.

* [BACKWARD INCOMPATIBILITY] Example comparer `identical_or_TRUE`
  is no longer available. `maps_identical_or_TRUE` has been renamed
  `sides_similar` and now has an option to ignore the consideration
  of indicated side effects.

* [BUGFIX] `summary.realtest_results` no longer tries to subset symbols.


## 0.1.2 (2021-06-03)

* [BUGFIX] `test_dir` does not modify the global environment anymore.

* [BUGFIX] `test_dir` now evaluates tests in a temporary environment
  whose parent is the caller's envir, not `namespace:realtest`.


## 0.1.1 (2021-06-01)

* [NEW FEATURE] Core functions: `E`, `P`, `R`.

* [NEW FEATURE] Example comparers.

* [NEW FEATURE] Example postprocessors.

* [NEW FEATURE] Example batch case processing/reporting: `test_dir`,
  `print.realtest_results_summary`, and `summary.realtest_results`.


## 0.0.0 (2021-05-27)

* The *realtest* project has been established.
