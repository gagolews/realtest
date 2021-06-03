# What Is New in *realtest*


## 0.1.2 (2021-06-03)

* [BUGFIX] `test_dir` does not modify the global environment anymore.
* [BUGFIX] `test_dir` now evaluates tests in a temporary environment
  whose parent is the caller's envir, not `namespace:realtest`.


## 0.1.1 (2021-06-01)

* [NEW FEATURE] Core functions: `E`, `P`, `R`.
* [NEW FEATURE] Example comparers.
* [NEW FEATURE] Example postprocessors.
* [NEW FEATURE] `test_dir`.


## 0.0.0 (2021-05-27)

* The *realtest* project has been established.
