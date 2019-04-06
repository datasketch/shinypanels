
#' @export
dsAppPanels <- function(..., styles = "", title = NULL, debug = FALSE){
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
  panels <- list(...)

  jsfile <- system.file("srcjs", "index.js", package = "dsAppLayout")
  indexJS <- tags$script(HTML(paste0(readLines(jsfile),collapse="\n")))
  #debugJS <- tags$script(ifelse(debug,"var debug = true;","var debug = false;"))

  page <- tagList(
    tags$head(
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$meta(`http-equiv` = "X-UA-Compatible", content="ie=edge"),
      tags$title(title)
    ),
    div(class="app-container",
        panels
    ),
    #debugJS,
    indexJS,
    customCSS(styles)
  )
  old <- attr(page, "html_dependencies", TRUE)
  htmlDependencies(page) <- c(old, deps)
  page
}

#' @export
customCSS <- function(styles = ""){
  tags$style(
    styles
  )
}


