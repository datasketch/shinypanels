
#' @export
dsApiData <- function(endpoint){
  x <- jsonlite::fromJSON(endpoint, simplifyDataFrame = FALSE)
  x <- map(x, ~.[c("uid","title", "date_added")])
  d <- transpose(x) %>% map(unlist) %>% as_tibble()
  d
}


