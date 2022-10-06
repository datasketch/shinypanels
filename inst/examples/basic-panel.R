library(shinypanels)

styles <- "
.topbar {
    padding: 20px 55px;
    background-color: #2e4856;
    font-size: 14px;
    color: #fff;
    overflow: hidden;
}

.top_title {
  margin-left: 24px;
  display: flex;
}

.topbar__img {
  height: auto;
  width: 72px;
}

.top_line {
  border-left: 1px solid #ffffff;
  margin-left: 10px;
  font-weight: 700;
}


.topbar-modal, .tex_sub {
  font-size: 14px;
  color: #fff;
}

@media only screen and (min-width: 768px) {
  .topbar, .tex_sub {
    font-size: 20px;
  }
}

@media only screen and (min-width: 1024px) {
  .topbar, .tex_sub {
    font-size: 32px;
  }
}


}

"

ui <- panelsPage(
  styles = styles,
  # header =  topbar(title = 'Herramienta | CO2',
  #        image = 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F0%2F0b%2FQt_logo_2016.svg%2F1200px-Qt_logo_2016.svg.png&f=1&nofb=1',
  #        background_color = 'steelblue'),
  header = div(style="", class="topbar",
      img(class="topbar__img", src = "https://datasketch.github.io/landing-gcs/images/logo.webp"),
      HTML("<div class = 'top_title'> HERRAMIENTA <div class = 'top_line'> <div style = 'margin-left: 10px;'> ESTIMACIÓN DE BIODIVERSIDAD Y <span class = 'tex_sub'>CAPTURA DE CO<sub>2</sub></span></div></div></div>"),
      uiOutput("for_modal"),
  ),
  modal(id = 'test', title = uiOutput("title_modal"), p('Modal ipsum'), id_wrapper = "wrapper"),
  panel(title = "First Panel", title_complent = "HOLAAAA", color = "#04bb7a", collapsed = FALSE, width =  400,
        head = h2("Head"),
        body = div(
          h2("Body"),
          infomessage(type = "warning", p("Hello, this is a warning")),
          infomessage(type = "info", p("Oh yes, this is some information")),
          infomessage(type = "success", p("You did it!")),
          infomessage(type = "error", p("Ups!, try again")),
          selectizeInput("selector", "Select One", choices = c("First", "Second"), selected = "Fist"),
          textInput("text", "Text input"),
          radioButtons("radioButtons1", "Radio Buttons", choices = c("First", "Second"), inline = TRUE),
          radioButtons("radioButtons2", "Radio Buttons", choices = c("First", "Second"), inline = FALSE),
          img(src="https://placeimg.com/640/180/any"),
          shinypanels::modalButton(id = "ss", modal_id = 'test', label = 'Test modal BLAL')
        ),
        footer = NULL
  ),
  panel(title = "Second Panel", color = "chardonnay", collapsed = FALSE, width =  400,
        head = h2("Head"),
        body = div(
          h2("Body"),
          selectizeInput("selector", "Select One", choices = c("First", "Second"), selected = "Fist"),
          textInput("text", "Text input"),
          radioButtons("radioButtons1", "Radio Buttons", choices = c("First", "Second"), inline = TRUE),
          radioButtons("radioButtons2", "Radio Buttons", choices = c("First", "Second"), inline = FALSE),
          img(src="https://placeimg.com/640/180/any"),
          shinypanels::modalButton(id = "aa", modal_id = 'test', label = 'Test modal')
        ),
        footer = NULL
  ),
  panel(title = "Visualize", color = "magenta", collapsed = FALSE,
        head = h2("Head 2"),
        body = list(
          # box(title = "New box",
          # collapsed = FALSE,
          #   p("Lorem ipsum 3"),
          #   selectInput("selector2", "Select", choices = 1980:2019)
          # ),
          uiOutput("box_test"),
          h2(textOutput("selected")),
          img(src="https://placeimg.com/640/180/nature"),
          actionButton("show", label = "Test modal 2")
        ),
        footer = list(
          div(class="panel-title", "Tipos de visualización"),
          h3("This is a footer")
        )
  )
)

server <- function(input, output, session) {


  output$title_modal <- renderUI({
    HTML(
      '
      <div class="tabs" id="download-modal" data-open="db">
        <!-- Tab links -->
        <div class="tab-list">
        <button class="tab" data-panel="db">Base de datos</button>
        <button class="tab" data-panel="chart">Gráfica</button>
        <button class="tab" data-panel="api">API</button>
        </div>
      '
    )
  })

  # modal button rendered within server
  output$for_modal <- renderUI({
    shinypanels::modalButton(id = 'id-but-mod', modal_id = 'test', label = HTML('<i class="fa fa-info-circle" style="font-size:31px;color:#fff"></i>'))
  })

  output$selected <- renderText({
    input$selector
  })

  output$box_test <- renderUI({
    box(title = "New box",
    collapsed = FALSE,
      p("Lorem ipsum 3"),
      selectInput("selector2", "Select", choices = 1980:2019)
    )
  })

  observeEvent(input$show, {
    showModal('test')
  })
}
shinyApp(ui, server)

