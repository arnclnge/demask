scoring_raster <- function(core_areas, species, quarter, shp = NULL, plot_title = NULL, save_path=NULL){
  consistent_core <- app(core_areas, function(x) {
    if (all(is.na(x))) {NA_real_
    } else {
      sum(x == 1, na.rm = TRUE)}
  })
  # Make zero-count cells transparent
  consistent_core[consistent_core == 0] <- 0
  consistent_core[consistent_core %in% 1:2] <- 1
  consistent_core[consistent_core %in% 3:6] <- 2
  consistent_core[consistent_core %in% 7:10] <- 3
  
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
                                   updatevalue = 4)
    n_classes <- 4
  }
  
  # Plot the raster
  score_levels <- c("0", "1", "2", "3", "4")
  
  score_labels <- c(
    "0" = "0",
    "1" = "1-2 years",
    "2" = "3-6 years",
    "3" = "7-10 years",
    "4" = "Spawning area")
  
  matter <- cmocean("matter")
  cols <- matter(9)
  
  fill_vals <- c(
    "0" = "white",
    "1" = cols[1],
    "2" = cols[3],
    "3" = cols[5],
    "4" = cols[7])
  
  raster_df <- as.data.frame(consistent_core, xy = TRUE) %>%
    dplyr::select(score = lyr.1, x, y) %>%
    dplyr::mutate(score = factor(as.character(score), levels = score_levels))
  
  p <- ggplot() + 
    geom_raster(data = raster_df,aes(x = x, y = y, fill = score)) +
    scale_fill_manual(
      values = fill_vals,
      limits = score_levels,
      breaks = score_levels,
      labels = score_labels,
      drop = FALSE,
      na.value = "transparent", name = NULL) +
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


