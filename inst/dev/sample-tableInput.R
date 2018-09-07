
library(dsAppLayout)
library(shinyjs)
library(tidyverse)
library(DT)

styles <- "#sidebar{background-color: #f9f9f9}"

ui <- dsAppPage(skin = "magenta",styles = styles,
                #### DATA
                dataControls(label = "Edit data",
                             verbatimTextOutput("debug"),
                             tableInputUI("dataIn",  selected = "pasted",
                                          choices = list("Copiar & Pegar"="pasted",
                                                         "Cargar"="fileUpload",
                                                         "GoogleSheet" = "googleSheet",
                                                         "Muestra"="sampleData")
                                          ),
                             br()
                ),
                dataPreview(
                  uiOutput("data_preview"),
                  #dsHot("dataTable2", data = cars),
                  verbatimTextOutput("debug_data")
                ),
                ##### VIZ
                vizControls(label = "Personaliza tu vis",
                            h4("This is vis controls"),
                            radioButtons("radios",NULL,choices = c("XXXX", "YYYY")),
                            radioButtons("radios2",NULL,choices = c("XXXX", "YYYY"), inline = TRUE),
                            hr(),
                            textInput("title","Título"),
                            textInput("subtitle","Subtítulo"),
                            textInput("titlex","Título Eje Horizontal"),
                            textInput("titley","Título Eje Vertical")
                ),
                vizPreview(
                  p("THIS IS VIZ PREVIEW"),
                  uiOutput("viz"),
                  br()
                ),
                dsModal("hola", h2("MODAL")),
                tags$link(rel = 'stylesheet',
                          type = 'text/css',
                          href = 'http://127.0.0.1:8080/lib/dsHot/dsHot.css'),
                tags$script(src = 'http://127.0.0.1:8080/lib/dsHot/dsHot.js')
)

server <- function(input,output,session){
  output$debug_data <- renderPrint({
    #data <- hot_data(input$dataTable)
    #data
    inputData()
  })

  inputData <- callModule(tableInput, "dataIn",
                          sampleFile = list("File1"="sample1.csv","Archivo2"="sample2.csv"))

  output$data_preview <- renderUI({
    list(
      dsHot("dataTable", data = inputData())
    )
  })


  output$debug <- renderPrint({
    input$radios
  })
  output$viz <- renderUI(
    dataTableOutput("vizData")
  )
  output$vizData <- renderDataTable({
    #input$dataTable
    data <- hot_data(input$dataTable, labels = TRUE)
    DT::datatable(data, options = list(scrollX = TRUE))
  })

}
shinyApp(ui,server)




