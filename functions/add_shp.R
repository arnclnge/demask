#' add_shp
#' Add shpfile to the plot 
#' @param shp shpfile to be added
#' 

add_shp <- function(shp){
  
}


my_shape <- st_read(file.path(
  "data",
  "spawning",
  "20250912_10x10km_grid.shp"
))

my_shape <- st_transform(my_shape, "EPSG:3035")