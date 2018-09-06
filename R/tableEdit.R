########## INICIAL
# #' @export
# tableEditUI <- function(id){
#   ns <- NS(id)
#   tagList(
#     div(id=ns("tableEdit"), class = "tableEdit",
#         column(3, class = "tableEditCol",
#                uiOutput(ns("dataControls"))
#         ),
#         column(9, class = "tableEditCol",
#                rHandsontableOutput(ns("dataInputPreview"))
#         )
#     )
#   )
# }

#' @export
tableEditUI <- function(id){
  ns <- NS(id)
  tagList(
    div(id = ns("tableEdit"), class = "tableEdit",
        column(3, class = "tableEditCol",
               uiOutput(ns("dataControls0")),
               uiOutput(ns("dataControls1"))
        ),
        column(9, class = "tableEditCol",
               rHandsontableOutput(ns("dataInputPreview"))
        )
    )
  )
}


#' @export
tableEdit <- function(input, output, session,
                      inputData,
                      addColSelect = TRUE,
                      selectColsLabel = "Select and Arrange Columns",
                      addRowFilters = FALSE,
                      filterRowsLabel = "Add filters",
                      addCleaners = FALSE,
                      cleanersLabel = "Cleaners",
                      addCtypes = FALSE,
                      permanentCtypes = FALSE,
                      ctypesLabel = "Add column types",
                      ctypesOptions = c("Numerica" = "Num", "Categórica" = "Cat", "Fecha" = "Dat",
                                        "Longitud" = "Gln", "Latitud" = "Glt",
                                        "Lugar" = "Gnm", "Código lugar" = "Gcd", "Imágen" = "Img")) {

  ns <- session$ns
  output$dataControls0 <- renderUI({
    if (is.null(inputData())) return()
    d <- inputData()

    colSelect <- selectizeInput(ns("selectedCols"), selectColsLabel,
                                choices = names(d),
                                selected = names(d),
                                multiple = TRUE,
                                options = list(plugins = list("drag_drop", "remove_button")))
    if (!addColSelect) colSelect <- NULL
    tagList(
      colSelect
    )
  })
  output$dataControls1 <- renderUI({
    d <- inputData()
    cleaners <- list(
      checkboxInput(ns("dataCleaners"), cleanersLabel, value = input$dataCleaners),
      conditionalPanel(paste0("input[['", ns("dataCleaners"), "']]"))
    )
    rowFilters <- list(
      checkboxInput(ns("dataAddFilters"), filterRowsLabel, value = input$dataAddFilters),
      conditionalPanel(paste0("input[['", ns("dataAddFilters"), "']]"),
                       p("Here goes the filters"))
    )
    if (permanentCtypes) {
      ctypes <- list(
        strong(ctypesLabel),
        br(),
        map(as.list(input$selectedCols),
            ~selectInput(paste0("ctp-", .x), label = .x, choices = ctypesOptions))
      )
    } else {
      ctypes <- list(
        checkboxInput(ns("dataAddColTypes"), ctypesLabel, value = input$dataAddColTypes),
        conditionalPanel(paste0("input[['", ns("dataAddColTypes"), "']]"),
                         map(as.list(input$selectedCols),
                             ~selectInput(paste0("ctp-", .x), label = .x, choices = ctypesOptions)))
      )
    }
    if (!addRowFilters) rowFilters <- NULL
    if (!addCtypes) ctypes <- NULL
    if (!addCleaners) cleaners <- NULL
    tagList(
      cleaners,
      rowFilters,
      ctypes
    )
  })
  output$dataInputPreview <- renderRHandsontable({
    d <- inputData()
    selectedCols <- input$selectedCols
    #d <- d %>% select_(.dots = selectedCols)
    d <- d[selectedCols]
    if(is.null(inputData()))
      return()
    h <- rhandsontable(d, useTypes = FALSE, readOnly = FALSE,
                       width = "100%",height = 500) %>%
      hot_table(stretchH = "none") %>%
      hot_cols(manualColumnMove = TRUE)
    h
  })

  data <- reactive({
    if(is.null(input$dataInputPreview))
      return()
    as_tibble(hot_to_r(input$dataInputPreview))
  })
  data
}


# tableEdit <- function(input, output, session,
#                       inputData,
#                       addColSelect = TRUE,
#                       selectColsLabel = "Select and Arrange Columns",
#                       addRowFilters = FALSE,
#                       filterRowsLabel = "Add filters",
#                       addCleaners = FALSE,
#                       cleanersLabel = "Cleaners",
#                       addCtypes = FALSE,
#                       ctypesLabel = "Add column types",
#                       ctypesOptions = c("Numerica", "Categórica", "Fecha",
#                                         "Porcentual", "Longitud", "Latitud",
#                                         "Lugar", "Código lugar", "Imágen")) {
#
#   ns <- session$ns
#   output$dataControls0 <- renderUI({
#     if (is.null(inputData())) return()
#     d <- inputData()
#
#     colSelect <- selectizeInput(ns("selectedCols"), selectColsLabel,
#                                 choices = names(d),
#                                 selected = names(d),
#                                 multiple = TRUE,
#                                 options = list(plugins = list("drag_drop", "remove_button")))
#     if (!addColSelect) colSelect <- NULL
#     tagList(
#       colSelect
#     )
#   })
#   output$dataControls1 <- renderUI({
#     d <- inputData()
#     cleaners <- list(
#       checkboxInput(ns("dataCleaners"), cleanersLabel, value = input$dataCleaners),
#       conditionalPanel(paste0("input[['", ns("dataCleaners"), "']]"),
#                        checkboxGroupInput(ns("colToClean"), NULL,
#                                           #"Buscar y reemplazar en las siguientes columnas:",
#                                           choices = c("Todas", input$selectedCols), inline = TRUE,
#                                           selected = input$colToClean),
#                        div(style = "display:flex",
#                            textInput(ns("aReemplazar"), label = NULL, placeholder = "Buscar..."),
#                            HTML('<span style = "height:34px" class="input-group-addon"></span>'),
#                            textInput(ns("reemplazar"), label = NULL, placeholder = "reemplazar")),
#                        actionButton(ns("botonClean"), "Reemplazar", width = "100%"))
#     )
#     rowFilters <- list(
#       checkboxInput(ns("dataAddFilters"), filterRowsLabel, value = input$dataAddFilters),
#       conditionalPanel(paste0("input[['", ns("dataAddFilters"), "']]"),
#                        p("Here goes the filters"),
#                        radioButtons(ns("colToFilter"), NULL,
#                                     #"En las siguientes columnas:",
#                                     choices = c("Todas", input$selectedCols), inline = TRUE,
#                                     selected = input$colToFilter),
#                        selectizeInput(ns("remFilas"), "Remover filas con",
#                                       choices = if (input$colToFilter == "Todas" && sum(nchar(input$colToFilter)) != 0) c("NA") else unique(d[input$colToFilter]),
#                                       multiple = TRUE,
#                                       options = list(plugins = list("drag_drop", "remove_button"))),
#                        actionButton(ns("actFiltrar"), "Remover", width = "100%"),
#                        if (input$colToFilter != "Todas" && sum(nchar(input$colToFilter)) != 0
#                            && homodatum:::guessCtype(d[[input$colToFilter]]) %in% c("Num", "Glt", "Gln", "Dat", "Yea")) {
#                          list(sliderInput(ns("rangeFilter"), "",
#                                           min = min(d[[input$colToFilter]], na.rm = TRUE),
#                                           max = max(d[[input$colToFilter]], na.rm = TRUE),
#                                           value = c(min(d[[input$colToFilter]], na.rm = TRUE),
#                                                     max(d[[input$colToFilter]], na.rm = TRUE))),
#                               actionButton(ns("ranFiltrar"), "Acotar", width = "100%"))
#                        } else {
#                          NULL
#                        })
#     )
#     ctypes <- list(
#       checkboxInput(ns("dataAddColTypes"), ctypesLabel, value = input$dataAddColTypes),
#       conditionalPanel(paste0("input[['", ns("dataAddColTypes"), "']]"),
#                        p("Here goes the ctypes"),
#                        map(as.list(input$selectedCols),
#                            ~selectInput(paste0("ctp-", .x), label = .x, choices = ctypesOptions)))
#     )
#     if (!addRowFilters) rowFilters <- NULL
#     if (!addCtypes) ctypes <- NULL
#     if (!addCleaners) cleaners <- NULL
#     tagList(
#       cleaners,
#       rowFilters,
#       ctypes
#     )
#   })
#
#   dataT <- reactiveValues("datRemp" = NULL, "dataFilt" = NULL)
#
#   observeEvent(input$ranFiltrar, {
#     # if (nrow(data()) == 0) dt <- inputData()
#     #     dt <- data()
#     d0 <- dataT$datRemp %||% data()
#     if (!is.null(input$ranFiltrar)) {
#       print(paste("MENOR", input$rangeFilter[1]))
#       print(paste("MAYOR", input$rangeFilter[2]))
#       w <- which(d0[[input$colToFilter]] >= input$rangeFilter[1] &&
#                    d0[[input$colToFilter]] >= input$rangeFilter[2])
#       d0 <- d0 %>%
#         dplyr::slice(w)
#     }
#     dataT$datFilt <- d0
#   })
#   observeEvent(input$actFiltrar, {
#     # if (nrow(data()) == 0) dt <- inputData()
#     #     dt <- data()
#     d0 <- dataT$datRemp %||% data()
#     if (!is.null(input$colToFilter)) {
#       if (input$colToFilter == "Todas") {
#         d0 <- d0 %>% na.omit()
#       } else {
#         if (!is.null(input$remFilas)) {
#           w <- which(d0[[input$colToFilter]] %in% input$remFilas)
#           d0 <- d0 %>%
#             dplyr::slice(-w)
#           View(d0)
#         }
#       }
#     }
#     dataT$datFilt <- d0
#   })
#
#   observeEvent(input$botonClean, {
#     d0 <- data()
#     if (input$dataCleaners && !is.null(input$colToClean)) {
#       if (nchar(input$aReemplazar) != 0) {
#         if ("Todas" %in% input$colToClean) {
#           lista <- names(d0)
#         } else {
#           lista <- input$colToClean
#         }
#         map(as.list(lista), function(r) {
#           if (input$aReemplazar == "NA") {
#             d0[[r]][which(is.na(d0[[r]]))] <<- input$reemplazar
#           } else {
#             d0[[r]] <<- gsub(input$aReemplazar, input$reemplazar, d0[[r]])
#           }
#         })
#       }
#     }
#     dataT$datRemp <- d0
#     dataT$datFilt <- d0
#   })
#
#   output$dataInputPreview <- renderRHandsontable({
#     print(getUrlParameters(session))
#     # if (is.null(inputData()))
#     # return()
#     if (is.null(inputData())) return()
#     d <- dataT$datFilt %||% inputData()
#     selectedCols <- input$selectedCols
#     dif <- setdiff(selectedCols, names(d))
#     if (sum(nchar(dif)) != 0) d <- cbind(d, inputData()[, dif])# d <- inputData()
#     #d <- d %>% select_(.dots = selectedCols)
#     d <- d[selectedCols]
#     h <- rhandsontable(d, useTypes = FALSE, readOnly = FALSE,
#                        width = "100%", height = 500) %>%
#       hot_table(stretchH = "none") %>%
#       hot_cols(manualColumnMove = TRUE)
#     h
#   })
#
#   data <- reactive({
#     if(is.null(input$dataInputPreview))
#       return()
#     as_tibble(hot_to_r(input$dataInputPreview))
#   })
#   data
#}




####### INICIAL

# #' @export
# tableEdit <- function(input, output, session,
#                       inputData,
#                       addColSelect = TRUE,
#                       selectColsLabel = "Select and Arrange Columns",
#                       addRowFilters = FALSE,
#                       filterRowsLabel = "Add filters",
#                       addCleaners = FALSE,
#                       cleanersLabel = "Cleaners",
#                       addCtypes = FALSE,
#                       ctypesLabel = "Add column types",
#                       ctypesOptions = c("Numerica", "Categórica", "Fecha",
#                                         "Porcentual", "Longitud", "Latitud",
#                                         "Lugar", "Código lugar", "Imágen")) {
#
#   output$dataControls <- renderUI({
#     if(is.null(inputData())) return()
#     ns <- session$ns
#     d <- inputData()
#
#     colSelect <- selectizeInput(ns("selectedCols"), selectColsLabel,
#                                 choices = names(d),
#                                 selected = names(d),
#                                 multiple = TRUE,
#                                 options = list(plugins = list("drag_drop", "remove_button")))
#
#     rowFilters <- list(
#       checkboxInput(ns("dataAddFilters"),filterRowsLabel),
#       conditionalPanel(paste0("input[['",ns("dataAddFilters"),"']]"),
#                        p("Here goes the filters"))
#     )
#     ctypes <- list(
#       checkboxInput(ns("dataAddColTypes"), ctypesLabel),
#       conditionalPanel(paste0("input[['",ns("dataAddColTypes"),"']]"),
#                        p("Here goes the ctypes"))
#     )
#     if(!addColSelect) colSelect <- NULL
#     if(!addRowFilters) rowFilters <- NULL
#     if(!addCtypes) ctypes <- NULL
#
#     tagList(
#       colSelect,
#       rowFilters,
#       ctypes
#     )
#   })
#
#   output$dataInputPreview <- renderRHandsontable({
#     d <- inputData()
#     selectedCols <- input$selectedCols
#     #d <- d %>% select_(.dots = selectedCols)
#     d <- d[selectedCols]
#     if(is.null(inputData()))
#       return()
#     h <- rhandsontable(d, useTypes = FALSE, readOnly = FALSE,
#                        width = "100%",height = 500) %>%
#       hot_table(stretchH = "none") %>%
#       hot_cols(manualColumnMove = TRUE)
#     h
#   })
#
#   data <- reactive({
#     if(is.null(input$dataInputPreview))
#       return()
#     as_tibble(hot_to_r(input$dataInputPreview))
#   })
#   data
# }
