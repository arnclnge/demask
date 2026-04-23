library(quarto)


# invertebrates --------------------------------------------------------------------
#Norwegian lobster
quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates.qmd"),
  output_file = file.path("masks_norwegianlobster.html"),
  execute_params = list(species = "Nephrops norvegicus",
                        temp_min = 6,
                        temp_max = 17,
                        so_min = 29,
                        depth_min = 15,
                        depth_max = 800))

quarto_render(
  input = file.path("scripts", "mapping",
                    "analysis_invertebrates.qmd"),
  output_file = file.path("masks_bluemussel.html"),
  execute_params = list(species = "Mytilus edulis",
                        temp_min = 0,
                        temp_max = 29,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 50))
quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates.qmd"),
  output_file = file.path("masks_cuttlefish.html"),
  execute_params = list(species = "Sepia officinalis",
                        temp_min = 7,
                        temp_max = 30,
                        so_min = 18,
                        so_max= 40,
                        depth_min = 0,
                        depth_max = 50))

quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates.qmd"),
  output_file = file.path("masks_europeanlobster.html"),
  execute_params = list(species = "Homarus gammarus",
                        temp_min = 5,
                        temp_max = 22,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 50))

quarto_render(
  input = file.path("scripts","mapping",
                    "analysis_invertebrates.qmd"),
  output_file = file.path("masks_scallop.html"),
  execute_params = list(species = "Pecten maximus",
                        temp_min = 9,
                        temp_max = 21,
                        so_min = 0,
                        depth_min = 0,
                        depth_max = 150))
