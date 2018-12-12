
library(dsAppLayout)
library(shinyjs)
library(tidyverse)
library(DT)

styles <- "#sidebar{background-color: #f9f9f9}"

ui <- dsAppPage(skin = "magenta",styles = styles,
                dataControls(label = "Edit data",
                             br()
                ),
                dataPreview(
                  h3("This is data preview"),
                  dsHot("dataTable", data = mtcars),
                  textOutput("debug"),
                  verbatimTextOutput("debug_data"),
                  br()
                ),
                vizControls(label = "Personaliza tu vis",
                            basic = list(
                              h4("Basic controls"),
                              uiOutput("basic"),
                              radioButtons("radios",NULL,choices = c("XXXX", "YYYY")),
                              radioButtons("radios2",NULL,choices = c("XXXX", "YYYY"), inline = TRUE),
                              hr(),
                              textInput("title","Título"),
                              textInput("subtitle","Subtítulo"),
                              textInput("titlex","Título Eje Horizontal"),
                              textInput("titley","Título Eje Vertical")
                            ),
                            advanced = list(
                              h4("Advanced controls"),
                              uiOutput("advanced"),
                              radioButtons("adv_radios",NULL,choices = c("XXXX", "YYYY")),
                              radioButtons("adv_radios2",NULL,choices = c("XXXX", "YYYY"), inline = TRUE),
                              hr(),
                              textInput("adv_title","Título"),
                              textInput("adv_subtitle","Subtítulo")
                            ),
                            h4("Other controls not in tabs"),
                            textInput("Other Input","Other Input")
                ),
                vizPreview(
                  p("THIS IS VIZ PREVIEW"),
                  uiOutput("viz"),
                  br()
                ),
                dsModal("hola", h2("MODAL"))
)

server <- function(input,output,session){
  output$debug_data <- renderPrint({
    #hot_data <- hot_data(input$dataTable)
    #str(transpose(hot_data) %>% as_tibble)
    input$dataTable
  })
  output$debug <- renderPrint({
  })
  output$basic <-renderUI({
    list(
      h4("hola"),
      h4("basic")
    )
  })
  output$advanced <- renderUI({})
  outputOptions(output, "advanced", suspendWhenHidden = FALSE)
  output$advanced <-renderUI({
    list(
      h4("hola"),
      h4("advanced")
    )
  })
  output$viz <- renderUI(
    dataTableOutput("vizData")
  )
  output$vizData <- renderDataTable({
    #input$dataTable
    data <- input$dataTable$data
    DT::datatable(data, options = list(scrollX = TRUE))
  })
}
shinyApp(ui,server)




