#' Panel component for shiny panels layout
#'
#' @param head html for the panel header
#' @param body html tag list for panel body contents
#' @param show_footer include footer
#' @param footer footer contents
#' @param color color name as defined in custom css
#' @param id panel div id
#' @param collapsed panel starts as collapsed
#' @param width panel width in pixels
#' @param id panel div id
#'
#' @return None
#'
#' @examples
#' dsAppPanels()
#'
#' @export
#' @export
panel <- function(head = NULL, body = NULL, show_footer = TRUE, footer = NULL,
                  title = NULL, color = "malibu",
                  id = NULL, collapsed = FALSE, width = NULL,
                  ...){
  collapsed <- ifelse(collapsed, "is-collapsed", "panel--expanded")
  if(is.null(title)) stop("Need panel title")

  #if(!is.null(width)) width <- glue("data-width='{width}'")
  style_panel <- ifelse(show_footer,"display: block;", "display: none !important;")
  id_head <- paste0(id,"_head")
  id_body <- paste0(id,"_body")

  div(class=glue("panel is-collapsible box-shadow top-{color} {collapsed} "),
      `data-width` = width,
      id=id,
      div(class="panel-head", id = id_head,
          div(class="panel-title text-{color}", title),
          svgX(color)
      ),
      div(class="panel-body", id = id_body,
          div(class="panel-content",
              body
          )
      ),
      div(class="panel-footer", style = style_panel,
          footer
      )
  )
}

#' @export
topbar <- function(..., title = NULL, image = NULL, background_color = NULL){
  if(is.null(title) && is.null(image)){
    contents <- list(...)
  } else{
    contents <- ""
  }
  message(contents)
  div(style=glue("background-color:{background_color}"), class="topbar",
      img(class="topbar__img", src = image),
      h3(class = "topbar__title", title),
      contents
      )
}

#' @export
box <- function(..., title = NULL, collapsed = TRUE, color = "", body = NULL) {

  collapsed <- ifelse(collapsed, "box-collapsed", "no-box-collapsed")

  div(class="box-collapsible",
    tags$button(class="box-collapsible-trigger",  span(title),
    svgArrow()),
        div(class="box-collapsible-content",
          body
        )
  )
}

#' @export
modal <- function(..., title = NULL, id = NULL){
  contents <- rlang::dots_list(...)
  div(class = "modal", id = id,
      div(class = "modal-wrapper",
          div(class = "modal-title",
                tags$h3(title),
                tags$button(svgX())
              ),
          div(class = "modal-content", div(contents))
          )
      )
}

#' @export
modalBtn <- function(modal_id = NULL, label = NULL, id_modal = NULL) {
  tags$button('data-modal' = modal_id,
              class="modal-trigger",
              id = id_modal,
                tags$span(label)
              )
}

svgArrow <- function(color){
  HTML(glue('<svg class="box-collapsible-icon box-collapsible-icon-color" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
  <path d="M10.707 7.05L10 6.343 4.343 12l1.414 1.414L10 9.172l4.243 4.242L15.657 12z"/></svg>
'))
}

svgX <- function(color = ""){
  HTML(glue('<svg class="icon-close icon-close--{color}" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
                        <line x1="0" y1="0" x2="10" y2="10" />
                        <line x1="10" y1="0" x2="0" y2="10" />
                        </svg>
             '))
}
