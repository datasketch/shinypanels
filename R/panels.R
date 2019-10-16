
#' @export
panel <- function(head = NULL, body = NULL, footer = NULL,
                  title = NULL, color = "malibu",
                  id = NULL, collapsed = TRUE, width = NULL,
                  ...){
  collapsed <- ifelse(collapsed, "is-collapsed", "panel--expanded")
  if(is.null(title)) stop("Need panel title")

 #if(!is.null(width)) width <- glue("data-width='{width}'")

  div(class=glue("panel is-collapsable box-shadow top-{color} {collapsed} "),
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


svgX <- function(color){

HTML(glue('<svg class="icon-close icon-close--{color}" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
                        <line x1="0" y1="0" x2="10" y2="10" />
                        <line x1="10" y1="0" x2="0" y2="10" />
                        </svg>
             '))
}

#' #' @export
#' modal <- function(){
#'   (
#'   HTML('
#'              <div class="modal-wrapper">
#'        <div class="modal">
#'        <div class="modal-header">
#'        <div class="modal-dismiss">
#'        <svg class="icon-close icon-close--gray" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
#'        <line x1="0" y1="0" x2="10" y2="10" />
#'        <line x1="10" y1="0" x2="0" y2="10" />
#'        </svg>
#'        </div>
#'        <h3 class="modal-title text-magenta">Exportar gráfica</h3>
#'        </div>
#'        <div class="modal-content"> '
#'   ),
#'   div(class="modal-preview",
#'       plotModal
#'   ),
#'   HTML('
#'              <div class="modal-actions">
#'              <div class="modal-action">
#'              <a class="modal-action-label box-shadow text-magenta">Guardar</a>
#'              <div class="modal-action-form">
#'              <div class="form-group">
#'              <label class="text-magenta">Título</label>
#'              <input type="text" class="box-shadow">
#'              </div>
#'              <div class="form-group">
#'              <label class="text-magenta">Descripción</label>
#'              <textarea rows="4" class="box-shadow"></textarea>
#'              </div>
#'              <div class="form-group">
#'              <label class="text-magenta">Etiquetas</label>
#'              <input type="text" class="box-shadow">
#'              </div>
#'              </div>
#'              </div>
#'              <div class="modal-action">
#'              <a class="modal-action-label box-shadow text-magenta">Descargar</a>
#'              '),
#'   div(class="modal-action-form",
#'       downloadModal
#'   )
#'   )
#'
#' }


