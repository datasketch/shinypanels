

library(dsAppLayout)
library(shinyjs)
library(tidyverse)
library(dsAppModules)

styles <- "#sidebar{background-color: #f9f9f9}"


jsCode <- ''



ui <- stepsPage(skin = "magenta",styles = styles,
                stepsHeader(show = FALSE, height = 50,
                            verbatimTextOutput("debug"),
                            pagerButtons("hola","Prev","Next"),
                            prevStepButton("prev"),
                            nextStepButton("next"),
                            br()
                ),
                stepsBody(selected = "step1",
                          stepPanel(id="step1",
                                    sidebarStep(title = "Cargar Datos",
                                                pagerButtons("hola","Prev","Next"),
                                                prevStepButton("prev"),
                                                nextStepButton("next"),
                                                p("sidebar step1"),
                                                tableInputUI("dataIn", choices = list("Copiar & Pegar"="pasted",
                                                                                      "Cargar"="fileUpload",
                                                                                      "Muestra"="sampleData"),
                                                             selected = "sampleData"),
                                                verbatimTextOutput("debugData"),
                                                br()
                                    ),
                                    mainStep(title = "Datos",
                                             jumpStepButton("to3","Next","step2"),
                                             p("Main step1"),
                                             uiOutput("dataMain"),
                                             #pagerButtons("hola","Prev","Next"),
                                             br()
                                    )
                          ),
                          stepPanel(id="step2",
                                    sidebarStep(title = "Visualizar",
                                                p("sidebar step2"),
                                                verbatimTextOutput("debugViz"),
                                                uiOutput("vizSide"),
                                                br()
                                    ),
                                    mainStep(title = "Visualización",
                                             p("MAIN VIZ"),
                                             uiOutput("vizMain")
                                    )
                          )
                )
)



server <- function(input,output,session){

  currentStep <- reactive({
  })

  inputData <- callModule(tableInput, "dataIn",
                          sampleFile =
                            list(
                              "File1"="data/sample1.csv",
                              "Ocad Caribe" = "data/ocad-caribe.csv",
                              "Archivo2"="data/sample2.csv"))

  data <- callModule(tableEdit, "tableEditable", inputData = inputData,
                     addColSelect = TRUE,
                     selectColsLabel = "Seleccione y organice columnas",
                     addRowFilters = FALSE,
                     addCtypes = FALSE)

  output$debug <- renderPrint({
    #str(data())
    input$step_current
  })

  output$dataMain <- renderUI({
    if(is.null(inputData())){
      return(p("Select data on the left"))
    }
    tagList(
      tableEditUI("tableEditable"),
      actionButton("btn_visualize", "Visualizar")
    )
  })

  output$debugData <- renderPrint({
    #str(inputData())
  })

  output$debugViz <- renderPrint({
    #str(data())
  })

  output$vizSide <- renderUI({
    data <- data()
    if(is.null(data())){
      return(p("Cargando"))
    }
    tagList(
      p(names(data))
    )
  })

  output$vizMain <- renderUI({
    data <- data()
    tagList(
      renderPrint(str(data))
    )
  })

  # observeEvent(input$btn_visualize, {
  #   nextStep <- "step2"
  #   current <- input$dsAppLayout_current
  #   steps <- input$dsAppLayout_stepIds
  #   session$sendCustomMessage("nextStep", nextStep)
  # })

  # observe({
  #   js$togglePages()
  # })

}

shinyApp(ui,server)






