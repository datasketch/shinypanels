library(jsonlite)
library(dsAppLayout)
library(shinyjs)
library(colourpicker)
library(tidyverse)
library(DT)
library(hgchmagic)
library(ggmagic)
library(webshot)

styles <- "#sidebar{background-color: #f9f9f9} .shiny-html-output {
background-color: transparent; color: white;} #vizEnd{background:#ffffff;}"
random_name <- function(n = 10) {
  paste0(sample(c(LETTERS, letters, 0:9), n, TRUE), collapse = "")
}
conf <- fromJSON("ds-app-config.json", simplifyDataFrame = FALSE)
initial_values_df <- data.frame("name" = c("title", "subtitle", "caption", "horLabel", "verLabel", "theme","tooltip", "legendTitle", "horLineLabel", "verLineLabel",
                                           "horLine", "verLine",
                                           "colors", "colorText", "highlightValueColor",
                                           "colorScale", "orientation",
                                           "agg", "graphType",
                                           "dropNa", "percentage", "showText", "export", "startAtZero", "spline",
                                           "dropNaV",
                                           "format", "marks", "nDigits", "legendPosition",
                                           "shapeType",
                                           "highlightValue",
                                           "labelRatio", "labelWrap", "labelWrapV1", "labelWrapV2", "sliceN", "colorOpacity",
                                           "order", "order1", "order2",
                                           "sort"),
                                "choices" = I(list(list(NULL), list(NULL), list(NULL), list(NULL), list(NULL),  list("choices" = c("Datasketch" = "datasketch", "nombre1" = "nomb1", "nombre2" = "nomb2")), list(NULL), list(NULL), list(NULL), list(NULL),
                                                   list("min" = 0, "max" = Inf), list("min" = 0, "max" = Inf),
                                                   list(NULL), list(NULL), list(NULL),
                                                   list("choices" = c("Discreta" = "discrete", "Continua" = "continuous", "Ninguna" = "no")), list("choices" = c("Vertical" = "ver", "Horizontal" = "hor"), inline = TRUE),
                                                   list("choices" = c("Total" = "sum", "Promedio" = "mean", "Mediana" = "median"), inline = TRUE), list("choices" = c("Grupo" = "grouped", "Stack" = "stacked"), inline = TRUE),
                                                   list(NULL), list(NULL), list(NULL), list(NULL), list(NULL), list(NULL),
                                                   list(choices = c("Categorías leyenda" = 1, "Categorías eje" = 2)),
                                                   list(NULL), list("choices" = c(". & ,", ", & .")), list("min" = 0, "max" = 10, "step" = 1), list("choices" = c("Derecha" = "right", "Izquierda" = "left", "Arriba" = "top", "Abajo" = "bottom")),
                                                   list("choices" = c("Círculo" = 19, "Triángulo" = 17, "Rombo" = 18, "Cuadrado" = 15)),
                                                   list("multiple" = TRUE),
                                                   list("min" = 0, "max" = 1), list("min" = 1, "max" = 100, "step" = 1), list("min" = 1, "max" = 100, "step" = 1), list("min" = 1, "max" = 100, "step" = 1), list("min" = 0, "step" = 1), list("min" = 0, "max" = 1),
                                                   list("multiple" = TRUE), list("multiple" = TRUE), list("multiple" = TRUE),
                                                   list("choices" = c("No" = "no", "Descendientemente" = "desc", "Ascendientemente" = "asc")))),
                                stringsAsFactors = FALSE)



ui <- dsAppPage(skin = "magenta", styles = styles,
                dataControls(label = "Edit data",
                             br()
                ),
                dataPreview(
                  h3("This is data preview"),
                  dsHot("dataTable", data = mtcars)),
                vizControls(label = "Personaliza tu vis",
                            basic = list(uiOutput("basic")),
                            advanced = list(uiOutput("advanced")),
                            uiOutput("libraryDiv")

                ),
                vizPreview(
                  #radioButtons("library", label = "Librería de visualización", choices = c("hgchmagic", "ggmagic"), inline = TRUE),
                  p("THIS IS VIZ PREVIEW"),
                  verbatimTextOutput('aver'),
                  uiOutput('vizEnd'),
                  uiOutput("butGraf"),
                  radioButtons('typeGrf', 'graficos', c("bar", "pie", "donut", "line", "area"), inline = TRUE),
                  radioButtons('typeC', 'columnas', c("Cat", "CatNum", "CatCat", "CatCatNum", "CatNumP"), inline = TRUE),
                  br()
                ),
                dsModal("hola",
                        uiOutput('downOptions'))
                )

server <- function(input, output, session) {
  # data columns after ctypes
  dataCols <- reactiveValues()

  # graph type
  gtype <- reactive({
    if (is.null(input$last_graph)) {
      "bar"
    } else {
      input$last_graph
    }
  })

  # ctype
  ctype <- reactive({
    # if (is.null(input$dataTable$selected)) {
    #   ct <- NULL
    # } else {
      ct <- input$typeC
      # ct0 <- input$dataTable$selected$ctype
      # names(ct0) <- input$dataTable$selected$label
      # # posibilidades de ctypes según el tipo de viz escogido
      # v0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype()
      # v1 <- map_chr(seq_along(conf[[which(v0)]]$canonic_ctypes), ~conf[[which(v0)]]$canonic_ctypes[[.x]]$canonic_ctype)
      # b0 <- belongingCtypesCombinations(ct0, v1)
      # if (!is.null(b0)) {
      #   ct <- b0[1]
      #   dataCols$cols <- strsplit(names(ct), "\\|")[[1]]
      # }
    #}
    ct
  })


  # filtrando conf
  conf_filtrado <- reactiveValues()

  # radiobutton para escoger librería y filtrando archivo de cofiguración
  output$libraryDiv <- renderUI({
    # reactivo tipo viz
    gtype <- gtype()
    # reactivo ctypes
    ctype <- 'Cat'#ctype()
    # cuáles librerías tienen funciones para gtype ctype
    c0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype
    c1 <- map(seq_along(conf[[which(c0)]]$canonic_ctypes), ~conf[[which(c0)]]$canonic_ctypes[[.x]]$canonic_ctype) == ctype
    lib_values <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$id_library)
    names(lib_values) <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$label_library)
    conf_filtrado$conf0 <- conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library
    radioButtons("library", label = "Librería de visualización", choices = lib_values, selected = input$library, inline = TRUE)
  })

  # generando datos (mientras tanto)
  dt0 <- reactive({
    if (!is.null(input$typeC)) {
      if (input$typeC %in% "Cat") {
        d <- data.frame("Njdn" = c(rep("Sjd kaka dj dj", 5),
                                   rep("AJ djajfk ja", 8),
                                   rep(NA, 3),
                                   rep("AJ djajfkkdsjfs fjdshfjsa fjs", 13),
                                   rep("AJ sdfjsahjfdhjsa sdf dsajfjd jdsf", 18)),
                        # "JSJS" = 1,
                        stringsAsFactors = FALSE)
      }
      if (input$typeC %in% "CatNum") {
        d <- sampleData("Cat-Num")
      }
      if (input$typeC %in% "CatCat") {
        d <- sampleData("Cat-Cat")
      }
      if (input$typeC %in% "CatCatNum") {
        d <- sampleData("Cat-Cat-Num")
      }
      if (input$typeC %in% "CatNumP") {
        d <- sampleData("Cat-NumP")
      }
      d
    }
  })


  # tipo de gráfica
  output$butGraf <- renderUI({
    ctype <- ctype()
    grafs <- unlist(map(seq_along(conf), function(z) {
      d0 <- NULL
      d1 <- conf[[z]]$canonic_ctypes
      d2 <- map(seq_along(d1), ~d1[[.x]]$canonic_ctype)
      if (ctype %in% d2) {
        d0 <- conf[[z]]$id_viztype
      } else {
        d0
      }
    }))

    if (!is.null(grafs)) {
      l <- map(grafs, function(z) {
        tags$button(id = z,
                    class = "imgButton",
                    type = "button",
                    tags$img(src = paste0('plotLogos/', z, '.png'), class =  'imgCont')
        )})
      l[[1]] <- HTML(gsub('"imgButton"', '"imgButton active"', l[[1]]))
      l
    }
  })

  # para que renderice widgets en el tab avanzado
  output$advanced <- renderUI({})
  outputOptions(output, "advanced", suspendWhenHidden = FALSE)


  observe({
    library <- input$library
    if (!is.null(library)) {
      ctype <- ctype()
      gtype <- gtype()

      # json
      c0 <- map(seq_along(conf_filtrado$conf0), ~conf_filtrado$conf0[[.x]]$id_library) == input$library
      c1 <- conf_filtrado$conf0[[which(c0)]]$params
      conf_filtrado$conf1 <- c1
      assign("c1", c1, envir = globalenv()) ############333 eleimnoiar
      basico <- map(seq_along(c1), ~c1[[.x]]$panel) == "Básico"
      avanzado <- map(seq_along(c1), ~c1[[.x]]$panel) == "Avanzado"
      secciones <- map(seq_along(c1), ~c1[[.x]]$label_panel)
      secciones_basico <- map(which(basico), ~c1[[.x]]$label_panel)
      secciones_avanzado <- map(which(avanzado), ~c1[[.x]]$label_panel)

      output$basic <- renderUI({
        map(unique(secciones_basico), function(z) {
          div(id = paste0("basico-", z),
              h4(z),
              map(seq_along(c1), function(s) {
                l0 <- list()
                l1 <- list()
                if (c1[[s]]$panel == 'Básico' && c1[[s]]$label_panel == z) {
                 # l0 <- isolate(input[[c1[[s]]$name]])#c1[[s]]
                  v0 <- isolate(input[[c1[[s]]$name]])
                  if (is.null(v0)) {
                    v0 <- c1[[s]]$default_value
                    if (c1[[s]]$name %in% "sliceN") {
                      v0 <- length(unique(dt0()[[1]]))
                    }
                  }
                  v0 <- list(v0)
                  names(v0) <- c1[[s]]$default_value_field
                  s0 <- list()
                  if (c1[[s]]$name %in% "sliceN") {
                    s0 <- list("max" = length(unique(dt0()[[1]])))
                  }

                  l0 <- list(do.call(c1[[s]]$input_type,
                                     c(list("inputId" = c1[[s]]$name,
                                            "label" = HTML(c1[[s]]$label)),
                                       v0,
                                       s0,
                                       initial_values_df$choices[[which(initial_values_df$name == c1[[s]]$name)]])))

                } else {
                  return()
                }
                if (!is.null(c1[[s]]$child_params)) {
                  w0 <- map(seq_along(c1[[s]]$child_params), ~c1[[s]]$child_params[[.x]]$selected_value)
                  if (length(w0) > 1) {
                    w1 <- input[[c1[[s]]$name]]
                    if (is.null(w1)) {
                      w1 <- c1[[s]]$default_value
                    }
                    w2 <- which(map(seq_along(c1[[s]]$child_params), ~c1[[s]]$child_params[[.x]]$selected_value) == w1)
                    c2 <- c1[[s]]$child_params[[w2]]$params
                  } else {
                    w1 <- input[[c1[[s]]$name]]
                    c2 <- list()
                    if (sum(nchar(w1), na.rm = TRUE)) {
                      w1 <- 1
                      c2 <- c1[[s]]$child_params[[1]]$params
                    }
                  }
                  if (!is.null(c2$panel)) {
                    if (c2$panel == "Básico" & c2$label_panel == z) {
                      t0 <- input[[c2$name]]
                      if (is.null(t0)) {
                        t0 <- c2$default_value
                      }
                      t0 <- list(t0)
                      names(t0) <- c2$default_value_field
                      l1 <- list(do.call(c2$input_type,
                                         c(list("inputId" = c2$name,
                                                "label" = HTML(c2$label)),
                                           t0,
                                           initial_values_df$choices[[which(initial_values_df$name == c2$name)]])))
                    }
                  }
                }

                c(l0, l1)

              })
          )
      })
      })

      output$advanced <- renderUI({
        map(unique(secciones_avanzado), function(z) {
          div(id = paste0("avanzado-", z),
              h4(z),
              map(seq_along(c1), function(s) {
                l0 <- list()
                l1 <- list()
                if (c1[[s]]$panel == "Avanzado" & c1[[s]]$label_panel == z) {
                  # v0 <- NULL
                  v0 <- isolate(input[[c1[[s]]$name]])
                  if (is.null(v0)) {
                    v0 <- c1[[s]]$default_value
                  }
                  v0 <- list(v0)
                  names(v0) <- c1[[s]]$default_value_field
                  h0 <- list()
                  if (c1[[s]]$name %in% "highlightValue") {
                    ### PRIMERA CATEGORÍA.... no uno..
                    h0 <- list("choices" = sort(as.character(unique(dt0()[[1]])), na.last = TRUE))
                  }
                  o0 <- list()
                  if (c1[[s]]$name %in% c("order", "order1", "order2")) {
                    o0 <- list("choices" = sort(as.character(unique(dt0()[[1]])), na.last = TRUE))
                  }
                  l0 <- list(do.call(c1[[s]]$input_type,
                                     c(list("inputId" = c1[[s]]$name,
                                            "label" = HTML(c1[[s]]$label)),
                                       v0,
                                       h0,
                                       o0,
                                       initial_values_df$choices[[which(initial_values_df$name == c1[[s]]$name)]])))

                }
                if (!is.null(c1[[s]]$child_params)) {
                  w0 <- map(seq_along(c1[[s]]$child_params), ~c1[[s]]$child_params[[.x]]$selected_value)
                  if (length(w0) > 1) {
                    w1 <- input[[c1[[s]]$name]]
                    if (is.null(w1)) {
                      w1 <- c1[[s]]$default_value
                    }
                    w2 <- which(map(seq_along(c1[[s]]$child_params), ~c1[[s]]$child_params[[.x]]$selected_value) == w1)
                    c2 <- c1[[s]]$child_params[[w2]]$params
                  } else {
                    w1 <- input[[c1[[s]]$name]]
                    c2 <- list()
                    if (sum(nchar(w1), na.rm = TRUE)) {
                      w1 <- 1
                      c2 <- c1[[s]]$child_params[[1]]$params
                    }
                  }
                  if (!is.null(c2$panel)) {
                    if (c2$panel == "Avanzado" & c2$label_panel == z) {
                      t0 <- input[[c2$name]]
                      if (is.null(t0)) {
                        t0 <- c2$default_value
                      }
                      t0 <- list(t0)
                      names(t0) <- c2$default_value_field
                      l1 <- list(do.call(c2$input_type,
                                         c(list("inputId" = c2$name,
                                                "label" = HTML(c2$label)),
                                           t0,
                                           initial_values_df$choices[[which(initial_values_df$name == c2$name)]])))
                    }
                  }
                }
                c(l0, l1)
              })
          )
        })
      })



      }
      })

  # output$aver <- renderPrint({
  #   dt0()
  # })

  parametros <- reactive({
    p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)

    i <- map(p, ~input[[.x]])
    names(i) <- p
    w0 <- which(p %in% "dropNaV")
    w1 <- which(p %in% "format")
    w2 <- which(p %in% c("labelWrapV1", "labelWrapV2"))
    w3 <- which(p %in% "marks")
    w4 <- which(p %in% "tooltip")
    w5 <- which(p %in% "theme")

    if (sum(w0) > 0) {
      r <- c(TRUE, TRUE)
      if (length(input$dropNaV) < 2) {
        r[setdiff(1:2, as.numeric(input$dropNaV))] <- FALSE
      }
      i[[w0]] <- r
    }
    if (sum(w1) > 0) {
      r0 <- strsplit(input$format, "&")[[1]]
      r1 <- replace_na(c(r0[1], r0[2]), "")
      i[[w1]] <- r1
    }
    if (sum(w3) > 0) {
      i[[w3]] <- strsplit(input$marks, "&")[[1]]
    }
    if (sum(w4) > 0) {
      i[[w4]] <- NULL
    }
    if (sum(w5) > 0) {
      i[[w5]] <- NULL
    }
    if (sum(w2) > 0) {
      i <- i[-w2]
      i$labelWrapV <- c(input$labelWrapV1, input$labelWrapV2)
    }
    i
  })
  # tipo de output dependiendo la librería
  output$vizEnd <- renderUI({
    idLib <- input$library
    if (is.null(idLib)) return()
    if (idLib == 'ggmagic') {
      viz <- plotOutput('plotGg') }
    if (idLib == 'hgchmagic') {
      viz <- highchartOutput('plotHc')
    }
    viz
  })

  # gráfica de ggmagic
  plot_ggmagic <- reactive({
    if (input$library != "ggmagic") return()
    ctype <- ctype()
    gtype <- gtype()
    typeV <- paste0('gg_', gtype, '_', ctype)
    print(typeV)
    viz <- do.call(typeV, c(list(dt0()), parametros()))
  })

  # gráfica de hgchmagic
  plot_hcmagic <- reactive({
    if (input$library != "hgchmagic") return()
    ctype <- ctype()
    gtype <- gtype()
    typeV <- paste0('hgch_', gtype, '_', ctype)
    ###################eliminar
    assign("dt", dt0(), envir = globalenv())
    assign("par", parametros(), envir = globalenv())
    viz <- do.call(typeV, c(list(dt0()), parametros()))
  })

  # renderizando ggplot
  output$plotGg <- renderPlot({
    print(plot_ggmagic())
  })

  # renderizando hgcharts
  output$plotHc <- renderHighchart({
    print(plot_hcmagic())
  })



  # descargas
  output$downOptions <- renderUI({
    idLib <- input$library
    if (is.null(idLib)) return()
    if (idLib == 'ggmagic') {
      tx <-  div(
        p('Descarga tu gráfico en los siguientes formatos:'),
        downloadButton('Gg_png', 'png', class = "buttonDown"),
        downloadButton('Gg_jpeg', 'jpeg', class = "buttonDown"),
        downloadButton('Gg_svg', 'svg', class = "buttonDown"),
        downloadButton('Gg_pdf', 'pdf', class = "buttonDown")
      ) }
    if (idLib == 'hgchmagic') {
      tx <- div(
        p('Descarga tu gráfico en los siguientes formatos:'),
        downloadButton('Hc_html', 'html', class = "buttonDown"),
        downloadButton('Hc_png', 'png', class = "buttonDown"),
        downloadButton('Hc_jpeg', 'jpeg', class = "buttonDown"),
        downloadButton('Hc_pdf', 'pdf', class = "buttonDown")
      )}
    tx

  })


  tempDir <- reactive({
    last_ext <- input$last_btn
    if (is.null(last_ext)) return()
    dicTemp <- tempdir()
    n <- sample(1:10, 1)
    fileName <- random_name(n)
    x <-  list(
      'Dir' = dicTemp,
      'viz_id' = fileName,
      'ext' = paste0('.', gsub('.+_','' , last_ext))
    )
    x
  })

  observe({
    map(c('Gg_png', 'Gg_jpeg', 'Gg_svg', 'Gg_pdf'),
        function(z) {output[[z]] <- downloadHandler(
          filename = function() {
            paste0(tempDir()$Dir, tempDir()$viz_id, tempDir()$ext )},
          content = function(file) {
            ggmagic::save_viz(file, plot_ggmagic(), tempDir()$ext)
          })
        })
  })


  observe({
    map(c('Hc_html','Hc_png', 'Hc_jpeg', 'Hc_svg', 'Hc_pdf'),
        function(z) {output[[z]] <- downloadHandler(
          filename = function() {
            paste0(tempDir()$Dir, tempDir()$viz_id, tempDir()$ext )},
          content = function(file) {
            hgchmagic::save_viz(file, plot_hcmagic(), tempDir()$ext)
          })
        })
  })
}

shinyApp(ui, server)
