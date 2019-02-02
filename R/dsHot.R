
#' @export
dsHot <- function(inputId, data = NULL, dic = NULL,
                  options = NULL){
  if(is.null(data)) return()
  if(is.reactive(data))
    data <- data()
  defaultOpts <- list(
    maxRows = NULL %||% nrow(data),
    height = 450,
    width = NULL,
    manualRowMove = TRUE,
    manualColumnMove = TRUE
  )
  if(is.reactive(data))
    data <- data()
  f <- fringe(data)

  options <- modifyList(defaultOpts, options %||% list())

  addResourcePath(
    prefix='handsontable',
    directoryPath=system.file("lib/handsontable",
                              package='dsAppLayout'))
  addResourcePath(
    prefix='dsHot',
    directoryPath=system.file("lib/dsHot",
                              package='dsAppLayout'))
  #js <- system.file("lib/dsHot/dsHot.js", package = "dsAppLayout")
  #css <- system.file("lib/dsHot/dsHot.css", package = "dsAppLayout")
  #js <- "../lib/dsHot/dsHot.js"
  #css <- "../lib/dsHot/dsHot.css"

  id <- inputId
  #id <- "hot"

  data <- f$d
  dic <- dic %||% f$dic_$d
  dic$id <- letters[1:ncol(data)]

  json_opts <- jsonlite::toJSON(options, auto_unbox = TRUE)
  json_table <- jsonlite::toJSON(data, auto_unbox = TRUE)
  json_dic <- jsonlite::toJSON(dic, auto_unbox = TRUE)
  tagList(
    singleton(tags$head(
      tags$link(rel = 'stylesheet',
                type = 'text/css',
                href = 'handsontable/handsontable.full.min.css'),
      tags$script(src = 'handsontable/handsontable.full.min.js')
    )),
    # div(class="hot-container",
    div(id = id, class = "hot",
        `data-hotOpts` = HTML(json_opts),
        `data-table` = HTML(json_table),
        `data-dic` = HTML(json_dic)),
    # ),
    # tags$style(HTML(paste0(readLines(css),collapse="\n"))),
    # tags$script(HTML(paste0(readLines(js),collapse="\n"))),
    tags$link(rel = 'stylesheet',
              type = 'text/css',
              href = 'dsHot/dsHot.css'),
    tags$script(src = 'dsHot/dsHotHelpers.js'),
    tags$script(src = 'dsHot/dsHot.js')
  )
}

