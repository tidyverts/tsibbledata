library(rlang)
data_env <- new.env()
lapply(list.files("data/", full.names = TRUE), load, envir = data_env)
env_bind(data_env, !!!lapply(data_env, function(data){
  as_tsibble(as_tibble(data),
             regular = !is_empty(interval(data)),
             index = index_var(data),
             key = vapply(key(data), as_string, character(1L))
  )
}))
lapply(ls(data_env), function(data) {
  eval_tidy(expr(
    usethis::use_data(
      !!sym(data),
      overwrite = TRUE
    )
  ), env = data_env)
})
