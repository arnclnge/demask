#' core_areas
#' Based on a raster with values, define the grid cells that make up the core area.
#' @param raster Raster containing values for the study area.
#' @param threshold Threshold in cumulative percentage, default is 0.50(50%)
#' @return A spatraster masked object.
#' @details Based on a raster select the grid cells that you need to retain a
#' cumulative percentage.
#' @examples
#' core_area_cod_q1 <- core_areas(cod_q1_masked, threshold = 0.5)
#' @export
# core_areas <- function(r, threshold = 0.5){
#   core_areas <- list()
#   #Order the values from large to small
#   vals <- as.data.frame(r, cells = TRUE, na.rm = FALSE)
#   for(i in 2:ncol(vals)){ #first column is cell number
#     #Index the cell column and one of the years
#     df_yr <- vals[,c(1,i)]
#     #Order based on the year value
#     df_ordered <- df_yr[order(df_yr[,2], decreasing = TRUE),]
#     # Calculate cumsum
#     df_ordered$c_sum <- cumsum(df_ordered[,2])
#     total <- sum(df_ordered[,2], na.rm = TRUE)
#     df_ordered$c_percent <- df_ordered$c_sum / total
#     # Flag whenever the threshold is reached
#     df_ordered$top <- df_ordered$c_percent <= threshold | #and include first row that exceeds threshold
#       seq_len(nrow(df_ordered)) == which(df_ordered$c_percent > threshold)[1]
#     cell_nrs <- df_ordered[df_ordered$top==TRUE,1]
#     #Create a mask based on these true false
#     mask[] <- NA
#     mask[!is.na(r[[i - 1]])] <- 0
#     mask[cell_nrs] <- 1
#   }
#   core_areas <- terra::rast(core_areas)
#   names(core_areas) <- names(r)
#   return(core_areas)
# }

core_areas <- function(r, threshold = 0.5){
  core_areas <- list()
  vals <- as.data.frame(r, cells = TRUE, na.rm = FALSE)
  for(i in 2:ncol(vals)){ # first column is cell number
    #Index the cell column and one of the years
    df_yr <- vals[, c(1, i)]
    names(df_yr) <- c("cell", "value")
    # Keep only non-NA cells
    df_valid <- df_yr[!is.na(df_yr$value), ]
    
    # Create output layer:
    # NA stays NA
    # valid non-core cells become 0
    # core cells become 1
    mask <- terra::rast(r[[i - 1]])
    mask[] <- NA
    mask[!is.na(r[[i - 1]])] <- 0
    
    if (nrow(df_valid) > 0) {
      
      df_ordered <- df_valid[order(df_valid$value, decreasing = TRUE), ]
      
      total <- sum(df_ordered$value, na.rm = TRUE)
      
      if (!is.na(total) && total > 0) {
        # Calculate cumsum
        df_ordered$c_sum <- cumsum(df_ordered$value)
        df_ordered$c_percent <- df_ordered$c_sum / total
        
        first_over <- which(df_ordered$c_percent > threshold)[1]
        # Flag whenever the threshold is reached
        df_ordered$top <- df_ordered$c_percent <= threshold #and include first row that exceeds threshold
        
        if (!is.na(first_over)) {
          df_ordered$top[first_over] <- TRUE
        }
        cell_nrs <- df_ordered$cell[df_ordered$top == TRUE]
        mask[cell_nrs] <- 1
      }}
    
    core_areas[[i - 1]] <- mask
  }
  
  core_areas <- terra::rast(core_areas)
  names(core_areas) <- names(r)
  
  return(core_areas)
}
