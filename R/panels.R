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
#' @param title panel title
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @examples
#' panel(title = "My title")
#'
#' @export
panel <- function(head = NULL, body = NULL, footer = NULL,
                  title = NULL, color = "malibu",
                  id = NULL, collapsed = FALSE, width = NULL,
                  ...){
  collapsed <- ifelse(collapsed, "is-collapsed", "panel--expanded")
  if(is.null(title)) stop("Need panel title")

  #if(!is.null(width)) width <- glue("data-width='{width}'")
  style_panel <- ifelse(!is.null(footer),"display: block;", "display: none !important;")
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

#' Top bar component for shiny panels layout
#'
#' @param title Top bar panel
#' @param image Logo image
#' @param background_color background color for top bar
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @examples
#' topbar()
#'
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

  div(class="box-collapsible",
      tags$button(class=glue("box-collapsible-trigger {state}"),  span(title),
                  svgArrow()),
      div(class=glue("box-collapsible-content {state}"),
          div(contents)
      )
  )

}

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

svgRotate <- function() {
  HTML('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 125" x="0px" y="0px">
       <path d="M30.26,21.007H6.818A4.322,4.322,0,0,0,2.5,25.325v49.35a4.322,4.322,0,0,0,4.318,4.318H30.26a4.322,
       4.322,0,0,0,4.318-4.318V25.325A4.322,4.322,0,0,0,30.26,21.007ZM4.967,30.259H32.111V68.507H4.967Zm1.851-6.785H30.26a1.853,
       1.853,0,0,1,1.851,1.851v2.467H4.967V25.325A1.853,1.853,0,0,1,6.818,23.474ZM30.26,
       76.526H6.818a1.853,1.853,0,0,1-1.851-1.851v-3.7H32.111v3.7A1.853,1.853,0,0,1,30.26,76.526Z"/>
       <path d="M18.54,71.9a1.85,1.85,0,1,0,1.849,1.851A1.853,1.853,0,0,0,18.54,71.9Z"/><path d="M93.182,46.916H43.831a4.322,4.322
       ,0,0,0-4.318,4.317V74.675a4.322,4.322,0,0,0,4.318,4.318H93.182A4.322,4.322,0,0,0,97.5,74.675V51.233A4.322,4.322,0,0,0,93.182,
       46.916Zm-4.934,2.467V76.526H50V49.383ZM41.98,74.675V51.233a1.852,1.852,0,0,1,1.851-1.85h3.7V76.526h-3.7A1.853,1.853,0,0,1,41.98,
       74.675Zm53.053,0a1.853,1.853,0,0,1-1.851,1.851H90.715V49.383h2.467a1.852,1.852,0,0,1,1.851,1.85Z"/>
       <path d="M44.756,61.1a1.851,1.851,0,1,0,1.851,1.85A1.852,1.852,0,0,0,44.756,61.1Z"/>
       <path d="M40.747,23.474a10.808,10.808,0,0,1,10.8,10.795v3.5L50.16,36.384a1.233,1.233,0,0,0-1.744,1.744l3.489,3.49a1.21,1.21,
       0,0,0,.4.266,1.234,1.234,0,0,0,1.348-.266l3.489-3.49A1.233,1.233,0,0,0,55.4,36.384l-1.384,1.384v-3.5A13.278,13.278,0,0,0,40.747,
       21.007a1.234,1.234,0,1,0,0,2.467Z"/></svg>')
}



