
#' @export
dsAppPage <- function(dataControls, dataPreview,
                      vizControls, vizPreview, ...,
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
    div(class="layout",
        # NAV
        div(class="layout__nav",
            div(class="section__nav data__nav",
                a(class = "section__nav-action",href= "", id="edit-data",
                  "Edit Data"
                )
            ),
            div(class="section__nav viz__nav",
                a(class = "section__nav-action",href= "", id="edit-graphic",
                  "Edit visualization"
                ),
                a(class = "section__nav-action modal-trigger",href= "", id="edit-publish",
                  "Publish")
            )
        ),
        # BODY
        div(class="layout__body",
            div(class="section__content data",
                dataControls,
                div(class="data__preview",
                    dataPreview
                )
            ),
            div(class="drag js-drag"),
            div(class="section__content viz",
                vizControls,
                div(class="viz__result",
                    vizPreview
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


