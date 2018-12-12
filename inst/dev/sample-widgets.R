library(jsonlite)
library(dsAppLayout)
library(shinyjs)
library(colourpicker)
library(tidyverse)
library(DT)
library(hgchmagic)
library(ggmagic)

styles <- "#sidebar{background-color: #f9f9f9}"
conf <- fromJSON("../../ds-app-config.json", simplifyDataFrame = FALSE)

initial_values_df <- data.frame("name" = c("title", "subtitle", "caption", "horLabel", "verLabel",
                                           "horLine", "verLine",
                                           "colors", "colorText", "highlightValueColor",
                                           "colorScale", "orientation",
                                           "dropNa", "percentage", "showText",
                                           "format", "marks", "nDigits",
                                           "highlightValue",
                                           "labelRatio", "labelWrap", "sliceN",
                                           "order",
                                           "sort"),
                                "choices" = I(list(list(NULL), list(NULL), list(NULL), list(NULL), list(NULL),
                                                   list("min" = 0, "max" = Inf), list("min" = 0, "max" = Inf),
                                                   list(NULL), list(NULL), list(NULL),
                                                   list("choices" = c("Ninguna" = "no", "Discreta" = "discrete", "Continua" = "continuous")), list("choices" = c("Horizontal" = "hor", "Vertical" = "ver"), inline = TRUE),
                                                   list(NULL), list(NULL), list(NULL),
                                                   list(NULL), list("choices" = c(". & ,", ", & .")), list("min" = 0, "max" = 10),
                                                   list("multiple" = TRUE),
                                                   list("min" = 0, "max" = 1, "value" = 0.5), list("min" = 1, "max" = 100, "value" = 15), list("min" = 0),
                                                   list("multiple" = TRUE),
                                                   list("choices" = c("No" = "no", "Descendientemente" = "desc", "Ascendientemente" = "asc")))),
                                stringsAsFactors = FALSE)



ui <- dsAppPage(skin = "magenta",#styles = styles,
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
                            uiOutput("libraryDiv"),
                            uiOutput("basico"),
                            uiOutput("avanzado"),
                            uiOutput("vizCont")),
                #simular
                vizPreview(
                radioButtons('typeGrf', 'graficos', c('bar', 'pie')),
                radioButtons('typeC', 'columnas', c("Cat", "CatNum")),
                  p("THIS IS VIZ PREVIEW"),
                  uiOutput("viz"),
                  br()
                ),
                dsModal("hola", h2("MODAL"))
)

server <- function(input, output, session) {

#   d0 <- data.frame(idVizType = c("bar", "bar", 'pie', "pie"),
#                    ctype = "Cat",
#                    input = c("radioButtons",
#                              "radioButtons",
#                              "radioButtons",
#                              "selectInput"),
#                    options = I(list(list('inputId' =  'orientacion', 'label' = 'cosa 1', 'choices' = c('horizontal', 'vertical'),
#                                          "selected" = NULL, "inline" = FALSE,
#                                          "width" = NULL, "choiceNames" = NULL, "choiceValues" = NULL),
#                                     list('inputId' = 'camila', 'label' = 'esto es un label',  'choices' = c('otras cosas', 'anaGil'),
#                                          "selected" = NULL, "inline" = FALSE,
#                                          "width" = NULL, "choiceNames" = NULL, "choiceValues" = NULL),
#                                     list('inputId' =  'orientacion', 'label' = 'ELRLDG', 'choices' = c('dsda', 'vdjaske', 'horizontal', 'vertical'),
#                                          "selected" = NULL, "inline" = FALSE,
#                                          "width" = NULL, "choiceNames" = NULL, "choiceValues" = NULL),
#                                     list('inputId' =  'hul', 'label' = 'SLEL 1', 'choices' = c('SKDJDKJD', 'AJDSDHJ'),
#                                          "selected" = NULL, "multiple" = FALSE,
#                                          "selectize" = TRUE, "width" = NULL, "size" = NULL))),
#                    reactiveArgument = c("selected", "selected", "selected", "selected"),
#                    param = c("orientacion", "camila", "orientacion", "hul"),
#                    dependencias = c('camila', NA, NA, NA),
#                    updateFunction = c('updateRadioButtons', NA, NA, NA),
#                    optionsDepend  = I(list(list('otras cosas' = list('session' = session,
#                                                                      'inputId' = 'orientacion', 'choices' = c('horizontal', 'vertical'),#c('opcion1', 'opcion2', 'opcion3'),
#                                                                      "label" = NULL, "selected" = "horizontal", "inline" = FALSE, "choiceNames" = NULL,
#                                                                      "choiceValues" = NULL),
#                                                 'anaGil' = list('session' = session,
#                                                   'inputId' = 'orientacion', 'choices' = c("op1", "op2"),
#                                                                      "label" = NULL, "selected" = NULL, "inline" = FALSE, "choiceNames" = NULL,
#                                                                      "choiceValues" = NULL)),
#                                            NA,
#                                            NA,
#                                            NA)))
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

  # filtrando conf
  conf_filtrado <- reactiveValues()

  # observe({
  #   # reactivo tipo viz
  #   gtype <- input$typeGrf
  #   # reactivo ctypes
  #   ctype <- input$typeC
  #   c0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype
  #   c1 <- map(seq_along(conf[[which(c0)]]), ~conf[[which(c0)]]$canonic_ctypes[[.x]]$canonic_ctype) == ctype
  #   lib_values <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$id_library)
  #   names(lib_values) <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$library_label) ### NOMBRE:¿?¿?¿?
  #   conf_filtrado$library <- lib_values
  #   conf_filtrado$conf <- conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library
  # })
  output$libraryDiv <- renderUI({
    # reactivo tipo viz
    gtype <- input$typeGrf
    # reactivo ctypes
    ctype <- input$typeC
    # cuáles librerías tienen funciones para gtype ctype
    c0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype
    c1 <- map(seq_along(conf[[which(c0)]]$canonic_ctypes), ~conf[[which(c0)]]$canonic_ctypes[[.x]]$canonic_ctype) == ctype
    lib_values <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$id_library)
    names(lib_values) <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$label_library) ### NOMBRE:¿?¿?¿?
    conf_filtrado$conf <- conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library
    radioButtons("library", label = "Librería de visualización", choices = lib_values, selected = input$library, inline = TRUE)
  })
  # map(seq_along(conf), ~conf[[.x]]$id_viztype)
  # map(seq_along(conf[[1]]), ~conf[[1]]$canonic_ctypes[[.x]]$canonic_ctype)
  # map(seq_along(conf[[1]]$canonic_ctypes[[1]]), ~conf[[1]]$canonic_ctypes[[1]]$library[[.x]]$id_library)

  # conf_filtrado <- reactive({
  #   # reactivo tipo viz
  #   gtype <- input$typeGrf
  #   # reactivo ctypes
  #   ctype <- input$typeC
  #   c0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype
  #   c1 <- map(seq_along(conf[[which(c0)]]), ~conf[[which(c0)]]$canonic_ctypes[[.x]]$canonic_ctype) == ctype
  #   map(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$id_library) ==
  #
  # })
  dt <- data.frame("Njdn" = c(rep("Sjd kaka dj dj", 5), rep("AJ djajfk ja", 8),
                              rep("AJ djajfkkdsjfs fjdshfjsa fjs", 13), rep("AJ sdfjsahjfdhjsa sdf dsajfjd jdsf", 18)))
  # renderizando los controles dentro de las secciones
  observe({
    library <- input$library
    if (!is.null(library)) {
    ctype <- input$typeC
    gtype <- input$typeGrf

    #json
    c0 <- map(seq_along(conf_filtrado$conf), ~conf_filtrado$conf[[.x]]$id_library) == input$library
    c1 <- conf_filtrado$conf[[which(c0)]]$params
    basico <- map(seq_along(c1), ~c1[[.x]]$panel) == "Básico"
    avanzado <- map(seq_along(c1), ~c1[[.x]]$panel) == "Avanzado"
    secciones <- map(seq_along(c1), ~c1[[.x]]$label_panel)
    secciones_basico <- map(which(basico), ~c1[[.x]]$label_panel)
    secciones_avanzado <- map(which(avanzado), ~c1[[.x]]$label_panel)
    childs_basico <- map_lgl(which(basico), ~!is.null(c1[[.x]]$child_params))
    childs_avanzado <- map_lgl(which(avanzado), ~!is.null(c1[[.x]]$child_params))
    # dft_value_field_basico <- map(which(basico), ~c1[[.x]]$default_value_field)
    # dft_value_field_avanzado <- map(which(avanzado), ~c1[[.x]]$default_value_field)
    # dft_value_basico <- map(which(basico), ~c1[[.x]]$default_value)
    # dft_value_avanzado <- map(which(avanzado), ~c1[[.x]]$default_value)


    # childs <- map_lgl(seq_along(c1), ~!is.null(c1[[.x]]$child_params))
    # dft_value_field <- map(seq_along(c1), ~c1[[.x]]$default_value_field)
    # dft_value <- map(seq_along(c1), ~c1[[.x]]$default_value)
    #map("basico", "avanzado")

    output$basico <- renderUI({

      map(unique(secciones_basico), function(z) {
        print(z)
        n0 <- which(secciones_basico == z)
        # colorScale... dflt_value_field está mal
        if (any(n0 %in% c(14))) {
          n0 <- n0[!n0 %in% c(14)]
        }
        div(id = paste0("basico-", z),
            h4(z),
            map(n0, function(s) {
              print(s)
              # v0 <- NULL
              v0 <- input[[c1[[s]]$name]]
              if (is.null(v0)) {
                v0 <- c1[[s]]$default_value
                if (c1[[s]]$name %in% "sliceN") {
                  v0 <- length(unique(dt[[1]]))
                }
              }
              if (c1[[s]]$name %in% "marks") {
                v0 <- strsplit(c1[[s]]$default_value, "&")[[1]]
              }
              v0 <- list(v0)
              names(v0) <- c1[[s]]$default_value_field
              h0 <- list()
              if (c1[[s]]$name %in% "highlightValue") {
                ### PRIMERA CATEGORÍA.... no uno..
                h0 <- list("choices" = sort(as.character(unique(dt[[1]]))))
              }
              s0 <- list()
              if (c1[[s]]$name %in% "sliceN") {
                s0 <- list("max" = length(unique(dt[[1]])))
              }
              o0 <- list()
              if (c1[[s]]$name %in% "order") {
                o0 <- list("choices" = sort(as.character(unique(dt[[1]]))))
              }
              do.call(c1[[s]]$input_type, c(list("inputId" = c1[[s]]$name,
                                                 "label" = c1[[s]]$label),
                                            v0,
                                            h0,
                                            s0,
                                            o0,
                                            initial_values_df$choices[[which(initial_values_df$name == c1[[s]]$name)]]))
              # if (!is.null(c1[[s]]$child_params)) {
              #   # arreglar
              #   n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
              #   map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$label_panel)
              # }
            })
        )
      })
    })

    # output$avanzado <- renderUI({
    #
    #   map(unique(secciones_avanzado), function(z) {
    #     print(z)
    #     n0 <- which(secciones == z)
    #     # colorScale... dflt_value_field está mal
    #     if (any(n0 %in% c(14))) {
    #       n0 <- n0[!n0 %in% c(14)]
    #     }
    #     div(id = paste0("avanzado-", z),
    #         h4(z),
    #         map(n0, function(s) {
    #           print(s)
    #           # v0 <- NULL
    #           v0 <- input[[c1[[s]]$name]]
    #           if (is.null(v0)) {
    #             v0 <- c1[[s]]$default_value
    #             if (c1[[s]]$name %in% "sliceN") {
    #               v0 <- length(unique(dt[[1]]))
    #             }
    #           }
    #           if (c1[[s]]$name %in% "marks") {
    #             v0 <- strsplit(c1[[s]]$default_value, "&")[[1]]
    #           }
    #           v0 <- list(v0)
    #           names(v0) <- c1[[s]]$default_value_field
    #           h0 <- list()
    #           if (c1[[s]]$name %in% "highlightValue") {
    #             ### PRIMERA CATEGORÍA.... no uno..
    #             h0 <- list("choices" = sort(as.character(unique(dt[[1]]))))
    #           }
    #           s0 <- list()
    #           if (c1[[s]]$name %in% "sliceN") {
    #             s0 <- list("max" = length(unique(dt[[1]])))
    #           }
    #           o0 <- list()
    #           if (c1[[s]]$name %in% "order") {
    #             o0 <- list("choices" = sort(as.character(unique(dt[[1]]))))
    #           }
    #           do.call(c1[[s]]$input_type, c(list("inputId" = c1[[s]]$name,
    #                                              "label" = c1[[s]]$label),
    #                                         v0,
    #                                         h0,
    #                                         s0,
    #                                         o0,
    #                                         initial_values_df$choices[[which(initial_values_df$name == c1[[s]]$name)]]))
    #           # if (!is.null(c1[[s]]$child_params)) {
    #           #   # arreglar
    #           #   n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
    #           #   map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$label_panel)
    #           # }
    #         })
    #     )
    #   })
    # })



    }







    # output$avanzado <- renderUI({
    #   map(unique(secciones), function(z) {
    #     n0 <- which(secciones == z)
    #
    #     div(id = z,
    #         map(n0, function(s) {
    #           v0 <- list()
    #           if (!nzchar(dft_val[[s]])) {
    #             v0 <- list(input[[c1[[s]]$name]])
    #             names(v0) <- c1[[s]]$default_value_field
    #           }
    #           do.call(c1[[s]]$input_type, c( list("inputId" = c1[[s]]$name,
    #                                               "label" = c1[[s]]$label),
    #                                          v0,
    #                                          initial_values_df$choices[[initial_values_df$name == c1[[s]]$name]]))
    #           if (!is.null(c1[[s]]$child_params)) {
    #             # arreglar
    #             n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
    #             map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$label_panel)
    #           }
    #         })
    #         # list('inputId' =  'hul', 'label' = 'SLEL 1', 'choices' = c('SKDJDKJD', 'AJDSDHJ'),
    #         #      "selected" = NULL, "multiple" = FALSE,
    #         #      "selectize" = TRUE, "width" = NULL, "size" = NULL)
    #     )
    #
    #   })
    #
    # })
  })

  #### DEPRONTO TODO SE ARREGLA SI SE LE PONE AL VALUE UN IFELSE
  #### SI EL INPUT$ NO ES VACIO PUES QUE PONGA ESE POR DEFAULT
  # output$vizCont <- renderUI({
  #   library <- input$library
  #   ctype <- input$typeC
  #   gtype <- input$typeGrf
  #
  #   # d <- d0 %>%
  #   #   filter(idVizType %in% gtype,
  #   #          ctype %in% ctype)
  #
  #   #json
  #   c0 <- map(seq_along(conf_filtrado$conf), ~conf_filtrado$conf[[.x]]$id_library) == input$library
  #   c1 <- conf_filtrado$conf[[which(c0)]]$params
  #   secciones <- map(seq_along(c1), ~c1[[.x]]$label_panel)
  #   childs <- map_lgl(seq_along(c1), ~!is.null(c1[[.x]]$child_params))
  #   dft_val <- map(seq_along(c1), ~c1[[.x]]$default_value_field)
  #   map(unique(secciones), function(z) {
  #     n0 <- which(secciones == z)
  #
  #     div(id = z,
  #         map(n0, function(s) {
  #           v0 <- list()
  #           if (!nzchar(dft_val[[s]])) {
  #             v0 <- list(input[[c1[[s]]$name]])
  #             names(v0) <- c1[[s]]$default_value_field
  #           }
  #           do.call(c1[[s]]$input_type, c( list("inputId" = c1[[s]]$name,
  #                                               "label" = c1[[s]]$label),
  #                                          v0,
  #                                          initial_values_df$choices[[initial_values_df$name == c1[[s]]$name]]))
  #           if (!is.null(c1[[s]]$child_params)) {
  #             # arreglar
  #             n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
  #             map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$label_panel)
  #           }
  #         })
  #         # list('inputId' =  'hul', 'label' = 'SLEL 1', 'choices' = c('SKDJDKJD', 'AJDSDHJ'),
  #         #      "selected" = NULL, "multiple" = FALSE,
  #         #      "selectize" = TRUE, "width" = NULL, "size" = NULL)
  #     )
  #
  #   })
  #     #########
  #     isolate(assign("foo", reactiveValuesToList(saveParams), envir = globalenv()))
  #     # isolate(print(foo))
  #     isolate({
  #       k <- reactiveValuesToList(saveParams)
  #     })
  #
  #     # map(1:nrow(d), function(z) {
  #     #   # if(!is.null(input[[as.character(d$param[z])]])) {
  #     #   #   print("CALS")
  #     #   #   print(class(k))
  #     #   #   print(is.null(k))
  #     #   # # if (!is.null(f)) {
  #     #   # assign("f", f[[as.character(d$param[z])]], envir = globalenv())
  #     # # # }
  #     # print(k)
  #     # # if (!is.empty(k)) {
  #     #   o <- k[[as.character(d$param[z])]]
  #     #   y <- d$options[[z]]
  #     #   # doble por el map
  #     #   print("ERER")
  #     #   if (!is.null(o)) {
  #     #     if (!is.na(d$dependencias[z])) {
  #     #       print("TERER")
  #     #       o <- k[[as.character(d$param[z])]]
  #     #       y <- d$optionsDepend[[z]][[input[[as.character(d$dependencias[z])]]]][-1]
  #     #       if (!is.null(o)) {
  #     #         y <- modifyList(y, o)
  #     #       }
  #     #     }
  #     #     y <- modifyList(y, o)
  #     # # g <- modifyList(d$options[[z]], k[[as.character(d$param[z])]])
  #     # # assign("bar", g, envir = globalenv())
  #     #   }
  #     #   do.call(as.character(d$input[z]), y)
  #     #
  #     # # } else {
  #     # #   do.call(as.character(d$input[z]), d$options[[z]])
  #     # # }
  #     #
  #     #
  #   # })
  # })
  # }, priority = 5)
#
# # inicializar con los dependientes
#   # observe({
#   saveParams <- reactiveValues()
# # }, priority = 10)
#   observe({
#     # print("ESTA PASASND")
#     # map(as.character(d0$param), function(z) {
#     map(1:nrow(d0), function(z) {
#       w <- as.character(d0$param[z])
#       if (!is.null(input[[w]])) {
#         l <- list()
#         l[[as.character(d0$reactiveArgument[z])]] <- input[[w]]
#         saveParams[[w]] <- l
#         # saveParams[[z]] <- input[[z]]
#       }
#     })
#     # print(reactiveValuesToList(saveParams))
#   })
#
#
#   observeEvent(c(map(as.character(na.omit(d0$dependencias)), ~saveParams[[.x]])), {
# print("SE CORRE 2")
#     isolate({
#       k <- reactiveValuesToList(saveParams)
#     })
#     if (!is.empty(k)) {
#     d <- d0 %>%
#       filter(!is.na(dependencias))
#     map(1:nrow(d), function(z) {
#       o <- k[[as.character(d$param[z])]]
#       # y <- d$options[[z]]
#       # y <- d0$optionsDepend[[1]][["otras cosas"]]
#       y <- d$optionsDepend[[z]][[input[[as.character(d$dependencias[z])]]]]
#       if (!is.null(o)) {
#         y <- modifyList(y, o)
#         # g <- modifyList(d$options[[z]], k[[as.character(d$param[z])]])
#         # assign("bar", g, envir = globalenv())
#       }
#
#       # do.call(as.character(d$input[z]), y)
#
#       do.call(as.character(d0$updateFunction[z]), y)
#     })
#     }
#   }, ignoreInit = TRUE)
#
#


  # observeEvent(input$typeGrf, {
  # dG <
  # })


#  tipo de visualizaciøn gtypeviz
 # se van guardando los graficoas actuales



  # output$vizData <- renderDataTable({
  #   #input$dataTable
  #   data <- hot_data(input$dataTable, labels = TRUE)
  #   DT::datatable(data, options = list(scrollX = TRUE))
  # })


output$vizHgmagic <- renderHighchart({

  ctype <- input$typeC
  gtype <- input$typeGrf
  viz <- paste0('hgch_', gtype, '_', ctype)

  do.call(viz, list(data = dt,
                    title = input$title,
                    subtitle = input$subtitle,
                    caption = input$caption,
                    horLabel = input$horLabel,
                    verLabel = input$verLabel,
                    horLine = input$horLine,
                    horLineLabel = input$horLineLabel,
                    verLine = input$verLine,
                    verLineLabel = input$verLineLabel,
                    labelWrap = input$labelWrap,
                    # #colors = NULL,
                    #colorScale = input$colorScale, esta flayando
                    #agg = input$agg, esta flayando
                    orientation = input$orientation,
                    # #marks = c(".",   ","),
                    #nDigits = input$nDigits, pensar
                    #dropNa = input$dropNa,
                    highlightValueColor = input$highlightValueColor,
                    highlightValue = input$highlightValue,
                    #percentage = input$percetage,
                    # #format = c("", ""),
                    order = input$order,
                    #sort = input$sort,
                    sliceN = input$sliceN,
                    # tooltip = input$tooltip,
                    #export = input$export,
                    theme = tma(background = '#FFFFFF')))

})

  output$vizGgmagic <- renderPlot({
    gg_bar_Cat(sampleData('Cat'))
  })

  output$viz <- renderUI({
    library <- input$library
    if (is.null(library)) return()

    if (library == 'hgchmagic') {
      h <- highcharter::highchartOutput('vizHgmagic')}
    if (library == 'ggmagic') {
      h <- plotOutput('vizGgmagic')
    }
    h
  })





}
shinyApp(ui,server)




