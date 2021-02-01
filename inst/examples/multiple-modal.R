library(shinypanels)
library(shinyinvoer)
styles <- "

.modal-wrapper {
  width: 60%;
  height: 100%;
}
"

ui <- panelsPage(
  shinypanels::modal(id = 'mytest', title = 'Important message', p('This is an important message!')),
  panel(title = "Panel",
        color = "chardonnay",
        collapsed = FALSE,
        body = div(
        uiOutput("select_countries"),
        uiOutput("select_colors"),
        uiOutput("select_number")
        ),
        footer = NULL
  )
)

server <- function(input, output, session) {


  output$select_countries <- renderUI({
    selectizeInput(inputId = "countries", "Countries", c("Colombia", "Argentina", "Brazil", "Mexico"))
  })

  output$select_colors <- renderUI({
    shinyinvoer::colorPaletteInput("id_colors", "Colores", colors = c("#FEAFEA", "#AFCA31"))
  })

  output$select_number <- renderUI({
    radioButtons("id_num", "Numbers", c("One", "Two", "Three"))
  })

  observe({
    showModalMultipleId("mytest", list_id = c("select_countries", "select_colors"))
  })


}
shinyApp(ui, server)

