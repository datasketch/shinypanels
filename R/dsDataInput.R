
#' @export
dsDataInputUI <- function(id){
  # UI
  ns <- NS(id)
  #choiceNames <-  choiceNames %||% choices
  #names(choices) <- choiceNames
  tagList(
    div(id=ns("tableInput"),class="tableInput",
        dataTableOutput(ns("userFiles")),
        actionButton(ns("dsDataLoad"), "Cargar ahora")
    )
  )
}


#' @export
dsDataInput <- function(input, output, session, username = NULL){

  user_files <- reactive({
    endpoint <- system.file("dev/ds-endpoint-sample.json", package = "dsAppLayout")
    dsApiData(endpoint)
  })

  output$userFiles <- renderDataTable({
    ns <- session$ns
    d <- user_files()
    datatable(d, selection = 'single')
  })

  selectedData <- eventReactive(input$dsDataLoad, {
    data_id <- input$userFiles_row_last_clicked
    if(is.reactive(user_files)) user_files <- user_files()
    data_id <- user_files %>% slice(data_id)
    #data_id
    read_csv(paste0("http://data.datasketch.co/drops/",data_id$uid,"/",data_id$uid,".csv"))
  })
  selectedData
}
