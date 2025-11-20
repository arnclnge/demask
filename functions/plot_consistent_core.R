#' plot_consistent_core
#' Plot the consistent core areas over the study area based on the core areas raster. 
#' @param core_areas Core area Raster to plot.
#' @param species Species to display in the plot subtitle. 
#' @param quarter Quarter to display in the plot subtitle
#' @return A ggplot object
#' @examples
#' plot_raster(raster_cod_q1, upper_limit = 100)
#' @export
plot_consistent_core <- function(core_areas, species, quarter){
  matter <- cmocean("matter")
  pal <- c("white",matter(9))
  consistent_core <- app(core_areas, function(x) sum(!is.na(x)))
  #Plot the raster
  raster_df <- as.data.frame(consistent_core, xy=TRUE)%>%
    dplyr::select(years = lyr.1,x,y)
  p <- ggplot() +
    geom_raster(data = raster_df, aes(x = x, y = y, fill = years))+
    geom_sf(data = study_area%>%st_transform("EPSG:3035")%>%st_union(), fill = NA)+
    scale_fill_gradientn(colours = pal, na.value = "transparent",
                         limits = c(0, 10),
                         breaks = seq(0,10, by = 2))+
    labs(title = "Consistent core areas",
         subtitle = paste0(species," Q",quarter),
         x = NULL, y = NULL)
  return(p)
}



