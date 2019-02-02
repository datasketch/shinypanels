
#' Adds the content of www to shinyWidgets/
#'
#' @importFrom shiny addResourcePath registerInputHandler
#'
#' @noRd
#'
.onLoad <- function(...) {
  #shiny::addResourcePath('shinyWidgets', system.file('www', package = 'shinyWidgets'))
  try({ shiny::removeInputHandler("dsHotBinding") })

  shiny::registerInputHandler("dsHotBinding", function(x, ...) {
    if (is.null(x))
      NULL
    else{
      x <- jsonlite::fromJSON(x)
      list(data = x$data,
           dic = x$dic,
           selected = x$selected
      )
    }
  }, force = TRUE)

}
