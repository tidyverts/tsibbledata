
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tsibbledata <a href='https://tsibbledata.tidyverts.org'><img src='man/figures/logo.png' align="right" height="138.5" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/tidyverts/tsibbledata/workflows/R-CMD-check/badge.svg)](https://github.com/tidyverts/tsibbledata/actions)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tsibbledata)](https://cran.r-project.org/package=tsibbledata)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/tidyverts/tsibbledata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverts/tsibbledata/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package provides examples of
[tsibble](https://tsibble.tidyverts.org/) datasets which can be used
within the [tidyverts](https://tidyverts.org/) family of packages.

## Installation

You could install the stable version on
[CRAN](https://cran.r-project.org/package=tsibbledata):

``` r
install.packages("tsibbledata")
```

You could install the development version from
[GitHub](https://github.com/) using

``` r
# install.packages("remotes")
remotes::install_github("tidyverts/tsibbledata")
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
