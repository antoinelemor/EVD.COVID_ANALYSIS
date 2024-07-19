# Base path
import_data_path <- "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/annotated_data"
export_path <- "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Results"

# Chargement des données (ajustez le nom du fichier si nécessaire)
swd_data <- read.csv(file.path(import_data_path, "SWD.processed_conf_texts_with_new_responses.csv"))
qc_data <- read.csv(file.path(import_data_path, "QC.processed_conf_texts_with_new_responses.csv"))

# Chargement des packages nécessaires
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyverse)
library(broom)


## CRÉATION D'UN NOUVEAU DATAFRAME UNIQUE ##

# Ajouter une colonne pour identifier le pays
swd_data$country <- 'Sweden'
qc_data$country <- 'Quebec'

# Modifier les doc_ID pour les rendre uniques
# En ajoutant un préfixe basé sur le pays
swd_data$doc_ID <- paste("SWD", swd_data$doc_ID, sep="_")
qc_data$doc_ID <- paste("QC", qc_data$doc_ID, sep="_")

# Fusionner les deux dataframes
combined_data <- rbind(swd_data, qc_data)



## GRAPHIQUE PROPORTION DE MEASURES PAR FRAMES ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs en français par des valeurs en anglais
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')

filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression') # Assurez-vous que les autres catégories sont déjà en anglais ou les traduire également

# Calculer les proportions et préparer les données pour le test du chi²
# Création d'une table de contingence entre 'frame_response' et 'measures_response'
contingency_table <- table(filtered_data$frame_response, filtered_data$measures_response)

# Réaliser le test du chi²
chi2_test <- chisq.test(contingency_table)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(frame_response, measures_response) %>%
  group_by(frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec modifications pour la traduction en anglais et ajustements des étiquettes
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = measures_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of Measures by Frame",
       x = "Frame",
       y = "Proportion",
       fill = "Measures") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.2e", chi2_test$statistic, chi2_test$parameter, chi2_test$p.value),
           hjust = 2.4, vjust = 1.1, size = 4, color = "black") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

ggsave(filename = "Frames_and_Measures.pdf", path=export_path, width = 10, height = 8, units = "in")


## GRAPHIQUE PROPORTION DE MEASURES PAR PAYS ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs en français par des valeurs en anglais
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')

filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')

# Préparation des données pour le graphique, cette fois en incluant la colonne pays
graph_data <- filtered_data %>%
  count(country, frame_response, measures_response) %>% # Assurez-vous d'inclure le pays dans le comptage
  group_by(country, frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec séparation par pays
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = measures_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of Measures by Frame and Country",
       x = "Frame",
       y = "Proportion",
       fill = "Measures") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~ country, scales = "free_y") # Utilisez facet_wrap pour créer un graphique séparé pour chaque pays

# Vous pouvez ajuster 'path=export_path' selon le chemin d'exportation que vous souhaitez utiliser
ggsave(filename = "Frames_and_Measures_by_Country.pdf", path=export_path, width = 12, height = 10, units = "in")









## GRAPHIQUE PROPORTIONS DE EVIDENCE PAR FRAMES ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))


# Remplacement des valeurs en français par des valeurs en anglais
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')
filtered_data$detect_evidence_response <- recode(filtered_data$detect_evidence_response,
                                                 'oui' = 'Yes',
                                                 'non' = 'No')

# Calculer les proportions et préparer les données pour le test du chi²
# Création d'une table de contingence entre 'frame_response' et 'detect_evidence_response'
contingency_table <- table(filtered_data$frame_response, filtered_data$detect_evidence_response)

# Réaliser le test du chi²
chi2_test <- chisq.test(contingency_table)

# Affichage des résultats du test du chi²
print(chi2_test)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(frame_response, detect_evidence_response) %>%
  group_by(frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec résultats du test inclus
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = detect_evidence_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of 'evidence' by 'frames'",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.2e", chi2_test$statistic, chi2_test$parameter, chi2_test$p.value),
           hjust = 2.59, vjust = 1.1, size = 4, color = "black") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

ggsave(filename = "Frames_and_evidence.pdf", path = export_path, width = 10, height = 8, units = "in")


## GRAPHIQUE PROPORTIONS DE EVIDENCE + SOURCES PAR FRAMES ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs en français par des valeurs en anglais pour frame_response
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')

# Création d'une nouvelle variable qui prend 'oui' si 'detect_evidence_response' ou 'detect_source_response' est 'oui'
filtered_data$evidence_or_source_detected <- ifelse(filtered_data$detect_evidence_response == 'oui' | filtered_data$detect_source_response == 'oui', 'Yes', 'No')

# Création d'une table de contingence entre 'frame_response' et 'evidence_or_source_detected'
contingency_table_evidence_source <- table(filtered_data$frame_response, filtered_data$evidence_or_source_detected)

# Réalisation du test du chi² pour 'frame_response' et 'evidence_or_source_detected'
chi2_test_evidence_source <- chisq.test(contingency_table_evidence_source)

# Affichage des résultats du test du chi²
print(chi2_test_evidence_source)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(frame_response, evidence_or_source_detected) %>%
  group_by(frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = evidence_or_source_detected)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) +
  labs(title = "Proportions of Evidence or Scientific Sources by Frame",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence or Scientific Source") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.2e", 
                                                     chi2_test_evidence_source$statistic, chi2_test_evidence_source$parameter, chi2_test_evidence_source$p.value),
           hjust = 2.165, vjust = 0.9, size = 4, color = "black")

# Sauvegarde du graphique
ggsave(filename = "Frames_with_Evidence_or_Sources_Detected.pdf", path = export_path, width = 10, height = 8, units = "in")


## GRAPHIQUE PROPORTIONS DE EVIDENCE PAR PAYS ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs en français par des valeurs en anglais
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')
filtered_data$detect_evidence_response <- recode(filtered_data$detect_evidence_response,
                                                 'oui' = 'Yes',
                                                 'non' = 'No')

# Préparation des données pour le graphique, cette fois en incluant la colonne pays
graph_data <- filtered_data %>%
  count(country, frame_response, detect_evidence_response) %>% # Ajout de la colonne pays dans le comptage
  group_by(country, frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec séparation par pays
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = detect_evidence_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of Evidence by Frame and Country",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~ country, scales = "free_y") # Crée un graphique séparé pour chaque pays

# Vous pouvez ajuster 'path=export_path' selon le chemin d'exportation que vous souhaitez utiliser
ggsave(filename = "Frames_and_Evidence_by_Country.pdf", path=export_path, width = 12, height = 10, units = "in")

## GRAPHIQUE PROPORTIONS DE EVIDENCE + SOURCES PAR FRAMES ET PAR PAYS ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs en français par des valeurs en anglais pour frame_response
filtered_data$frame_response <- recode(filtered_data$frame_response,
                                       'dangereux' = 'Dangerous',
                                       'modéré' = 'Moderate',
                                       'neutre' = 'Neutral')

# Création d'une nouvelle variable qui prend 'oui' si 'detect_evidence_response' ou 'detect_source_response' est 'oui'
filtered_data$evidence_or_source_detected <- ifelse(filtered_data$detect_evidence_response == 'oui' | filtered_data$detect_source_response == 'oui', 'Yes', 'No')

# Ajout d'une dimension de pays à la préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(country, frame_response, evidence_or_source_detected) %>%
  group_by(country, frame_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec une comparaison par pays
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = evidence_or_source_detected)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) +
  facet_wrap(~ country) + # Ajoute une subdivision par pays
  labs(title = "Proportions of Evidence or Scientific Sources by Frame and Country",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence or Scientific Source Detected") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Sauvegarde du graphique
ggsave(filename = "Frames_with_Evidence_or_Sources_Detected_by_Country.pdf", path = export_path, width = 10, height = 8, units = "in")






## GRAPHIQUE PROPORTIONS DE EVIDENCE PAR MEASURES ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))
filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')
filtered_data$detect_evidence_response <- recode(filtered_data$detect_evidence_response,
                                          'oui' = 'Yes',
                                          'non' = 'No')

# Calculer les proportions et préparer les données pour le test du chi²
# Création d'une table de contingence entre 'measures_response' et 'measures_response'
contingency_table <- table(filtered_data$measures_response, filtered_data$detect_evidence_response)

# Réaliser le test du chi²
chi2_test <- chisq.test(contingency_table)

# Affichage des résultats du test du chi²
print(chi2_test)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(measures_response, detect_evidence_response) %>%
  group_by(measures_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec résultats du test inclus
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = detect_evidence_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of 'evidence' by 'measures'",
       x = "Frame Response",
       y = "Proportion",
      fill = "Evidence") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.2e", chi2_test$statistic, chi2_test$parameter, chi2_test$p.value),
           hjust = 2.59, vjust = 1.1, size = 4, color = "black") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

ggsave(filename = "Measures_and_evidence.pdf", path = export_path, width = 10, height = 8, units = "in")

## GRAPHIQUE EVIDENCE & SOURCES PAR MEASURES AVEC TEST DU CHI-CARRÉ ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs pour 'measures_response'
filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')

# Création de la nouvelle variable combinée
filtered_data$combined_evidence_source <- ifelse(filtered_data$detect_evidence_response == 'oui' | filtered_data$detect_source_response == 'oui', 'Yes', 'No')

# Création d'une table de contingence entre 'measures_response' et 'combined_evidence_source'
contingency_table <- table(filtered_data$measures_response, filtered_data$combined_evidence_source)

# Réalisation du test du chi²
chi2_test <- chisq.test(contingency_table)

# Affichage des résultats du test du chi²
print(chi2_test)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(measures_response, combined_evidence_source) %>%
  group_by(measures_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec résultats du test inclus
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = combined_evidence_source)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) +
  labs(title = "Proportions of Combined 'Evidence and Sources' by Measures",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence and Sources") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.3f", chi2_test$statistic, chi2_test$parameter, chi2_test$p.value),
           hjust = 2.51, vjust = 1, size = 4, color = "black")

# Sauvegarde du graphique
ggsave(filename = "Measures_Evidence_and_Sources.pdf", path = export_path, width = 10, height = 8, units = "in")


## GRAPHIQUE PROPORTIONS DE EVIDENCE PAR PAYS ##


# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>%
  filter(detect_COVID_response == 'oui', journalist_question_response == 'non')
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs par leur équivalent en anglais
filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')
filtered_data$detect_evidence_response <- recode(filtered_data$detect_evidence_response,
                                                 'oui' = 'Yes',
                                                 'non' = 'No')

# Préparation des données pour le graphique, incluant cette fois la colonne pays
graph_data <- filtered_data %>%
  count(country, measures_response, detect_evidence_response) %>% # Ajout de la colonne pays dans le comptage
  group_by(country, measures_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec séparation par pays
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = detect_evidence_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of Evidence by Measures and Country",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~ country, scales = "free_y") # Crée un graphique séparé pour chaque pays

# Vous pouvez ajuster 'path=export_path' selon le chemin d'exportation que vous souhaitez utiliser
ggsave(filename = "Measures_and_Evidence_by_Country.pdf", path=export_path, width = 12, height = 10, units = "in")

## GRAPHIQUE EVIDENCE & SOURCES PAR MEASURES SÉPARÉS PAR PAYS ##

# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui', journalist_question_response == 'non')
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs pour 'measures_response'
filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')

# Création de la nouvelle variable combinée
filtered_data$combined_evidence_source <- ifelse(filtered_data$detect_evidence_response == 'oui' | filtered_data$detect_source_response == 'oui', 'Yes', 'No')

# Préparation des données pour le graphique, séparées par pays
graph_data <- filtered_data %>%
  count(country, measures_response, combined_evidence_source) %>%
  group_by(country, measures_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création des graphiques séparés par pays
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = combined_evidence_source)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) +
  facet_wrap(~country, scales = "free_y") +
  labs(title = "Proportions of Combined 'Evidence and Sources' by Measures, Separated by Country",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence and Sources") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Sauvegarde du graphique, adaptée si nécessaire pour gérer plusieurs pays
ggsave(filename = "Measures_Evidence_and_Sources_by_Country.pdf", path = export_path, width = 10, height = 8, units = "in")







## PROPORTION GLOBALE DE EVIDENCE & SOURCES PAR MEASURES ##

# Filtrage et préparation des données
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui', journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE)) %>%
  mutate(measures_response = recode(measures_response, 'neutre' = 'Neutral', 'mitigation' = 'Mitigation', 'suppression' = 'Suppression'),
         combined_evidence_source = ifelse(detect_evidence_response == 'oui' | detect_source_response == 'oui', 'Yes', 'No'))

# Création d'une table de contingence et réalisation du test du chi²
contingency_table <- table(filtered_data$measures_response, filtered_data$combined_evidence_source)
chi2_test <- chisq.test(contingency_table)
print(chi2_test)

# Préparation des données pour le graphique
graph_data <- filtered_data %>%
  count(measures_response, combined_evidence_source) %>%
  mutate(proportion = n / sum(n))

# Création du graphique
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = combined_evidence_source)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion), y = proportion + 0.05), position = position_dodge(width = 0.9), vjust = 1.7) +
  geom_text(aes(label = paste("n =", n), y = proportion), position = position_dodge(width = 0.9), vjust = -0.2) +
  labs(title = "Global Proportions of 'Evidence and Sources' by Measures",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence and Sources") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.3f", chi2_test$statistic, chi2_test$parameter, chi2_test$p.value),
           hjust = 2.51, vjust = 1, size = 4, color = "black")

# Sauvegarde du graphique
ggsave(filename = "Global_Measures_Evidence_and_Sources.pdf", path = export_path, width = 10, height = 8, units = "in")



## PROPORTION GLOBALE DE EVIDENCE & SOURCES PAR MEASURES PAR PAYS ##

# Assurez-vous que 'combined_data' contient une colonne 'country'
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui', journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE)) %>%
  mutate(measures_response = recode(measures_response,
                                    'neutre' = 'Neutral',
                                    'mitigation' = 'Mitigation',
                                    'suppression' = 'Suppression'),
         combined_evidence_source = ifelse(detect_evidence_response == 'oui' | detect_source_response == 'oui', 'Yes', 'No'))

# Préparation des données pour le graphique avec distinction par pays
graph_data <- filtered_data %>%
  count(country, measures_response, combined_evidence_source) %>%
  group_by(country) %>%
  mutate(proportion = n / sum(n)) %>%
  ungroup()

# Création du graphique avec distinction par pays
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = combined_evidence_source)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f%%", 100 * proportion), y = proportion + 0.02), position = position_dodge(width = 0.9), vjust = 0, size = 3) +
  geom_text(aes(label = paste("n =", n), y = proportion + 0.05), position = position_dodge(width = 0.9), vjust = 0, size = 3) +
  facet_wrap(~ country, scales = "free_y", ncol = 1) +
  labs(title = "Global Proportions of 'Evidence and Sources' by Measures and Country",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence and Sources") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Sauvegarde du graphique avec différenciation par pays
ggsave(filename = "Global_Measures_Evidence_and_Sources_by_Country.pdf", path = export_path, width = 10, height = 8, units = "in")



## PROPORTION GLOBALE DES EVIDENCE ET SOURCES PAR FRAMES ##

# Filtrage et préparation des données
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE)) %>%
  mutate(frame_response = recode(frame_response, 'dangereux' = 'Dangerous', 'modéré' = 'Moderate', 'neutre' = 'Neutral'),
         evidence_or_source_detected = ifelse(detect_evidence_response == 'oui' | detect_source_response == 'oui', 'Yes', 'No'))

# Calcul des proportions globales pour 'Evidence or Source Detected'
total_yes_no <- filtered_data %>%
  summarise(total_yes = sum(evidence_or_source_detected == 'Yes'), total_no = sum(evidence_or_source_detected == 'No'))

# Préparation des données pour le graphique, en utilisant les totaux globaux pour calculer les proportions
graph_data <- filtered_data %>%
  count(frame_response, evidence_or_source_detected) %>%
  mutate(proportion_yes = n / total_yes_no$total_yes * (evidence_or_source_detected == 'Yes'),
         proportion_no = n / total_yes_no$total_no * (evidence_or_source_detected == 'No'),
         proportion = ifelse(evidence_or_source_detected == 'Yes', proportion_yes, proportion_no)) %>%
  select(-proportion_yes, -proportion_no) %>%
  arrange(frame_response, evidence_or_source_detected)

# Création du graphique avec ajustement des positions des étiquettes "n ="
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = evidence_or_source_detected)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion), y = proportion + 0.05), position = position_dodge(width = 0.9), vjust = 2.5) + # Position des proportions
  geom_text(aes(label = paste("n =", n), y = proportion + 0.08), position = position_dodge(width = 0.9), size = 3.5, vjust = 3.5) + # Position des étiquettes "n ="
  labs(title = "Global Proportions of Evidence or Scientific Sources by Frame",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence or Scientific Source Detected") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  annotate("text", x = Inf, y = Inf, label = sprintf("Chi-squared = %.2f, df = %d, p-value = %.2e", 
                                                     chi2_test_evidence_source$statistic, chi2_test_evidence_source$parameter, chi2_test_evidence_source$p.value),
           hjust = 2.165, vjust = 0.9, size = 4, color = "black")

# Sauvegarde du graphique
ggsave(filename = "Global_Frames_with_Evidence_or_Sources_Detected.pdf", path = export_path, width = 10, height = 8, units = "in")





## PROPORTION GLOBALE DES EVIDENCE ET SOURCES PAR FRAME PAR PAYS ##

# Filtrage et préparation des données avec différenciation par pays
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE)) %>%
  mutate(frame_response = recode(frame_response, 'dangereux' = 'Dangerous', 'modéré' = 'Moderate', 'neutre' = 'Neutral'),
         evidence_or_source_detected = ifelse(detect_evidence_response == 'oui' | detect_source_response == 'oui', 'Yes', 'No'))

# Calcul des proportions globales pour 'Evidence or Source Detected' par pays
total_yes_no_by_country <- filtered_data %>%
  group_by(country) %>%
  summarise(total_yes = sum(evidence_or_source_detected == 'Yes'), total_no = sum(evidence_or_source_detected == 'No')) %>%
  ungroup()

# Préparation des données pour le graphique, en utilisant les totaux globaux par pays pour calculer les proportions
graph_data <- filtered_data %>%
  count(country, frame_response, evidence_or_source_detected) %>%
  left_join(total_yes_no_by_country, by = "country") %>%
  mutate(proportion_yes = n / total_yes * (evidence_or_source_detected == 'Yes'),
         proportion_no = n / total_no * (evidence_or_source_detected == 'No'),
         proportion = ifelse(evidence_or_source_detected == 'Yes', proportion_yes, proportion_no)) %>%
  select(-proportion_yes, -proportion_no) %>%
  arrange(country, frame_response, evidence_or_source_detected)

# Ajustement pour le positionnement des étiquettes "n ="
graph_data <- graph_data %>%
  group_by(country, frame_response, evidence_or_source_detected) %>%
  mutate(min_proportion = min(proportion)) %>%
  ungroup()

# Création du graphique avec différenciation par pays
ggplot(graph_data, aes(x = frame_response, y = proportion, fill = evidence_or_source_detected)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion), y = proportion + 0.02), position = position_dodge(width = 0.9), vjust = -0.7) +
  geom_text(aes(label = paste("n =", n), y = min_proportion - 0.05), position = position_dodge(width = 0.9), vjust = -3.4, size = 3.5) +
  facet_wrap(~ country, scales = "free_y") +
  labs(title = "Global Proportions of Evidence or Scientific Sources by Frame and Country",
       x = "Frame",
       y = "Proportion",
       fill = "Evidence or Scientific Source Detected") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Enregistrement du graphique, ajustez 'export_path' selon votre configuration
ggsave(filename = "Global_Frames_with_Evidence_or_Sources_Detected_by_Country.pdf", path = export_path, width = 10, height = 8, units = "in")







## GRAPHIQUE PROPORTIONS DE EVIDENCE PAR PAYS ##


# Filtrage des données pour inclure uniquement les lignes où detect_COVID_response est 'oui'
filtered_data <- combined_data %>%
  filter(detect_COVID_response == 'oui', journalist_question_response == 'non')
filtered_data <- combined_data %>% 
  filter(detect_COVID_response == 'oui') %>%
  filter(journalist_question_response == 'non') %>%
  filter(!grepl('grave situation|la strategie|reduction', measures_response, ignore.case = TRUE)) %>%
  filter(!grepl('espoir|la conference|le texte', associated_emotion_response, ignore.case = TRUE)) %>%
  filter(!grepl('le cadrage', frame_response, ignore.case = TRUE))

# Remplacement des valeurs par leur équivalent en anglais
filtered_data$measures_response <- recode(filtered_data$measures_response,
                                          'neutre' = 'Neutral',
                                          'mitigation' = 'Mitigation',
                                          'suppression' = 'Suppression')
filtered_data$detect_evidence_response <- recode(filtered_data$detect_evidence_response,
                                                 'oui' = 'Yes',
                                                 'non' = 'No')

# Préparation des données pour le graphique, incluant cette fois la colonne pays
graph_data <- filtered_data %>%
  count(country, measures_response, associated_emotion_response) %>% # Ajout de la colonne pays dans le comptage
  group_by(country, measures_response) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(proportion = n / total)

# Création du graphique avec séparation par pays
ggplot(graph_data, aes(x = measures_response, y = proportion, fill = associated_emotion_response)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = sprintf("%.2f", proportion)), position = position_dodge(width = 0.9), vjust = -1.7) +
  geom_text(aes(label = paste("n =", n)), position = position_dodge(width = 0.9), vjust = -0.2) + # Ajoute le nombre d'observations avec "n ="
  labs(title = "Proportions of Evidence by Measures and Country",
       x = "Measures Response",
       y = "Proportion",
       fill = "Evidence") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~ country, scales = "free_y") # Crée un graphique séparé pour chaque pays

# Vous pouvez ajuster 'path=export_path' selon le chemin d'exportation que vous souhaitez utiliser
ggsave(filename = "Measures_and_Evidence_by_Country.pdf", path=export_path, width = 12, height = 10, units = "in")


