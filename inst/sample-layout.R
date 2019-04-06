library(dsAppLayout)

ui <- dsAppPanels(
  panel(title = "Edit Data", color = "chardonnay", collapsed = FALSE, width =  300,
    head = h2("Head"),
    body = div(
      h2("Body"),
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

  # output$test <- renderUI({
  #   dsAppWidgets::buttonImage(id = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
  #                             labels = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
  #                             values = c('perro', 'gato', 'jirafa', 'elefante', 'coco'))
  # })

}
shinyApp(ui, server)




