#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tags$head(
        tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
        h7 {
     text-align:left;
        }
      
      h7 {
     text-align:right;
      }

    "))
    ),
    
    # Application title
    titlePanel("Pacientes Farmac"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput('nid', 'NID: ', value = "", width = NULL,
                     placeholder = 'NID do Paciente'),
            actionButton("do", "Pesquisar")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(1, h5("NID:") ),
                column(4, offset = 1, h6(textOutput("txt_patientid")) )
                # 
                # column(4,
                #        h4("NID:"),
                #        h4(textOutput("txt_patientid")),
                #        h4("Nome:"),
                #        h4(textOutput("txt_firstnames")),
                #        h4("Apelido:"),
                #        h4(textOutput("txt_lastname")),
                #        h4("Data Nasc:"),
                #        h4(textOutput("txt_dateofbirth")),
                #        h4("Proveniencia:"),
                #        h4(textOutput("txt_mainclinicname")),
                #        h4("Referido Para:"),
                #        h4(textOutput("txt_clinicname")),
                #        h4("Importado Farmac:"),
                #        h4(textOutput("txt_imported")),
                #        br())
            ),
            fluidRow(
                column(1, h5("Nome:") ),
                column(4, offset = 1, h6(textOutput("txt_firstnames")) )
            ),
            fluidRow(
                column(1, h5("Apelido:") ),
                column(4, offset = 1, h6(textOutput("txt_lastname")) )
            ),
            fluidRow(
                column(1, h5("Data_Nasc:") ),
                column(4, offset = 1, h6(textOutput("txt_dateofbirth")) )
            ),
            fluidRow(
                column(1, h5("Proveniencia:") ),
                column(4, offset = 1, h6(textOutput("txt_mainclinicname")) )
            ),
            fluidRow(
                column(1, h5("Referido_Para:") ),
                column(4, offset = 1, h5(textOutput("txt_clinicname")) )
            ),
            fluidRow(
                column(1, h5("Importado_Farmac:") ),
                column(4, offset = 1, h6(textOutput("txt_imported")) ),
                br(),
                br()
            ),
            fluidRow(
              column(1, h5("") ),
              column(4, h5("") )
         
            ),
            fluidRow(
              column(1, h5("") ),
              column(4, h5("") )
              
            ),
            fluidRow(
            tableOutput('df_dispenses') )
        )
    )
))
