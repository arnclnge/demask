combine_plots <- function(species = NULL, save_path = NULL) {
  
  pp <-p1 + p3 +
    plot_layout(nrow = 1)
  
  if (!is.null(save_path)) {
    ggsave(filename = save_path, plot = pp, width = 8, height = 4, dpi = 300)
  }
  
  return(pp)
}