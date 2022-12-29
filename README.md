# **realtest**

## Where Expectations Meet Reality: Realistic Unit Testing in [R](https://www.r-project.org/)

--------------------------------------------------------------------------------

> We are all adults here. We can't always get what we want.
> Such is life. You may say we're dreamers, but we're not the only ones:
> in an ideal world, things could look different, there could be more
> or less of this or that. Sometimes, there might be many equally correct
> outcomes. Other behaviours are good enough for now, but we shall improve
> them eventually, say, during the 2027 summer holidays. Sometimes, what we
> have is barely acceptable, but we'll fix it when we have time.
> Or when other dependencies will finally take our feedback into account and
> accept that series of bug fixes and enhancements. Sad but true,
> one needs to be patient.
>
> [*realtest*](https://realtest.gagolewski.com) is a framework for unit testing
> for realistic minimalists; it aids in formalising:
>
> * assertions,
> * current behaviour that we'd like to see changed in the future,
> * alternative yet perfectly acceptable behaviours (e.g., when outputs
>   are platform-dependent and should remain so),
> * requested features to be implemented in due time
>   (e.g., as part of the monitoring of third-party
>   software projects for changes).

--------------------------------------------------------------------------------


The introduced vocabulary is (and will be kept!) minimalistic:

*  **`P`** is *prototype* – you can use it to manually create a descriptor like
    "*I expect this function to return `c(1, 2, 3)`, with a warning*"
    or "*that should result in an error*";

*  **`R`** stands for *record* – creates a descriptor by evaluating an
    expression and capturing its direct and indirect effects:

    * values generated (together with object attributes),
    * errors,
    * warnings and messages,
    * text output on `stdout` and `stderr`;

*  **`E`** means *expect* – compares an expression under scrutiny (via `R`)
    with a series of descriptors (created via `P` or `R` and using
    a pairwise comparer provided) and stores the matching one (if any).

--------------------------------------------------------------------------------

Some examples:

```r
library("realtest")  # call install.packages("realtest") first

# identical
E(sqrt(4), 2.0)  # equivalent to E(sqrt(4), P(2.0))

# almost-equal (round-off errors)
E(sin(pi), 0.0, value_comparer=all.equal)

# two equally okay possible outcomes:
E(sample(c("head", "tail"), 1), "head", "tail")

# not-a-number, with a warning
E(sqrt(-1), P(NaN, warning=TRUE))

# desired vs. current vs. undesired (because it can always be worse!) behaviour
E(
    paste0(1:2, 1:3),                  # expression to test - concatenation
    best=P(                            # what we yearn for (ideally)
        c("11", "22", "13"),
        warning=TRUE
    ),
    current=c("11", "22", "13"),       # this is the behaviour we have now
    bad=P(error=TRUE)                  # avoid regression
    # and of course, everything else (un-expected) makes up a failed test
)
```

Refer to the on-line documentation at <https://realtest.gagolewski.com>
for more details.

To learn more about R, check out Marek's recent open-access (free!) textbook
[*Deep R Programming*](https://deepr.gagolewski.com/).



--------------------------------------------------------------------------------

**Package Maintainer and Author**:
[Marek Gagolewski](https://www.gagolewski.com/)

**Homepage**: https://realtest.gagolewski.com

**CRAN Entry**: https://CRAN.R-project.org/package=realtest

**License**:
*realtest* is distributed under the terms of the GNU General Public License,
either Version 2 or Version 3, see
[LICENSE](https://raw.githubusercontent.com/gagolews/realtest/master/LICENSE)

**Changelog**: see
[NEWS](https://raw.githubusercontent.com/gagolews/realtest/master/NEWS)
