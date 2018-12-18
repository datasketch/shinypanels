library(jsonlite)
library(dsAppLayout)
library(shinyjs)
library(colourpicker)
library(tidyverse)
library(DT)
library(hgchmagic)
library(ggmagic)

styles <- "#sidebar{background-color: #f9f9f9} .shiny-html-output {
background-color: transparent; color: white;} .non {display: none;}"

conf <- fromJSON("ds-app-config.json", simplifyDataFrame = FALSE)
initial_values_df <- data.frame("name" = c("title", "subtitle", "caption", "horLabel", "verLabel", "tooltip", "legendTitle",
                                           "horLine", "verLine",
                                           "colors", "colorText", "highlightValueColor",
                                           "colorScale", "orientation",
                                           "agg", "graphType",
                                           "dropNa", "percentage", "showText", "export",
                                           "format", "marks", "nDigits", "legendPosition",
                                           "highlightValue",
                                           "labelRatio", "labelWrap", "sliceN",
                                           "order", "order1", "order2",
                                           "sort"),
                                "choices" = I(list(list(NULL), list(NULL), list(NULL), list(NULL), list(NULL), list(NULL), list(NULL),
                                                   list("min" = 0, "max" = Inf), list("min" = 0, "max" = Inf),
                                                   list(NULL), list(NULL), list(NULL),
                                                   list("choices" = c("Ninguna" = "no", "Discreta" = "discrete", "Continua" = "continuous")), list("choices" = c("Vertical" = "ver", "Horizontal" = "hor"), inline = TRUE),
                                                   list("choices" = c("Total" = "sum", "Promedio" = "mean", "Mediana" = "median"), inline = TRUE), list("choices" = c("Grupos" = "grouped", "Stack" = "stacked"), inline = TRUE),
                                                   list(NULL), list(NULL), list(NULL), list(NULL),
                                                   list(NULL), list("choices" = c(". & ,", ", & .")), list("min" = 0, "max" = 10, "step" = 1), list("choices" = c("Derecha" = "right", "Izquierda" = "left", "Arriba" = "top", "Abajo" = "bottom")),
                                                   list("multiple" = TRUE),
                                                   list("min" = 0, "max" = 1), list("min" = 1, "max" = 100, "step" = 1), list("min" = 0, "step" = 1),
                                                   list("multiple" = TRUE), list("multiple" = TRUE), list("multiple" = TRUE),
                                                   list("choices" = c("No" = "no", "Descendientemente" = "desc", "Ascendientemente" = "asc")))),
                                stringsAsFactors = FALSE)





ui <- dsAppPage(skin = "magenta", styles = styles,
                dataControls(label = "Edit data",
                             verbatimTextOutput("debug"),
                             br()
                ),
                dataPreview(
                  h3("This is data preview"),
                  # dsHot("dataTable", data = mtcars),
                  verbatimTextOutput("debug_data")
                ),
                vizControls(label = "Personaliza tu vis",
                            basic = list(uiOutput("basic")),
                            advanced = list(uiOutput("advanced"))
                            # uiOutput("libraryDiv")

                            ),
                #simular
                vizPreview(
                  radioButtons("library", label = "Librería de visualización", choices = c("hgchmagic", "ggmagic"), inline = TRUE),
                radioButtons('typeGrf', 'graficos', c('bar', 'pie')),
                radioButtons('typeC', 'columnas', c("Cat", "CatNum", "CatCat", "CatCatNum")),
                p("THIS IS VIZ PREVIEW"),
                # uiOutput("vizData"),
                highchartOutput("vizHgchmagic"),
                plotOutput('vizGgmagic'),

                br()
                ),
                dsModal("hola", h2("MODAL"))
)

server <- function(input, output, session) {

  output$debug <- renderPrint({
    input$radios
  })
  output$viz <- renderUI(
    dataTableOutput("vizData")
  )

  # filtrando conf
  conf_filtrado <- reactiveValues()

  # radiobutton para escoger librería y filtrando archivo de cofiguración
  # output$libraryDiv <- renderUI({
  observe({
    # reactivo tipo viz
    gtype <- input$typeGrf
    # reactivo ctypes
    ctype <- input$typeC
    # cuáles librerías tienen funciones para gtype ctype
    c0 <- map(seq_along(conf), ~conf[[.x]]$id_viztype) == gtype
    c1 <- map(seq_along(conf[[which(c0)]]$canonic_ctypes), ~conf[[which(c0)]]$canonic_ctypes[[.x]]$canonic_ctype) == ctype
    lib_values <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$id_library)
    names(lib_values) <- map_chr(seq_along(conf[[which(c0)]]$canonic_ctypes[[which(c1)]]), ~conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library[[.x]]$label_library) ### NOMBRE:¿?¿?¿?
    conf_filtrado$conf0 <- conf[[which(c0)]]$canonic_ctypes[[which(c1)]]$library
    # radioButtons("library", label = "Librería de visualización", choices = lib_values, selected = input$library, inline = TRUE)
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
      d
    }
  })

  # para que renderice widgets en el tab avanzado
  output$advanced <- renderUI({})
  outputOptions(output, "advanced", suspendWhenHidden = FALSE)
  # renderizando los controles dentro de las secciones
  observe({
    library <- input$library
    if (!is.null(library)) {
      ctype <- input$typeC
      gtype <- input$typeGrf

      #json
      c0 <- map(seq_along(conf_filtrado$conf0), ~conf_filtrado$conf0[[.x]]$id_library) == input$library
      c1 <- conf_filtrado$conf0[[which(c0)]]$params
      conf_filtrado$conf1 <- c1
      basico <- map(seq_along(c1), ~c1[[.x]]$panel) == "Básico"
      avanzado <- map(seq_along(c1), ~c1[[.x]]$panel) == "Avanzado"
      cb <- c1[basico]
      ca <- c1[avanzado]
      secciones <- map(seq_along(c1), ~c1[[.x]]$label_panel)
      secciones_basico <- map(which(basico), ~c1[[.x]]$label_panel)
      secciones_avanzado <- map(which(avanzado), ~c1[[.x]]$label_panel)
      childs_basico <- map_lgl(which(basico), ~!is.null(c1[[.x]]$child_params))
      childs_avanzado <- map_lgl(which(avanzado), ~!is.null(c1[[.x]]$child_params))

### hacer listas por fuera... después renderizar.. esto para los hijos
      output$basic <- renderUI({
        map(unique(secciones_basico), function(z) {
          n0 <- which(secciones_basico == z)
          div(id = paste0("basico-", z),
              h4(z),
              map(n0, function(s) {
                # print(s)
                v0 <- input[[cb[[s]]$name]]
                ###########3 QUITAR CUANDO SE ARREGLE CATCATNUM GGMAGIC
                cl <- 1
                if (library == "ggmagic" & ctype %in% c("CatCat", "CatCatNum")) {
                  cl <- 2
                }
                ######################
                if (is.null(v0)) {
                  v0 <- cb[[s]]$default_value
                  if (cb[[s]]$name %in% "sliceN") {
                    v0 <- length(unique(dt0()[[cl]]))
                  }
                }
                v0 <- list(v0)
                names(v0) <- cb[[s]]$default_value_field
                s0 <- list()
                if (cb[[s]]$name %in% "sliceN") {
                  s0 <- list("max" = length(unique(dt0()[[cl]])))
                }
                do.call(cb[[s]]$input_type, c(list("inputId" = cb[[s]]$name,
                                                   "label" = cb[[s]]$label),
                                              v0,
                                              s0,
                                              initial_values_df$choices[[which(initial_values_df$name == cb[[s]]$name)]]))
              })
              ### FALTAN LOS HIJOS... SE PODRÍA HACER ASIGNANDO LISTAS CON NOMBRES DE SECCIONES Y AGREGANDO
              ### LO QUE SE NECESITE A CADA LISTA (tagList)
              # if (!is.null(cb[[s]]$child_params)) {
              #   # arreglar
              #   n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
              #   map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$label_panel)
              # }
          )
        })
      })


      output$advanced <- renderUI({
        map(unique(secciones_avanzado), function(z) {
          # print(z)
          n0 <- which(secciones_avanzado == z)
          div(id = paste0("avanzado-", z),
              h4(z),
              map(n0, function(s) {
                # print(s)
                # v0 <- NULL
                v0 <- input[[ca[[s]]$name]]
                cl <- 1
                if (library == "ggmagic" & ctype %in% c("CatCat", "CatCatNum")) {
                  cl <- 2
                }
                if (is.null(v0)) {
                  v0 <- ca[[s]]$default_value
                }
                v0 <- list(v0)
                names(v0) <- ca[[s]]$default_value_field
                h0 <- list()
                if (ca[[s]]$name %in% "highlightValue") {
                  ### PRIMERA CATEGORÍA.... no uno..
                  h0 <- list("choices" = sort(as.character(unique(dt0()[[1]])), na.last = TRUE))
                }
                o0 <- list()
                if (ca[[s]]$name %in% c("order", "order1", "order2")) {
                  o0 <- list("choices" = sort(as.character(unique(dt0()[[1]])), na.last = TRUE))
                }
                do.call(ca[[s]]$input_type, c(list("inputId" = ca[[s]]$name,
                                                   "label" = ca[[s]]$label),
                                              v0,
                                              h0,
                                              o0,
                                              initial_values_df$choices[[which(initial_values_df$name == ca[[s]]$name)]]))
                # if (!is.null(c1[[s]]$child_params)) {
                #   # arreglar
                #   n1 <- which(!map_lgl(1:20, ~is.null(conf[[1]]$canonic_ctypes[[1]]$library[[1]]$params[[.x]]$child_params)))
                #   map(n1, ~conf[[1]]$canonic_ctypes[[1]]$library[[1]]$paramssampleData("Cat-Cat")[[.x]]$label_panel)
                # }
              })
          )
        })
      })
    }
  })


  # output$vizData <- renderUI({
  #   library <- input$library
  #   if (is.null(library)) return()
  #   # if (library == 'hgchmagic') {
  #   #   h <- highchartOutput('vizHgchmagic')}
  #   if (library == 'ggmagic') {
  #     plotOutput('vizGgmagic')
  #   }
  #
  # })

  observe({
    map(c("title", "subtitle"), ~assign(.x, input[[.x]], envir = globalenv()))
    map(c("title", "subtitle"), ~print(input[[.x]]))
  })


  # output$vizHgchmagic <- renderHighchart({
  #   hgch_bar_Cat(sampleData("Cat"))
  # })


  output$vizGgmagic <- renderPlot({
    toggleCssClass("vizHgchmagic", class = "non")
    p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)
    i <- map(p, ~input[[.x]])
    names(i) <- p
    # if ()
    w <- which(p %in% c("tooltip", "format", "marks"))
    i <- i[-w]
     # assign("p", inputs, envir = globalenv())
     assign("conf", conf_filtrado$conf1, envir = globalenv())
     assign("inputs", i, envir = globalenv())

    if (input$library == "ggmagic") {
      do.call("gg_bar_Cat", c(list(sampleData("Cat")), i))
    }
    # gg_bar_Cat(sampleData("Cat"), unlist(i)
  })

  output$vizHgchmagic <- renderHighchart({
    toggleCssClass("vizGgmagic", class = "non")
    p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)
    i <- map(p, ~input[[.x]])
    names(i) <- p
    # if ()
    w <- which(p %in% c("tooltip", "format", "marks"))
    i <- i[-w]
    # assign("p", inputs, envir = globalenv())
    assign("conf", conf_filtrado$conf1, envir = globalenv())
    assign("inputs", i, envir = globalenv())

    if (input$library == "hgchmagic") {
      do.call("hgch_bar_Cat", c(list(sampleData("Cat")), i))
    }
    # gg_bar_Cat(sampleData("Cat"), unlist(i)
  })



  blabla <- reactive({
    ctype <- input$typeC
    gtype <- input$typeGrf
    iDlibrary <- input$library
    print(library)
    p <- parametros()[1:4]

    df <- dt0()
    # if (iDlibrary == 'hgchmagic') {
    #   viz <- do.call(paste0('hgch_', gtype, '_', ctype), c(list(data = df), p))}
    # if (iDlibrary ==  'ggmagic') {
      viz <- do.call(paste0('gg_', gtype, '_', ctype), c(list(data = df), p))#}
    viz
    # viz <- paste0('hgch_', gtype, '_', ctype)
  })

  # output$hola <- renderHighchart({
  #   print(blabla())
  # })

  # output$chaoBb <- renderPlot({
  #   print(blabla())
  # })


  # output$vizAver <- renderUI({
  #   library <- input$library
  #   if (library == 'hgchmagic') {
  #     viz <- highchartOutput('hola') }
  #   if (library ==  'ggmagic') {
  #     viz <- plotOutput('chaoBb')}
  #   viz
  # })
  #output$vizHgchmagic <-  #renderHighchart({
  #   print("HIGHCHAR")
  vizTemp <- reactive({
    dt0 <- sampleData('Cat')#dt0()
    # View(dt0)
      # ctype <- input$typeC
      # gtype <- input$typeGrf
      # viz <- paste0('hgch_', gtype, '_', ctype)
      # w <- which(names(parametros()) == "tooltip")
      # p <- parametros()[-w]
      # print(p)
      #h <- #do.call(viz, c(list(data = dt0),
          #                p))
      h <- hgch_area_Cat(dt0)

      print(h)
      h
  #
      # format <- c("", "")
      # if (nzchar(input$format)) {
      #   format <- strsplit(input$format, "&")[[1]]
      # }
      # ad0 <- list()
      # if (ctype %in% c("CatNum", "CatCat", "CatCatNum")) {
      #   if (grepl("Num", ctype)) {
      #     ad0 <- list(agg = input$agg)
      #   }
      #
      #   if (gtype %in% c("CatCat", "CatCatNum") ) {
      #     ad0 <- c(ad0,list(legendPosition = input$legendPosition,
      #                       legendTitle = input$legendTitle))
      #   }
      #   ad0 <- c(ad0, list(
      #     order1 = input$order1,
      #     order2 = input$order2,
      #     typeGraph = input$typeGraph))
      # } else {
      #   ad0 <- list(order = input$order)
      # }
      #
      # if (gtype %in% "pie") {
      #   ad0 <- c(ad0, list(legendPosition = input$legendPosition,
      #                      legendTitle = input$legendTitle))
      # }
      print("CATGGGG")
      # p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)
      # p <- c("title", "subtitle")
      # inp <- map(p, ~input[[.x]])
      # names(inp) <- p
      # w <- which(names(p) == "tooltip")
      # assign("g", inp, envir = globalenv())
      # print(inp)
      # hgch_bar_Cat(dt0(), unlist(inp)[-w])

      # print(do.call(viz, c(list(data = dt0()), inp[-w])))
      # do.call(viz, c(list(data = dt0(),
      #                     title = input$title,
      #                     subtitle = input$subtitle,
      #                     caption = input$caption,
      #                     horLabel = input$horLabel,
      #                     verLabel = input$verLabel,
      #                     horLine = input$horLine,
      #                     horLineLabel = input$horLineLabel,
      #                     verLine = input$verLine,
      #                     verLineLabel = input$verLineLabel,
      #                     labelWrap = input$labelWrap,
      #                     colors = NULL,
      #                     colorScale = input$colorScale,
      #                     # agg = input$agg, esta flayando
      #
      #                     orientation = input$orientation,
      #                     marks = strsplit(input$marks, "&")[[1]],
      #                     nDigits = input$nDigits,
      #                     dropNa = input$dropNa,
      #                     # highlightValueColor = input$highlightValueColor, #hijo
      #                     highlightValue = input$highlightValue,
      #                     percentage = input$percentage,
      #                     format = format,
      #                     # order = input$order,
      #                     # # sort = input$sort,# HIJO
      #                     sliceN = input$sliceN,
      #                     # tooltip = input$tooltip,
      #                     export = input$export,
      #                     theme = tma(background = '#FFFFFF')),
      #                ad0))

})



  # output$vizGgmagic <- renderPlot({
  #   dt0 <- dt0()
  #   ctype <- input$typeC
  #   gtype <- input$typeGrf
  #   viz <- paste0('gg_', gtype, '_', ctype)
  #
  #   # p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)
  #   # # p <- c("title", "subtitle")
  #   # inp <- map(p, ~input[[.x]])
  #   # names(inp) <- p
  #   # w <- which(names(p) == "tooltip")
  #   # assign("g", inp, envir = globalenv())
  #   # print(inp)
  #   # # hgch_bar_Cat(dt0(), unlist(inp)[-w])
  #   # print(do.call(viz, c(list(data = dt0()), inp[-w])))
  #
  #
  #   format <- c("", "")
  #   if (nzchar(input$format)) {
  #     format <- strsplit(input$format, "&")[[1]]
  #   }
  #   ad0 <- list()
  #   if (ctype %in% c("CatNum", "CatCat", "CatCatNum")) {
  #     if (grepl("Num", ctype)) {
  #       ad0 <- list(agg = input$agg)
  #     }
  #     if (gtype %in% c("CatCat", "CatCatNum") ) {
  #       ad0 <- c(ad0,list(legendPosition = input$legendPosition,
  #                         legendTitle = input$legendTitle))
  #     }
  #
  #     ad0 <- c(ad0, list(
  #       order1 = input$order1,
  #       order2 = input$order2,
  #       typeGraph = input$typeGraph))
  #   }else {
  #     ad0 <- list(order = input$order)
  #   }
  #
  #   if (gtype %in% "pie") {
  #     ad0 <- c(ad0, list(legendPosition = input$legendPosition,
  #                        legendTitle = input$legendTitle))
  #   }
  #   do.call(viz, c(list(data = dt0,
  #                       #
  #                       # # do.call(viz, list(data = dt0[, 1]))
  #                       title = input$title,
  #                       subtitle = input$subtitle,
  #                       caption = input$caption,
  #                       horLabel = input$horLabel,
  #                       verLabel = input$verLabel,
  #                       horLine = input$horLine,
  #                       horLineLabel = input$horLineLabel,
  #                       verLine = input$verLine,
  #                       verLineLabel = input$verLineLabel,
  #                       colors = NULL,
  #                       colorScale = input$colorScale,
  #                       # agg = input$agg, esta flayando
  #                       # labelWrap = input$labelWrap,
  #                       labelRatio = input$labelRatio,
  #                       orientation = input$orientation,
  #                       marks = strsplit(input$marks, "&")[[1]],
  #                       nDigits = input$nDigits,
  #                       # dropNa = input$dropNa,
  #
  #                       # highlightValueColor = input$highlightValueColor, #hijo
  #                       highlightValue = input$highlightValue,
  #                       percentage = input$percentage,
  #                       format = format,
  #                       order = input$order,
  #                       showText = input$showText,
  #                       # # sort = input$sort,# HIJO
  #                       sliceN = input$sliceN),
  #                  ad0))
  # })
}
shinyApp(ui, server)




