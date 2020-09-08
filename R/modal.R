#' Modal window
#'
#' @param title title for the modal
#' @param id html attribute id for the component
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @examples
#' modal()
#' @export
modal <- function(..., title = NULL, id = NULL, whole_window = FALSE){
  contents <- rlang::dots_list(...)
  div(class = "modal", id = id, whole_window = whole_window,
      div(class = "modal-wrapper",
          div(class = "modal-title",
              tags$h3(title),
              tags$button(style = "background-color: inherit; border: none;",
                          svgX())),
          div(class = "modal-content", div(contents))))
}

#' Modal button to trigger a modal
#'
#' @param label label for the button
#' @param modal_id modal id to be triggered by the button
#' @param id html attribute id for the button
#'
#' @return None
#'
#' @examples
#' modal()
#' @export
modalButton <- function(modal_id = NULL, label = NULL, id = NULL) {
  tags$button('data-modal' = modal_id,
              class="modal-trigger",
              id = id,
              tags$span(label)
  )
}


#' @export
showModal <- function(modal_id, session = getDefaultReactiveDomain()) {
  session$sendCustomMessage("showModalManually", modal_id)
}

#' @export
removeModal <- function(modal_id, session = getDefaultReactiveDomain()) {
  session$sendCustomMessage("removeModalManually", modal_id)
}
