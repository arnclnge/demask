#' calculate_mean
#' Based on a raster grid, average the catch values in a buffer around the center of the grid.
#' @param raster_grid Raster that determines the grid cells with their resolution and center. 
#' @param catch_sf Sf point objects with catch values at specific points. crs = EPSG:3035
#' @return A raster with interpolated values.
#' @details
#' The output is a raster where the value of each grid cell is the inverse distance weighted average.
#' @examples
#' gam_raster <- calculate_gam(r, catch_sf) 
#' @export
calculate_gam <- function(raster_grid, catch_sf){
  grid_pts <- as.points(raster_grid) |> 
    st_as_sf()
  gam_data <- catch_sf %>%
    dplyr::mutate(lon = sf::st_coordinates(.)[,1],
                  lat = sf::st_coordinates(.)[,2])
  fit <- mgcv::gam(Catch ~ s(lon, lat, bs = "ts", k = 10),
                   family = tw(link = "log"),
                   data = gam_data,
                   method = "REML")
  spatial_data <- grid_pts %>% dplyr::mutate(lon = sf::st_coordinates(.)[,1],
                                             lat = sf::st_coordinates(.)[,2])%>%
    dplyr::select(lon,lat)
  spatial_predictions <- mgcv::predict.gam(fit, spatial_data, type = "response")
  spatial_all <- cbind(spatial_data, spatial_predictions)
  r_gam <- rasterize(x = spatial_all,
                     y = raster_grid,
                     field = "spatial_predictions"
  )
  return(r_gam)
}
