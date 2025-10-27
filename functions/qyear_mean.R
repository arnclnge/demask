#' qyear_mean
#' Based on a quarter-year combination calculate the mean layers.
#' @param raster_grid Raster that determines the grid cells with their resolution and center. 
#' @param q_yr_combo Dataframe with quarter-year combinations we are interested in. 
#' @param catch_df Dataframe with catch values at specific points. crs = EPSG:3035
#' @return A list of rasters per quarter with mean values over the years.
#' @details For each quarter the the values are averaged yearly using the calculate_mean function.
#' @examples
#' quarters <- qyear_mean(raster_grid, q_yr_combo, catch_df) 
#' @export
qyear_mean <- function(raster_grid, q_yr_combo, catch_df){
  #Run the analysis for each Quarter-Year combination
  mean_raster <- apply(q_yr_combo,
                       1, #to apply it row by row 
                       function(x) {
                         q <- x["quarter"]
                         y <- x["Year"]
                         catch_sf <- catch_df%>%
                           dplyr::filter(quarter == q,
                                         Year == y)%>%
                           st_as_sf(coords = c("Longitude", "Latitude"), crs = "EPSG:4326")%>%sf::st_transform(crs = "EPSG:3035")
                         calculate_mean(raster_grid, catch_sf) 
                       })
  #Turn the list of rasters into a spatraster with different layers
  mean_raster <- terra::rast(mean_raster)
  names(mean_raster) <- as.character(q_yr_combo$Year)
  #We split the raster layers per quarter in q_yr_combo
  split_list <- q_yr_combo$quarter
  raster_split <- terra::split(mean_raster, split_list)
  names(raster_split) <- paste0("q",unique(q_yr_combo$quarter))
  return(raster_split)
  }