#' calculate_mean
#' Based on a raster grid, average the catch values in a buffer around the center of the grid.
#' @param raster_grid Raster that determines the grid cells with their resolution and center. 
#' @param catch_sf Sf point objects with catch values at specific points. crs = EPSG:3035
#' @param buffer Distance (in m) around each grid center used for averaging, default = 65000
#' @return A raster with mean values.
#' @details Based on a sf points objects, average the values within the buffer distance.
#' The output is a raster where the value of each grid cell is the average of the
#' values inside the buffer distance from the center of the grid cell.
#' @examples
#' mean_raster <- calculate_mean(r, catch_sf) 
#' @export
calculate_mean <- function(raster_grid, catch_sf, buffer = 65000){
  #Get the coordinates of the center of each grid cell
  cells_not_na <- cells(raster_grid)
  center_grid <- xyFromCell(raster_grid, cells_not_na)
  
  #Create a SpatVector from these center points
  center_grid <- terra::vect(center_grid, crs = "EPSG:3035")
  
  #Draw a buffer around the centers of 65km
  center_buffer <- terra::buffer(center_grid, width = buffer)
  
  #Turn into sf object for easier spatial operations
  center_buffer <- st_as_sf(center_buffer, crs = "EPSG:3035")
  
  #Check which points intersect with which polygons of buffers
  contains_list <- st_contains(center_buffer, catch_sf)
  #Calculate the value of each grid cell as the mean of values around the center
  mean_catch <- sapply(contains_list, function(idx) {
    if (length(idx) == 0) {
      return(NA)  # no points in this buffer
    } else {
      mean(catch_sf$Catch[idx], na.rm = TRUE)
    }
  })
  
  #Each buffer now contains the mean catch value
  center_buffer$mean_catch <- mean_catch
  
  #Give each center of the grid cells this value for easier rasterizing
  center_grid$mean_catch <- mean_catch
  
  #Rasterize mean catchweight
  r_mean <- rasterize(x = center_grid,
                      y = raster_grid, #grid of pre-defined resolution within Greater North Sea
                      field = "mean_catch",
                      fun = "first")
  return(r_mean)
}