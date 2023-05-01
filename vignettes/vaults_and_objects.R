## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(quartzbio.edp)
# select an EDP instance using a profile
Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
Sys.getenv('EDP_PROFILE')
u <- User()
u$first_name
u$last_name
u$full_name
u$id
u$email
u$account$name
u$url


