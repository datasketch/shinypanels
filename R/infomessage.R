#' Infomessage to show messages
#'
#' @param type one of: warning, success, error or info
#' @param id id of html element
#' @param class class of html element
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @import htmltools
#' @import glue
#' @examples
#' infomessage()
#'
#' @export
infomessage <- function(..., type = "warning",  id = NULL, class = NULL){
  if(!type %in% c("warning","error", "info", "success"))
    stop('Type must be one of "warning","error", "info", "success"')
  div(class = paste("infomessage", type, class), id = id,
      rlang::dots_list(...)
  )
}
