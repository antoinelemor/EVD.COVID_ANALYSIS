# BEYOND EVIDENCE: HOW FRAMING SHAPES PUBLIC HEALTH POLICIES DURING HEALTH CRISES

Welcome to the **EVD.COVID_ANALYSIS** repository, which supports the scientific article:

> **Beyond Evidence: How Framing Shapes Public Health Policies During Health Crises**  

This repository contains all data, scripts, models, and results used in the comparative analysis of COVID-19 press conferences in Quebec and Sweden. The project explores how evolving frames, evidence levels, and institutional configurations influenced the adoption of either stringent suppression or more moderate mitigation policies during the COVID-19 pandemic.

---

## Table of Contents

1. [Abstract](#abstract)  
2. [Repository Structure](#repository-structure)  
   1. [Database](#database)  
      - [annotated_data](#annotated_data)  
      - [epidemiology](#epidemiology)  
      - [original_data](#original_data)  
      - [pred](#pred)  
      - [preprocessed_data](#preprocessed_data)  
      - [training_data_per_label_per_country](#training_data_per_label_per_country)  
      - [verification_annotation_data](#verification_annotation_data)  
   2. [Results](#results)  
   3. [Scripts](#scripts)  
      - [1_preprocessing](#1_preprocessing)  
      - [2_feedback_scripts](#2_feedback_scripts)  
      - [3_training_and_annotation](#3_training_and_annotation)  
      - [4_data_analysis](#4_data_analysis)  
   4. [models](#models)  
3. [Detailed Code Explanations](#detailed-code-explanations)  
   1. [Scripts/1_preprocessing](#scripts1_preprocessing)  
   2. [Scripts/2_feedback_scripts](#scripts2_feedback_scripts)  
   3. [Scripts/3_training_and_annotation](#scripts3_training_and_annotation)  
   4. [Scripts/4_data_analysis](#scripts4_data_analysis)  
4. [How to Use This Repository](#how-to-use-this-repository)  
5. [License and Citation](#license-and-citation)

---

## Abstract

Below is the abstract of the article in text form, along with a screenshot of the same abstract stored in the `Results` folder:

> **BEYOND EVIDENCE: HOW FRAMING SHAPES PUBLIC HEALTH POLICIES DURING HEALTH CRISES**  
> **ABSTRACT**  
> This article develops and applies an integrated conceptual framework that bridges sociological and equivalence framing theories to understand how framing, evidence level, and the balance of influence between policymakers and scientists shape policymaking during a health crisis. Using a unique dataset of daily press conferences from Quebec—where political decision-makers held comparatively greater authority—and Sweden—where scientists enjoyed more autonomy—this study employs Natural Language Processing techniques and OLS regressions to examine how evolving frames and levels of evidence influenced the adoption of stringent suppression measures or more moderate mitigation policies during the COVID-19 pandemic. The findings show that in Quebec, where political decision-makers exerted relatively more influence, a frame emphasizing imminent danger justified far-reaching interventions even with low levels of evidence. By contrast, in Sweden, the effect of the same frame was conditional on higher levels of evidence, illustrating a different approach to uncertainty, where scientists may require stronger empirical justification before endorsing similar measures. By linking framing and evidence levels to institutional configurations, and by offering a comparative, real-time empirical analysis that transcends retrospective or single-case approaches, this research highlights how institutional dynamics shape the effects of frames, and the evidence thresholds required for policy action. Ultimately, the integrated approach proposed here advances our theoretical understanding of how frames emerge and operate within distinct institutional settings, interact with varying evidence levels, and influence public health choices, offering valuable lessons on the balance between democratic accountability, expert influence, and framing in shaping highly consequential policies.

---

## Repository Structure

Below is an overview of all major directories and files within this repository. Each file is critical to either data gathering, data preprocessing, model training, inference, or analysis.

```
EVD.COVID_ANALYSIS
├── Database
│   ├── annotated_data
│   ├── epidemiology
│   ├── original_data
│   ├── pred
│   ├── preprocessed_data
│   ├── training_data_per_label_per_country
│   └── verification_annotation_data
├── README.md
├── Results
├── Scripts
│   ├── 1_preprocessing
│   ├── 2_feedback_scripts
│   ├── 3_training_and_annotation
│   └── 4_data_analysis
└── models
```

### 1. Database

The `Database` folder is home to all datasets used and produced during the project.

1. **annotated_data**  
   - Contains final CSV files with annotation labels (e.g., `QC.final_annotated_texts.csv`, `SWD.final_annotated_texts.csv`).  
   - Includes frame databases (`QC.frame_database.csv`, `SWD.frame_database.csv`, and `_2.csv` variations) for both countries, used for regression analyses and correlation checks.

2. **epidemiology**  
   - This subfolder houses spreadsheets of epidemiological data such as case counts, hospitalizations, vaccination rates, and stringency indexes (e.g., `QC.COVID_data.xlsx`, `SWD.cases.csv`, `SWD.hospitalizations.csv`).  
   - Used for creating scaled indices (0–100) in the analysis.

3. **original_data**  
   - Contains the original raw press conference texts (`QC.conf_texts.csv` and `SWD.conf_texts.csv`).

4. **pred**  
   - Holds performance logs of model predictions for each country (e.g., `perf_QC`, `perf_SE` or `perf_SWD`).  
   - Each text file (e.g., `frame_QC_scores.txt`) stores training and validation metrics.

5. **preprocessed_data**  
   - Contains CSV files where raw text is split into sentences with context windows (e.g., `QC.processed_conf_texts.csv`, `SWD.processed_conf_texts.csv`).  
   - Produced by the scripts in `Scripts/1_preprocessing` to facilitate model training and annotation.

6. **training_data_per_label_per_country**  
   - Houses JSONL files for each label (e.g., `frame`, `measures`, `detect_COVID`) across training, testing, and prediction sets.  
   - Divided by country subfolders `QC` and `SWD` (e.g., `frame_QC_train.jsonl`).

7. **verification_annotation_data**  
   - Hosts JSONL files used for verifying annotations, training, test, and evaluation sets (e.g., `QC.training_data.jsonl`, `SWD.test_data.jsonl`).  
   - Additional JSONL scripts that select random subsets of data for supplementary annotations.

### 2. Results

The `Results` folder contains:

- Plots, figures, and correlation heatmaps (e.g., `QC.corrplot_manual.png`, `SWD.corrplot_manual.png`).  
- PDF files of linear regression projections (e.g., `QC.unc.results_moderate_frame_and_evidence_stringency_projections.pdf`).  
- Final docx tables for OLS results (e.g., `combined_results_OLS_mitigation.docx.docx`).  
- The `abstract.png` file containing the screenshot of the article’s abstract.  
- Additional visuals (e.g., `Distribution_through_time.png`, `QC_SWD_deaths_per_100k.pdf`) used throughout the comparative analysis.

### 3. Scripts

The `Scripts` folder contains all Python and R scripts involved in data cleaning, annotation, training, and analysis. They are subdivided into:

1. **1_preprocessing**  
   - Scripts for cleaning and preparing raw data.  
   - Example: `1_Preprocessed_QC.py` removes English sentences from Quebec texts, tokenizes them, and creates context windows.

2. **2_feedback_scripts**  
   - Includes scripts for handling annotation feedback loops, generating JSONL files, or selecting additional sentences for annotation.  
   - Example: `1_JSONL_Annotation.py` creates training, validation, and test JSONL from the processed CSV data.

3. **3_training_and_annotation**  
   - Scripts that train machine learning models on annotated data (Camembert for French and SwedishBert for Swedish).  
   - Example: `1_Train_QC.py` trains Camembert-based classification models for Quebec data, while `1_Train_SWD.py` does so for Sweden.  
   - Prediction scripts (`2_Predict_QC.py` / `2_Predict_SWD.py`) apply trained models to produce final labeled data.

4. **4_data_analysis**  
   - R scripts that merge all data, compute correlations, run OLS regressions, generate VIF checks, and produce final plots.  
   - Example: `3.Models.R` organizes regression models for both Quebec and Sweden, while `4.Robustness.R` computes VIF and correlation plots.

### 4. models

The `models` folder contains saved model files for each label, with subfolders such as `frame_QC`, `measures_QC`, etc. Each subfolder typically has:

- A `config.json` file.  
- A tokenizer file (e.g., `sentencepiece.bpe.model` or `vocab.txt`).  

These are outputs of the HuggingFace-based training process using either **Camembert** (for French) or **SwedishBert** (for Swedish).

---

## Detailed Code Explanations

Below are step-by-step explanations of selected key scripts in each folder. All scripts have detailed docstrings or inline comments describing their purpose and methods.

### Scripts/1_preprocessing

1. **`2_Sentences_to_annotate.py`**  
   - **Goal**: Calculate the total number of sentences in press conferences (both Quebec and Sweden). Then compute the recommended number of sentences to annotate, based on a 95% confidence level and 5% margin of error.  
   - **Key Functions**:  
     - `remove_english_sentences(text)`: Removes any English sentences from a text block.  
     - `tokenize_and_context(text, nlp)`: Tokenizes the text into sentences using SpaCy.  
     - `calculate_sample_size(N, Z, E, p=0.5)`: Computes the number of samples needed.

2. **`1_Preprocessed_SWD.py`**  
   - **Goal**: Takes the original Swedish press conference data (`SWD.conf_texts.csv`), tokenizes each text into sentences (with context windows), and saves the result to `SWD.processed_conf_texts.csv`.  

3. **`1_Preprocessed_QC.py`**  
   - **Goal**: Similarly, for Quebec’s French data, removes English sentences, tokenizes into sentences, and generates context windows around each sentence. Saves to `QC.processed_conf_texts.csv`.

### Scripts/2_feedback_scripts

1. **`1_JSONL_Annotation.py`**  
   - **Goal**: Converts CSV data into JSONL format for annotation or model training. Splits data into training, evaluation, and test sets.  
   - **Key Steps**:  
     - Loads existing training data IDs to prevent duplicates.  
     - Randomly splits data with user-defined proportions.  
     - Exports JSONL files with text and metadata.

2. **`3_JSONL_train_AS.py`**  
   - **Goal**: Reads annotation JSONL, maps textual responses (e.g., “oui”, “non”, “dangereux”) to integer labels, then writes them into separate JSONL files per label.  
   - **Key Steps**:  
     - Splits by country code (QC or SWD).  
     - Groups data by label key (frame, measures, source detection, etc.).  
     - Ensures distribution is tracked (number of occurrences per label).

3. **`2_Supplementary_sent_JSONL_FR.py`** and **`2_Supplementary_sent_JSONL_SWD.py.py`**  
   - **Goal**: Select random new sentences (not previously annotated) for further annotation.  
   - **Key Steps**:  
     - Loads annotated data.  
     - Filters out duplicates.  
     - Exports a random sample as a new JSONL file.  

4. **`2_Translate_JSONL_for_annotation.py`**  
   - **Goal**: Uses DeepL to translate Swedish text into French, appending the translation within the same JSONL to assist French-speaking annotators.

### Scripts/3_training_and_annotation

1. **`1_Train_QC.py`**  
   - **Goal**: Trains multiple **Camembert**-based classification models for Quebec data.  
   - **Process**:  
     - Loads training/test JSONL data.  
     - Encodes text using Camembert.  
     - Trains with specific parameters (learning rate, epochs).  
     - Saves the trained model under `models/` (e.g., `frame_QC`, `measures_QC`).

2. **`2_Predict_QC.py`**  
   - **Goal**: Uses the trained Camembert models to predict frames, evidence presence, measures, etc., on the final Quebec data.  
   - **Outputs**:  
     - A final annotated CSV (`QC.final_annotated_texts.csv`).

3. **`1_Train_SWD.py`**  
   - **Goal**: Trains **SwedishBert** models for Sweden data.  
   - **Details**:  
     - Similar flow to Quebec’s training but uses Swedish language data and the SwedishBert model.

4. **`2_Predict_SWD.py`**  
   - **Goal**: Predicts labels for Swedish texts using the trained SwedishBert models.  
   - **Outputs**:  
     - The final annotated CSV (`SWD.final_annotated_texts.csv`).

### Scripts/4_data_analysis

1. **`4.Robustness.R`**  
   - **Goal**: Conducts robustness checks:  
     - Calculates Variance Inflation Factors (VIF) for regression models in Quebec and Sweden (`QC.frame_database_2.csv`, `SWD.frame_database_2.csv`).  
     - Creates correlation matrices and correlation heatmaps (e.g., `QC.corrplot_manual.png`).  
     - Analyzes annotation distributions over time.

2. **`2.Graphs_and_plot.R`**  
   - **Goal**: Generates major plots illustrating policy stringency, simulated effects of frames vs. evidence, and COVID deaths over time.  
   - **Outputs**:  
     - PDFs of interactive results, e.g., `QC.unc.results_moderate_frame_and_evidence_stringency_projections.pdf`.

3. **`1.Database_creation.R`**  
   - **Goal**: Builds and merges all relevant epidemiological and annotated data into final CSVs (`QC.frame_database.csv`, `SWD.frame_database.csv`, etc.).  
   - **Steps**:  
     - Normalize epidemiological variables.  
     - Merge with textual aggregates (`detect_evidence`, `detect_frame`, etc.).  
     - Export final databases for modeling.

4. **`3.Models.R`**  
   - **Goal**: Performs OLS regressions on the merged datasets. Summarizes how frames and evidence predict mitigation or suppression outcomes.  
   - **Outputs**:  
     - Word documents with regression tables (e.g., `combined_results_OLS_mitigation.docx`).

---

## How to Use This Repository

1. **Data Preparation**:  
   - Place your raw CSV files in `Database/original_data/`.  
   - Run scripts in `Scripts/1_preprocessing/` to generate sentence-level data in `Database/preprocessed_data/`.

2. **Annotation & Model Training**:  
   - Create JSONL files using `Scripts/2_feedback_scripts/1_JSONL_Annotation.py`.  
   - Annotate or check the distribution.  
   - Train models using Camembert (for French data) or SwedishBert (for Swedish data). The scripts are in `Scripts/3_training_and_annotation/`.

3. **Prediction**:  
   - Apply the trained models with `2_Predict_QC.py` or `2_Predict_SWD.py` to label your data.  
   - The final labeled data will appear in `Database/annotated_data/` as `QC.final_annotated_texts.csv` or `SWD.final_annotated_texts.csv`.

4. **Analysis**:  
   - Run R scripts in `Scripts/4_data_analysis/` to merge the epidemiological and textual data, compute correlations, run regression models, and generate visualizations.  
   - Check final results in the `Results` folder.

---

## License and Citation

- **License**: Please see the repository license if provided, or assume academic use only.  
- **Citation**: If you use or extend this code or data, please cite the associated article:

  ```
  Lemor, A., & Collaborators (2023).
  Beyond Evidence: How Framing Shapes Public Health Policies During Health Crises.
  (In press / Working Paper).
  ```

For any questions or suggestions, please open an issue or contact the author(s). Thank you for your interest in **EVD.COVID_ANALYSIS**!