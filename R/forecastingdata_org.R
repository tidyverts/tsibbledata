## Functions to download data files from Monash Time Series Forecasting Archive, https://zenodo.org/communities/forecasting
## Fore more details, please visit to https://forecastingdata.org/


#' convert_tsf_to_tsibble function
#'
#' This function converts the contents in a .tsf file into a tsibble or a dataframe and returns it along with other meta-data of the dataset: frequency, horizon, whether the dataset contains missing values and whether the series have equal lengths.
#'
#' @param file .tsf file path
#' @param value_column_name Any name that is preferred to have as the name of the column containing series values in the returning tsibble.
#' @param key The name of the attribute that should be used as the key when creating the tsibble. If doesn't provide, a data frame will be returned instead of a tsibble.
#' @param index The name of the time attribute that should be used as the index when creating the tsibble. If doesn't provide, it will search for a valid index. When no valid index found, a data frame will be returned instead of a tsibble.
#'
#' @return This function returns a tsibble or a dataframe based on the validity of given key and index values.
#' @export
convert_tsf_to_tsibble <-   function(file, value_column_name = "series_value", key = NULL, index = NULL){
  options(pillar.sigfig = 7)
  
  
  # Extend these frequency lists as required
  LOW_FREQUENCIES <- c("4_seconds", "minutely", "10_minutes", "half_hourly", "hourly")
  LOW_FREQ_VALS <- c("4 sec", "1 min", "10 min", "30 min", "1 hour")
  HIGH_FREQUENCIES <- c("daily", "weekly", "monthly", "quarterly", "yearly")
  HIGH_FREQ_VALS <- c("1 day", "1 week", "1 month", "3 months", "1 year")
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
  col_names <- NULL
  col_types <- NULL
  frequency <- NULL
  forecast_horizon <- NULL
  contain_missing_values <- NULL
  contain_equal_length <- NULL
  index_var <- NULL
  
  line <- readLines(file, n = 1) # n is no: of lines to read
  
  while(length(line) && regexpr('^[[:space:]]*@data', line, perl = TRUE) == -1) { # Until read @data, run this loop (-1 indicate no match with the regular expression yet)
    
    if(regexpr('^[[:space:]]*@', line, perl = TRUE) > 0) { # This condition will be true for lines starting with @
      
      con <- textConnection(line)
      line <- scan(con, character(), quiet = TRUE) # Creating a vector containing the words in a line (ex: "@attribute" "series_name" "string")
      close(con)
      
      if(line[1] == "@attribute"){
        if(length(line) != 3)  # Attributes have both name and type
          stop("Invalid meta-data specification.")
        
        if(is.null(index) & line[3] == "date") # Searching for a valid index, if index is not given 
          index_var <- line[2]
        
        col_names <- c(col_names, line[2])
        col_types <- c(col_types, line[3])
      }else{
        if(length(line) != 2) # Other meta-data have only values
          stop("Invalid meta-data specification.")
        
        if(line[1] == "@frequency")
          frequency <- line[2]
        else if(line[1] == "@horizon")
          forecast_horizon <- as.numeric(line[2])
        else if(line[1] == "@missing")
          contain_missing_values <- as.logical(line[2])
        else if(line[1] == "@equallength")
          contain_equal_length <- as.logical(line[2])
      }
    }
    line <- readLines(file, n = 1)
  }
  
  if(length(line) == 0)
    stop("Missing data section.")
  if(is.null(col_names))
    stop("Missing attribute section.")
  
  line <- readLines(file, n = 1)
  
  if(length(line) == 0)
    stop("Missing series information under data section.")
  
  for(col in col_names)
    assign(col, NULL)
  
  values <- NULL
  row_count <- 0
  
  # Get data
  while(length(line) != 0){
    full_info <- strsplit(line, ":")[[1]]
    
    if(length(full_info) != length(col_names)+1)
      stop("Missing attributes/values in series.")
    
    series <- as.numeric(strsplit(tail(full_info, 1), ",")[[1]])
    
    if(sum(is.na(series)) == length(series))
      stop("All series values are missing. A given series should contains a set of comma separated numeric values. At least one numeric value should be there in a series.")
    
    values <- c(values, series)
    row_count <- row_count + length(series)
    
    attributes <- head(full_info, length(full_info)-1)
    
    for(col in seq_along(col_names)){
      
      att <- eval(parse(text=col_names[col]))
      
      # This format supports 3 attribute types: string, numeric and date
      if(col_types[col] == "date"){
        if(is.null(frequency))
          stop("Frequency is missing.")
        else{
          if(frequency %in% LOW_FREQUENCIES)
            start_time <- as.POSIXct(attributes[col], format = "%Y-%m-%d %H-%M-%S")
          else if(frequency %in% HIGH_FREQUENCIES)
            start_time <- as.Date(attributes[col], format = "%Y-%m-%d %H-%M-%S")
          else
            stop("Invalid frequency.")
          
          if(is.na(start_time))
            stop("Incorrect timestamp format. Specify your timestamps as YYYY-mm-dd HH-MM-SS")
        }
        
        att <- append(att, seq(start_time, length = length(series), by = FREQ_MAP[[frequency]]))
      }else{
        if(col_types[col] == "numeric")
          attributes[col] <- as.numeric(attributes[col])
        else if(col_types[col] == "string")
          attributes[col] <- as.character(attributes[col])
        else
          stop("Invalid attribute type.")
        
        if(is.na(attributes[col]))
          stop("Invalid attribute values.")
        
        att <- append(att, rep(attributes[col], length(series)))
      }
      assign(col_names[col], att)
    }
    
    line <- readLines(file, n = 1)
  }
  
  data <- as.data.frame(matrix(nrow = row_count, ncol = length(col_names) + 1))
  colnames(data) <- c(col_names, value_column_name)
  
  for(col in col_names)
    data[[col]] <- eval(parse(text = col))
  
  data[[value_column_name]] <- values
  
  if(!(is.null(key))){
    if(!(key %in% col_names))
      stop("Invalid key. Cannot convert data into tsibble format.")
    else{
      if(is.null(index)){
        if(is.null(index_var))
          cat("Index is not provided. No valid index found in data. Returning a dataframe.")
        else
          data <- tsibble:::build_tsibble(x = data, key = key, index = index_var, ordered = F)
      }else{
        if(!(index %in% col_names))
          stop("Invalid index Cannot convert data into tsibble format.")
        else
          data <- tsibble:::build_tsibble(x = data, key = key, index = index, ordered = F)
      }
    }
  }else{
    cat("Key is not provided. Returning a dataframe.")
  }
  
  list(data, frequency, forecast_horizon, contain_missing_values, contain_equal_length)
}



#' download_data function
#' 
#' This function downloads a zip file from Zenodo platform given the record identifier and file name, unzip the contents and converts the unzipped .tsf file into a tsibble or a dataframe given the key and index.
#' 
#' @param record_id Record identifier of the file that needs to be downloaded from Zenodo.
#' @param file_name Name of the file (without extensions) that needs to be downloaded from Zenodo.
#' @param destination_folder Folder path where the downloaded files need to be stored. By default, it uses the R working directory to store files.
#' @param index The name of the time attribute that should be used as the index when creating the tsibble. If doesn't provide, it tries to find a valid index within the data. If there is no valid index, then a data frame will be returned instead of a tsibble.
#' @param key The name of the attribute that should be used as the key when creating the tsibble. The default value is "series_name" which is the key of the datasets in our repository. If doesn't provide, a data frame will be returned instead of a tsibble.
#' @param value_column_name Any name that is preferred to have as the name of the column containing series values in the returning tsibble.
#'
#' @return This function returns a tsibble or a dataframe based on the validity of given key and index values.
#' @export
download_data <- function(record_id, file_name, destination_folder = '', index = NULL, key = "series_name", value_column_name = "series_value"){
  
  if(is.null(record_id) | is.na(as.numeric(record_id)))
    stop("Please provide the ID of the dataset that you need to download. This should be a numerical value.")
  
  if(is.null(file_name) | is.na(as.character(file_name)))
    stop("Please provide the file name of the dataset that you need to download. This should be a character/string value.")
  
  # Check whether the destination folder exists. If not create a folder at the specified path
  if(destination_folder != '' & !file.exists(destination_folder)){
    tryCatch({
      dir.create(destination_folder)
    }, error = function(e) {   
      message(e)
      stop("Please provide a valid path/name for destination folder")
    })
  }
    
  if(destination_folder == ''){  
    dest_file <- paste0(file_name, ".zip")
    tsf_file <- paste0(file_name, ".tsf")
  }else{  
    dest_file <- file.path(destination_folder, paste0(file_name, ".zip"))
    tsf_file <- file.path(destination_folder, paste0(file_name, ".tsf"))
  }
  
  
  if(!file.exists(tsf_file)){ # Check whether the required .tsf file is already there at the specified destination folder
    if(!file.exists(dest_file)){ # Check whether the required .zip file is already there at the specified destination folder. If not download the .zip file from Zenodo
      tryCatch({
        download.file(paste0("https://zenodo.org/record/", record_id, "/files/", file_name, ".zip"), destfile = dest_file)
      }, error = function(e) {   
        message(e)
        stop("Record ID or file name is incorrect")
      })
    }
    
    if(destination_folder != '') # Unzip the downloaded .zip folder
      unzip(dest_file, exdir = destination_folder)
    else
      unzip(dest_file)
  }
 
  convert_tsf_to_tsibble(tsf_file, value_column_name, key, index) # Creating a tsibble/dataframe depending on the provided key and index
}



#' get_forecastingdata function
#' 
#' This function downloads a zip file from Zenodo platform given the name of the dataset, unzip the contents and converts the unzipped .tsf file into a tsibble or a dataframe given the key and index.
#' 
#' @param dataset Name of the dataset that needs to be downloaded from Zenodo.
#' @param destination_folder Folder path where the downloaded files need to be stored. By default, it uses the R working directory to store files.
#' @param index The name of the time attribute that should be used as the index when creating the tsibble. If doesn't provide, it tries to find a valid index within the data. If there is no valid index, then a data frame will be returned instead of a tsibble.
#' @param key The name of the attribute that should be used as the key when creating the tsibble. The default value is "series_name" which is the key of the datasets in our repository. If doesn't provide, a data frame will be returned instead of a tsibble.
#' @param value_column_name Any name that is preferred to have as the name of the column containing series values in the returning tsibble.
#'
#' @return This function returns a tsibble or a dataframe based on the validity of given key and index values.
#' @export
get_forecastingdata <- function(dataset, destination_folder = '', index = NULL, key = "series_name", value_column_name = "series_value"){
 
  # Current datasets in archive
  forecastingdata <- readr:::read_csv(
     "prefix,record_id,file_name
      nn5,4656110,nn5_daily_dataset_with_missing_values
      nn5_without_missing,4656117,nn5_daily_dataset_without_missing_values
      nn5_weekly,4656125,nn5_weekly_dataset
      m1_yearly,4656193,m1_yearly_dataset
      m1_quarterly,4656154,m1_quarterly_dataset
      m1_monthly,4656159,m1_monthly_dataset
      m3_yearly,4656222,m3_yearly_dataset
      m3_quarterly,4656262,m3_quarterly_dataset
      m3_monthly,4656298,m3_monthly_dataset
      m3_other,4656335,m3_other_dataset
      m4_yearly,4656379,m4_yearly_dataset
      m4_quarterly,4656410,m4_quarterly_dataset
      m4_monthly,4656480,m4_monthly_dataset
      m4_weekly,4656522,m4_weekly_dataset
      m4_daily,4656548,m4_daily_dataset
      m4_hourly,4656589,m4_hourly_dataset
      tourism_yearly,4656103,tourism_yearly_dataset
      tourism_quarterly,4656093,tourism_quarterly_dataset
      tourism_monthly,4656096,tourism_monthly_dataset
      carparts,4656022,car_parts_dataset_with_missing_values
      carparts_without_missing,4656021,car_parts_dataset_without_missing_values
      hospital,4656014,hospital_dataset
      weather,4654822,weather_dataset
      dominick,4654802,dominick_dataset
      fred-md,4654833,fred_md_dataset
      solar_10_minutes,4656144,solar_10_minutes_dataset
      solar_weekly,4656151,solar_weekly_dataset
      solar_4_seconds,4656027,solar_4_seconds_dataset
      wind_4_seconds,4656032,wind_4_seconds_dataset
      sunspot,4654773,sunspot_dataset_with_missing_values
      sunspot_without_missing,4654722,sunspot_dataset_without_missing_values
      wind_farms,4654909,wind_farms_minutely_dataset_with_missing_values
      wind_farms_without_missing,4654858,wind_farms_minutely_dataset_without_missing_values
      elecdemand,4656069,elecdemand_dataset
      us_births,4656049,us_births_dataset
      saugeenday,4656058,saugeenday_dataset
      covid,4656009,covid_deaths_dataset
      cif,4656042,cif_2016_dataset
      london_smart_meters,4656072,london_smart_meters_dataset_with_missing_values
      london_smart_meters_without_missing,4656091,london_smart_meters_dataset_without_missing_values
      web_traffic,4656080,kaggle_web_traffic_dataset_with_missing_values
      web_traffic_without_missing,4656075,kaggle_web_traffic_dataset_without_missing_values
      web_traffic_weekly,4656664,kaggle_web_traffic_weekly_dataset
      traffic_hourly,4656132,traffic_hourly_dataset
      traffic_weekly,4656135,traffic_weekly_dataset
      electricity_hourly,4656140,electricity_hourly_dataset
      electricity_weekly,4656141,electricity_weekly_dataset
      pedestrians,4656626,pedestrian_counts_dataset
      kdd,4656719,kdd_cup_2018_dataset_with_missing_values
      kdd_without_missing,4656756,kdd_cup_2018_dataset_without_missing_values"
  )
  
  if(dataset %in% forecastingdata$prefix){
    required_dataset <- dplyr:::filter(forecastingdata, prefix == dataset,)
    record_id <- required_dataset$record_id
    file_name <- required_dataset$file_name
    
    download_data(record_id, file_name, destination_folder, index, key, value_column_name)
  }else{
    message (paste("Invalid dataset. Current archive datasets are as follows. If your dataset is not there in the below list, retrieve the record_id and file name from Zenodo and use the download_data function."))
    stop(paste(forecastingdata$prefix, collapse=" "))
  }
}



