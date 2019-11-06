
#' @export
tableInputUI <- function(id,
                         choices = c("pasted","fileUpload","sampleData", "googleSheet", "dsLibrary"),
                         selected = "pasted") {
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
tableInput <- function (input, output, session, sampleFiles = NULL, image = FALSE) {

  output$tableInputControls <- renderUI({
    ns <- session$ns

    if (is.reactive(sampleFiles))
      sampleFiles <- sampleFiles()

    if (!is.null(input$tableInput) && input$tableInput == "sampleData") {
      if (!all(map_lgl(sampleFiles, file.exists)))
        stop("All Sample Files must exist")
    }

    tableInputControls <- list(pasted = textAreaInput(ns("inputDataPasted"),
                                                      label = "Paste", placeholder = "placeholder", rows = 5),
                               fileUpload = fileInput(ns("inputDataUpload"), "Choose CSV File", accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv", ".xls")),
                               sampleData = selectInput(ns("inputDataSample"), "Select sample data", choices = sampleFiles),
                               googleSheet = list(textInput(ns("inputDataGoogleSheet"), "GoogleSheet URL"),
                                                  numericInput(ns("inputDataGoogleSheetSheet"), "Sheet", 1)),
                               url = textInput(ns("inputURL"), "Image URL"),
                               dsLibrary = dsDataInputUI(ns("dsFileInput")))

    if (is.null(input$tableInput)) {
      return()
    } else {
      tableInputControls[[input$tableInput]]
    }
  })

  queryData <- reactive({
    query <- parseQueryString(session$clientData$url_search)
    json_str <- query[["json_data"]]
    data <- NULL
    if (!is.null(json_str)) {
      data <- jsonlite::fromJSON(URLdecode(json_str))
    }
    data
  })

  inputData <- reactive({
    if (is.null(input$tableInput)) {
      warning("inputType must be one of pasted, fileUpload, sampleData, url, googlesheet, dsLibrary")
      return()
    }

    inputType <- input$tableInput
    queryData <- queryData()
    if (!is.null(queryData)) {
      return(queryData)
    }

    if (inputType == "pasted") {
      if (is.null(input$inputDataPasted))
        return()
      if (input$inputDataPasted == "")
        return()
      df <- read_tsv(input$inputDataPasted)
    } else if (inputType == "fileUpload") {
      if (is.null(input$inputDataUpload))
        return()
      old_path <- input$inputDataUpload$datapath
      path <- file.path(tempdir(), input$inputDataUpload$name)
      file.copy(old_path, path)
      df <- rio::import(path)
    } else if (inputType == "sampleData") {
      file <- input$inputDataSample
      df <- read_csv(file)
    } else if (inputType == "url") {
      url <- input$inputURL
      df <- read_csv(url) # DATOS DESDE UNA URL... ¿CÓMO SERÍA?
    } else if (inputType == "googleSheet") {
      if (is.null(input$inputDataGoogleSheet))
        return()
      if (input$inputDataGoogleSheet == "")
        return()
      url <- input$inputDataGoogleSheet
      ws <- input$inputDataGoogleSheetSheet
      s <- gs_url(url)
      tabs <- gs_ws_ls(s)
      df <- gs_read_csv(s, ws = ws)
    } else if (inputType == "dsLibrary") { # ADAPTAR PARA IMÁGENES
      df <- callModule(dsDataInput, "dsFileInput")
      df <- df()
    }
    return(df)
  })
  inputData
}
