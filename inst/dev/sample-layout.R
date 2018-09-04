
library(dsAppLayout)
library(shinyjs)
library(tidyverse)
library(DT)

styles <- "#sidebar{background-color: #f9f9f9}"

ui <- dsAppPage(skin = "magenta",styles = styles,
  dataControls(label = "Edit data",
    verbatimTextOutput("debug"),
    br()
    ),
  dataPreview(
    h3("This is data preview"),
    dsHot("dataTable", data = mtcars),
    verbatimTextOutput("debug_data")
  ),
  vizControls(label = "Personaliza tu vis",
    h4("This is vis controls"),
    radioButtons("radios",NULL,choices = c("XXXX", "YYYY")),
    textInput("title",NULL)
  ),
  vizPreview(
    p("THIS IS VIZ PREVIEW"),
    uiOutput("viz")
  ),
  dsModal("hola", h2("MODAL"))
)

server <- function(input,output,session){
  output$debug_data <- renderPrint({
    data <- hot_data(input$dataTable)
    data
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
    DT::datatable(data)
  })

}
shinyApp(ui,server)




