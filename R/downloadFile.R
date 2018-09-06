#' @export
downloadFileUI <- function(id, text = "Download", class = NULL){
  # indicators taken from https://github.com/daattali/advanced-shiny#proxy-click
  ns <- NS(id)
  loadingGif <- "data:image/gif;base64,R0lGODlhEAALAPQAAP///wAAANra2tDQ0Orq6gYGBgAAAC4uLoKCgmBgYLq6uiIiIkpKSoqKimRkZL6+viYmJgQEBE5OTubm5tjY2PT09Dg4ONzc3PLy8ra2tqCgoMrKyu7u7gAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQuaW5mbwAh+QQJCwAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27ifDgfkEYe04kDIDC5zrtYKRa2WQgAh+QQJCwAAACwAAAAAEAALAAAFJGBhGAVgnqhpHIeRvsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQJCwAAACwAAAAAEAALAAAFNiAgjothLOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh+QQJCwAAACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAkLAAAALAAAAAAQAAsAAAUyICCOZGme1rJY5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkECQsAAAAsAAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00kj5g0Al8tADY2y6C+4FIIACH5BAkLAAAALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpyHCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkECQsAAAAsAAAAABAACwAABS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7AAAAAAAAAAAA"
  tagList(
    div(
      `data-for-btn` = ns("downloadFile"),
      downloadButton(ns("downloadFile"),text, class = class),
      #button,
      span(
        class = "btn-loading-container",
        hidden(
          img(src = loadingGif, class = ns("btn-loading-indicator")),
          icon("check", class = ns("btn-done-indicator"))
        )
      ),
      hidden(
        div(class = "btn-err",
            div(icon("exclamation-circle"),
                tags$b("Error: "),
                span(class = "btn-err-msg")
            )
        )
      )
    )
  )
}

#' @export
downloadFile <- function(input,output,session, path = NULL, name = "widget"){

  ns <- session$ns

  buttonId <- ns("downloadFile")
  loadingEl <- sprintf(paste0("[data-for-btn=%s] .", ns("btn-loading-indicator")), buttonId)
  doneEl <- sprintf(paste0("[data-for-btn=%s] .", ns("btn-done-indicator")), buttonId)
  errEl <- sprintf(paste0("[data-for-btn=%s] .",ns("btn-err")), buttonId)

  # on.exit({
  #   shinyjs::enable(buttonId)
  #   shinyjs::hide(selector = loadingEl)
  # })

  output$downloadFile <- downloadHandler(
    filename = function() {
      shinyjs::disable(buttonId)
      shinyjs::show(selector = loadingEl)
      shinyjs::hide(selector = doneEl)
      shinyjs::hide(selector = errEl)
      if(is.reactive(name))
        name <- name()
      if(is.reactive(path))
        path <- path()
      paste0(name,"-",gsub(" ","_",substr(as.POSIXct(Sys.time()),1,19)),".",file_ext(path))
    },
    content = function(file) {
      if(is.reactive(path))
        path <- path()
      file.copy(path,file)
      shinyjs::enable(buttonId)
      shinyjs::hide(selector = loadingEl)
      shinyjs::show(selector = doneEl)
    }
  )
}
