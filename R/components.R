#'
#'
#' #' @export
#' pagerButtons <- function(id, prevLabel = "Previous", nextLabel = "Next",
#'                          position = ""){
#'   classPrev <- "btn-step-prev"
#'   classNext <- "btn-step-next"
#'   if(position == "side"){
#'     classPrev <- paste("previous",classPrev)
#'     classNext <- paste("next",classNext)
#'   }
#'   tags$ul(id = id, class = "pager",
#'          tags$li(class = classPrev,
#'                 tags$a(href="#", prevLabel)
#'          ),
#'          tags$li(class = classNext,
#'                 tags$a(href="#", nextLabel)
#'          )
#'   )
#' }
#'
#' #' @export
#' jumpStepButton <- function(id, label = "Jump", jumpTo = NULL){
#'   tags$a(href="#", class = "btn btn-default btn-step-jump", "data-jumpto" = jumpTo, label)
#' }
#'
#' #' @export
#' nextStepButton <- function(id, label = "Next"){
#'   tags$a(href="#", class = "btn btn-default btn-step-next", label, span(icon("angle-right", class = "fa-1x")))
#' }
#'
#' #' @export
#' prevStepButton <- function(id, label = "Prev"){
#'   tags$a(href="#", class = "btn btn-default btn-step-prev", span(icon("angle-left", class = "fa-1x")), label)
#' }
