# tsibbledata 0.4.1

* Add row number index for datasets without natural time index obtained with
  `monash_forecasting_repository()` (#19).

# tsibbledata 0.4.0

* Added `monash_forecasting_repository()` for access to tsibble formatted data
  from the Monash Forecasting Repository (https://forecastingdata.org/).
* Documentation improvements

# tsibbledata 0.3.0 (17th March 2021)

* Filled gaps in PBS with zeroes.
* Updated `nyc_bikes` and `gafa_stock` data objects for tsibble changes. This
  fixes the interval not being displayed as 'irregular'.

# tsibbledata 0.2.0 (5th June 2020)

* Changed times of `vic_elec` back 30 minutes for consistency with `fpp2::elecdemand`.
* Updated data for compatibility with tsibble v0.9.0.

# tsibbledata 0.1.0 (12th June 2019)

* First release.
* Contains 12 tsibble datasets: `ansett`, `vic_elec`, `aus_livestock`, `aus_production`, `aus_retail`, `gafa_stock`, `global_economy`, `hh_budget`, `nyc_bikes`, `olympic_running`, `PBS`, `pelt`.
* Added a `NEWS.md` file to track changes to the package.
