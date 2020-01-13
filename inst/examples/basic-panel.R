library(shinypanels)

ui <- panelsPage(
  header =  topbar(title = 'Herramienta | CO2',
         image = 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F0%2F0b%2FQt_logo_2016.svg%2F1200px-Qt_logo_2016.svg.png&f=1&nofb=1',
         background_color = 'steelblue'),
  modal(id = 'test', title = 'Test modal title', p('Modal ipsum')),
  panel(title = "First Panel", color = "chardonnay", collapsed = FALSE, width =  400,
        head = h2("Head"),
        body = div(
          h2("Body"),
          selectizeInput("selector", "Select One", choices = c("First", "Second"), selected = "Fist"),
          textInput("text", "Text input"),
          radioButtons("radioButtons1", "Radio Buttons", choices = c("First", "Second"), inline = TRUE),
          radioButtons("radioButtons2", "Radio Buttons", choices = c("First", "Second"), inline = FALSE),
          img(src="https://placeimg.com/640/180/any"),
          modalButton(modal_id = 'test', label = 'Test modal'),
        ),
        footer = NULL
  ),
  panel(title = "Visualize", color = "magenta", collapsed = FALSE,
        head = h2("Head 2"),
        body = list(
          box(title = "New box",
          collapsed = FALSE,
            p("Lorem ipsum 3"),
            selectInput("selector2", "Select", choices = 1980:2019)
          ),
          h2(textOutput("selected")),
          img(src="https://placeimg.com/640/180/nature")
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

