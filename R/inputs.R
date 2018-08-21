

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
