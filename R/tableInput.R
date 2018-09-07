
#' @export
tableInputUI <- function(id,
                         choices = c("pasted","fileUpload","sampleData", "googleSheet"),
                         selected = "pasted"
){
  # UI
  ns <- NS(id)
  #choiceNames <-  choiceNames %||% choices
  #names(choices) <- choiceNames
  tagList(
    div(id=ns("tableInput"),class="tableInput",
        radioButtons(ns("tableInput"), "",
                     choices = choices, selected = selected),
        uiOutput(ns("tableInputControls"))
    )
  )
}

#' @export
tableInput <- function(input,output,session,
                       sampleFiles = NULL){

  output$tableInputControls <- renderUI({

    # str(session)
    # if(!exists(session))
    #   stop("No session defined in server.")

    ns <- session$ns

    if(is.reactive(sampleFiles))
      sampleFiles <- sampleFiles()

    if(input$tableInput == "sampleData"){
      if(!all(map_lgl(sampleFiles,file.exists)))
        stop("All Sample Files must exist")
    }
    tableInputControls <- list(
      "pasted" = textAreaInput(ns("inputDataPasted"),label = "Paste",
                               placeholder = "placeholder",
                               rows = 5),
      "fileUpload" =  fileInput(ns('inputDataUpload'), 'Choose CSV File',
                                accept=c('text/csv',
                                         'text/comma-separated-values,text/plain',
                                         '.csv','.xls')),
      "sampleData" = selectInput(ns("inputDataSample"),"Seleccione Datos de Muestra",
                                 choices = sampleFiles),
      "googleSheet" = list(
        textInput(ns("inputDataGoogleSheet"),"GoogleSheet URL"),
        numericInput(ns("inputDataGoogleSheetSheet"),"Sheet",1)
        )
    )
    tableInputControls[[input$tableInput]]
  })


  queryData <- reactive({
    #d <- read_csv("inst/dev/sample1.csv") %>% jsonlite::toJSON()
    #URLencode(d)
    query <- parseQueryString(session$clientData$url_search)
    json_str <- query[["json_data"]]
    data <- NULL
    # OJO Add Clip data
    if(!is.null(json_str)){
      data <- jsonlite::fromJSON(URLdecode(json_str))
    }
    data
  })

  inputData <- reactive({
    inputType <- input$tableInput
    #readDataFromInputType(inputType)

    queryData <- queryData()
    if(!is.null(queryData)){
      return(queryData)
    }

    if(inputType == "pasted"){
      if(input$inputDataPasted == "")
        return()
      df <- read_tsv(input$inputDataPasted)
    }
    if(inputType ==  "fileUpload"){
      if(is.null(input$inputDataUpload)) return()
      old_path <- input$inputDataUpload$datapath
      path <- file.path(tempdir(),input$inputDataUpload$name)
      file.copy(old_path,path)
      df <- rio::import(path)
    }
    if(inputType ==  "sampleData"){
      file <- input$inputDataSample
      df <- read_csv(file)
    }
    if(inputType == "googleSheet"){
      url <- input$inputDataGoogleSheet
      ws <- input$inputDataGoogleSheetSheet
      s <- gs_url(url)
      tabs <- gs_ws_ls(s)
      df <- gs_read_csv(s, ws = ws)
    }
    return(df)
  })
  inputData
}

