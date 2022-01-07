## Functions to download data files from Monash Time Series Forecasting Archive, https://zenodo.org/communities/forecasting
## Contributed by github:rakshitha123 with modifications by github:mitchelloharawild
## For more details, please visit to https://forecastingdata.org/

#' Get data from the Monash Forecasting Repository
#'
#' This function downloads datasets from the Monash Time Series Forecasting
#' Repository (<https://forecastingdata.org/>) and reads them in as a tsibble.
#' Downloaded data will be stored locally, allowing subsequent use of the data
#' without downloading. By default, the data is stored the appropriate
#' application data directory which varies by your operating system. The storage
#' path for these datasets can be changed by setting the `rpkg_tsibbledata`
#' option with `options(rpkg_tsibbledata = /path/to/datadir)`
#'
#' @details
#'
#' Datasets from this repository are stored in a tsf file format, which stores
#' time series metadata at the top of the file. This function uses this metadata
#' to produce a tsibble dataset, ready for analysis in R. For more details on
#' the repository and the tsf file format, please refer to: Godahewa, R.,
#' Bergmeir, C., Webb, G. I., Hyndman, R. J. & Montero-Manso, P. (2021), Monash
#' Time Series Forecasting Archive.
#'
#' @param record_id Record ID of the dataset to be downloaded from the Monash Time Series Forecasting Repository. A complete table of datasets which can be obtained with this function can be found here: <https://forecastingdata.org/#datasets>. From this link, the data's `record_id` can be found in the URL of the download link provided in the table (it should look like https://zenodo.org/record/<Record ID>). This can also simply be a link to the zenodo record.
#'
#' @return A tsibble.
#'
#' @references
#' Godahewa, R., Bergmeir, C., Webb, G. I., Hyndman, R. J. & Montero-Manso, P. (2021), Monash Time Series Forecasting Repository. \url{https://forecastingdata.org/}
#'
#' Godahewa, R., Bergmeir, C., Webb, G. I., Hyndman, R. J. & Montero-Manso, P. (2021), Monash Time Series Forecasting Archive.
#'
#' @export
monash_forecasting_repository <- function(record_id){
  # Parse URL for record ID if provided
  record_id <- sub("^.*zenodo.org/record/", "", record_id)

  # Download and unzip the data
  tsf_file <- download_zenodo_record(record_id)

  # Read the tsf file in as a data frame
  data <- read_tsf(tsf_file)

  # Convert to a tsibble
  cn <- colnames(data)
  is_index <- vapply(
    data[seq_len(ncol(data)-1)],
    inherits, what = c("POSIXt", "Date"),
    logical(1L)
  )

  tsibble::build_tsibble(
    data,
    key = cn[which(!is_index)], index = cn[which(is_index)],
    ordered = TRUE
  )
}

#' @importFrom utils download.file unzip
download_zenodo_record <- function(record_id){
  if(is.null(record_id) | is.na(as.numeric(record_id)))
    stop("Please provide the ID of the dataset that you need to download. This should be a numerical value.")

  data_name <- mfr_ids[record_id]
  if(is.na(data_name) && interactive()) {
    "Could not find the file name for the dataset with this record_id."
    data_name <- readline("Could not find the file name for the dataset with this record_id.\nPlease provide the name of the file from the provided Zenodo record that you'd like to import.")
    # Remove file exts and paths from file name.
    data_name <- basename(sub("\\..+", "", data_name))
  }

  dest_file <- tsibbledata_path(record_id, paste0(data_name, ".zip"))
  tsf_file <- tsibbledata_path(record_id, paste0(data_name, ".tsf"))

  if(!file.exists(tsf_file)){ # Check whether the required .tsf file is already there at the specified destination folder
    if(!file.exists(dest_file)){ # Check whether the required .zip file is already there at the specified destination folder. If not download the .zip file from the Monash Time Series Forecasting Repository
      tryCatch({
        download.file(paste0("https://zenodo.org/record/", record_id, "/files/", data_name, ".zip"), destfile = dest_file)
      }, error = function(e) {
        message(e)
        stop("Unable to download dataset from the Monash Forecasting Repository.\nCheck that the record ID correctly matches the ID in the data's URL: https://zenodo.org/record/<Record ID>")
      })
    }

    unzip(dest_file, exdir = tsibbledata_path(record_id))
  }

  tsf_file
}

read_tsf <- function(file) {
  # Extend these frequency lists as required
  LOW_FREQUENCIES <- c("daily", "weekly", "monthly", "quarterly", "yearly")
  LOW_FREQ_VALS <- c("1 day", "1 week", "1 month", "3 months", "1 year")
  HIGH_FREQUENCIES <- c("4_seconds", "minutely", "10_minutes", "half_hourly", "hourly")
  HIGH_FREQ_VALS <- c("4 sec", "1 min", "10 min", "30 min", "1 hour")
  FREQUENCIES <- c(LOW_FREQUENCIES, HIGH_FREQUENCIES)
  FREQ_VALS <- c(LOW_FREQ_VALS, HIGH_FREQ_VALS)


  # Create a hashmap containing possible frequency key-value pairs
  FREQ_MAP <- list()

  for(f in seq_along(FREQUENCIES))
    FREQ_MAP[[FREQUENCIES[f]]] <- FREQ_VALS[f]


  if(is.character(file)) {
    file <- file(file, "r")
    on.exit(close(file))
  }
  if(!inherits(file, "connection"))
    stop("Argument 'file' must be a character string or connection.")
  if(!isOpen(file)) {
    open(file, "r")
    on.exit(close(file))
  }

  # Read meta-data
  col_types <- list()
  metadata <- list()

  line <- readLines(file, n = 1) # n is no: of lines to read

  # Incrementally read metadata until @data line is read.
  while(length(line) && !grepl('^[[:space:]]*@data', line, perl = TRUE)) {
    # If the line contains metadata (line starting with @), store it
    if(grepl('^[[:space:]]*@', line, perl = TRUE)) {
      # Read separate words from line
      line <- scan(text = line, what = character(), quiet = TRUE) # Creating a vector containing the words in a line (ex: "@attribute" "series_name" "string")

      # Column names / type
      if(line[1] == "@attribute"){
        if(length(line) != 3)  # Attributes must have both name and type
          stop("Invalid meta-data specification.")
        col_types[[line[2]]] <- line[3]
      } else {
        if(length(line) != 2) # Other meta-data have only values
          stop("Invalid meta-data specification.")
        metadata[[substring(line[1], 2)]] <- line[2]
      }
    }
    line <- readLines(file, n = 1)
  }

  if(length(line) == 0)
    stop("Missing data section.")
  if(length(col_types) == 0)
    stop("Missing attribute section.")

  line <- readLines(file, n = 1)

  if(length(line) == 0)
    stop("Missing series information under data section.")

  data <- list()

  # Get data
  while(length(line) != 0){
    row_data <- strsplit(line, ":")[[1]]

    if(length(row_data) != length(col_types)+1)
      stop("Missing attributes/values in series.")

    # Parse in data as numeric
    series <- scan(text = row_data[length(row_data)], sep=",",
                   na.strings = "?", quiet = TRUE)
    if(all(is.na(series)))
      stop("All series values are missing. A given series should contains a set of comma separated numeric values. At least one numeric value should be there in a series.")

    # Add attribute columns to data
    for(col in seq_along(col_types)){
      # This format supports 3 attribute types: string, numeric and date
      val <- if(col_types[[col]] == "date"){
        if(is.null(metadata$frequency)) stop("Frequency is missing.")
        if(metadata$frequency %in% HIGH_FREQUENCIES)
          start_time <- as.POSIXct(row_data[[col]], format = "%Y-%m-%d %H-%M-%S", tz = "UTC")
        else if(metadata$frequency %in% LOW_FREQUENCIES)
          start_time <- as.Date(row_data[[col]], format = "%Y-%m-%d %H-%M-%S")
        else
          stop("Invalid frequency.")

        if(is.na(start_time)) stop("Incorrect timestamp format. Specify your timestamps as YYYY-mm-dd HH-MM-SS")
        seq(start_time, length.out = length(series), by = FREQ_MAP[[metadata$frequency]])
      } else {
        if(col_types[[col]] == "numeric")
          as.numeric(row_data[[col]])
        else if(col_types[[col]] == "string")
          as.character(row_data[[col]])
        else
          stop("Invalid attribute type.")
      }

      # Add parsed value to dataset
      data[[names(col_types)[[col]]]] <-
        if(is.null(data[[names(col_types)[[col]]]]))
          rep(val, length.out = length(series))
        else
          c(data[[names(col_types)[[col]]]], rep(val, length.out = length(series)))
    }

    # Add series value column to data
    data[["value"]] <- c(data[["value"]], series)

    line <- readLines(file, n = 1)
  }

  data <- as.data.frame(data)
  attributes(data)[names(metadata)] <- metadata

  data
}

# Lookup table for file names from Zenodo IDs.
# Ideally this would be from the Zenodo API, but that requires auth.
mfr_ids <- c(
  "4656110" = "nn5_daily_dataset_with_missing_values",
  "4656117" = "nn5_daily_dataset_without_missing_values",
  "4656125" = "nn5_weekly_dataset",
  "4656193" = "m1_yearly_dataset",
  "4656154" = "m1_quarterly_dataset",
  "4656159" = "m1_monthly_dataset",
  "4656222" = "m3_yearly_dataset",
  "4656262" = "m3_quarterly_dataset",
  "4656298" = "m3_monthly_dataset",
  "4656335" = "m3_other_dataset",
  "4656379" = "m4_yearly_dataset",
  "4656410" = "m4_quarterly_dataset",
  "4656480" = "m4_monthly_dataset",
  "4656522" = "m4_weekly_dataset",
  "4656548" = "m4_daily_dataset",
  "4656589" = "m4_hourly_dataset",
  "4656103" = "tourism_yearly_dataset",
  "4656093" = "tourism_quarterly_dataset",
  "4656096" = "tourism_monthly_dataset",
  "4656022" = "car_parts_dataset_with_missing_values",
  "4656021" = "car_parts_dataset_without_missing_values",
  "4656014" = "hospital_dataset",
  "4654822" = "weather_dataset",
  "4654802" = "dominick_dataset",
  "4654833" = "fred_md_dataset",
  "4656144" = "solar_10_minutes_dataset",
  "4656151" = "solar_weekly_dataset",
  "4656027" = "solar_4_seconds_dataset",
  "4656032" = "wind_4_seconds_dataset",
  "4654773" = "sunspot_dataset_with_missing_values",
  "4654722" = "sunspot_dataset_without_missing_values",
  "4654909" = "wind_farms_minutely_dataset_with_missing_values",
  "4654858" = "wind_farms_minutely_dataset_without_missing_values",
  "4656069" = "elecdemand_dataset",
  "4656049" = "us_births_dataset",
  "4656058" = "saugeenday_dataset",
  "4656009" = "covid_deaths_dataset",
  "4656042" = "cif_2016_dataset",
  "4656072" = "london_smart_meters_dataset_with_missing_values",
  "4656091" = "london_smart_meters_dataset_without_missing_values",
  "4656080" = "kaggle_web_traffic_dataset_with_missing_values",
  "4656075" = "kaggle_web_traffic_dataset_without_missing_values",
  "4656664" = "kaggle_web_traffic_weekly_dataset",
  "4656132" = "traffic_hourly_dataset",
  "4656135" = "traffic_weekly_dataset",
  "4656140" = "electricity_hourly_dataset",
  "4656141" = "electricity_weekly_dataset",
  "4656626" = "pedestrian_counts_dataset",
  "4656719" = "kdd_cup_2018_dataset_with_missing_values",
  "4656756" = "kdd_cup_2018_dataset_without_missing_values",
  "4659727" = "australian_electricity_demand_dataset",
  "4663762" = "covid_mobility_dataset_with_missing_values",
  "4663809" = "covid_mobility_dataset_without_missing_values"
)
