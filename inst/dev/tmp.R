

#dsHot("in", cars)
#html_print(dsHot("in", cars))


ui <- fluidPage(
  column(3,
    verbatimTextOutput("debug")
         ),
  column(9,
  dsHot("indata2", data = mtcars)
         )
)
server <- function(input,output,session){
  output$debug <- renderPrint({
    str(input$indata2)
  })
}
shinyApp(ui,server)


