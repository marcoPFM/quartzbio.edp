## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
Sys.unsetenv('EDP_PROFILE')

## -----------------------------------------------------------------------------

# by default all functions will use the default profile set in the default config file
library(quartzbio.edp)
User()
vlst <- Vaults()
vlst[[1]]

flds <- Folders()
flds[[1]]

fis  <- Files()
fis[[1]]

das  <-Datasets()
das[[1]]


## -----------------------------------------------------------------------------
library(quartzbio.edp)
# use the default profile  on host https://api.solvebio.com
conn <- connect_with_profile()
User(conn)

#> use  profile named demo-corp that is dedined in the default config file
conn <- connect_with_profile('demo-corp')
User(conn)
Vaults(conn = conn)

## -----------------------------------------------------------------------------
#> set the demo-corp connection as the default for future connections
Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'demo-corp')
conn <- connect_with_profile()
User(conn)


## -----------------------------------------------------------------------------
conn <- read_connection_profile('default')
secret <- conn$secret
host <- conn$host
conn <- connect(secret, host)
User(conn)


## -----------------------------------------------------------------------------
Sys.setenv(EDP_PROFILE = 'demo-corp')
conn <- autoconnect()
User(conn=conn)

# unset the EDP_PROFILE environment variable
# autoconnect() use the default settings.
Sys.unsetenv('EDP_PROFILE')
conn <- autoconnect()
User(conn=conn)



## -----------------------------------------------------------------------------
# explicitely set the connection with a profile
set_connection( connect_with_profile('demo-corp'))

# remove the current connection
set_connection(NULL, check = FALSE)

# the firt call to User() sets the current default connection to the default connection
# both calls will use the current connection
User()
User(conn = get_connection())

# the current connection remains the 'default'
# connecting with a profile did not change it
conn_corp <- connect_with_profile('demo-corp')
User(conn_corp)
User()

Sys.setenv(EDP_PROFILE = 'demo-corp')

# remove the current connection
set_connection(NULL, check = FALSE)

# the current connection is now the 'demo-corp' one 
User()
User(conn_corp)


