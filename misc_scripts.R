
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
local.postgres.host='localhost'                        # ******** modificar
local.postgres.port=5432                                # ******** modificar
con_farmac_sync  <-  getLocalServerCon()


df_reffered_patients <- dbGetQuery(con_farmac_sync, " select * from sync_temp_patients ;")
df_patient_dispenses <- dbGetQuery(con_farmac_sync, " select * from sync_temp_dispense ;")
df_log_referencia <- dbGetQuery(con_farmac_sync, " select * from logdispense ;")

