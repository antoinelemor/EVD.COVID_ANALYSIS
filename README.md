# EVD.COVID_ANALYSIS

## Table of Contents

1. [Overview](#overview)

2. [Folder Structure : Data and Codes](#folder-structure)
   - [Database](#database)
   - [Scripts](#scripts)
     - [1_Preprocessing](#1_preprocessing)
     - [2_Feedback_Scripts](#2_feedback_scripts)
     - [3_Training_and_Annotation](#3_training_and_annotation)
     - [4_Data_Analysis](#4_data_analysis)
   - [Models](#models)
   - [Results](#results)

3. [Annotation Performance Metrics](#annotation-performance-metrics)

4. [Section en Français](#section-en-fran%C3%A7ais)

## Overview

This repository contains scripts and data for processing, training, and analyzing text data related to COVID-19 press conferences in Quebec and Sweden. The primary goal is to preprocess the data, train models, annotate sentences, and conduct data analysis to understand the policies and measures taken by these countries during the pandemic. The annotation methodology is based on the approach described in [Do et al. (2022)](https://journals.sagepub.com/doi/pdf/10.1177/00491241221134526?casa_token=je4hEAkbGj4AAAAA:DF8Co2J-JzFNMycjRfroCdfrLB0Qivqu3WM_U83eX2oW17eJ-mh2jxTD6ai-fKoz_wICW_OQg0qkYMs), which uses sequential transfer learning to annotate large-scale text data.

The results of these analyses contribute to our understanding of how different frames influenced policy and evidence use during the COVID-19 pandemic. This method is used in the following working paper:

<p align="center">
  <img src="/Results/abstract.png" alt="Abstract">
</p>

## Folder Structure : Data and Codes

### 📂 Database

This folder contains various subdirectories for different types of data used in the project:

- #### 📂 original_data
  - **Content**: Raw text data from Quebec and Sweden's COVID-19 press conferences coming transmitted by the Public health agency of Sweden, or extracted [in another project](https://github.com/antoinelemor/QC.Uncertainty_COVID).

- #### 📂 epidemiology
  - **Content**: Epidemiological data for Quebec and Sweden, including COVID-19 cases, hospitalizations, vaccination data, and stringency index coming from the INSPQ for Quebec, or the ECDC for Sweden.

- #### 📂 preprocessed_data
  - **Content**: Preprocessed text data ready for annotation and analysis.

- #### 📂 verification_annotation_data
  - **Content**: JSONL files containing the evaluation, test, and training data (manual annotations using Doccano) for both Quebec and Sweden.

- #### 📂 training_data_per_label_per_country
  - **Content**: Subdirectories for Quebec (QC) and Sweden (SWD) containing JSONL files for various manual annotation labels used in model training.

- #### 📂 pred
  - **Content**: Subdirectories for Quebec (perf_QC) and Sweden (perf_SE) containing performance logs (e.g., F1 scores) of the annotation models.

### 📂 Scripts

This folder contains four subdirectories, each dedicated to a specific part of the project workflow:

#### 📂 1_Preprocessing

This subdirectory includes scripts for preprocessing the text data, specifically for Quebec and Sweden.

- **1_Preprocessed_QC.py**:
  - **Objectifs**: Preprocesses text data from Quebec by removing English sentences, tokenizing the text, and creating sentence contexts.

- **1_Preprocessed_SWD.py**:
  - **Objectifs**: Similar to the Quebec preprocessing script, but for Swedish text data. It removes English sentences, tokenizes the text, and creates sentence contexts.

- **2_Sentences_to_annotate.py**:
  - **Objectifs**: Calculates the number of sentences that need to be annotated for both Quebec and Sweden with a CI of 95%.

#### 📂 2_Feedback_Scripts

This subdirectory includes scripts to process and prepare data for annotation feedback.

- **1_JSONL_Annotation.py**:
  - **Objectifs**: Converts annotation data to JSONL format for processing.

- **2_Supplementary_sent_JSONL_FR.py**:
  - **Objectifs**: Processes additional French sentences into JSONL format.

- **2_Supplementary_sent_JSONL_SWD.py**:
  - **Objectifs**: Processes additional Swedish sentences into JSONL format.

- **2_Translate_JSONL_for_annotation.py**:
  - **Objectifs**: Translates sentences to be annotated and formats them into JSONL.

- **3_JSONL_train_AS.py**:
  - **Objectifs**: Prepares JSONL files for training annotation models.

#### 📂 3_Training_and_Annotation

This subdirectory contains scripts for training models and annotating text data.

- **1_Train_QC.py**:
  - **Objectifs**: Trains models using the Quebec text data.

- **1_Train_SWD.py**:
  - **Objectifs**: Trains models using the Swedish text data.

- **2_Predict_QC.py**:
  - **Objectifs**: Makes predictions and annotate the Quebec database using models trained on Quebec data.

- **2_Predict_SWD.py**:
  - **Objectifs**: Makes predictions and annotate the Swedish database using models trained on Swedish data.

#### 📂 4_Data_Analysis

This subdirectory includes scripts for analyzing the processed and annotated data.

- **1.Database_creation.R**:
  - **Objectifs**: Creates databases from the textual and epidemiological data.

- **2.Graphs_and_plot.R**:
  - **Objectifs**: Generates graphs and plots for visual data analysis based on OLS models performed in the 3.Models.R.

- **3.Models.R**:
  - **Objectifs**: Runs OLS models on the data.

- **4.Robustness.R**:
  - **Objectifs**: Tests the robustness of the statistical models.

### 📂 Models

This folder contains the trained models for each country and category. Note that these models are not included in the repository due to their size.

### 📂 Results

This folder contains all the results produced by the R scripts in the Data Analysis folder.

## Annotation Performance Metrics

### Annotation Metrics

<p align="center">
  <img src="/Results/annotation_metrics.png" alt="Annotation Metrics">
</p>

## Section en Français

### Vue d'ensemble

Ce dépôt contient des scripts et des données pour le traitement, l'entraînement et l'analyse des données textuelles relatives aux conférences de presse sur la COVID-19 au Québec et en Suède. L'objectif principal est de prétraiter les données, d'entraîner des modèles, d'annoter des phrases et de réaliser une analyse des données pour comprendre les politiques et les mesures prises par ces pays pendant la pandémie. La méthodologie d'annotation est basée sur l'approche décrite dans [Do et al. (2022)](https://journals.sagepub.com/doi/pdf/10.1177/00491241221134526?casa_token=je4hEAkbGj4AAAAA:DF8Co2J-JzFNMycjRfroCdfrLB0Qivqu3WM_U83eX2oW17eJ-mh2jxTD6ai-fKoz_wICW_OQg0qkYMs), qui utilise l'apprentissage par transfert séquentiel pour annoter des données textuelles à grande échelle.

Les résultats de ces analyses contribuent à notre compréhension de la manière dont différents cadres ont influencé l'utilisation des politiques et des preuves pendant la pandémie de COVID-19. Cette méthode est utilisée dans le document de travail suivant :

<p align="center">
  <img src="/Results/abstract.png" alt="Abstract">
</p>

### Structure des Dossiers : Données et Codes

#### 📂 Base de données

Ce dossier contient divers sous-répertoires pour les différents types de données utilisées dans le projet :

- #### 📂 original_data
  - **Contenu** : Données textuelles brutes des conférences de presse sur la COVID-19 au Québec et en Suède, transmises par l'Agence de santé publique de Suède, ou extraites [dans un autre projet](https://github.com/antoinelemor/QC.Uncertainty_COVID).

- #### 📂 epidemiology
  - **Contenu** : Données épidémiologiques pour le Québec et la Suède, y compris les cas de COVID-19, les hospitalisations, les données sur la vaccination et l'indice de sévérité provenant de l'INSPQ pour le Québec, ou de l'ECDC pour la Suède.

- #### 📂 preprocessed_data
  - **Contenu** : Données textuelles prétraitées prêtes pour l'annotation et l'analyse.

- #### 📂 verification_annotation_data
  - **Contenu** : Fichiers JSONL contenant les données d'évaluation, de test et d'entraînement (annotations manuelles utilisant Doccano) pour le Québec et la Suède.

- #### 📂 training_data_per_label_per_country
  - **Contenu** : Sous-répertoires pour le Québec (QC) et la Suède (SWD) contenant des fichiers JSONL pour divers labels d'annotation manuels utilisés dans l'entraînement des modèles.

- #### 📂 pred
  - **Contenu** : Sous-répertoires pour le Québec (perf_QC) et la Suède (perf_SE) contenant des journaux de performance (par exemple, les scores F1) des modèles d'annotation.

#### 📂 Scripts

Ce dossier contient quatre sous-répertoires, chacun dédié à une partie spécifique du flux de travail du projet :

#### 📂 1_Preprocessing

Ce sous-répertoire comprend des scripts pour le prétraitement des données textuelles, spécifiquement pour le Québec et la Suède.

- **1_Preprocessed_QC.py** :
  - **Objectifs** : Prétraite les données textuelles du Québec en supprimant les phrases en anglais, en tokenisant le texte et en créant des contextes de phrases.

- **1_Preprocessed_SWD.py** :
  - **Objectifs** : Similaire au script de prétraitement pour le Québec, mais pour les données textuelles suédoises. Il supprime les phrases en anglais, tokenize le texte et crée des contextes de phrases.

- **2_Sentences_to_annotate.py** :
  - **Objectifs** : Calcule le nombre de phrases à annoter pour le Québec et la Suède avec un CI de 95%.

#### 📂 2_Feedback_Scripts

Ce sous-répertoire comprend des scripts pour traiter et préparer les données pour les retours d'annotation.

- **1_JSONL_Annotation.py** :
  - **Objectifs** : Convertit les données d'annotation en format JSONL pour le traitement.

- **2_Supplementary_sent_JSONL_FR.py** :
  - **Objectifs** : Traite les phrases supplémentaires en français au format JSONL.

- **2_Supplementary_sent_JSONL_SWD.py** :
  - **Objectifs** : Traite les phrases supplémentaires en suédois au format JSONL.

- **2_Translate_JSONL_for_annotation.py** :
  - **Objectifs** : Traduit les phrases à annoter et les formate en JSONL.

- **3_JSONL_train_AS.py** :
  - **Objectifs** : Prépare les fichiers JSONL pour l'entraînement des modèles d'annotation.

#### 📂 3_Training_and_Annotation

Ce sous-répertoire contient des scripts pour l'entraînement des modèles et l'annotation des données textuelles.

- **1_Train_QC.py** :
  - **Objectifs** : Entraîne les modèles en utilisant les données textuelles du Québec.

- **1_Train_SWD.py** :
  - **Objectifs** : Entraîne les modèles en utilisant les données textuelles suédoises.

- **2_Predict_QC.py** :
  - **Objectifs** : Fait des prédictions et annoter la base de données du Québec en utilisant les modèles entraînés sur les données du Québec.

- **2_Predict_SWD.py** :
  - **Objectifs** : Fait des prédictions et annoter la base de données suédoise en utilisant les modèles entraînés sur les données suédoises.

#### 📂 4_Data_Analysis

Ce sous-répertoire comprend des scripts pour analyser les données traitées et annotées.

- **1.Database_creation.R** :
  - **Objectifs** : Crée des bases de données à partir des données textuelles et épidémiologiques.

- **2.Graphs_and_plot.R** :
  - **Objectifs** : Génère des graphiques et des tracés pour l'analyse visuelle des données basée sur les modèles OLS réalisés dans le fichier 3.Models.R.

- **3.Models.R** :
  - **Objectifs** : Exécute les modèles OLS sur les données.

- **4.Robustness.R** :
  - **Objectifs** : Teste la robustesse des modèles statistiques.

#### 📂 Models

Ce dossier contient les modèles entraînés pour chaque pays et catégorie. Notez que ces modèles ne sont pas inclus dans le dépôt en raison de leur taille.

#### 📂 Results

Ce dossier contient tous les résultats produits par les scripts R dans le dossier Analyse des Données.

## Annotation Performance Metrics

### Annotation Metrics

<p align="center">
  <img src="/Results/annotation_metrics.png" alt="Annotation Metrics">
</p>
