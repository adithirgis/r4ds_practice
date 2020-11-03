Workflow Basics and Data Transformation
================
Adithi R Upadhya
11/3/2020

## Coding Basics

  - Use RStudio’s keyboard shortcut: `Alt` + `-` (the minus sign).
    Notice that RStudio automagically surrounds `<-` with spaces, which
    is a good code formatting practice.

  - Code is miserable to read on a good day, so giveyoureyesabreak and
    use spaces.

  - Object names must start with a letter, and can only contain letters,
    numbers, `_` and `.`. You want your object names to be descriptive,
    so you’ll need a convention for multiple words. We recommend
    snake\_case where you separate lowercase words with `_`.

  - `i_use_snake_case`

  - `otherPeopleUseCamelCase`

  - `some.people.use.periods`

  - `And_aFew.People_RENOUNCEconvention`

  - Typos matter. Case matters.

  - If you make an assignment, you don’t get to see the value. You’re
    then tempted to immediately double-check the result:

<!-- end list -->

``` r
y <- seq(1, 10, length.out = 5)
y
```

    ## [1]  1.00  3.25  5.50  7.75 10.00

  - This common action can be shortened by surrounding the assignment
    with parentheses, which causes assignment and “print to screen” to
    happen.

<!-- end list -->

``` r
(y <- seq(1, 10, length.out = 5))
```

    ## [1]  1.00  3.25  5.50  7.75 10.00
