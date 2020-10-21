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
  HTML(paste0('<div class="tooltip" style="',
              containerStyle,
              '"><span>',
              title,
              '</span><div class="tooltip-slot"><span class="tooltip-icon" style="',
              iconStyle,
              '">',
              icon(icon),
              '</span><div class="tooltip-content" style="',
              tooltipStyle,
              '">',
              info,
              '</div></div></div>'
              ))
}
