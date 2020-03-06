#' Shiny panels layout
#'
#' @param header html list with custom header
#' @param title Title html page attribute
#' @param debug Used for debugging layout html
#' @param styles custom css styles
#' @param ... html list contents for the panel
#'
#' @return None
#'
#' @examples
#' panelsPage()
#'
#' @export
panelsPage <- function(..., styles = "", header = NULL, title = NULL, debug = FALSE){
  deps <- list(

    htmlDependency("font-awesome", "4.1.0",
                   src = c(href = "//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.1.0/css/"),
                   stylesheet = "font-awesome.min.css"
    ),
    # htmlDependency("box", "0.0.1",
    #                src = (file = system.file("assets/js", package = "shinypanels")),
    #                script = "box_info.js"
    # ),
    htmlDependency("style", "0.0.1",
                   src = (file = system.file("assets","css", package = "shinypanels")),
                   stylesheet = "style.css"
    )
  )
  panels <- list(...)

  jsfile <- system.file("assets","js", "index.js", package = "shinypanels")
  indexJS <- tags$script(HTML(paste0(readLines(jsfile),collapse="\n")))
  #debugJS <- tags$script(ifelse(debug,"var debug = true;","var debug = false;"))


  # addResourcePath(
  #     prefix = 'box',
  #     directoryPath = system.file('/assets/js', package='shinypanels')
  #   )
  jsbox <-  system.file("assets","js", "box_info.js", package = "shinypanels")
  boxJS <- tags$script(HTML(paste0(readLines(jsbox),collapse="\n")))

  header <- header
  if (!is.null(header)) {
  div(class = "layout-header",
      header)
    }


  page <- tagList(
    tags$head(
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$meta(`http-equiv` = "X-UA-Compatible", content="ie=edge"),
      tags$title(title)#,
      #tags$script(src = "box/box_info.js")
    ),
    div(class = "orientation-notice",
      div(class="orientation-notice-content",
        p('Gira tu dispositivo', style = "text-align: center;"),
        svgRotate()
      ),
    ),
    div(class = "layout-container",
       header,
        div(class = "layout-panels",
            div(class="app-container",
                panels
            )
        )
    ),
    indexJS,
    boxJS,
    tags$style(styles)
  )
  old <- attr(page, "html_dependencies", TRUE)
  htmlDependencies(page) <- c(old, deps)
  page
}



