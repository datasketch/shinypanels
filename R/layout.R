
#' @export
dsAppPage <- function(dataControls, dataPreview,
                      vizControls, vizPreview,
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

  jsfile <- system.file("srcjs", "index.js", package = "dsAppLayout")
  indexJS <- tags$script(HTML(paste0(readLines(jsfile),collapse="\n")))
  debugJS <- tags$script(ifelse(debug,"var debug = true;","var debug = false;"))
  page <- tagList(
    div(class="layout",
        # NAV
        div(class="layout__nav",
            div(class="section__nav data__nav",
                dsRadioInput("selectDataSource",
                             choices = list(Edit = "edit", Upload = "upload"))
            ),
            div(class="section__nav vis__nav",
                a(class = "section__nav-action",href= "", id="edit-graphic",
                  "Edit Visualization"
                ),
                a(class = "section__nav-action",href= "", id="edit-graphic",
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
            div(class="section__content vis",
                vizControls,
                div(class="vis__result",
                    vizPreview
                )
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
vizControls <- function(..., label = NULL, on = NULL){
  x <- list(...)
  tagList(
    shiny::tags$form(class="settings vis__settings",
                     shiny::tags$fieldset(
                       shiny::tags$legend(label),
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


