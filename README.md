# **realtest**

## When Expectations Meet Reality: Realistic Unit Testing in [R](https://www.r-project.org/)

--------------------------------------------------------------------------------

> We are all adults here. We can't always get what we want.
> Such is life. You may say we're dreamers, but we're not the only ones:
> in an ideal world, things could look different, there could be more
> or less of this and that. Sometimes, there might be many equally correct
> outcomes. Other behaviours are good enough for now, but we shall improve
> them eventually, say, during the 2027 summer holidays. Sometimes, what we
> have is barely acceptable, but we need to live with it: it is
> scheduled to be fixed when we have time. Or when other dependencies
> will finally take our feedback into account and accept that series of
> bug fixes and enhancements. Sad but true, one needs to be patient.
>
> [*realtest*](https://realtest.gagolewski.com) is a framework for unit testing
> for realistic minimalists; it aids in formalising:
>
> * assertions
> * current behaviour that we'd like to see changed in the future
> * alternative yet perfectly acceptable behaviours (e.g., when outputs
> are platform-dependent and should remain so)
> * requested features to be implemented in due time
> (e.g., as part of the monitoring of other software projects for changes)

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
# identical
E(sqrt(4), 2.0)  # equivalent to E(sqrt(4), P(2.0))

# almost-equal (round-off errors)
E(sin(pi), 0.0, value_comparer=all.equal)

# two equally okay possible outcomes:
E(sample(c("head", "tail"), 1), "head", "tail")

# not-a-number, with a warning
E(sqrt(-1), P(NaN, warning=TRUE))

# not-a-number, but we don't care about the side effects here
E(sqrt(-1), NaN, sides_comparer=ignore_differences)

# desired vs. current vs. undesired (because it can always be worse!) behaviour
E(
    paste0(1:2, 1:3),                  # expression to test - concatenation
    .description="partial recycling",  # info - what behaviour are we testing?
    desired=P(                         # what we yearn for (ideally)
        c("11", "22", "13"),
        warning="longer object length is not a multiple of shorter object length"
    ),
    current=c("11", "22", "13"),       # this is the behaviour we have now
    undesired=P(error=TRUE)            # avoid regression
)

# if a test fails, the default result postprocessor
# prints out the differences and throws an error:
E(E(sin(pi), 7), P(error=TRUE, stdout=TRUE))  # inception: realtest tests itself
```

Labels `desired`, `current`, `undesired`, etc., are not hard-coded – you
yourself choose the vocabulary (you are only limited by your imagination
and programming skills).
You can then summarise the results and customise them to your liking —
it is up to you: the test outcomes are represented as ordinary R lists.


Refer to the on-line documentation at https://realtest.gagolewski.com
for some inspirations and to
https://cran.r-project.org/doc/manuals/r-release/R-intro.html
to learn more about programming in R.


--------------------------------------------------------------------------------

**Package Maintainer and Author**:
[Marek Gagolewski](https://www.gagolewski.com/)

**Homepage**: https://realtest.gagolewski.com

**CRAN Entry**: TODO

**License**:
*realtest* is distributed under the terms of the GNU General Public License,
either Version 2 or Version 3, see
[LICENSE](https://raw.githubusercontent.com/gagolews/realtest/master/LICENSE)

**Changelog**: see
[NEWS](https://raw.githubusercontent.com/gagolews/realtest/master/NEWS)
