

library(dsAppLayout)
library(dsAppModules)

styles <- ""



ui <- stepsPage(skin = "magenta",styles = styles, debug = TRUE,
                stepsHeader(show = FALSE, height = 0,
                            verbatimTextOutput("debug"),
                            showDebugUI("showDebug")
                ),
                stepsBody(selected = "step1",
                          stepPanel(id="step1",
                                    sidebarStep(title = "Cargar Datos",
                                                #p("sidebar step1"),
                                                tableInputUI("dataIn", choices = list("Copiar & Pegar"="pasted",
                                                                                      "Cargar"="fileUpload",
                                                                                      "Muestra"="sampleData"),
                                                             selected = "sampleData"),
                                                verbatimTextOutput("debugData"),
                                                br()
                                    ),
                                    mainStep(title = NULL,
                                             uiOutput("dataMain")
                                    )
                          ),
                          stepPanel(id="step2",
                                    sidebarStep(title = "Visualizar",
                                                verbatimTextOutput("debugViz"),
                                                uiOutput("vizSide")
                                    ),
                                    mainStep(title = "STEP2 Title",
                                             uiOutput("vizMain")
                                    )
                          ),
                          stepPanel(id="step3",
                                    sidebarStep(title = "Publish",
                                                h4("Publish side")
                                    ),
                                    mainStep(title = "Publish",
                                             h4("Publish main")
                                    )
                          )
                )
)



server <- function(input,output,session){

  callModule(showDebug, "showDebug")

  currentStep <- reactive({
    paste(c(input$dsAppLayout_current,names(data())),collapse = "-")
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
    #input$dsAppLayout_current
    #currentStep()
    #input$step

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
    str(session$clientData$url_hostname)
  })

  output$debugViz <- renderPrint({
    str(data())
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

}

shinyApp(ui,server)






