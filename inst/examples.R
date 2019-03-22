library(dsAppLayout)
library(dsAppWidgets)
library(hgchmagic)

ui <- dsAppPage(dataControls = "ja",
                dataPreview = "hola",
                vizControls = uiOutput("bla"),
                vizPreview = highchartOutput("viz"),
                vizIcons = uiOutput("test"))

server <- function(input, output, session) {

  output$viz <- renderHighchart({
    hgch_bar_CatNum(sampleData("Cat-Num", 100))
  })

  output$bla <- renderUI({
    #textInput("hola", "sda", "valr")
    #sliderInput("hasd", "test", 0, 100, 30)
    selectizeInput("asd", "David es un gil", c("Si", "obvio", "Sin duda"))
  })

  output$test <- renderUI({
     dsAppWidgets::buttonImage(id = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
                               labels = c('perro', 'gato', 'jirafa', 'elefante', 'coco'),
                               values = c('perro', 'gato', 'jirafa', 'elefante', 'coco'))
  })

}
shinyApp(ui, server)




