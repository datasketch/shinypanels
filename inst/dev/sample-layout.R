
library(dsAppLayout)
library(shinyjs)
library(tidyverse)

styles <- "#sidebar{background-color: #f9f9f9}"

ui <- dsAppPage(skin = "magenta",styles = styles,
  dataControls(label = "Edit data",
    verbatimTextOutput("debug"),
    br()
    ),
  dataPreview(
    h3("This is data preview")
  ),
  vizControls(label = "Personaliza tu vis",
    h4("This is vis controls"),
    radioButtons("radios",NULL,choices = c("XXXX", "YYYY")),
    textInput("title",NULL)
  ),
  vizPreview(
    p("THIS IS VIZ PREVIEW"),
    plotOutput("viz")
  ),
  dsModal("hola", h2("MODAL"))
)

server <- function(input,output,session){
  output$debug <- renderPrint({
    input$radios
  })
  output$viz <- renderPlot(
    plot(cars)
  )

}
shinyApp(ui,server)




