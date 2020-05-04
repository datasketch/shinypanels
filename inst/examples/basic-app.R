library(shinypanels)

ui <- panelsPage(
  panel(
    title = "Panel 1",
    width = 300,
    color = "magenta",
    body = div(

    )
  ),
  panel(
    title = "Panel 2",
    body = div(
    )
  ),
  panel(
    title = "Panel 3",
    width = 350,
    collapsed = TRUE,
    body = div(

    )
  ),
  panel(
    title = "Panel 4",
    can_collapse = FALSE,
    body = div(
    ),
    footer = HTML("Footer")
  )
)



server <-  function(input, output, session) {
}

shinyApp(ui, server)

