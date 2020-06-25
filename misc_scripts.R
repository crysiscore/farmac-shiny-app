
library(RPostgreSQL)
#library(stringi)
#library(stringdist)
library(dplyr)

source('db_con_functions.R')

## con farmac_sync
local.postgres.user ='postgres'                         # ******** modificar
local.postgres.password='postgres'                      # ******** modificar
local.postgres.db.name='pharm'                          # ******** modificar
local.postgres.host='172.17.0.2'                        # ******** modificar
local.postgres.port=5432                                # ******** modificar
