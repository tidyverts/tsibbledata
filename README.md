
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tsibbledata <a href='https://tsibbledata.tidyverts.org'><img src='man/figures/logo.png' align="right" height="138.5" /></a>

[![Travis build
status](https://travis-ci.org/tidyverts/tsibbledata.svg?branch=master)](https://travis-ci.org/tidyverts/tsibbledata)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/tsibbledata)](https://cran.r-project.org/package=tsibbledata)

This package provides examples of
[tsibble](https://tsibble.tidyverts.org/) datasets which can be used
within the [tidyverts](https://tidyverts.org/) family of packages.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tidyverts/tsibbledata")
```

## Example

``` r
library(tsibbledata)
library(ggplot2)
ggplot(olympic_running, aes(x=Year, y = Time, colour = Sex)) +
  geom_line() +
  geom_point(size = 1) +
  facet_wrap(~ Length, scales = "free_y", nrow = 2) + 
  theme_minimal() + 
  scale_color_brewer(palette = "Dark2") + 
  theme(legend.position = "bottom", legend.title = element_blank()) +
  ylab("Running time (seconds)")
```

<img src="man/figures/README-elecdemand-1.png" width="100%" />
