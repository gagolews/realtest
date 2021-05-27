# **realtest**

## When Expectations Meet Reality: Realistic Unit Testing in [R](https://www.r-project.org/)

--------------------------------------------------------------------------------

> We are all adults here. We can't always get what we want.
> Such is life. You may say we're dreamers, but we're not the only ones:
> in an ideal world, things could look different, there could be more
> or less of this and that. Sometimes, there might be many equally correct
> outcomes. Other behaviours are good enough for now, but we might improve
> them eventually, say, during next summer holidays. Sometimes, what we have
> is barely acceptable, but we need to live with it: to be fixed when we
> have time. Or when other dependencies will finally take our feedback
> into account and accept that series of bug fixes and enhancements.
> Sad but true, one needs to be patient. The following is a framework
> for unit testing for realistic minimalists, where we distinguish between
> expected, acceptable, and current-yet-undesirable behaviour.
> It can also be used for monitoring other software projects for changes.



Realistic unit tests can be used to formalise:

* assertions
* alternative yet perfectly acceptable behaviours
* requested features to be implemented in due time
* current behaviour that we'd like to see changed in the future

The introduced vocabulary is (and will be kept!) minimalistic:

*  `P` is *prototype* -- you can use it to manually create a descriptor like
    *I expect the function to return `c(1, 2, 3)`, with a warning*
    or *this should result in an error*;

*  `R` is *record* -- creates a descriptor by evaluating an expression
    and capturing its direct and indirect effects:

    * values generated (together with object attributes),
    * errors,
    * warnings and messages,
    * text output on `stdout` and `stderr`;

*  `E` stands for *expect* -- compares an expression under scrutiny (via `R`)
    with a series of descriptors (created via `P` or `R` and using
    a comparer provided) and stores the matching one (if any).

You can then summarise the results however you want. It is up to you.
By default  ....@TODO....

```r
# identical
E(sqrt(4), 2.0)  # equivalent to E(sqrt(4), P(2.0))

# almost-equal (round-off errors)
E(sin(pi), 0.0, value_comparer=all.equal)

# two equally good possible outcomes:
E(sample(c("head", "tail"), 1), "head", "tail")

# a warning is expected
E(sqrt(-1), P(NaN, warning=TRUE))

E(sqrt(-1), NaN)

# it'd be better if the following generated a warning:
E(
    paste0(1:2, 1:3),  # expression to test
    description="partial recycling",  # info - what behaviour are we testing?
    desired=P(  # ideally, we'd like to have this
        c("11", "22", "13"),
        warning="longer object length is not a multiple of shorter object length"
    ),
    current=c("11", "22", "13"),  # this is the behaviour we have now
    undesired=P(error=TRUE)  # this is R, we should obey the recycling rule
)
```

Labels `desired`, `current`, `undesired`, etc. are not hard-coded -- you
choose the vocabulary.

--------------------------------------------------------------------------------


**Package Maintainer and Author**:
[Marek Gagolewski](https://www.gagolewski.com/)

**Homepage**: TODO

**CRAN Entry**: TODO

**License**:
*realtest* is distributed under the terms of the GNU General Public License,
either Version 2 or Version 3, see
[LICENSE](https://raw.githubusercontent.com/gagolews/realtest/master/LICENSE).

**Changelog**: see
[NEWS](https://raw.githubusercontent.com/gagolews/realtest/master/NEWS).
