#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# remotes::install_github("paulc91/shinyauthr")
# ------------------------- ANTICONF ERROR ---------------------------
#   Configuration failed because libsodium was not found. Try installing:
#   * deb: libsodium-dev (Debian, Ubuntu, etc)
#  sudo apt-get install libsodium-dev

library(dplyr)
library(RPostgreSQL)


wd <- '/data'
setwd(wd)
source('misc_scripts.R')

# data.frame with credentials info
credentials <- data.frame(
  user = c("admin", "farmac", "farmacia", "idart"),
  password = c("arv", "idart", "farmacia", "farmac"),
  password = c("arv", "arm", "farmacia", "farmac"),
  # comment = c("alsace", "auvergne", "bretagne"), %>% 
  stringsAsFactors = FALSE
)



con_farmac_sync  <-  getLocalServerCon()


# Define server logic required
shinyServer(function(input, output , session) {

  
  result_auth <- secure_server(check_credentials = check_credentials(credentials))
  
  # output$res_auth <- renderPrint({
  #   reactiveValuesToList(result_auth)
  # })
  

  
  
  df_reffered_patients <- reactivePoll(1800000, session,
                      
                       checkFunc = function() {
                         
                         # nrows <- dbGetQuery(con_farmac_sync, " select count(*)  as total from sync_temp_patients ;")
                         # print(nrows$total)
                         print("checking")
                       },
                       # This function returns the content of sync_temp_patients
                       valueFunc = function() {
                         RPostgreSQL::dbGetQuery(con_farmac_sync, " select * from sync_temp_patients ;")
                       }
  )
  df_patient_dispenses <- reactivePoll(1800000, session,
                               
                                       checkFunc = function() {
                                         # nrows <- dbGetQuery(con_farmac_sync, " select count(*)  as total from sync_temp_dispense ;")
                                         # print(nrows$total)
                                         print("checking")
                                       },
                                       # This function returns the content of sync_temp_dispense
                                       valueFunc = function() {
                                         RPostgreSQL::dbGetQuery(con_farmac_sync, " select * from sync_temp_dispense ;")
                                       }
  )
    
  observeEvent(input$do, {
    
    
    patient_info <- df_reffered_patients() %>% filter(patientid==input$nid) %>% select(patientid,firstnames,lastname,
                                                                                       dateofbirth,imported,clinicname,mainclinicname)
    
    if(nrow(patient_info)==0){
      
      df_pat_dispenses <-  df_patient_dispenses() %>% filter(patientid==input$nid) %>% select(dispensedate,
                                                                                              regimeid,dispensatrimestral,drugname,
                                                                                              dateexpectedstring) %>% arrange(dispensedate)
      
      if(nrow(df_pat_dispenses)>0){
        
        output$txt_patientid <- renderText(df_pat_dispenses$patientid[1])
        output$txt_firstnames <- renderText(df_pat_dispenses$patientfirstname[1])
        output$txt_lastname <- renderText(df_pat_dispenses$patientlastname[1])
        # txt_dateofbirth nao existe na tabela sync_temp_dispense
        #output$txt_dateofbirth <- renderText(substr(as.character(patient_info$dateofbirth[1]), 1,10))
        output$txt_mainclinicname <- renderText(patient_info$sync_temp_dispenseid[1])
        output$txt_clinicname <- renderText(patient_info$clinic_name_farmac[1])
        output$txt_imported <- renderText("sim")
        
        
        df_pat_dispenses$dispensedate <- substr(as.character(df_pat_dispenses$dispensedate),1,10)
        df_pat_dispenses <- distinct(df_pat_dispenses,as.Date(dispensedate), drugname, dateexpectedstring, .keep_all = TRUE )
        df_pat_dispenses$'as.Date(dispensedate)' <- NULL
        
        
        names(df_pat_dispenses)[1]<- "Data dispensa"
        names(df_pat_dispenses)[2]<- "Regime"
        names(df_pat_dispenses)[4]<- "ARV"
        names(df_pat_dispenses)[5]<- "Data Prox. Consulta"
        df_pat_dispenses <- df_pat_dispenses[0,]
        output$df_dispenses <- renderTable(df_pat_dispenses)
        
      } else {
        
        output$txt_patientid <- renderText(patient_info$patientid[1])
        output$txt_firstnames <- renderText(patient_info$firstnames[1])
        output$txt_lastname <- renderText(patient_info$lastname[1])
        output$txt_dateofbirth <- renderText(substr(as.character(patient_info$dateofbirth[1]), 1,10))
        output$txt_mainclinicname <- renderText(patient_info$mainclinicname[1])
        output$txt_clinicname <- renderText(patient_info$clinicname[1])
        output$txt_imported <- renderText(patient_info$imported[1])
        output$df_dispenses <- renderTable(df_pat_dispenses)
      }
      
    } else if(nrow(patient_info)==1){
      output$txt_patientid <- renderText(patient_info$patientid[1])
      output$txt_firstnames <- renderText(patient_info$firstnames[1])
      output$txt_lastname <- renderText(patient_info$lastname[1])
      output$txt_dateofbirth <- renderText(substr(as.character(patient_info$dateofbirth[1]), 1,10))
      output$txt_mainclinicname <- renderText(patient_info$mainclinicname[1])
      output$txt_clinicname <- renderText(patient_info$clinicname[1])
      if(is.na(patient_info$imported[1]) | patient_info$imported[1]=='' ){
        output$txt_imported <- renderText("Nao")
      } else{
        output$txt_imported <- renderText("Sim")
      }
      df_pat_dispenses <-  df_patient_dispenses() %>% filter(patientid==input$nid) %>% select(dispensedate,
                                                                                              regimeid,dispensatrimestral,drugname,
                                                                                              dateexpectedstring) %>% arrange(dispensedate)
      
      if(nrow(df_pat_dispenses)>0){
        
        df_pat_dispenses$dispensedate <- substr(as.character(df_pat_dispenses$dispensedate),1,10)
        df_pat_dispenses <- distinct(df_pat_dispenses,as.Date(dispensedate), drugname, dateexpectedstring, .keep_all = TRUE )
        df_pat_dispenses$'as.Date(dispensedate)' <- NULL
        
        
        names(df_pat_dispenses)[1]<- "Data dispensa"
        names(df_pat_dispenses)[2]<- "Regime"
        names(df_pat_dispenses)[4]<- "ARV"
        names(df_pat_dispenses)[5]<- "Data Prox. Consulta"
        output$df_dispenses <- renderTable(df_pat_dispenses)
      }
      
    } 
    
  })
  
  
  
  dispenses <-   dbGetQuery(con_farmac_sync, " select * from sync_temp_dispense ;")
  no_dups_dispenses <- distinct(dispenses,as.Date(dispensedate), drugname, patientid , .keep_all = TRUE )
  names(no_dups_dispenses)[48] <- "d_dispensedate"
  today= Sys.Date()
  no_dups_dispenses   <- no_dups_dispenses %>% filter(d_dispensedate <= today)  %>% arrange(patientid,desc(dispensedate)) 
  
  # Total de pacientes com pelo menos um levantamento
  total_pat_dispensa <- no_dups_dispenses %>% distinct(patientid, .keep_all = TRUE )  %>%  group_by(clinic_name_farmac)  %>%  summarise(total_pacientes_dispensados = n())
  names(total_pat_dispensa)[1] <- "Farmacia"
  
  # Total de pacientes Referidos por Farmac
  patients <- dbGetQuery(con_farmac_sync, " select * from sync_temp_patients ;")
  total_pat_farmac <- patients %>% distinct(patientid, .keep_all = TRUE )  %>%  group_by(clinicname)  %>%  summarise(total_referidos = n())
  names(total_pat_farmac)[1]<- "Farmacia"
  
  # Total de pacientes Referidos por US
  total_pat_us    <- patients %>% distinct(patientid, .keep_all = TRUE )  %>%  group_by(mainclinicname)  %>%  summarise(total_referidos = n())
  names(total_pat_us)[1]<- "Unidade_Sanitaria"
  
  # Sumario 
  
  output$df_referidos <- renderTable(total_pat_us)
  sumario <- bind_cols(total_pat_farmac,total_pat_dispensa) %>% select(Farmacia, total_referidos,total_pacientes_dispensados)
  output$df_resumo <- renderTable(sumario)
  
    #on.exit(dbDisconnect(con_farmac_sync), add = TRUE)
})
