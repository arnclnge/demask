#' plot_raster
#' Plot a raster on the study area, clamp values to a max value for plotting purposes.
#' @param raster Raster to plot.
#' @param plot_title Main title to display on the plot 
#' @param plot_subtitle Subtitle to display on the plot
#' @return A ggplot object
#' @examples
#' @export
plot_raster_binary <- function(raster, plot_title = NULL, plot_subtitle = NULL, save_path = NULL){
  #Plot the raster
  raster_df <- as.data.frame(raster, xy = TRUE, na.rm = FALSE) %>%
    tidyr::pivot_longer(cols = names(raster),
                        names_to = "Year",
                        values_to = "core_area") %>% 
    dplyr::mutate(core_area = dplyr::case_when(is.na(core_area) ~ NA,
                                                core_area == TRUE | core_area == 1 ~ "True",
                                                core_area == FALSE | core_area == 0 ~ "False",
                                                TRUE ~ NA_character_),
                  core_area = factor(core_area, levels = c("False", "True")))
  
  p <- ggplot() +
    geom_raster(data = raster_df, aes(x = x, y = y, fill = core_area))+
    geom_sf(data = study_area%>%st_transform("EPSG:3035")%>%st_union(), fill = NA)+
    scale_fill_manual(values = c("False" = "white", "True" = "green"),
                                 na.value = "transparent", drop = FALSE)+
    labs(title = plot_title,
         subtitle = plot_subtitle,
         x = NULL, y = NULL,
         fill = "Core area")+
    facet_wrap("Year",ncol = 5)+
    theme(plot.title = element_text(face = "italic"))
  
  if (!is.null(save_path)) {
    ggsave(filename = save_path, plot = p, width = 10, height = 6, dpi = 300)}
    
  return(p)
}



