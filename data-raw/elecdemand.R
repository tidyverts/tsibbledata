elecdemand <- fpp2::elecdemand
elecdemand <- tsibble::as_tsibble(elecdemand, gather = FALSE)
usethis::use_data(elecdemand, overwrite=TRUE)
