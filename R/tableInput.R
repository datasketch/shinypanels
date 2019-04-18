
#' @export
tableInputUI <- function(id,
                         choices = c("pasted","fileUpload","sampleData", "googleSheet", "dsLibrary"),
                         selected = "pasted", lang = "en"){
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
                       sampleFiles = NULL, lang = "en"){

  if(!lang %in% c("en", "es"))
    lang <- "en"
  texts <- list(
    "copy_paste" = list(en = "Copy and paste", es = "Copiar y pegar"),
    "copy_paste_placeholder" = list(en = "Paste here", es = "Pegar aquí"),
    "choose_file" = list(en = "Choose file", es = "Seleccione archivo"),
    "choose_file_button" = list(en = "Browse", es = "Cargar"),
    "choose_file_placeholder" = list(en = "No file selected", es = "Ningún archivo seleccionado"),
    "select_sample_data" = list(en = "Select Sample Data", es = "Seleccione tabla de ejemplo")
  )

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
      "pasted" = textAreaInput(ns("inputDataPasted"),label = texts[["copy_paste"]][[lang]],
                               placeholder = texts[["copy_paste_placeholder"]][[lang]],
                               rows = 5),
      "fileUpload" =  fileInput(ns('inputDataUpload'), texts[["choose_file"]][[lang]],
                                buttonLabel = texts[["choose_file_button"]][[lang]],
                                placeholder = texts[["choose_file_placeholder"]][[lang]],
                                accept=c('text/csv',
                                         'text/comma-separated-values,text/plain',
                                         '.csv','.xls', '.xlsx')),
      "sampleData" = selectInput(ns("inputDataSample"),texts[["select_file"]][[lang]],
                                 choices = sampleFiles),
      "googleSheet" = list(
        textInput(ns("inputDataGoogleSheet"),"GoogleSheet URL"),
        numericInput(ns("inputDataGoogleSheetSheet"),"Sheet",1)
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

