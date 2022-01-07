#' @importFrom rappdirs user_data_dir
tsibbledata_path <- function(...){
  path <- file.path(
    paste0(
      getOption("tsibbledata.path", default = rappdirs::user_data_dir("rpkg_tsibbledata")),
      .Platform$file.sep
    ),
    ...
  )
  dir.exists(dirname(path)) || dir.create(dirname(path), recursive = TRUE)
  path
}
