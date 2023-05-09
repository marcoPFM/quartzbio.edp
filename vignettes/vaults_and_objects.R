## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
Sys.unsetenv('EDP_PROFILE')

## ---- tltr--------------------------------------------------------------------
library(quartzbio.edp)
Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
Sys.getenv('EDP_PROFILE')

vlts <- Vaults()
u <- User()
u$first_name
vme <- Vault_create(paste0('vault_', u$first_name))

Vault(id = vme)
Folder_create(vme, 'data/cyto')
Folder_create(vme, 'data/flow')
Folder_create(vme, 'source/code')
Folders(vault_id=vme)

delete(vme)

## ----user---------------------------------------------------------------------
library(quartzbio.edp)
# select an EDP instance using a profile

u <- User()
u$first_name
u$last_name
u$full_name
u$id
u$email
u$account$name
u$url


## ---- vaults-0----------------------------------------------------------------
library(quartzbio.edp)
# select an EDP instance using a profile
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
# fetch personnal vault info
myV <- Vault()
# personal vault: user-id
myV$name
myV$full_path 
myV$has_children  
myV$has_folder_children
myV$user$full_name
myV$permissions

## ----vaults-1-----------------------------------------------------------------
# create a vault
v <- Vault_create('vault_test_1', description = 'test_1', tags = list('tag1', 'tag2'))
v$name
v$full_path

# retrieve a vault by name
Vault(name = 'vault_test_1')

# retrieve a vault by full_path
Vault(full_path = v$full_path)

v$description
v$metadata
v$tags

# update metadata
new_name <- 'test_one'
v2 <- Vault_update(v, 
      name = new_name, 
      description = 'barabor', 
      metadata = list(meta_1 = 'foo'), 
      storage_class = 'Performance', tags = 'tag_A')

v3 <- update(v2, storage_class = 'Temporary')


## ----vaults-2-----------------------------------------------------------------
# get the firt two ordered vaults
vs1 <- Vaults(limit = 2, page = 1)

# get the the third and fourth vault
Vaults(limit = 2, page = 2)

# same as above
vs2 <- fetch_next(vs1)
vs2

# fetch all remaining vaults by pages of size 2
all_vlts <- fetch_all(vs1)
all_vlts_df <- as.data.frame(all_vlts)

# delete vault
delete(v)

## ----folders-1----------------------------------------------------------------
# list all folders in an account
all_folders <- Folders()

# get first four
Folders(limit = 4)

# create folder with description and tags
v1 <- Vault_create('_an_upload',  description = 'upload', tags = list('fake', 'can_be_removed'))
fdata <- Folder_create(v1, 'data')
fdata

# CAUTION, no overwritting per default, folders are renamed incrementally
# a new folder data-1 is created
Folder_create(v1, 'data')

# create a hierarchy
Folder_create(v1, 'source/code')

# List folders of a given vault - recursive
Folders(vault_id = v1)

# List folders using regex on paths - recursive
Folders(regex = '^/data')
Folders(regex = 'code$')

# List folders matching paths - recursive
Folders(query = 'code')

# fetch a a folder from a given vault
Folder(vault_id = v1, path = 'data')

# fetch a folder with its full.path
Folder(full_path = fdata$full_path)
delete(v1)

