bubble_chart <- function(circle_colors, circle_sizes, color_scale = NULL, xlab = "", ylab = "", x_axis_opt = NULL, y_axis_opt = NULL, bty = "n", white_buffer = T, lwd = 1, main = "", shape = "circle", fg = "black", box_resize = 1, diverging = F) {
  # color_colors are assumed to be between 0-1 and linearly scale withing color_scale
  
  # make diverging if specified
  if (diverging) {
    biggest_value = max(abs(circle_colors), na.rm = T)
    
    # make between 0 and 1, but with negative numbers starting at 0.5
    circle_colors[circle_colors < 0 & !is.na(circle_colors)] = circle_colors[circle_colors < 0 & !is.na(circle_colors)] / biggest_value
    circle_colors[circle_colors > 0 & !is.na(circle_colors)] = circle_colors[circle_colors > 0 & !is.na(circle_colors)] / biggest_value
    circle_colors = (circle_colors + 1) / 2
    
    # create diverging circle sizes too
    circle_sizes = circle_colors
    negative_sizes = circle_sizes <= 0.5 & !is.na(circle_sizes)
    circle_sizes[circle_sizes > 0.5 & !is.na(circle_sizes)] = (circle_sizes[circle_sizes > 0.5 & !is.na(circle_sizes)] - 0.5) * 2
    circle_sizes[negative_sizes] = circle_sizes[negative_sizes] * -2 + 1
    
  }
  
  # attempt to make max circle size aesthetic
  circle_sizes = (circle_sizes / max(abs(circle_sizes), na.rm = T)) * 20 * box_resize
  
  if (is.null(color_scale)) {
    library(RColorBrewer)
    color_scale = colorRampPalette(brewer.pal(n = 7, name ="Reds"))(100)
  }
  
  # initialize common plot parameters
  x_axis = c(0, ncol(circle_colors) + 1)
  y_axis = c(0, nrow(circle_colors) + 1)
  if (!white_buffer) {
    x_axis = c(1, ncol(circle_colors))
    y_axis = c(1, nrow(circle_colors))
  }
  
  y_grid = rep(1:nrow(circle_colors), each = ncol(circle_colors))
  x_grid = rep(1:ncol(circle_colors), nrow(circle_colors))
  
  # map circle_colors to the proper colors
  mapped_colors = color_scale[matrix(t(round(circle_colors * (length(color_scale) - 1))), ncol = 1, byrow = T) + 1]
  # browser()
  
  if (shape == "circle") {
    p <- symbols(x = x_grid, y = rev(y_grid), circles = (matrix(t(circle_sizes), ncol = 1, byrow = T)/pi)^0.5, bg = mapped_colors, fg = fg, xlim = x_axis, ylim = y_axis, inches = F, xlab = xlab, ylab = ylab, xaxt = "n", yaxt = "n", bty = bty, lwd = lwd, main = main)
  } else if (shape == "square") {
    p <- symbols(x = x_grid, y = rev(y_grid), squares = (matrix(t(sqrt(circle_sizes)), ncol = 1, byrow = T)/pi)^0.5, bg = mapped_colors, fg = fg, xlim = x_axis, ylim = y_axis, inches = F, xlab = xlab, ylab = ylab, xaxt = "n", yaxt = "n", bty = bty, lwd = lwd, main = main)
  }
  
  if (!is.null(x_axis_opt)) {
    suppressWarnings(do.call(axis, x_axis_opt))
  }
  if (!is.null(y_axis_opt)) {
    y_axis_opt$labels = rev(y_axis_opt$labels)
    suppressWarnings(do.call(axis, y_axis_opt))
  }
  
  return(p)
}

