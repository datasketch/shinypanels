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
modal <- function(..., title = NULL, id = NULL, fullscreen = FALSE, id_wrapper = NULL, id_title = NULL, id_content = NULL){
  contents <- rlang::dots_list(...)
  div(class = "modal", id = id, `data-fullscreen` = fullscreen,
      div(class = "modal-wrapper",id = id_wrapper,
          div(class = "modal-title", id = id_title,
              tags$h3(title),
              tags$button(style = "background-color: inherit; border: none;", id = "close-modal",
                          svgX())),
          div(class = "modal-content", id = id_content, div(contents))))
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

#' @export
showModalMultipleId <- function(modal_id, list_id, session = getDefaultReactiveDomain()) {
  purrr::map(list_id, ~ session$sendCustomMessage("showModalMultiple", message = list(
    apply_id = .x, inputId = modal_id))
  )
}

