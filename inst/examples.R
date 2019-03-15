library(dsAppLayout)
library(dsAppWidgets)
library(hgchmagic)

ui <- dsAppPage(dataControls = "ja",
                dataPreview = "hola",
                vizControls = uiOutput("bla"),
                vizPreview = highchartOutput("viz"),
                vizIcons = "iconos")#verbatimTextOutput("test"))

server <- function(input, output, session) {

  output$viz <- renderHighchart({
    hgch_bar_CatNum(sampleData("Cat-Num", 100))
  })

  output$bla <- renderUI({
    #textInput("hola", "sda", "valr")
    selectizeInput("asd", "David es un gil", c("Si", "obvio", "Sin duda"))
  })

  output$test <- renderPrint({
    "test icon viz"
  })

}
shinyApp(ui, server)




