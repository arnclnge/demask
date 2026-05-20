#' plot_raster
#' Plot a raster on the study area, clamp values to a max value for plotting purposes.
#' @param raster Raster to plot.
#' @param upper_limit Upper values, for plotting purposes.
#' @param plot_title Main title to display on the plot 
#' @param plot_subtitle Subtitle to display on the plot
#' @return A ggplot object
#' @examples
#' plot_raster(raster_cod_q1, upper_limit = 100)
#' @export
plot_raster <- function(raster, upper_limit, plot_title = NULL, plot_subtitle = NULL, save_path = NULL){
  # Setup color scheme using the cmocean package
  algae <- cmocean("algae")
  pal <- algae(15)
  #Plot the raster
  raster_df <- as.data.frame(terra::clamp(raster, upper = upper_limit, values=TRUE), xy=TRUE)%>%
    tidyr::pivot_longer(cols = names(raster),
                        names_to = "Year",
                        values_to = "mean_catch")
  legend_breaks <- seq(0, upper_limit, by = upper_limit / 10)
  legend_labels <- as.character(legend_breaks)
  legend_labels[length(legend_labels)] <- paste0("> ", upper_limit)
  
  p <- ggplot() +
    geom_raster(data = raster_df %>% dplyr::filter(!is.na(mean_catch), mean_catch == 0), aes(x = x, y = y), fill = "white")+
    geom_raster(data = raster_df %>% dplyr::filter(!is.na(mean_catch), mean_catch > 0),aes(x=x, y=y, fill=mean_catch))+
    geom_sf(data = study_area%>%st_transform("EPSG:3035")%>%st_union(), fill = NA)+
    scale_fill_gradientn(colours = pal, na.value = "transparent",
                         limits = c(0, upper_limit),
                         breaks = seq(0,upper_limit, by = upper_limit/10),
                         labels = legend_labels)+
    labs(title = plot_title,
         subtitle = plot_subtitle,
         x = NULL, y = NULL,
         fill = "CPUE")+
    facet_wrap("Year",ncol = 5)+
    theme(plot.title = element_text(face = "italic"))
  
  if (!is.null(save_path)) {
    ggsave(filename = save_path, plot = p, width = 10, height = 6, dpi = 300)}
    
  return(p)
}



