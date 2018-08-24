

#dsHot("in", cars)
#html_print(dsHot("in", cars))


ui <- fluidPage(
  verbatimTextOutput("debug"),
  dsHot("in")
)
server <- function(input,output,session){
  output$debug <- renderPrint({
    #input$in
  })
}
shinyApp(ui,server)


