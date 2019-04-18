
#' @export
tableInputUI <- function(id,
                         choices = c("pasted","fileUpload","sampleData", "googleSheet", "dsLibrary"),
                         selected = "pasted"){
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
                       sampleFiles = NULL, labels = NULL){

  if(is.reactive(labels)){
    labels <- labels()
  }
  labels_default <- list(
    "copy_paste" = "Copy and paste",
    "copy_paste_placeholder" = "Paste here",
    "choose_file" = "Choose file",
    "choose_file_button" = "Browse",
    "choose_file_placeholder" = "No file selected",
    "select_sample_data" = "Select Sample Data",
    "gsheet" = "Googlesheet URL",
    "gsheet_sheet" = "Sheet"
  )
  labels <- modifyList(labels_default, labels)

  output$tableInputControls <- renderUI({

    # str(session)
    # if(!exists(session))
    #   stop("No session defined in server.")

    ns <- session$ns

    if(is.reactive(sampleFiles))
      sampleFiles <- sampleFiles()

    if(!is.null(input$tableInput) && input$tableInput == "sampleData"){
      if(!all(map_lgl(sampleFiles,file.exists)))
        stop("All Sample Files must exist")
    }
    tableInputControls <- list(
      "pasted" = textAreaInput(ns("inputDataPasted"),label = labels[["copy_paste"]],
                               placeholder = labels[["copy_paste_placeholder"]],
                               rows = 5),
      "fileUpload" =  fileInput(ns('inputDataUpload'), labels[["choose_file"]],
                                buttonLabel = labels[["choose_file_button"]],
                                placeholder = labels[["choose_file_placeholder"]],
                                accept=c('text/csv',
                                         'text/comma-separated-values,text/plain',
                                         '.csv','.xls', '.xlsx')),
      "sampleData" = selectInput(ns("inputDataSample"),labels[["select_file"]],
                                 choices = sampleFiles),
      "googleSheet" = list(
        textInput(ns("inputDataGoogleSheet"), labels[["gsheet"]]),
        numericInput(ns("inputDataGoogleSheetSheet"),labels[["gsheet_sheet"]],1)
      ),
      "dsLibrary" = dsDataInputUI(ns("dsFileInput"))
    )
    if(is.null(input$tableInput)){
      return()
    }else{
      tableInputControls[[input$tableInput]]
    }
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

    if(is.null(input$tableInput)){
      warning("inputType must be one of pasted, fileUpload, sampleData, googlesheet, dsLibrary")
      return()
    }

    inputType <- input$tableInput
    #readDataFromInputType(inputType)

    queryData <- queryData()
    if(!is.null(queryData)){
      return(queryData)
    }

    if(inputType == "pasted"){
      if(is.null(input$inputDataPasted)) return()
      if(input$inputDataPasted == "")
        return()
      df <- read_tsv(input$inputDataPasted)
    } else if(inputType ==  "fileUpload"){
      if(is.null(input$inputDataUpload)) return()
      old_path <- input$inputDataUpload$datapath
      path <- file.path(tempdir(),input$inputDataUpload$name)
      file.copy(old_path,path)
      df <- rio::import(path)
    } else if(inputType ==  "sampleData"){
      file <- input$inputDataSample
      df <- read_csv(file)
    } else if(inputType == "googleSheet"){
      if(is.null(input$inputDataGoogleSheet))
        return()
      if(input$inputDataGoogleSheet == "")
        return()
      url <- input$inputDataGoogleSheet
      ws <- input$inputDataGoogleSheetSheet
      s <- gs_url(url)
      tabs <- gs_ws_ls(s)
      df <- gs_read_csv(s, ws = ws)
    } else if(inputType == "dsLibrary"){
      df <- callModule(dsDataInput,"dsFileInput")
      df <- df()
    }
    return(df)
  })
  inputData
}

