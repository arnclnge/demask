library(quarto)


# Invertebrates --------------------------------------------------------------------
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_invertebrates_interpolation.qmd"),
  output_file = file.path("results_norwegian_lobster.html"),
  execute_params = list(species = "Nephrops norvegicus",
                        group = "invertebrates", #because code also works for invertebrates now
                        plot_limit = 100,#Change this to change the maximum value plotted,
                        #Everything above this value gets the same value and color, for plot clarity reasons
                        years_mask = 0,
                        consistent_thr = 0.8,
                        idp_value = 1,
                        max_distance = 65000)) #grid cells with less than 90% of data are NA

quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_invertebrates_interpolation.qmd"),
  output_file = file.path("results_cuttlefish.html"),
  execute_params = list(species = "Sepia officinalis",
                        group = "invertebrates", #because code also works for invertebrates now
                        plot_limit = 100,#Change this to change the maximum value plotted,
                        #Everything above this value gets the same value and color, for plot clarity reasons
                        years_mask = 0,
                        consistent_thr = 0.8,
                        idp_value = 1,
                        max_distance = 65000)) #grid cells with less than 90% of data are NA

quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_invertebrates_interpolation.qmd"),
  output_file = file.path("results_great scallop.html"),
  execute_params = list(species = "Pecten maximus",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0,
                        consistent_thr = 0.8,
                        idp_value = 1,
                        max_distance = 65000))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_invertebrates_interpolation.qmd"),
  output_file = file.path("results_european_lobster.html"),
  execute_params = list(species = "Homarus gammarus",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0,
                        consistent_thr = 0.8,
                        idp_value = 1,
                        max_distance = 65000))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_invertebrates_interpolation.qmd"),
  output_file = file.path("results_blue mussel.html"),
  execute_params = list(species = "Mytilus edulis",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.00,
                        consistent_thr =0.8,
                        idp_value = 1,
                        max_distance = 65000)) #otherwise no grid cells in summer, summer2015&2016 no data
