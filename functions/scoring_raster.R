scoring_raster <- function(core_areas, species, quarter, shp = NULL){
  consistent_core <- app(core_areas, function(x) sum(!is.na(x)))
  # Make zero-count cells transparent
  consistent_core[consistent_core == 0] <- NA
  consistent_core[consistent_core == 1] <- 1
  consistent_core[consistent_core %in% 2:3] <- 2
  consistent_core[consistent_core %in% 4:7] <- 3
  consistent_core[consistent_core %in% 8:10] <- 4
  
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
                                   updatevalue = 5)
    n_classes <- 5
  }
  
  # Plot the raster
  raster_df <- as.data.frame(consistent_core, xy = TRUE) %>%
    dplyr::select(score = lyr.1, x, y)%>%
    dplyr::mutate(score = factor(score))
  matter <- cmocean("matter")
  cols <- matter(9)
  idx <- if (n_classes == 5) {
    c(1, 3, 5, 7, 9)
  } else {
    c(1, 3, 5, 7)
  }
  fill_vals <- setNames(cols[idx], as.character(1:n_classes))
  p <- ggplot() + 
    geom_raster(data = raster_df, aes(x = x, y = y, fill = score)) +
    scale_fill_manual(
      values = fill_vals,
      na.value = "transparent"
    ) +
    geom_sf(data = study_area %>%
              st_transform(terra::crs(consistent_core)) %>%
              st_union(), fill = NA) +
    labs(title = "Consistent core areas", subtitle = paste0(species, " Q", quarter),
         x = NULL, y = NULL)
  
  return(p)
}
