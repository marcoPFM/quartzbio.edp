## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(quartzbio.edp)
Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
Sys.getenv('EDP_PROFILE')
get_connection()

## ---- include = FALSE, echp = FALSE, message = FALSE,warning = FALSE----------
Sys.unsetenv('EDP_PROFILE')

