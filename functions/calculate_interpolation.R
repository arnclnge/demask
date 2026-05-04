#' calculate_mean
#' Based on a raster grid, average the catch values in a buffer around the center of the grid.
#' @param raster_grid Raster that determines the grid cells with their resolution and center. 
#' @param catch_sf Sf point objects with catch values at specific points. crs = EPSG:3035
#' @return A raster with interpolated values.
#' @details
#' The output is a raster where the value of each grid cell is the inverse distance weighted average.
#' @examples
#' interpolated_raster <- calculate_interpolation(r, catch_sf) 
#' @export
calculate_interpolation <- function(raster_grid, catch_sf, idp_value){
  grid_pts <- as.points(raster_grid) |> 
    st_as_sf()
  idw_out <- gstat::idw(
    formula = Catch ~ 1,
    locations = catch_sf,
    newdata = grid_pts,
    idp = idp_value)
  interpolate_sf <- st_as_sf(idw_out)
  r_interpolate <- rasterize(x = interpolate_sf,
                             y = raster_grid,
                             field = "var1.pred"
  )
  return(r_interpolate)
}