
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
        div(class="panel panel--small", id="data-edit",

            div(class="panel-head",
				    div(class="panel-title", "Editar datos")
            ),
            div(class="panel-body box-shadow",
         HTML(paste0( '
            <div class="panel-collapse">
            <svg class="panel-collapse__close" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
            <line x1="0" y1="0" x2="10" y2="10" stroke="#bdcad1" stroke-width="2" />
            <line x1="10" y1="0" x2="0" y2="10" stroke="#bdcad1" stroke-width="2" />
            </svg>
            </div>
            '
        )),
        div( class="panel-title panel-title--rotated",
             "Editar datos"),
        #control de datos
        dataControls,
        #todo lo que va en el panel de DATOS
        dataPreview
        )
        ),
        div(class="panel panel--small", id="viz-edit",
            div(class="panel-head",
                div(class="panel-title", "Editar visualización")),
            div(class="panel-body box-shadow",
                HTML(paste0('
				<div class="panel-collapse">
					<svg class="panel-collapse__close" xmlns="http://www.w3.org/2000/svg" width="10" height="10">
						<line x1="0" y1="0" x2="10" y2="10" stroke="#bdcad1" stroke-width="2" />
						<line x1="10" y1="0" x2="0" y2="10" stroke="#bdcad1" stroke-width="2" />
					</svg>
				</div>'
                )),
              div(class="panel-title panel-title--rotated",
                  "Editar visualización"),
             #Argumentos que editan el gráfico
              vizControls
            )
        ),
              div(class="panel panel--big",id="preview",
               div(class="panel-head",
              div(class="panel-title", "Vista previa"),
              tags$a(href="", id="edit-publish", class="btn modal-trigger", "Publicar")
              ),
              div(class="panel-body box-shadow mb-1",
                # Panel de visualización
                  vizPreview
              ),
              div(class="preview-types",
              div(class="panel-title",
                "Tipos de visualización"),
              div(class="viz-types box-shadow",
                #Panel de tipos de gráficos
                vizIcons
              )
              )
        ),
        div(
          extra
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
  x <- list(...)
  tagList(
    shiny::tags$form(class="settings viz__settings",
                     shiny::tags$fieldset(
                       shiny::tags$legend(label),
                       tags$ul(class = "ds__tabs",
                               tags$li(class = "ds__tab active", `data-tab`="options__general","General"),
                               tags$li(class = "ds__tab", `data-tab`="options__advanced","Avanzado")
                       ),
                       div(id="options__general", class="ds__tab-content-pane active",
                           div(class="flex", style="border-bottom: 1px solid var(--disco); padding: 5px 0; margin: 0 0 10px;",
                               basic
                           )
                       ),
                       div(id="options__advanced", class="ds__tab-content-pane",
                           div(class="flex", style="border-bottom: 1px solid var(--disco); padding: 5px 0; margin: 0 0 10px;",
                               advanced
                           )
                       ),
                       x
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

stepsCSS <- function(styles = ""){
  tags$style(
    styles
  )
}


