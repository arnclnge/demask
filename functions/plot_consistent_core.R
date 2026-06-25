#' plot_consistent_core
#' Plot the consistent core areas over the study area based on the core areas raster. 
#' @param core_areas Core area Raster to plot.
#' @param species Species to display in the plot subtitle. 
#' @param quarter Quarter to display in the plot subtitle
#' @return A ggplot object
#' @examples
#' plot_raster(raster_cod_q1, upper_limit = 100)
#' @export
plot_consistent_core <- function(core_areas, species, quarter, shp, save_path){
  
  matter <- cmocean("matter")
  pal <- c("white", matter(9))
  
  # extract years from layer names
  years <- as.numeric(names(core_areas))
  
  #calculate weights
  weights <- 1 - 0.10* (2024 - years)
  
  consistent_core <- app(core_areas, function(x) {
    if (all(is.na(x))) {
      NA_real_
    } else {
      sum((x == 1) * weights, na.rm = TRUE)
    }
  })
  
  # Make zero-count cells transparent
  #consistent_core[consistent_core == 0] <- NA
  
  if(is.null(shp) || !file.exists(here("data", "spawning", shp))){
    print("No valid spawning shapefile given")
    # Plot the raster
    raster_df <- as.data.frame(consistent_core, xy = TRUE) %>%
      dplyr::select(years = lyr.1, x, y)

    p <- ggplot() + 
      geom_raster(data = raster_df, aes(x = x, y = y, fill = years)) +
      scale_fill_gradientn(name = "Years", colours = pal, na.value = "transparent", limits = c(0, sum(weights, na.rm = TRUE))) +
      geom_sf(data = study_area %>%
                st_transform(terra::crs(consistent_core)) %>%
                st_union(), fill = NA) +
      labs(title = "Consistent core areas", subtitle = paste0(species, " Q", quarter),
           x = NULL, y = NULL)
  } else {
    spawning <- st_read(here("data", "spawning", shp), quiet = TRUE)
    
    spawning <- st_transform(spawning, terra::crs(consistent_core))
    
    spawning$spawning <- 1L
    
    spawning_raster <- terra::rasterize(terra::vect(spawning), consistent_core, field = "spawning", background = NA, touches = TRUE)
    
    names(spawning_raster) <- "spawning"
    
    # Plot the raster
    raster_df <- as.data.frame(consistent_core, xy = TRUE) %>%
      dplyr::select(years = lyr.1, x, y)
    
    spawning_df <- as.data.frame(spawning_raster, xy = TRUE, na.rm = TRUE)
    
    p <- ggplot() + 
      geom_raster(data = raster_df, aes(x = x, y = y, fill = years)) +
      scale_fill_gradientn(name = "Years", colours = pal, na.value = "transparent", limits = c(0, sum(weights, na.rm = TRUE))) +
      ggnewscale::new_scale_fill() +
      geom_raster(data = spawning_df, aes(x = x, y = y, fill = "Spawning area"), alpha = 0.35) +
      scale_fill_manual(name = NULL, values = c("Spawning area" = "red")) +
      geom_sf(data = study_area %>%
                st_transform(terra::crs(consistent_core)) %>%
                st_union(), fill = NA) +
      labs(title = species, subtitle = paste0("Consistent core areas", " Q", quarter),
           x = NULL, y = NULL)+
      theme(plot.title = element_text(face = "italic"))
  }

  if (!is.null(save_path)) {
    ggsave(filename = save_path, plot = p, width = 10, height = 6, dpi = 300)
    saveRDS(raster_df, file = here("outputs", "df", paste0(species,"_",threshold,"_",quarter, "_consistent_core_areas_yearly.rds")))}
  
  return(p)
}


