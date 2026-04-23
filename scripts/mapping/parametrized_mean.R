library(quarto)


# FISH --------------------------------------------------------------------
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_cod.html"),
  execute_params = list(species = "Gadus morhua",
                        group = "fish", #because code also works for invertebrates now
                        plot_limit = 100,#Change this to change the maximum value plotted,
#Everything above this value gets the same value and color, for plot clarity reasons
years_mask = 0.90,
consistent_thr = 0.6)) #grid cells with less than 90% of data are NA


quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_haddock.html"),
  execute_params = list(species = "Melanogrammus aeglefinus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.7))

quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_seabass.html"),
  execute_params = list(species = "Dicentrarchus labrax",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.70,
                        consistent_thr =0.6)) #otherwise no grid cells in summer, summer2015&2016 no data

quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_ling.html"),
  execute_params = list(species = "Molva molva",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6))

quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_herring.html"),
  execute_params = list(species = "Clupea harengus",
                        group = "fish",
                        plot_limit = 100,
                        years_mask = 0.90,
                        consistent_thr = 0.6))


# INVERTEBRATES -----------------------------------------------------------
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_europeanlobster.html"),
  execute_params = list(species = "Homarus gammarus",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.05,
                        consistent_thr = 0.6))
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_cuttlefish.html"),
  execute_params = list(species = "Sepia officinalis",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.1, #not a lot of years with data
                        consistent_thr = 0.6))
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_scallop.html"),
  execute_params = list(species = "Pecten maximus",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.10,
                        consistent_thr = 0.6))
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_norwaylobster.html"),
  execute_params = list(species = "Nephrops norvegicus",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.10,
                        consistent_thr = 0.6))
quarto_render(
  input = file.path("scripts",
                    "analysis_mean.qmd"),
  output_file = file.path("results_mussel.html"),
  execute_params = list(species = "Mytilus edulis",
                        group = "invertebrates",
                        plot_limit = 100,
                        years_mask = 0.05,
                        consistent_thr = 0.6))

