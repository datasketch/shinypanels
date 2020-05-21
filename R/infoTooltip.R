#' Text with tooltip
#'
#' @param title Text
#' @param info Message which appears when a cursor is positioned over an icon
#' @param icon HTML name of icon
#' @param containerStyle CSS styles for the container div
#' @param iconStyle CSS styles for the icon
#' @param tooltipStyle CSS styles for the tooltip
#'
#' @return None
#'
#' @examples
#' infoTooltip("Information", info = "This a content of tooltip", icon = "cloud")
#'
#' @export
infoTooltip <- function(title, info, icon = "info-circle", containerStyle = "", iconStyle = "", tooltipStyle = "") {
  HTML(paste0('<div style = "display: inline-flex; align-items:baseline; ', containerStyle, '">',
              title,
              '<div class = "info-tool">
               <div class="tooltip-inf" style = "', iconStyle, '">',
              icon(icon),
              '<span class="tooltiptext" style = "', tooltipStyle,'">',
              info,
              '</span></div></div></div>'))
}
