library(quarto)

quarto_render(
  input = file.path("scripts",
                    "ICES_datras_analysis.qmd"),
  output_file = file.path("results_cod.html"),
  execute_params = list(species = "Gadus morhua",
                        plot_limit = 100,#Change this to change the maximum value plotted,
#Everything above this value gets the same value and color, for plot clarity reasons
years_mask = 0.90,
consistent_thr = 0.6)) #grid cells with less than 90% of data are NA


quarto_render(
  input = file.path("scripts",
                    "ICES_datras_analysis.qmd"),
  output_file = file.path("results_haddock.html"),
  execute_params = list(species = "Melanogrammus aeglefinus",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.7))

quarto_render(
  input = file.path("scripts",
                    "ICES_datras_analysis.qmd"),
  output_file = file.path("results_seabass.html"),
  execute_params = list(species = "Dicentrarchus labrax",
                        plot_limit = 100,
                        years_mask = 0.70,
                        consistent_thr =0.6)) #otherwise no grid cells in summer, summer2015&2016 no data

quarto_render(
  input = file.path("scripts",
                    "ICES_datras_analysis.qmd"),
  output_file = file.path("results_ling.html"),
  execute_params = list(species = "Molva molva",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6))

quarto_render(
  input = file.path("scripts",
                    "ICES_datras_analysis.qmd"),
  output_file = file.path("results_herring.html"),
  execute_params = list(species = "Clupea harengus",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6))