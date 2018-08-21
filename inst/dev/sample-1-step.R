
library(dsAppLayout)
library(shinyjs)
library(tidyverse)


ui <- stepsPage(
  stepsHeader(show = FALSE),
  stepsBody(initStep = "step1",
               stepPanel(id="step1",
                         sideBarStep(title = "FIRST",
                                     verbatimTextOutput("debug"),
                                     p("sidebar step1")
                         ),
                         mainStep(
                           p("main step1")
                         )
               )
  )
)

server <- function(input,output,session){
  output$debug <- renderPrint({
    input$dsAppLayout_current
  })
}
shinyApp(ui,server)




