library(quarto)


# FISH --------------------------------------------------------------------
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_cod_1.html"),
  execute_params = list(species = "Gadus morhua",
                        group = "fish", #because code also works for invertebrates now
                        plot_limit = 200,#Change this to change the maximum value plotted,
#Everything above this value gets the same value and color, for plot clarity reasons
years_mask = 0.90,
consistent_thr = 0.5,
idp_value = 1)) #grid cells with less than 90% of data are NA
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_cod_2.html"),
  execute_params = list(species = "Gadus morhua",
                        group = "fish", #because code also works for invertebrates now
                        plot_limit = 200,#Change this to change the maximum value plotted,
                        #Everything above this value gets the same value and color, for plot clarity reasons
                        years_mask = 0.90,
                        consistent_thr = 0.5,
                        idp_value = 2)) #grid cells with less than 90% of data are NA

quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_haddock_1.html"),
  execute_params = list(species = "Melanogrammus aeglefinus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.5,
                        idp_value = 1))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_haddock_2.html"),
  execute_params = list(species = "Melanogrammus aeglefinus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.5,
                        idp_value = 2))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_seabass_1.html"),
  execute_params = list(species = "Dicentrarchus labrax",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.70,
                        consistent_thr =0.6,
                        idp_value = 1)) #otherwise no grid cells in summer, summer2015&2016 no data
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_seabass_2.html"),
  execute_params = list(species = "Dicentrarchus labrax",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.70,
                        consistent_thr =0.6,
                        idp_value = 2)) #otherwise no grid cells in summer, summer2015&2016 no data
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_ling_1.html"),
  execute_params = list(species = "Molva molva",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6,
                        idp_value = 1))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_ling_2.html"),
  execute_params = list(species = "Molva molva",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6,
                        idp_value = 2))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_herring_1.html"),
  execute_params = list(species = "Clupea harengus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6,
                        idp_value = 1))
quarto_render(
  input = file.path("scripts",
                    "mapping",
                    "analysis_fish_interpolation.qmd"),
  output_file = file.path("results_herring_2.html"),
  execute_params = list(species = "Clupea harengus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6,
                        idp_value = 2))
