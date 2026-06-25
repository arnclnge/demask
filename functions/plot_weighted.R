plot_weighted <- function(core_areas, species, quarter, shp = NULL, plot_title = NULL, save_path=NULL){
  
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
  
  
  if(is.null(shp) || !file.exists(here("data", "spawning", shp))){
    n_classes <-4
  print("No valid spawning shapefile was found.")
  } else{
    #Turn the spawning shapefile into a raster
    spawning <- st_read(here("data", "spawning", shp), quiet = TRUE)
    spawning <- st_transform(spawning, terra::crs(consistent_core))
    spawning$spawning <- TRUE
    spawning_raster <- terra::rasterize(terra::vect(spawning), consistent_core, field = "spawning", background = NA, touches = TRUE)
    names(spawning_raster) <- "spawning"
    consistent_core <- terra::mask(consistent_core,
                                   mask = spawning_raster,
                                   maskvalues = TRUE,
                                   updatevalue = 6)
  }
  
  # Plot the raster
  matter <- cmocean("matter")
  cols <- matter(9)
  
  raster_df <- as.data.frame(consistent_core, xy = TRUE) %>%
    dplyr::select(score = lyr.1, x, y) 
  
  p <- ggplot() + 
    geom_raster(data = raster_df,aes(x = x, y = y, fill = score)) +
    scale_fill_gradientn(
      name = "Score",
      colours = c("white", matter(9)),
      na.value = "transparent",
      limits = c(0, max(raster_df$score, na.rm = TRUE)),
      breaks = pretty(raster_df$score)) +
    geom_sf(data = study_area %>% st_transform(terra::crs(consistent_core)) %>%
        st_union(),
      fill = NA) +
    labs(
      title = plot_title,
      subtitle = paste0("Consistent core areas Q", quarter),
      x = NULL,
      y = NULL) +
    theme(plot.title = element_text(face = "italic"))
  
  if (!is.null(save_path)) {
    ggsave(filename = save_path, plot = p, width = 10, height = 6, dpi = 300)}
  
  return(p)
}


