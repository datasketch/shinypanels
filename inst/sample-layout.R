library(dsAppLayout)

ui <- dsAppPanels(
  panel(title = "Edit Data", color = "chardonnay", collapsed = FALSE, width =  300,
        head = h2("Head"),
        body = div(
          h2("Body"),
          selectizeInput("lang", "Reactive lang", choices = c("es", "en"), selected = "en"),
          tableInputUI("dataIn",  selected = "sample",
                       choices = list("Copiar & Pegar"="pasted",
                                      "Cargar"="fileUpload",
                                      "GoogleSheet" = "googleSheet",
                                      "Muestra"="sampleData",
                                      "Mi librería" = "dsLibrary"
                       )
          ),
          img(src="https://placeimg.com/640/480/any")
        ),
        footer = h3("This is a footer")
  ),
  panel(title = "Visualize", color = "magenta",
        head = h2("Head 2"),
        body = div(
          h2("Body"),
          img(src="https://placeimg.com/640/480/any")
        ),
        footer = list(
          div(class="panel-title", "Tipos de visualización"),
          h3("This is a footer")
        )
  )
)

server <- function(input, output, session) {

  labels <- reactive({
    lang <- input$lang
    labels_en <- list(
      "copy_paste" = "Copy and paste",
      "copy_paste_placeholder" = "Paste here",
      "choose_file" = "Choose file",
      "choose_file_button" = "Browse",
      "choose_file_placeholder" = "No file selected",
      "select_sample_data" = "Select Sample Data"
    )
    labels_es <- list(
      "copy_paste" = "Copiar y pegar",
      "copy_paste_placeholder" = "Pegar aquí",
      "choose_file" = "Seleccione archivo",
      "choose_file_button" = "Cargar",
      "choose_file_placeholder" = "Ningún archivo seleccionado",
      "select_sample_data" = "Seleccione tabla de ejemplo")
    if(lang == "es"){
      return(labels_es)
    }else{
      return(labels_en)
    }
  })


  observe({
    inputData <- callModule(tableInput, "dataIn",
                            labels = labels(),
                            sampleFile = list())
  })


  # output$test <- renderUI({
  #   dsAppWidgets::buttonImage(id = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
  #                             labels = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
  #                             values = c('perro', 'gato', 'jirafa', 'elefante', 'coco'))
  # })

}
shinyApp(ui, server)




