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
plot_raster <- function(raster, upper_limit, plot_title = NULL, plot_subtitle = NULL){
  # Setup color scheme using the cmocean package
  algae <- cmocean("algae")
  pal <- algae(15)
  #Plot the raster
  raster_df <- as.data.frame(terra::clamp(raster, upper = upper_limit, values=TRUE), xy=TRUE)%>%
    tidyr::pivot_longer(cols = names(raster),
                        names_to = "Year",
                        values_to = "mean_catch")
  p <- ggplot() +
    geom_sf(data = study_area%>%st_transform("EPSG:3035"), fill = NA)+
    geom_raster(data = raster_df, aes(x = x, y = y, fill = mean_catch))+
    scale_fill_gradientn(colours = pal, na.value = "transparent",
                         limits = c(0, upper_limit),
                         breaks = seq(0,upper_limit, by = upper_limit/10))+
    labs(title = plot_title,
         subtitle = plot_subtitle,
         x = NULL, y = NULL)+
    facet_wrap("Year",ncol = 5)
  return(p)
}



