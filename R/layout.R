
#' @export
dsAppPage <- function(dataControls, dataPreview,
                      vizControls, vizPreview, vizIcons, ...,
                      skin = "magenta", styles = "", debug = FALSE){
  deps <- list(
    htmlDependency("font-awesome", "4.1.0",
                   src = c(href = "//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.1.0/css/"),
                   stylesheet = "font-awesome.min.css"
    ),
    # htmlDependency("index", "0.0.1",
    #                src = (file = system.file("srcjs", package = "dsAppLayout")),
    #                script = "index.js"
    # ),
    htmlDependency("style", "0.0.1",
                   src = (file = system.file("css", package = "dsAppLayout")),
                   stylesheet = "style.css"
    )
  )
  extra <- list(...)

  jsfile <- system.file("srcjs", "index.js", package = "dsAppLayout")
  indexJS <- tags$script(HTML(paste0(readLines(jsfile),collapse="\n")))
  debugJS <- tags$script(ifelse(debug,"var debug = true;","var debug = false;"))

  page <- tagList(

    div(class="app-container",
        div(class="panel is-collapsable box-shadow top-malibu is-collapsed has-settings", id="data-edit",
            HTML(paste0('
      <div class="panel-head">
      <div class="panel-title text-malibu">Editar datos</div>
      <svg class="icon-close icon-close--malibu" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
      <line x1="0" y1="0" x2="10" y2="10" />
      <line x1="10" y1="0" x2="0" y2="10" />
      </svg>
      </div>'
            )),
            div(class="panel-body",
                div(class="panel-content",
                    dataControls
                )
            )
        ),
        div(class="panel is-collapsable box-shadow top-malibu panel--expanded", id="data-prev",
            HTML(paste0('
      <div class="panel-head">
      <div class="panel-title text-malibu">Ver datos</div>
      <svg class="icon-close icon-close--malibu" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
      <line x1="0" y1="0" x2="10" y2="10" />
      <line x1="10" y1="0" x2="0" y2="10" />
      </svg>
      </div>')),
            div(class="panel-body",
                div(class="panel-content",
                    dataPreview
                )
            )
        ),
        #div(class="panel is-collapsable box-shadow top-malibu panel--expanded", id="viz-edit",
        #div(class="panel is-collapsable box-shadow top-chardonnay has-settings", id="viz-edit",
        div(class="panel is-collapsable box-shadow top-chardonnay is-collapsed has-settings", id="viz-edit",
            HTML(paste0('
      <div class="panel-head">
      <div class="panel-title text-chardonnay">Editar visualización</div>
      <svg class="icon-close icon-close--chardonnay" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
      <line x1="0" y1="0" x2="10" y2="10" />
      <line x1="10" y1="0" x2="0" y2="10" />
      </svg>
      </div>'
            )),
            div(class="panel-body",
                div(class="panel-content",
                    vizControls
                )
            )
        ),
        div(class="panel is-not-collapsable top-chardonnay", id="viz-prev",
            HTML(
              '
              <div class="panel-head">
				        <div class="panel-title text-chardonnay">Vista previa</div>
				          <a id="publish-trigger" href="" class="btn">Publicar</a>
			        </div>
              '
            ),
            div(class="panel-body box-shadow",
                div(class="panel-content",
                    vizPreview
                )
            ),
            div(class="panel-footer box-shadow",
                div(class="panel-title", "Tipos de visualización"),
                vizIcons
            )
        )
    ),
    debugJS,
    indexJS,
    stepsCSS(styles)
  )
  old <- attr(page, "html_dependencies", TRUE)
  htmlDependencies(page) <- c(old, deps)
  page
}


#' @export
dataControls <- function(..., label = NULL, on = NULL){
  x <- list(...)
  tagList(
    shiny::tags$form(class="settings data__settings",
                     shiny::tags$fieldset(
                       shiny::tags$legend(label),
                       x
                     )
    )
  )
}

#' @export
dataPreview <- function(..., on = NULL){
  x <- list(...)
  tagList(
    x
  )
}

#' @export
vizControls <- function(...,
                        basic = NULL,
                        advanced = NULL,
                        label = NULL, on = NULL){

  tagList(
    div(class = "basicos",
        basic),
    div(class = "avanzados",
        HTML(paste0('
      <div class="titulo-avanzados">
      Opciones avanzadas
    <svg class = "icon-avanzados" height="15" width="20">
      <polyline points="3 5 8 12 12 5" />
      </svg>
      </div>')),
        div(class="contenido-avanzados",
            advanced
        )
    )
  )
}

#' @export
vizPreview <- function(..., on = NULL){
  x <- list(...)
  tagList(
    x
  )
}

#' @export
stepsCSS <- function(styles = ""){
  tags$style(
    styles
  )
}


