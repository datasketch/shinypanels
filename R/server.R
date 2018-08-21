
#' #' @export
#' nextStep <- function(nextStep){
#'   current <- input$dsAppLayout_current
#'   steps <- input$dsAppLayout_stepIds
#'   if(is.numeric(nextStep)){
#'     nextStep <- steps[nextStep]
#'   }
#'   session$sendCustomMessage("mymessage", nextStep)
#' }
