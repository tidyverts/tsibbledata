This submission resolves reverse dependency issues introduced by tsibble package
version 0.9.0, which is currently 'waiting' for CRAN acceptance.

## Test environments
* local ubuntu 18.04 install, R 3.6.1
* ubuntu 16.04 (on GitHub actions), R 4.0.0, R 3.6.3, R 3.5.3
* macOS (on GitHub actions), R-devel, R 3.6.1
* windows (on GitHub actions), R 3.6.1
* win-builder, R-devel, R 3.6.1, R 3.5.3

## R CMD check results

0 errors | 0 warnings | 0 notes

Reverse dependency checks have been performed:
* feasts has changed to worse, and has a submission resolving this issue
