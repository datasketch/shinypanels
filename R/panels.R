
#' @export
panel <- function(head = NULL, body = NULL, footer = NULL,
                  title = NULL, color = "malibu",
                  id = NULL, collapsed = FALSE, width = NULL,
                  ...){
  collapsed <- ifelse(collapsed, "is-collapsed", "panel--expanded")
  if(is.null(title)) stop("Need panel title")

  #if(!is.null(width)) width <- glue("data-width='{width}'")

  div(class=glue("panel is-collapsible box-shadow top-{color} {collapsed} "),
      `data-width` = width,
      id=id,
      div(class="panel-head",
          div(class="panel-title text-{color}", title),
          svgX(color)
      ),
      div(class="panel-body",
          div(class="panel-content",
              body
          )
      ),
      div(class="panel-footer box-shadow",
          footer
      )
  )
}

#' @export
topbar <- function(title = NULL, image = NULL, background_color = NULL){
  HTML(
    glue('
     <div style="background-color: {background_color}" class="topbar">
      <img class="topbar__img" src="{image}"/>
      <h3 class="topbar__title">{title}</h3>
     </div>
    ')
  )
}

#' @export
box <- function(..., title = NULL, collapsed = TRUE, color = ""){
  # contents <- list(...)
  contents <- rlang::dots_list(...)
  div(class = "box-collapsible",
      tags$button(class = "box-collapsible-trigger", span(title),
                  svgArrow()
                  ),
      div(class = "box-collapsible-content", div(contents))
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
modalBtn <- function(modal_id = NULL, label = NULL){
  tags$button('data-modal' = modal_id,
              class="modal-trigger",
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
