#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)


wd <- '~/Git/shinyapp/farmac/'
setwd(wd)
source('misc_scripts.R')


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    
    observeEvent(input$do, {

  
        
        patient_info <- df_reffered_patients %>% filter(patientid==input$nid) %>% select(patientid,firstnames,lastname,
                                                                                        dateofbirth,imported,clinicname,mainclinicname)
        
        if(nrow(patient_info)==0){
            output$txt_patientid <- renderText(patient_info$patientid[1])
            output$txt_firstnames <- renderText(patient_info$firstnames[1])
            output$txt_lastname <- renderText(patient_info$lastname[1])
            output$txt_dateofbirth <- renderText(substr(as.character(patient_info$dateofbirth[1]), 1,10))
            output$txt_mainclinicname <- renderText(patient_info$mainclinicname[1])
            output$txt_clinicname <- renderText(patient_info$clinicname[1])
            output$txt_imported <- renderText(patient_info$imported[1])
        } else if(nrow(patient_info)==1){
            output$txt_patientid <- renderText(patient_info$patientid[1])
            output$txt_firstnames <- renderText(patient_info$firstnames[1])
            output$txt_lastname <- renderText(patient_info$lastname[1])
            output$txt_dateofbirth <- renderText(substr(as.character(patient_info$dateofbirth[1]), 1,10))
            output$txt_mainclinicname <- renderText(patient_info$mainclinicname[1])
            output$txt_clinicname <- renderText(patient_info$clinicname[1])
            if(is.na(patient_info$imported[1])){
                output$txt_imported <- renderText("Nao")
            } else{
                output$txt_imported <- renderText(patient_info$imported[1])
            }
             df_pat_dispenses <-  df_patient_dispenses %>% filter(patientid==input$nid) %>% select(dispensedate,
                                                                                                       regimeid,dispensatrimestral,drugname,
                                                                                                       dateexpectedstring) %>% arrange(dispensedate)
        
            if(nrow(df_pat_dispenses)>0){
              df_pat_dispenses <- distinct(df_pat_dispenses,as.Date(dispensedate), drugname, dateexpectedstring, .keep_all = TRUE )
              df_pat_dispenses$'as.Date(dispensedate)' <- NULL
              
                df_pat_dispenses$dispensedate <- substr(as.character(df_pat_dispenses$dispensedate),1,10)
                names(df_pat_dispenses)[1]<- "Data dispensa"
                names(df_pat_dispenses)[2]<- "Regime"
                names(df_pat_dispenses)[4]<- "ARV"
                names(df_pat_dispenses)[5]<- "Data Prox. Consulta"
                output$df_dispenses <- renderTable(df_pat_dispenses)
            }
          
        } 
        
    })

})
