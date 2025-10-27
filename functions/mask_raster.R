#' mask_raster
#' Mask all cells that contain data in <threshold layers.
#' @param raster Raster containing values for the study area.
#' @param threshold Threshold in percentage, default is 0.90(90%)
#' @return A spatraster object.
#' @examples
#' cod_q1_masked <- mask_raster(raster_cod_q1, threshold = 0.90)
#' @export
mask_raster <- function(raster, threshold = 0.90){
  #Amount of years that should have data
  thr_year <- threshold * nlyr(raster)
  
  # count how many layers are non-NA in each cell
  valid_counts <- app(raster, function(x) sum(!is.na(x)))
  
  # mask out cells where count < threshold
  r_masked <- mask(raster, valid_counts >= thr_year, maskvalues=FALSE,updatevalue = NA)

  return(r_masked)
}
