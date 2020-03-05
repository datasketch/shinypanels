#' Box like component
#'
#' @param title title for the box
#' @param collapsed defines initial state
#' @param color color name as defined in custom css
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @import htmltools
#' @import glue
#' @examples
#' box()
#'
#' @export
box <- function(..., title = NULL, collapsed = TRUE, color = "") {

  contents <- rlang::dots_list(...)
  state <- ifelse(collapsed, '', 'active')

  # shiny::div(
  #   l,
  div(class="box-collapsible",
      tags$button(class=glue("box-collapsible-trigger {state}"),  span(title),
                  svgArrow()),
      div(class=glue("box-collapsible-content {state}"),
          div(contents)
      )
  )
}
