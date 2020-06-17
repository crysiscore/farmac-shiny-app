
library(RPostgreSQL)
library(stringi)
library(stringdist)
library(dplyr)

setwd('~/Git/shinyapp/farmac/')
source('db_con_functions.R')

## con farmac_sync
local.postgres.user ='postgres'                         # ******** modificar
local.postgres.password='postgres'                      # ******** modificar
local.postgres.db.name='farmac_sync'                          # ******** modificar
local.postgres.host='172.18.0.3'                        # ******** modificar
local.postgres.port=5432                                # ******** modificar
