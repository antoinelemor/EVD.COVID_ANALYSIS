# EVD.COVID_ANALYSIS Repository

## Overview
This repository is dedicated to the analysis of text data related to COVID-19 in Quebec and Sweden, utilizing natural language processing techniques and Mixtral 7x8b LLM. The data for this analysis (press conferences during the pandemic in Quebec and Sweden) is sourced from my other repositories: [Swedish COVID-19 Press Conferences](https://github.com/antoinelemor/SWD.COVID.CONF) and [Quebec COVID-19 Uncertainty](https://github.com/antoinelemor/QC.Uncertainty_COVID).

## 📁 Scripts

### Script 1: Text Processing and Language Filtering
- **Functionality:** Processes textual data, removes English sentences from French texts, tokenizes sentences, and creates contextual data and sample data.
- **Libraries Used:** pandas, os, spacy, langdetect.
- **Process:** Reads data from a CSV file, processes it using spaCy for French text, and outputs the cleaned data to a new CSV file.

### Script 2: Adding Annotation Instructions
- **Functionality:** Enhances preprocessed data with specific annotation instructions for various analysis tasks.
- **Libraries Used:** pandas, os.
- **Process:** Reads the preprocessed data, adds columns for different annotation tasks such as evidence detection, source identification, and emotional tone analysis, and saves the updated data to a CSV file.

### Script 3: Automated Text Annotation
- **Functionality:** Uses a local LLM (Mixtral 7x8b) to annotate text based on the instructions provided in Script 2.
- **Libraries Used:** pandas, os, re, llama_index.llms.ollama, transformers, unidecode.
- **Process:** Processes each line of text with specific prompts for annotations, such as evidence detection, source identification, and more, using Ollama and llama_index with Mixtral model and saves the annotated data to a CSV file.

## Environment Configuration for the LLM Mixtral 7x8b Model

Mixtral 7x8b must be installed to use these scripts:

1. **Creating a virtual environment with Python:**
   ```shell
   python -m venv env
   source env/bin/activate 

2. **Installing Ollama:**
   ```shell
   pip install Ollama
   
3. **Running the Mixtral Model:**
   ```shell
   ollama run mixtral:8x7b-instruct-v0.1-q5_K_M

## 📁 Scripts

### Script 1 : Traitement de texte et filtrage linguistique
- **Fonctionnalité :** Traite les données textuelles, supprime les phrases anglaises des textes français, tokenize les phrases et crée des données contextuelles et des échantillons de données.
- **Bibliothèques utilisées :** pandas, os, spacy, langdetect.
- **Processus :** Lit les données à partir d'un fichier CSV, les traite en utilisant spaCy pour le texte français et produit les données nettoyées dans un nouveau fichier CSV.

### Script 2 : Ajout d'instructions d'annotation
- **Fonctionnalité :** Améliore les données prétraitées avec des instructions d'annotation spécifiques pour diverses tâches d'analyse.
- **Bibliothèques utilisées :** pandas, os.
- **Processus :** Lit les données prétraitées, ajoute des colonnes pour différentes tâches d'annotation telles que la détection de preuves, l'identification de sources et l'analyse du ton émotionnel, et sauvegarde les données mises à jour dans un fichier CSV.

### Script 3 : Annotation automatique de texte
- **Fonctionnalité :** Utilise un LLM local (Mixtral 7x8b) pour annoter le texte selon les instructions fournies dans le Script 2.
- **Bibliothèques utilisées :** pandas, os, re, llama_index.llms.ollama, transformers, unidecode.
- **Processus :** Traite chaque ligne de texte avec des invites spécifiques pour les annotations, telles que la détection de preuves, l'identification de sources, et plus encore, en utilisant Ollama et llama_index avec le modèle Mixtral et enregistre les données annotées dans un fichier CSV.

## Configuration de l'environnement pour le modèle LLM Mixtral 7x8b

Mixtral 7x8b doit être installé pour utiliser ces scripts :

1. **Création d'un environnement virtuel avec Python :**
   ```shell
   python -m venv env
   source env/bin/activate 

2. **Installation d'Ollama :**
   ```shell
   pip install Ollama
   
3. **Installation de Mixtral 8x7b :**
   ```shell
   ollama run mixtral:8x7b-instruct-v0.1-q5_K_M

   
