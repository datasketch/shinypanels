library(dsAppLayout)
library(dsAppWidgets)
library(hgchmagic)

ui <- dsAppPage(dataControls = HTML("Controles data"),
                dataPreview =
                dataPreview(
                  h3("This is data preview"),
                  dsHot("dataTable", data = diamonds),
                  verbatimTextOutput("debug_data")
                ),
                vizControls = "controles",
                vizPreview = highchartOutput("viz") ,
                vizIcons = "zona de iconos")

server <- function(input, output, session) {

  output$viz <- renderHighchart({
    hgch_bar_CatNum(sampleData("Cat-Num", 100))
  })

}
shinyApp(ui, server)




