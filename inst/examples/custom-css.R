library(shinypanels)

styles <- "

app-container {
 background-color: #F2F7F9;
}

.top-olive {
	border-top: 2px solid #b0d361;
}
.text-olive {
	color: #b0d361;
}
.icon-close--olive line {
	stroke: #b0d361;
}


"


ui <- panelsPage( styles = styles,
  header = p("THIS IS A CUSTOM TITLE"),
  panel(title = infoTooltip("First Panel", "info panel"), color = "olive", collapsed = FALSE, width =  400,
        #head = h2("Head"),
        body = div(
              infoTooltip("Body", "Duis metus leo, sollicitudin sit amet bibendum sit amet, elementum a risus. Maecenas in bibendum felis. Etiam lobortis fringilla purus at dignissim. Etiam in leo ac lorem venenatis placerat. Proin sodales sagittis ipsum ac molestie. Quisque vitae egestas metus. Pellentesque molestie eget arcu a pellentesque. Nunc vel convallis quam. Nam vehicula, massa vel bibendum accumsan, ante nunc rutrum ante, eu mattis mi arcu eu dolor.", icon = "cloud"
              ),
          box(title = "test-box",
              collapsed = FALSE,
              "esto es una caja"
          ),
          br(),
          br(),
          selectizeInput("selector", "Select One", choices = c("First", "Second"), selected = "Fist"),
          img(src="https://placeimg.com/640/480/any")
        ),
        footer = h3("This is a footer")
  ),
  panel(title = "Visualize", color = "olive",
        head = h2("Head 2"),
        body = div(
          uiOutput("test"),
          h2(textOutput("selected")),
          img(src="https://placeimg.com/640/480/nature")

        ),
        footer = list(
          div(class="panel-title", "Tipos de visualización"),
          h3("This is a footer")
        )
  )
)

server <- function(input, output, session) {

  output$selected <- renderText({
    input$selector
  })

  output$test <- renderUI({
    box(title = "test-box-b",
        collapsed = T,
        #div(class = 'test-content',
        "Negro chuchón"
        #)
    )
  })

}
shinyApp(ui, server)

