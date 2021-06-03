realtest: When expectations meet reality: Realistic unit testing in R
============================================================================

    We are all adults here. We can't always get what we want.
    Such is life. You may say we're dreamers, but we're not the only ones:
    in an ideal world, things could look different, there could be more
    or less of this and that. Sometimes, there might be many equally correct
    outcomes. Other behaviours are good enough for now, but we shall improve
    them eventually, say, during the 2027 summer holidays. Sometimes, what we
    have is barely acceptable, but we need to live with it: it is
    scheduled to be fixed when we have time. Or when other dependencies
    will finally take our feedback into account and accept that series of
    bug fixes and enhancements. Sad but true, one needs to be patient.

    *realtest* is a framework for unit testing
    for realistic minimalists; it aids in formalising:

    * assertions,
    * current behaviour that we'd like to see changed in the future,
    * alternative yet perfectly acceptable behaviours (e.g., when outputs
      are platform-dependent and should remain so),
    * requested features to be implemented in due time
      (e.g., as part of the monitoring of third-party
      software projects for changes).

    -- by `Marek Gagolewski <https://www.gagolewski.com/>`_


The introduced vocabulary is (and will be kept!) minimalistic:

*  **P** is *prototype* – you can use it to manually create a descriptor like
    "*I expect this function to return `c(1, 2, 3)`, with a warning*"
    or "*that should result in an error*";

*  **R** stands for *record* – creates a descriptor by evaluating an
    expression and capturing its direct and indirect effects:

    * values generated (together with object attributes),
    * errors,
    * warnings and messages,
    * text output on `stdout` and `stderr`;

*  **E** means *expect* – compares an expression under scrutiny (via `R`)
    with a series of descriptors (created via `P` or `R` and using
    a pairwise comparer provided) and stores the matching one (if any).

Some examples:

.. code-block:: r

    library("realtest")  # call install.packages("realtest") first

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
        best=P(                            # what we yearn for (ideally)
            c("11", "22", "13"),
            warning="longer object length is not a multiple of shorter object length"
        ),
        current=c("11", "22", "13"),       # this is the behaviour we have now
        bad=P(error=TRUE)                  # avoid regression
        # and of course, everything else (un-expected) makes up a failed test
    )

    # if a test fails, the default result postprocessor
    # prints out the differences and throws an error:
    E(E(sin(pi), 7), P(error=TRUE, stdout=TRUE))  # inception: realtest tests itself


.. COMMENT
    s <- summary(test_dir("~/R/realtest/tests"))
    knitr::kable(table(s[[".file"]], s[["match"]]))


Labels `desired`, `current`, `undesired`, `good`, `better`,
`bad`, `worst`, etc., are not hard-coded – you choose the vocabulary yourself.
You can then summarise/visualise/analyse/customise the results to your liking
(e.g., how many `good` or `bad` instances have been caught) –
the test outcomes are represented as ordinary R lists.


Pros:

* minimalistic – clean design and non-overwhelming vocabulary,
* general and flexible – can be easily adapted to suit your needs,
* economic – an expression under scrutiny is evaluated once and
  all its different effects can be examined in a single unit,
* organised – makes planning future features/improved behaviour easier,
* analysable – introduces data science to unit testing: what story
  can you tell based on the observed facts?


Cons:

* steeper (or, should we rather say, normal) learning curve, you are
  limited by your imagination and programming skills
* other tools, e.g.,
  `tinytest <https://CRAN.R-project.org/package=tinytest>`_,
  `testthat <https://CRAN.R-project.org/package=testthat>`_,
  `RUnit <https://CRAN.R-project.org/package=RUnit>`_,
  might be more suitable for the more *typical* use cases.


*realtest*'s source code is hosted on
`GitHub <https://github.com/gagolews/realtest>`_.
It is a free software project distributed under the terms of the
GNU General Public License, either Version 2 or Version 3, see
`license <https://raw.githubusercontent.com/gagolews/realtest/master/LICENSE>`_.




.. toctree::
    :maxdepth: 2
    :caption: realtest

    About  <https://realtest.gagolewski.com/>


.. toctree::
    :maxdepth: 1
    :caption: Reference Manual
    :glob:

    rapi/*
.. rapi.md

.. toctree::
    :maxdepth: 1
    :caption: Other

    Source Code (GitHub) <https://github.com/gagolews/realtest>
    Bug Tracker and Feature Suggestions <https://github.com/gagolews/realtest/issues>
    Author's Homepage <https://www.gagolewski.com/>
    news.md

.. CRAN Entry <https://CRAN.R-project.org/package=realtest>

