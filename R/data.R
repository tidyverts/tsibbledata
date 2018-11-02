#' Half-hourly and daily electricity demand for Victoria, Australia, in 2014
#'
#' \code{elecdemand} is a half-hourly tsibble with three values:
#'   \tabular{ll}{
#'     Demand:      \tab Total electricity demand in GW for Victoria, Australia, every half-hour during 2014.\cr
#'     WorkDay:     \tab taking value 1 on work days, and 0 otherwise.\cr
#'     Temperature: \tab half-hourly temperatures for Melbourne (BOM site 086071).
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
#' @name elecdemand
#' @docType data
#' @format Time series of class \code{tsibble}.
#' @source Australian Energy Market Operator, and the Australian Bureau of
#' Meteorology. The data set is also available as \code{\link[fpp2]{elecdemand}}
#' in the \code{\link[fpp2]{fpp2}} package in a `msts` format.
#' @keywords datasets
#' @examples
#'
#' elecdemand
#'
NULL


#' @inherit datasets::UKLungDeaths
#' @name UKLungDeaths
#' @docType data
#' @format Time series of class \code{tsibble}.
#' @keywords datasets
#' @examples
#'
#' UKLungDeaths
#'
NULL

#' Monthly Medicare Australia prescription data
#'
#' \code{PBS} is a monthly tsibble with two values:
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
#' @name PBS
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#'
#' PBS
#'
NULL

#' Fastest running times for Olympic races
#'
#' \code{olympic_running} is a quadrennial tsibble with one value:
#' \tabular{ll}{
#'     Time:      \tab Fastest running time for the event\cr
#' }
#'
#' The event is identified using two keys:
#' \tabular{ll}{
#'     Length:     \tab The length of the race\cr
#'     Sex:     \tab The sex of the event\cr
#' }
#'
#' The data contains missing values in 1916, 1940 and 1944 due to the World Wars.
#'
#' @source
#' https://www.olympic.org/athletics
#'
#' @name olympic_running
#' @format Time series of class `tsibble`
#' @keywords datasets
#' @examples
#' library(ggplot2)
#' olympic_running %>% as_tibble %>%
#'   ggplot(aes(x=Year, y = Time, colour = Sex)) +
#'   geom_line() +
#'   facet_wrap(~ Length, scales = "free_y")
NULL
