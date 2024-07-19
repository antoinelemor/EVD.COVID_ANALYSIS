# EVD.COVID_ANALYSIS

## Overview

This repository contains scripts and data for processing, training, and analyzing text data related to COVID-19 press conferences. The primary goal is to preprocess the data, train models, annotate sentences, and conduct data analysis to understand the policies and measures taken by different countries during the pandemic. The annotation methodology is based on the approach described in [Do et al. (2022)](https://journals.sagepub.com/doi/pdf/10.1177/00491241221134526?casa_token=je4hEAkbGj4AAAAA:DF8Co2J-JzFNMycjRfroCdfrLB0Qivqu3WM_U83eX2oW17eJ-mh2jxTD6ai-fKoz_wICW_OQg0qkYMs), which uses sequential transfer learning to annotate large-scale text data.

The results of these analyses contribute to our understanding of how different frames and sources influence public perception and policy during the COVID-19 pandemic.

## Folder Structure

### 📂 Database

This folder contains various subdirectories for different types of data used in the project:

#### 📂 original_data

**Content**: Raw text data from Quebec and Sweden's COVID-19 press conferences.

#### 📂 epidemiology

**Content**: Epidemiological data for Quebec and Sweden, including COVID-19 cases, hospitalizations, vaccination data, and stringency index.

#### 📂 preprocessed_data

**Content**: Preprocessed text data ready for annotation and analysis.

#### 📂 verification_annotation_data

**Content**: JSONL files containing the evaluation, test, and training data for both Quebec and Sweden.

#### 📂 training_data_per_label_per_country

**Content**: Subdirectories for Quebec (QC) and Sweden (SWD) containing JSONL files for various labels used in model training.

#### 📂 pred

**Content**: Subdirectories for Quebec (perf_QC) and Sweden (perf_SE) containing performance logs (e.g., F1 scores) of the annotation models.

### 📂 Scripts

This folder contains four subdirectories, each dedicated to a specific part of the project workflow:

#### 📂 1_Preprocessing

This subdirectory includes scripts for preprocessing the text data, specifically for Quebec and Sweden.

- **`1_Preprocessed_QC.py`**:
  - **Purpose**: Preprocesses text data from Quebec by removing English sentences, tokenizing the text, and creating sentence contexts.
  - **Key Functions**: Preprocess text data, remove unwanted sentences, and tokenize the text to create structured data ready for analysis.

- **`1_Preprocessed_SWD.py`**:
  - **Purpose**: Similar to the Quebec preprocessing script, but for Swedish text data. It removes English sentences, tokenizes the text, and creates sentence contexts.
  - **Key Functions**: Clean and structure Swedish text data by removing non-relevant sentences and tokenizing for analysis.

- **`2_Sentences_to_annotate.py`**:
  - **Purpose**: Calculates the number of sentences that need to be annotated for both Quebec and Sweden.
  - **Key Functions**: Count and determine sample sizes of sentences for annotation based on statistical calculations.

#### 📂 2_Feedback_Scripts

This subdirectory includes scripts to process and prepare data for annotation feedback.

- **`1_JSONL_Annotation.py`**:
  - **Purpose**: Converts annotation data to JSONL format for processing.
  - **Key Functions**: Transform annotation data into a format suitable for machine learning models.

- **`2_Supplementary_sent_JSONL_FR.py`**:
  - **Purpose**: Processes additional French sentences into JSONL format.
  - **Key Functions**: Prepare supplementary French text data for annotation.

- **`2_Supplementary_sent_JSONL_SWD.py`**:
  - **Purpose**: Processes additional Swedish sentences into JSONL format.
  - **Key Functions**: Prepare supplementary Swedish text data for annotation.

- **`2_Translate_JSONL_for_annotation.py`**:
  - **Purpose**: Translates sentences to be annotated and formats them into JSONL.
  - **Key Functions**: Translate and format text data for annotation tasks.

- **`3_JSONL_train_AS.py`**:
  - **Purpose**: Prepares JSONL files for training annotation models.
  - **Key Functions**: Structure data into JSONL format for training purposes.

#### 📂 3_Training_and_Annotation

This subdirectory contains scripts for training models and annotating text data.

- **`1_Train_QC.py`**:
  - **Purpose**: Trains models using the Quebec text data.
  - **Key Functions**: Train machine learning models on preprocessed Quebec text data.

- **`1_Train_SWD.py`**:
  - **Purpose**: Trains models using the Swedish text data.
  - **Key Functions**: Train machine learning models on preprocessed Swedish text data.

- **`2_Predict_QC.py`**:
  - **Purpose**: Makes predictions using models trained on Quebec data.
  - **Key Functions**: Use trained models to predict annotations on Quebec text data.

- **`2_Predict_SWD.py`**:
  - **Purpose**: Makes predictions using models trained on Swedish data.
  - **Key Functions**: Use trained models to predict annotations on Swedish text data.

#### 📂 4_Data_Analysis

This subdirectory includes scripts for analyzing the processed and annotated data.

- **`1.Database_creation.R`**:
  - **Purpose**: Creates databases from the preprocessed data for analysis.
  - **Key Functions**: Compile and structure preprocessed data into databases for analysis, merging various data sources.

- **`2.Graphs_and_plot.R`**:
  - **Purpose**: Generates graphs and plots for visual data analysis.
  - **Key Functions**: Visualize data through various types of plots and graphs, highlighting key trends and findings.

- **`3.Models.R`**:
  - **Purpose**: Runs statistical models on the data.
  - **Key Functions**: Apply statistical analysis and modeling to understand data patterns and test hypotheses.

- **`4.Robustness.R`**:
  - **Purpose**: Tests the robustness of the statistical models.
  - **Key Functions**: Validate and verify the reliability of models through robustness checks and sensitivity analyses.

### 📂 Models

This folder contains the trained models for each country and category. Note that these models are not included in the repository due to their size.

### 📂 Results

This folder contains all the results produced by the R scripts in the Data Analysis folder.

## Annotation Performance Metrics

### Annotation Metrics

![Annotation Metrics](/Results/annotation_metrics.png)

## How to Use

1. **Preprocessing**:
   - Run the preprocessing scripts to clean and tokenize the text data.
   - Ensure the required libraries (e.g., `spacy`, `pandas`, `langdetect`) are installed.

2. **Feedback Scripts**:
   - Use these scripts to process feedback data.

3. **Training and Annotation**:
   - Train models and annotate sentences using the scripts in this subdirectory.

4. **Data Analysis**:
   - Analyze the processed and annotated data to derive insights and conclusions.

## Installation

Install the required Python libraries using:
```bash
pip install -r requirements.txt
