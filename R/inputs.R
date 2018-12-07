
#' @export
dsHot <- function(inputId, data = NULL, dic = NULL,
                  options = NULL){
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

hot_data <- function(x, labels = FALSE){
  if(is.null(x)) return()
  data <- map(transpose(x$data),unlist) %>% as_tibble()
  if(labels){
    dic <- map(transpose(x$dic),unlist) %>% as_tibble()
    names(data) <- dic$label
  }
  data
}

hot_dic <- function(x){
  map(transpose(x$dic),unlist) %>% as_tibble()
}


#' @export
dsModal <- function(inputId,..., header = NULL, footer = NULL){
  x <- list(...)
  tagList(
    div(class="ds__modal-wrapper",
        div(class="ds__modal",
            h3(class="ds__modal-header", header),
            div(class="ds__modal-body",x),
            div(class="ds__modal-footer",footer)
            )
        )
  )
}

#' @export
dsRadioButtons <- function(inputId, label = NULL,
                         choices = NULL, selected = NULL){
  if(is.null(names(choices))) names(choices) <- choices
  #choices <- c(EDIT="edit", UPLOAD="upload")
  selected <- selected %||% choices[[1]]
  inputs <- mapply(choices, names(choices), FUN = function(value,label){
    inputTag <- shiny::tags$input(type = "radio", name = value)
    if (value %in% selected)
      inputTag$attribs$checked <- "checked"
    div(class = "input__field",
     inputTag,
     shiny::tags$label(label)
    )
  },SIMPLIFY = FALSE, USE.NAMES = FALSE)
  tagList(
    div(id = inputId,
      inputs
    )
    )
}




# function (inputId, label, choices = NULL, selected = NULL, inline = FALSE,
#           width = NULL, choiceNames = NULL, choiceValues = NULL)
# {
#   args <- normalizeChoicesArgs(choices, choiceNames, choiceValues)
#   selected <- restoreInput(id = inputId, default = selected)
#   selected <- if (is.null(selected))
#     args$choiceValues[[1]]
#   else as.character(selected)
#   if (length(selected) > 1)
#     stop("The 'selected' argument must be of length 1")
#   options <- generateOptions(inputId, selected, inline, "radio",
#                              args$choiceNames, args$choiceValues)
#   divClass <- "form-group shiny-input-radiogroup shiny-input-container"
#   if (inline)
#     divClass <- paste(divClass, "shiny-input-container-inline")
#   tags$div(id = inputId, style = if (!is.null(width))
#     paste0("width: ", validateCssUnit(width), ";"), class = divClass,
#     controlLabel(inputId, label), options)
# }
