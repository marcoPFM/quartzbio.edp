## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
Sys.unsetenv('EDP_PROFILE')

## ----tltr_1-------------------------------------------------------------------
library(quartzbio.edp)
Sys.setenv(EDP_PROFILE = "vsim-dev_rw")
v <- Vault_create('_vignettes',  description = 'quartzbio.edp vignettes',  tags = list('please_removed'))
src_dir <- Folder_create(vault_id = v, 'src') 
datasets_dir <- Folder_create(vault_id = v, 'datasets')


