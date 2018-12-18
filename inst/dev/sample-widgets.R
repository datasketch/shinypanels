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
background-color: transparent; color: white;} .non {display: none;}"
random_name <- function(n = 10) {
  paste0(sample(c(LETTERS,letters,0:9), n, TRUE),collapse = "")
}
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
                            advanced = list(uiOutput("advanced")),
                            uiOutput("libraryDiv")

                ),
                #simular
                vizPreview(
                  #radioButtons("library", label = "Librería de visualización", choices = c("hgchmagic", "ggmagic"), inline = TRUE),
                  radioButtons('typeGrf', 'graficos', c('bar', 'pie')),
                  radioButtons('typeC', 'columnas', c("Cat", "CatNum", "CatCat", "CatCatNum")),
                  p("THIS IS VIZ PREVIEW"),
                  uiOutput('vizEnd'),
                  br()
                ),
                dsModal("hola",
                        uiOutput('downOptions')
                        )
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
 output$libraryDiv <- renderUI({
  #observe({
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

 parametros <- reactive({
   p <- map(seq_along(conf_filtrado$conf1), ~conf_filtrado$conf1[[.x]]$name)
   i <- map(p, ~input[[.x]])
   names(i) <- p
   # if ()
   w <- which(p %in% c("tooltip", "format", "marks"))
   i <- i[-w]
   i
 })

 plot_ggmagic <- reactive({
   if (input$library != "ggmagic") return()
   ctype <- input$typeC
   gtype <- input$typeGrf
   typeV <- paste0('gg_', gtype, '_', ctype)
   print(typeV)
   viz <- do.call(typeV, c(list(dt0()), parametros()))
 })

 plot_hcmagic <- reactive({
   if (input$library != "hgchmagic") return()
   ctype <- input$typeC
   gtype <- input$typeGrf
   typeV <- paste0('hgch_', gtype, '_', ctype)
   print(typeV)
   viz <- do.call(typeV, c(list(dt0()), parametros()))
 })


 output$plotGg <- renderPlot({
   print(plot_ggmagic())
 })

 output$plotHc <- renderHighchart({
   print(plot_hcmagic())
 })

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




