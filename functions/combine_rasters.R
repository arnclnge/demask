#' combine rasters of consistent core areas and environmental layers 
#' Plot the consistent core areas over the environmental layers raster from analysis_invertebrates.qmd
#' @param core_areas Core area Raster to plot.
#' @param species Species to display in the plot subtitle. 
#' @param quarter Quarter to display in the plot subtitle
#' @return A ggplot object
#' @examples
#' combine_rasters(df_core, df_mask, season = "Winter")
#' @export

combine_rasters <- function(df_core, df_mask, season){ 
df_mask$sum <- as.factor(df_mask$sum)

ggplot() +
  geom_raster(
    data = df_mask,
    aes(x = x, y = y, fill = factor(sum))) +
  scale_fill_manual(
    name = "Amount of positive conditions",
    values = c(
      "1" = "#f0f0f0",
      "2" = "#c6dbef",
      "3" = "#9ecae1",
      "4" = "#3182bd")) +
  ggnewscale::new_scale_fill() +
  geom_raster(
    data = subset(df_core, years > 0),
    aes(x = x, y = y, fill = years),
    alpha = 0.5) +
  scale_fill_distiller(
    name = "Consistent core areas (no. of years)",
    palette = "Reds",
    direction = 1,
    breaks = scales::breaks_width(1)) +
  coord_equal() +
  labs(
    subtitle = paste0("<i>", params$species, "</i>"),
    title = paste0(season, " core areas and positive environmental conditions"),
    x = "Lon",
    y = "Lat") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    plot.subtitle = ggtext::element_markdown())

ggsave(
  filename = here(
    "outputs", "png", "invertebrates", 
    paste0(params$species, "_", season, ".png")
  ),
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)}