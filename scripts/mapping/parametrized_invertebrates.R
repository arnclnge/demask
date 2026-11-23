library(quarto)

#Emodnet seabed classes 

# ID                 Folk_5cl_t
# 0       1. Mud to muddy Sand
# 1                    2. Sand
# 2 3. Coarse-grained sediment
# 3          4. Mixed sediment
# 4         5. Rock & boulders
# 5   6. No data at this level


# invertebrates --------------------------------------------------------------------
#Norwegian lobster
quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates_environmental_layers.qmd"),
  output_file = file.path("masks_norwegianlobster.html"),
  execute_params = list(species = "Nephrops norvegicus",
                        temp_min = 0,
                        temp_max = 17,
                        so_min = 29,
                        depth_min = 15,
                        depth_max = 800,
                        seabed_class = c(0)))

quarto_render(
  input = file.path("scripts", "mapping",
                    "analysis_invertebrates_environmental_layers.qmd"),
  output_file = file.path("masks_bluemussel.html"),
  execute_params = list(species = "Mytilus edulis", #This will return an error as there are not enough ICES data points (only 11 data points)
                        temp_min = 0,
                        temp_max = 29,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 50,
                        seabed_class =  c(1,2,3,4)))
quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates_environmental_layers.qmd"),
  output_file = file.path("masks_cuttlefish_winter.html"),
  execute_params = list(species = "Sepia officinalis",
                        temp_min = 7,
                        temp_max = 30,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 200, #max 50 during spring-summer, max 200 during autumn-winter
                        seabed_class =  c(0,1,3)))

quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates_environmental_layers.qmd"),
  output_file = file.path("masks_europeanlobster.html"),
  execute_params = list(species = "Homarus gammarus",
                        temp_min = 0,
                        temp_max = 22,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 50,
                        seabed_class = c(2,3,4)))

quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates_environmental_layers.qmd"),
  output_file = file.path("masks_scallop.html"),
  execute_params = list(species = "Pecten maximus",
                        temp_min = 7,
                        temp_max = 21,
                        so_min = 26,
                        depth_min = 0,
                        depth_max = 150,
                        seabed_class = c(1,2,3)))
