#' Text with tooltip
#'
#' @param title Text
#' @param info Message which appears when a cursor is positioned over an icon
#' @param icon HTML name of icon
#'
#' @return None
#'
#' @examples
#' infoTooltip("Information", info = "This a content of tooltip", icon = "cloud")
#'
#' @export
infoTooltip <- function(title, info, icon = "info-circle") {
  HTML(paste0('<div style = "display: inline-flex;align-items:baseline;">',
              title,
              '<div class = "info-tool">
               <div class="tooltip-inf"> <i class="fa fa-', icon  ,'"></i>
               <span class="tooltiptext"">',
              info,
              '</span></div></div></div>'))
}
