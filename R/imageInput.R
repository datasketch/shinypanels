#' @export
imageInputUI <- function (id,
                          choices = c("fileUpload", "sampleData", "url", "dsLibrary"),
                          selected = "fileUpload") {
  ns <- NS(id)
  tagList(div(id = ns("imageInput"),
              class = "tableInput",
              radioButtons(ns("imageInput"), "", choices = choices, selected = selected),
              uiOutput(ns("imageInputControls"))))
}


#' @export
imageInput <- function (input, output, session, sampleFiles = NULL) {
  output$imageInputControls <- renderUI({
    ns <- session$ns

    if (is.reactive(sampleFiles))
      sampleFiles <- sampleFiles()

    if (!is.null(input$imageInput) && input$imageInput == "sampleData") {
      if (!all(map_lgl(sampleFiles, file.exists)))
        stop("All Sample Files must exist")
    }

    imageInputControls <- list(
      # pasted = textAreaInput(ns("inputDataPasted"),
      #                        label = "Paste", placeholder = "placeholder", rows = 5),
      fileUpload = fileInput(ns("inputDataUpload"), "Choose image", accept = c("image/png", "image/jpeg")),
      sampleData = selectInput(ns("inputDataSample"), "Select sample image", choices = sampleFiles),
      url = textInput(ns("inputURL"), "Image URL"),
      dsLibrary = dsDataInputUI(ns("dsFileInput")))

    if (is.null(input$imageInput)) {
      return()
    } else {
      imageInputControls[[input$imageInput]]
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
    if (is.null(input$imageInput)) {
      warning("inputType must be one of fileUpload, sampleData, url, dsLibrary")
      return()
    }

    inputType <- input$imageInput
    queryData <- queryData()
    if (!is.null(queryData)) {
      return(queryData)
    }

    if (inputType == "fileUpload") {
      if (is.null(input$inputDataUpload))
        return()
      old_path <- input$inputDataUpload$datapath
      path <- file.path(tempdir(), input$inputDataUpload$name)
      file.copy(old_path, path)
      df <- list(src = path)
    } else if (inputType == "sampleData") {
      file <- input$inputDataSample
      df <- list(src = file)
    } else if (inputType == "url") {
      if (sum(is.null(input$inputURL) | nzchar(input$inputURL)) == 0)
        return()
      url <- input$inputURL
      path <- file.path(tempdir(), "url0")
      t0 <- tryCatch(download.file(url, path, mode = "wb"), error = function(e) e)
      if (any(grepl("error", class(t0)))) {
        df <- list(src = "")
      } else {
        df <- list(src = path)
      }
    } else if (inputType == "dsLibrary") { # ADAPTAR PARA IMÁGENES
      df <- callModule(dsDataInput, "dsFileInput")
      df <- df()
    }
    return(df)
  })
  inputData
}

