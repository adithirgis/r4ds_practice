R for Data Science
================
ARU
9/26/2020

## Introduction

![Fig 1: What to
expect?](D:/Dropbox/ILKConsultancy/r4ds_practice/R/images/Fig1.JPG)

## Data Visualisation

Do cars with big engines use more fuel than cars with small engines?

  - `displ`, a car’s engine size, in litres.

  - `hwy`, a car’s fuel efficiency on the highway, in miles per gallon
    (mpg). A car with a low fuel efficiency consumes more fuel than a
    car with a high fuel efficiency when they travel the same distance.

<!-- end list -->

``` r
mpg
```

    ## # A tibble: 234 x 11
    ##    manufacturer model    displ  year   cyl trans   drv     cty   hwy fl    class
    ##    <chr>        <chr>    <dbl> <int> <int> <chr>   <chr> <int> <int> <chr> <chr>
    ##  1 audi         a4         1.8  1999     4 auto(l~ f        18    29 p     comp~
    ##  2 audi         a4         1.8  1999     4 manual~ f        21    29 p     comp~
    ##  3 audi         a4         2    2008     4 manual~ f        20    31 p     comp~
    ##  4 audi         a4         2    2008     4 auto(a~ f        21    30 p     comp~
    ##  5 audi         a4         2.8  1999     6 auto(l~ f        16    26 p     comp~
    ##  6 audi         a4         2.8  1999     6 manual~ f        18    26 p     comp~
    ##  7 audi         a4         3.1  2008     6 auto(a~ f        18    27 p     comp~
    ##  8 audi         a4 quat~   1.8  1999     4 manual~ 4        18    26 p     comp~
    ##  9 audi         a4 quat~   1.8  1999     4 auto(l~ 4        16    25 p     comp~
    ## 10 audi         a4 quat~   2    2008     4 manual~ 4        20    28 p     comp~
    ## # ... with 224 more rows

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

The plot above shows a negative relationship between engine size
(`displ`) and fuel efficiency (`hwy`). In other words, cars with big
engines use more fuel.

### Exercises

`class` vs `drv`

``` r
ggplot(data = mpg)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
nrow(mpg)
```

    ## [1] 234

``` r
ggplot(mpg, aes(x = cyl, y = hwy)) +
  geom_point()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
ggplot(mpg, aes(x = class, y = drv)) +
  geom_point() +
  geom_count()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

``` r
mpg %>%
  count(class, drv) %>%
  ggplot(aes(x = class, y = drv)) +
    geom_tile(mapping = aes(fill = n))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-2-4.png)<!-- --> In the
previous plot, there are many missing tiles. These missing tiles
represent unobserved combinations of `class` and `drv` values. These
missing values are not unknown, but represent values of (`class`, `drv`)
where `n = 0`. The `complete()` function in the tidyr package adds new
rows to a data frame for missing combinations of columns. The following
code adds rows for missing combinations of `class` and `drv` and uses
the fill argument to set `n = 0` for those new rows.

``` r
mpg %>%
  count(class, drv) %>%
  complete(class, drv, fill = list(n = 0)) %>%
  ggplot(aes(x = class, y = drv)) +
    geom_tile(mapping = aes(fill = n))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

### Aesthetic mappings

You can add a third variable, like `class`, to a two dimensional
scatterplot by mapping it to an aesthetic. An aesthetic is a visual
property of the objects in your plot. Aesthetics include things like the
size, the shape, or the color of your points.

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

The colors reveal that many of the unusual points are two-seater cars.
These cars don’t seem like hybrids, and are, in fact, sports cars\!
Sports cars have large engines like SUVs and pickup trucks, but small
bodies like midsize and compact cars, which improves their gas mileage.
In hindsight, these cars were unlikely to be hybrids since they have
large engines.

The exact size of each point would reveal its class affiliation. We get
a warning here, because mapping an unordered variable (`class`) to an
ordered aesthetic (`size`) is not a good idea.

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-6-3.png)<!-- -->

What happened to the SUVs? ggplot2 will only use six shapes at a time.
By default, additional groups will go unplotted when you use the shape
aesthetic.

![Fig 2: Shapes in
R](D:/Dropbox/ILKConsultancy/r4ds_practice/R/images/Fig2.JPG)

### Exercises

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
```

![](Data_viz_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

``` r
glimpse(mpg)
```

    ## Rows: 234
    ## Columns: 11
    ## $ manufacturer <chr> "audi", "audi", "audi", "audi", "audi", "audi", "audi"...
    ## $ model        <chr> "a4", "a4", "a4", "a4", "a4", "a4", "a4", "a4 quattro"...
    ## $ displ        <dbl> 1.8, 1.8, 2.0, 2.0, 2.8, 2.8, 3.1, 1.8, 1.8, 2.0, 2.0,...
    ## $ year         <int> 1999, 1999, 2008, 2008, 1999, 1999, 2008, 1999, 1999, ...
    ## $ cyl          <int> 4, 4, 4, 4, 6, 6, 6, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 8, ...
    ## $ trans        <chr> "auto(l5)", "manual(m5)", "manual(m6)", "auto(av)", "a...
    ## $ drv          <chr> "f", "f", "f", "f", "f", "f", "f", "4", "4", "4", "4",...
    ## $ cty          <int> 18, 21, 20, 21, 16, 18, 18, 18, 16, 20, 19, 15, 17, 17...
    ## $ hwy          <int> 29, 29, 31, 30, 26, 26, 27, 26, 25, 28, 27, 25, 25, 25...
    ## $ fl           <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p",...
    ## $ class        <chr> "compact", "compact", "compact", "compact", "compact",...

The argument `colour = "blue"` is included within the `mapping`
argument, and as such, it is treated as an aesthetic, which is a mapping
between a variable and a value. In the expression, `colour = "blue"`,
`"blue"` is interpreted as a categorical variable which only takes a
single value `"blue"`. If this is confusing, consider how `colour
= 1:234` and `colour = 1` are interpreted by `aes()`.

Map a continuous variable to color, size, and shape. How do these
aesthetics behave differently for categorical vs. continuous variables?

``` r
ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

``` r
# ggplot(mpg, aes(x = displ, y = hwy, shape = cty)) +
#   geom_point()
```

What happens if you map the same variable to multiple aesthetics? -
Redundancy\!

``` r
ggplot(mpg, aes(x = displ, y = hwy, colour = hwy, size = displ)) +
  geom_point()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

What does the stroke aesthetic do? What shapes does it work with? (Hint:
use ?geom\_point)

  - Stroke changes the size of the border for shapes (21-25). These are
    filled shapes in which the color and size of the border can differ
    from that of the filled interior of the shape.

<!-- end list -->

``` r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

What happens if you map an aesthetic to something other than a variable
name, like `aes(colour = displ < 5)`?

``` r
ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()
```

![](Data_viz_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## Facets

The first argument of `facet_wrap()` should be a formula, which you
create with `~` followed by a variable name (here “formula” is the name
of a data structure in R, not a synonym for “equation”). The variable
that you pass to `facet_wrap()` should be discrete.

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

To facet your plot on the combination of two variables, add
`facet_grid()` to your plot call. The first argument of `facet_grid()`
is also a formula. This time the formula should contain two variable
names separated by a `~`.

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

If you prefer to not facet in the rows or columns dimension, use a `.`
instead of a variable name, e.g. `+ facet_grid(. ~ cyl)`.

### Exercises

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ displ)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

What do the empty cells in plot with `facet_grid(drv ~ cyl)` mean? How
do they relate to this plot?

``` r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

The empty cells (facets) in this plot are combinations of drv and cyl
that have no observations. These are the same locations in the scatter
plot of drv and cyl that have no points.

``` r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cty)) +
  facet_grid(drv ~ cyl)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

What plots does the following code make? What does `.` do?

The symbol `.` ignores that dimension when faceting. For example, drv \~
. facet by values of drv on the y-axis.

``` r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

What are the advantages to using faceting instead of the colour
aesthetic? What are the disadvantages? How might the balance change if
you had a larger dataset?

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

![](Data_viz_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

``` r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-19-2.png)<!-- -->

Advantages of encoding `class` with facets instead of color include the
ability to encode more distinct categories. For me, it is difficult to
distinguish between the colors of `"midsize"` and `"minivan"`.

Given human visual perception, the max number of colors to use when
encoding unordered categorical (qualitative) data is nine, and in
practice, often much less than that. Displaying observations from
different categories on different scales makes it difficult to directly
compare values of observations across categories. However, it can make
it easier to compare the shape of the relationship between the x and y
variables across categories.

Disadvantages of encoding the `class` variable with facets instead of
the color aesthetic include the difficulty of comparing the values of
observations between categories since the observations for each category
are on different plots. Using the same x- and y-scales for all facets
makes it easier to compare values of observations across categories, but
it is still more difficult than if they had been displayed on the same
plot. Since encoding class within color also places all points on the
same plot, it visualizes the unconditional relationship between the x
and y variables; with facets, the unconditional relationship is no
longer visualized since the points are spread across multiple plots.

The benefit of encoding a variable with facetting over encoding it with
color increase in both the number of points and the number of
categories. With a large number of points, there is often overlap. It is
difficult to handle overlapping points with different colors color.
Jittering will still work with color. But jittering will only work well
if there are few points and the classes do not overlap much, otherwise,
the colors of areas will no longer be distinct, and it will be hard to
pick out the patterns of different categories visually. Transparency
(`alpha`) does not work well with colors since the mixing of overlapping
transparent colors will no longer represent the colors of the
categories. Binning methods already use color to encode the density of
points in the bin, so color cannot be used to encode categories.

As the number of categories increases, the difference between colors
decreases, to the point that the color of categories will no longer be
visually distinct.

Read ?facet\_wrap. What does `nrow` do? What does `ncol` do? What other
options control the layout of the individual panels? Why doesn’t
`facet_grid()` have nrow and ncol variables?

The arguments nrow (ncol) determines the number of rows (columns) to use
when laying out the facets. It is necessary since `facet_wrap(`) only
facets on one variable.

The `nrow` and `ncol` arguments are unnecessary for `facet_grid()` since
the number of unique values of the variables specified in the function
determines the number of rows and columns.

When using `facet_grid()` you should usually put the variable with more
unique levels in the columns. Why? There will be more space for columns
if the plot is laid out horizontally (landscape).

## Geometric objects

A geom is the geometrical object that a plot uses to represent data.
People often describe plots by the type of geom that the plot uses. For
example, bar charts use bar geoms, line charts use line geoms, boxplots
use boxplot geoms, and so on. Scatterplots break the trend; they use the
point geom.

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](Data_viz_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->

``` r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-21-1.png)<!-- --> For these
geoms, you can set the group aesthetic to a categorical variable to draw
multiple objects. ggplot2 will draw a separate object for each unique
value of the grouping variable. In practice, ggplot2 will automatically
group the data for these geoms whenever you map an aesthetic to a
discrete variable.

``` r
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

``` r
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-22-2.png)<!-- -->

``` r
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-22-3.png)<!-- --> To display
multiple geoms in the same plot, add multiple geom functions to
`ggplot()`:

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-23-1.png)<!-- --> If you
place mappings in a geom function, ggplot2 will treat them as local
mappings for the layer. It will use these mappings to extend or
overwrite the global mappings for that layer only. This makes it
possible to display different aesthetics in different layers.

``` r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

You can use the same idea to specify different `data` for each layer.
Here, our smooth line displays just a subset of the `mpg` dataset, the
subcompact cars. The local data argument in `geom_smooth()` overrides
the global data argument in `ggplot()` for that layer only.

``` r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Data_viz_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->
