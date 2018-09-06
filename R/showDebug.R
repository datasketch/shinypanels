
#' @export
showDebugUI <- function(id){
  # UI
  ns <- NS(id)
  jsCode <- "
  shinyjs.hideDebug = function(params){
  console.log('hiding debug')
  $( '<style>.shiny-output-error{ visibility: hidden;} .shiny-output-error:before { visibility: hidden; }</style>').appendTo( 'head' )
  $(document).ready(function(){
  $(\"[id*='debug']\").css('display','none');
  });
  }
  "
  tagList(
    extendShinyjs(text = jsCode)
  )
}

#' @export
showDebug <- function(input,output,session, hosts = "127.0.0.1"){
  # Hide debug
  observe({
    message("Current host ", session$clientData$url_hostname)
    message("Showing debug in ", hosts)
    if(!session$clientData$url_hostname %in% hosts){
      js$hideDebug()
    }
  })
}
