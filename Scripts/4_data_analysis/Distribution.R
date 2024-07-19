# Charger les librairies nécessaires
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)

# Chemin d'exportation
export_path <- "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Results"

# Importer les données
qc_data <- read_csv("/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/annotated_data/QC.final_annotated_texts.csv")
swd_data <- read_csv("/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/annotated_data/SWD.final_annotated_texts.csv")

# Vérifier les premières lignes des données pour confirmer le format
head(qc_data)
head(swd_data)

# Convertir les colonnes doc_ID en character
qc_data$doc_ID <- as.character(qc_data$doc_ID)
swd_data$doc_ID <- as.character(swd_data$doc_ID)

# Convertir les dates en format Date
qc_data$date <- as.Date(qc_data$date, format = "%Y-%m-%d")
swd_data$date <- dmy(swd_data$date)  # Utiliser dmy pour les dates au format DD/MM/YYYY

# Ajouter une colonne pour identifier les datasets
qc_data$region <- "Quebec"
swd_data$region <- "Sweden"

# Combiner les données
combined_data <- bind_rows(qc_data, swd_data)

# Vérifier les premières lignes des données combinées
head(combined_data)

# Filtrer les données pour detect_covid == 1 et detect_journalist_question == 0
filtered_data <- combined_data %>%
  filter(detect_covid == 1, detect_journalist_question == 0)

# Vérifier les premières lignes des données filtrées
head(filtered_data)

# Calculer les agrégats pour chaque base de données par date
aggregated_data <- filtered_data %>%
  group_by(region, date) %>%
  summarise(
    `Dangerous Frame` = mean(detect_frame == 2, na.rm = TRUE),
    `Moderate Frame` = mean(detect_frame == 1, na.rm = TRUE),
    `Mitigation Policies` = mean(detect_measures == 1, na.rm = TRUE),
    `Evidence` = mean(detect_evidence == 1, na.rm = TRUE),
    `Scientific Sources` = mean(detect_source == 1, na.rm = TRUE)
  ) %>%
  pivot_longer(cols = -c(region, date), names_to = "metric", values_to = "value")

# Vérifier les premières lignes des données agrégées
head(aggregated_data)

# Créer le graphique
p <- ggplot(aggregated_data, aes(x = date, y = value, color = region, fill = region)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ metric, scales = "free_y", ncol = 1) +
  labs(title = "Comparative Distribution of Annotation Categories in Two Textual Databases",
       x = "Date",
       y = "Proportion",
       color = "Jurisdiction",
       fill = "Jurisdiction") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(p)
# Enregistrer le graphique
ggsave(filename = file.path(export_path, "Distribution_through_time.png"), plot = p, width = 10, height = 8)



# Charger les librairies nécessaires
library(readr)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(rlang) # Pour utiliser sym()

# Chemin des données exportées
import_path <- "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/Annotated_data"
qc_data_path <- file.path(import_path, "QC.frame_database.csv")
swd_data_path <- file.path(import_path, "SWD.frame_database.csv")
export_path <- "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Results"

# Importer les données
qc_data <- read_csv(qc_data_path)
swd_data <- read_csv(swd_data_path)

# Renommer les variables
qc_data <- qc_data %>%
  rename(
    `Dangerous Frame` = dangerous_frame_rate,
    `Moderate Frame` = moderate_frame_rate,
    `Evidence` = evidence_rate,
    `Scientific Sources` = source_rate,
    `Mitigation Policies` = mitigation_measure_rate,
    `Suppression Policies` = suppression_measure_rate,
    `Evidence Full (Scientific Sources + Evidence)` = evidence_full
  )

swd_data <- swd_data %>%
  rename(
    `Dangerous Frame` = dangerous_frame_rate,
    `Moderate Frame` = moderate_frame_rate,
    `Evidence` = evidence_rate,
    `Scientific Sources` = source_rate,
    `Mitigation Policies` = mitigation_measure_rate,
    `Suppression Policies` = suppression_measure_rate,
    `Evidence Full (Scientific Sources + Evidence)` = evidence_full
  )

# Filtrer les variables d'intérêt
variables <- c("Dangerous Frame", "Moderate Frame", "Evidence", "Scientific Sources", 
               "Mitigation Policies", "Suppression Policies", "Evidence Full (Scientific Sources + Evidence)")

# Fonction pour créer les graphiques de distribution
plot_distribution <- function(data, variable, title) {
  ggplot(data, aes(x = !!sym(variable))) +
    geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
    geom_density(alpha = 0.2, fill = "blue") +
    labs(title = title, x = variable, y = "Density") +
    theme_minimal()
}

# Créer les graphiques pour chaque variable
qc_plots <- lapply(variables, function(variable) {
  plot_distribution(qc_data, variable, paste("Quebec -", variable))
})

swd_plots <- lapply(variables, function(variable) {
  plot_distribution(swd_data, variable, paste("Sweden -", variable))
})

# Combiner les graphiques
combined_plots <- mapply(function(qc_plot, swd_plot) {
  ggarrange(qc_plot, swd_plot, ncol = 2, nrow = 1)
}, qc_plots, swd_plots, SIMPLIFY = FALSE)

# Afficher les graphiques dans une seule image
final_plot <- ggarrange(plotlist = combined_plots, ncol = 1, nrow = length(variables))
print(final_plot)

# Enregistrer le graphique
ggsave(filename = file.path(export_path, "EVD.COVID_Variables_distribution.pdf"), plot = final_plot, width = 12, height = 12)
