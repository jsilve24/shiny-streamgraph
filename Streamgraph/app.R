#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(streamgraph)
library(lazyeval)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Streamgraph"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
     sidebarPanel(
       fileInput('file1', 'Choose CSV File',
                 accept=c('text/csv', 
                          'text/comma-separated-values,text/plain', 
                          '.csv')),
       tags$hr(),
       checkboxInput('header', 'Header', TRUE),
       radioButtons('sep', 'Separator',
                    c(Comma=',',
                      Semicolon=';',
                      Tab='\t'),
                    ','),
       radioButtons('quote', 'Quote',
                    c(None='',
                      'Double Quote'='"',
                      'Single Quote'="'"),
                    '"'),
       tags$br(),
       uiOutput("tSelector"), 
       uiOutput("nSelector"), 
       uiOutput("labelSelector")
       # radioButtons('tidyformat', 'Tidy Format', 
       #              c('Wide'='wide', 
       #                'Long'='long'),
       #              'long')
     ),
      
      # Show a plot of the generated distribution
      mainPanel(
         streamgraphOutput("streamPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
   # Read data
   Data <- reactive({
     
     # input$file1 will be NULL initially. After the user selects
     # and uploads a file, it will be a data frame with 'name',
     # 'size', 'type', and 'datapath' columns. The 'datapath'
     # column will contain the local filenames where the data can
     # be found.
     inFile <- input$file1
     
     if (is.null(inFile))
       return(NULL)
     
     read.csv(inFile$datapath, header=input$header, sep=input$sep,
              quote=input$quote)
     
     # Tidy data as needed
     # Not implemented yet
   })
   
   # Get column names
   output$tSelector <- renderUI({
     if (is.null(Data())) opts <- ''
     else opts <- colnames(Data())
     selectInput("t", "Select time variable", opts)
   })
   # Get column names
   output$nSelector <- renderUI({
     if (is.null(Data())) opts <- ''
     else opts <- colnames(Data())
     selectInput("n", "Select width variable", opts)
   })
   # Get column names
   output$labelSelector <- renderUI({
     if (is.null(Data())) opts <- ''
     else opts <- colnames(Data())
     selectInput("label", "Select label variable", opts)
   })
  
  
   # Code to read table input 
   output$streamPlot <- renderStreamgraph({
     if (is.null(Data())) return()
     # Create the streamgraph that is returned and
     # Get around non-standard evaluation
     eval(call_new(streamgraph, Data(), input$label, input$n, input$t))
   })
})

# Run the application 
shinyApp(ui = ui, server = server)

