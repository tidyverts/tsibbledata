#' Monthly Medicare Australia prescription data
#'
#' \code{PBS} is a monthly `tsibble` with two values:
#' \tabular{ll}{
#'     Scripts:      \tab Total number of scripts\cr
#'     Cost:     \tab Cost of the scripts in $AUD\cr
#' }
#'
#' The data is disaggregated using four keys:
#' \tabular{ll}{
#'     Concession:      \tab Concessional scripts are given to pensioners, unemployed, dependents, and other card holders \cr
#'     Type:      \tab Co-payments are made until an individual's script expenditure hits a threshold ($290.00 for concession, $1141.80 otherwise). Safety net subsidies are provided to individuals exceeding this amount. \cr
#'     ATC1:     \tab Anatomical Therapeutic Chemical index (level 1)\cr
#'     ATC2:     \tab Anatomical Therapeutic Chemical index (level 2)\cr
#' }
#'
#' @source
#' Medicare Australia
#'
#' @name PBS
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' PBS
#'
NULL

#' Fastest running times for Olympic races
#'
#' \code{olympic_running} is a quadrennial `tsibble` with one value:
#' \tabular{ll}{
#'     Time:      \tab Fastest running time for the event (seconds)\cr
#' }
#'
#' The event is identified using two keys:
#' \tabular{ll}{
#'     Length:     \tab The length of the race (meters)\cr
#'     Sex:     \tab The sex of the event\cr
#' }
#'
#' The data contains missing values in 1916, 1940 and 1944 due to the World Wars.
#'
#' @source
#' <https://www.olympic.org/athletics>
#'
#' @name olympic_running
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' olympic_running
#'
#' if(requireNamespace("ggplot2")){
#' library(ggplot2)
#' olympic_running %>% as_tibble %>%
#'   ggplot(aes(x=Year, y = Time, colour = Sex)) +
#'   geom_line() +
#'   facet_wrap(~ Length, scales = "free_y")
#' }
NULL

#' Australian retail trade turnover
#'
#' \code{aus_retail} is a monthly `tsibble` with one value:
#' \tabular{ll}{
#'     Turnover:      \tab Retail turnover in $Million AUD\cr
#' }
#'
#' Each series is uniquely identified using two keys:
#' \tabular{ll}{
#'     State:     \tab The Australian state (or territory)\cr
#'     Industry:     \tab The industry of retail trade\cr
#' }
#'
#' @source
#' Australian Bureau of Statistics, catalogue number 8501.0, table 11.
#'
#' @name aus_retail
#' @format Time series of class `tsibble`
#' @keywords datasets
#'
#' @examples
#' library(tsibble)
#' aus_retail
#'
NULL

#' Passenger numbers on Ansett airline flights
#'
#' The data features a major pilots' industrial dispute which results in some
#' weeks having zero passengers. There were also at least two changes in the
#' definitions of passenger classes.
#'
#' \code{ansett} is a weekly `tsibble` with one value:
#' \tabular{ll}{
#'     Passengers:  \tab Total air passengers travelling with Ansett\cr
#' }
#'
#' Each series is uniquely identified using two keys:
#' \tabular{ll}{
#'     Airports:  \tab The airports that passengers are travelling between (both directions)\cr
#'     Class:     \tab The class of the ticket.\cr
#' }
#'
#' @source
#' Ansett Airlines (which no longer exists).
#'
#' @name ansett
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' ansett
#'
NULL


#' NYC Citi Bike trips
#'
#' A sample from NYC Citi Bike usage of 10 bikes throughout 2018. The data
#' includes event data on each trip, including the trip's start and end times
#' and locations. The customer's gender, birth year and bike usage type is
#' also available.
#'
#' \code{nyc_bikes} is a `tsibble` containing event data, the events include
#' these details:
#' \tabular{ll}{
#'     start_time:   \tab The time and date when the trip was started.\cr
#'     stop_time:    \tab The time and date when the trip was ended.\cr
#'     start_station:\tab A unique identifier for the starting bike station.\cr
#'     start_lat:    \tab The latitude of the starting bike station.\cr
#'     start_long:   \tab The longitude of the starting bike station.\cr
#'     end_station:  \tab A unique identifier for the destination bike station.\cr
#'     end_lat:      \tab The latitutde of the destination bike station.\cr
#'     end_long:     \tab The longitude of the destination bike station.\cr
#'     type:         \tab The type of trip. A "Customer" has purchased either a 24-hour or 3-day pass, and a "Subscriber" has purchased an annual subscription.\cr
#'     birth_year    \tab The bike rider's year of birth.\cr
#'     gender:       \tab The gender of the bike rider.\cr
#' }
#'
#' Each series is uniquely identified by one key:
#' \tabular{ll}{
#'     bike_id:      \tab A unique identifier for the bike.\cr
#' }
#'
#' @source
#' Citi Bike NYC, <https://www.citibikenyc.com/system-data>
#'
#' @name nyc_bikes
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' nyc_bikes
NULL

#' GAFA stock prices
#'
#' Historical stock prices from 2014-2018 for Google, Amazon, Facebook and Apple.
#' All prices are in $USD.
#'
#' \code{gafa_stock} is a `tsibble` containing data on irregular trading days:
#' \tabular{ll}{
#'     Open:      \tab The opening price for the stock.\cr
#'     High:      \tab The stock's highest trading price.\cr
#'     Low:       \tab The stock's lowest trading price.\cr
#'     Close:     \tab The closing price for the stock.\cr
#'     Adj_Close: \tab The adjusted closing price for the stock.\cr
#'     Volume:    \tab The amount of stock traded.\cr
#' }
#'
#' Each stock is uniquely identified by one key:
#' \tabular{ll}{
#'     Symbol:      \tab The ticker symbol for the stock.\cr
#' }
#'
#' @source
#' Yahoo Finance historical data, <https://finance.yahoo.com/>
#'
#' @name gafa_stock
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' gafa_stock
NULL


#' Pelt trading records
#'
#' Hudson Bay Company trading records for Snowshoe Hare and Canadian Lynx furs
#' from 1845 to 1935. This data contains trade records for all areas of the company.
#'
#' \code{pelt} is an annual `tsibble` with two values:
#' \tabular{ll}{
#'     Hare:      \tab The number of Snowshoe Hare pelts traded.\cr
#'     Lynx:      \tab The number of Canadian Lynx pelts traded.\cr
#' }
#'
#' @source
#' Hudson Bay Company
#'
#' @name pelt
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' pelt
NULL


#' Global economic indicators
#'
#' Economic indicators featured by the World Bank from 1960 to 2017.
#'
#' \code{global_economy} is an annual `tsibble` with six values:
#' \tabular{ll}{
#'     GDP:       \tab Gross domestic product (in $USD February 2019).\cr
#'     Growth:    \tab Annual percentage growth in GDP.\cr
#'     CPI:       \tab Consumer price index (base year 2010).\cr
#'     Imports:   \tab Imports of goods and services (% of GDP).\cr
#'     Exports:   \tab Exports of goods and services (% of GDP).\cr
#'     Population:\tab Total population.
#' }
#'
#' Each series is uniquely identified by one key:
#' \tabular{ll}{
#'     Country:   \tab The country or region of the series.\cr
#' }
#'
#' @source
#' The World Bank, <http://datatopics.worldbank.org/world-development-indicators/>
#'
#' @name global_economy
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' global_economy
NULL

#' Australian livestock slaughter
#'
#' Meat production in Australia for human consumption from Q3 1965 to Q4 2018.
#'
#' \code{aus_livestock} is an quarterly `tsibble` with one value:
#' \tabular{ll}{
#'     Count:    \tab Number of animals slaughtered.\cr
#' }
#'
#' Each series is uniquely identified by one key:
#' \tabular{ll}{
#'     Animal:   \tab The animal slaughtered.\cr
#' }
#'
#' @source
#' Australian Bureau of Statistics, catalogue number 7218.0.55.001 tables 1 to 6.
#'
#' @name aus_livestock
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(tsibble)
#' aus_livestock
NULL

#' Half-hourly electricity demand for Victoria, Australia
#'
#' \code{vic_elec} is a half-hourly `tsibble` with three values:
#'   \tabular{ll}{
#'     Demand:      \tab Total electricity demand in MW.\cr
#'     Temperature: \tab Temperature of Melbourne (BOM site 086071).\cr
#'     Holiday:     \tab Indicator for if that day is a public holiday.\cr
#' }
#'
#' This data is for operational demand, which is the demand met by local
#' scheduled generating units, semi-scheduled generating units, and
#' non-scheduled intermittent generating units of aggregate capacity larger
#' than 30 MW, and by generation imports to the region. The operational demand
#' excludes the demand met by non-scheduled non-intermittent generating units,
#' non-scheduled intermittent generating units of aggregate capacity smaller
#' than 30 MW, exempt generation (e.g. rooftop solar, gas tri-generation, very
#' small wind farms, etc), and demand of local scheduled loads. It also
#' excludes some very large industrial users (such as mines or smelters).
#'
#' @name vic_elec
#' @docType data
#' @format Time series of class `tsibble`.
#'
#' @source
#' Australian Energy Market Operator.
#'
#' @keywords datasets
#' @examples
#' library(tsibble)
#' vic_elec
NULL

#' Quarterly production of selected commodities in Australia.
#'
#' Quarterly estimates of selected indicators of manufacturing production in Australia.
#'
#' \code{aus_production} is a half-hourly `tsibble` with six values:
#'   \tabular{ll}{
#'     Beer:       \tab Beer production in megalitres.\cr
#'     Tobacco:    \tab Tobacco and cigarette production in tonnes.\cr
#'     Bricks:     \tab Clay brick production in millions of bricks.\cr
#'     Cement:     \tab Portland cement production in thousands of tonnes.\cr
#'     Electricity:\tab Electricity production in gigawatt hours.\cr
#'     Gas:        \tab Gas production in petajoules.\cr
#' }
#'
#' @name aus_production
#' @docType data
#' @format Time series of class `tsibble`.
#' @source
#' Australian Bureau of Statistics, catalogue number 8301.0.55.001 table 1.
#'
#' @keywords datasets
#' @examples
#' library(tsibble)
#' aus_production
#'
NULL

#' Household budget characteristics
#'
#' Annual indicators of household budgets for Australia, Japan, Canada and USA
#' from 1995-2016.
#'
#' \code{hh_budget} is an annual `tsibble` with six values:
#'   \tabular{ll}{
#'     Debt:         \tab Debt as a percentage of net disposable income.\cr
#'     DI:           \tab Annual growth rate of disposable income.\cr
#'     Expenditure:  \tab Annual growth rate of expenditure.\cr
#'     Savings:      \tab Savings as a percentage of household disposable income.\cr
#'     Wealth:       \tab Wealth as a percentage of net disposable income.\cr
#'     Unemployment: \tab Percentage of unemployed in the labour force.\cr
#' }
#'
#' Each country is uniquely identified by one key:
#' \tabular{ll}{
#'     Country:   \tab The country of the series.\cr
#' }
#'
#' @name hh_budget
#' @docType data
#' @format Time series of class `tsibble`.
#' @source
#' The Organisation for Economic Co-operation and Development (<https://data.oecd.org/>)
#'
#' @keywords datasets
#' @examples
#' library(tsibble)
#' hh_budget
#'
NULL
