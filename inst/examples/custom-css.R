library(dsAppLayout)

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


ui <- dsAppPanels( styles = styles,
  panel(title = "First Panel", color = "olive", collapsed = FALSE, width =  300,
        head = h2("Head"),
        body = div(
          h2("Body"),
          selectizeInput("selector", "Select One", choices = c("First", "Second"), selected = "Fist"),
          img(src="https://placeimg.com/640/480/any")
        ),
        footer = h3("This is a footer")
  ),
  panel(title = "Visualize", color = "olive",
        head = h2("Head 2"),
        body = div(
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
}
shinyApp(ui, server)

