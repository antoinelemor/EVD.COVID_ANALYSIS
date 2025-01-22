# PROJECT:
# -------
# EVD.COVID_ANALYSIS
# 
# TITLE:
# ------
# 3.Models.R
# 
# MAIN OBJECTIVE:
# -------------------
# This script performs Ordinary Least Squares (OLS) regression analyses on
# mitigation and suppression measures using data from Quebec and Sweden.
# 
# Dependencies:
# -------------
# - modelsummary
# - flextable
# - tidyverse
# - officer
# - knitr
# - kableExtra
# 
# MAIN FEATURES:
# ----------------------------
# 1) Imports annotated datasets for Quebec and Sweden.
# 2) Fits multiple OLS regression models for mitigation and suppression measures.
# 3) Combines and summarizes the models.
# 4) Generates and exports regression tables to Word documents.
# 
# Author : 
# --------
# Antoine Lemor

### OLS MODELS ###


# Base path
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data/"
export_path <- "/EVD.COVID_ANALYSIS/Results"

# Packages
library(modelsummary)
library(flextable)
library(tidyverse)
library(officer)
library(knitr)
library(kableExtra)

## OLS MODELS ##

# Importing the Quebec database for Mitigation Measures models
input_file_QC <- file.path(import_data_path, "QC.frame_database_2.csv")
reg_data_daily_QC <- read.csv(input_file_QC, header = TRUE, sep=",")

# Importing the Sweden database for Mitigation Measures models
input_file_SE <- file.path(import_data_path, "SWD.frame_database_2.csv")
reg_data_daily_SE <- read.csv(input_file_SE, header = TRUE, sep=",")

# Models for Quebec Mitigation Measures
models_QC_mitigation <- list()
models_QC_mitigation[['QC_OLS1']] = lm(mitigation_measure_rate ~ CC100+CD100+moderate_frame_rate+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_QC)
models_QC_mitigation[['QC_OLS2']] = lm(mitigation_measure_rate ~ CC100+CD100+dangerous_frame_rate+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_QC)
models_QC_mitigation[['QC_OLS3']] = lm(mitigation_measure_rate ~ CC100+CD100+moderate_frame_rate+dangerous_frame_rate+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_QC)
models_QC_mitigation[['QC_OLS4']] = lm(mitigation_measure_rate ~ CC100+CD100+dangerous_frame_rate+moderate_frame_rate+evidence_full+dangerous_frame_rate:evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_QC)
models_QC_mitigation[['QC_OLS5']] = lm(mitigation_measure_rate ~ CC100+CD100+dangerous_frame_rate+moderate_frame_rate+evidence_full+moderate_frame_rate:evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_QC)

# Models for Sweden Mitigation Measures
models_SE_mitigation <- list()
models_SE_mitigation[['SE_OLS1']] = lm(mitigation_measure_rate ~ dangerous_frame_rate+TH100+CC100+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_SE)
models_SE_mitigation[['SE_OLS2']] = lm(mitigation_measure_rate ~ moderate_frame_rate+TH100+CC100+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_SE)
models_SE_mitigation[['SE_OLS3']] = lm(mitigation_measure_rate ~ moderate_frame_rate+TH100+dangerous_frame_rate+CC100+evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_SE)
models_SE_mitigation[['SE_OLS4']] = lm(mitigation_measure_rate ~ moderate_frame_rate+TH100+CC100+dangerous_frame_rate+evidence_full+dangerous_frame_rate:evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_SE)
models_SE_mitigation[['SE_OLS5']] = lm(mitigation_measure_rate ~ moderate_frame_rate+TH100+CC100+dangerous_frame_rate+evidence_full+moderate_frame_rate:evidence_full+lag(mitigation_measure_rate, 1), data = reg_data_daily_SE)

# Combine models for Mitigation Measures
combined_models_mitigation <- c(models_QC_mitigation[1], models_SE_mitigation[1], models_QC_mitigation[2], models_SE_mitigation[2], models_QC_mitigation[3], models_SE_mitigation[3], models_QC_mitigation[4], models_SE_mitigation[4], models_QC_mitigation[5], models_SE_mitigation[5])

# Models for Quebec Suppression Measures
input_file_QC_suppression <- file.path(import_data_path, "QC.frame_database.csv")
reg_data_daily_QC_suppression <- read.csv(input_file_QC_suppression, header = TRUE, sep=",")

models_QC_suppression <- list()
models_QC_suppression[['QC_OLS1']] = lm(lead(stringencyPHM, 1) ~ dangerous_frame_rate+CC100+CD100+evidence_full+lag(stringencyPHM, 1), data = reg_data_daily_QC_suppression)
models_QC_suppression[['QC_OLS2']] = lm(lead(stringencyPHM, 1) ~ moderate_frame_rate+CC100+CD100+evidence_full+lag(stringencyPHM, 1), data = reg_data_daily_QC_suppression)
models_QC_suppression[['QC_OLS3']] = lm(lead(stringencyPHM, 1) ~ moderate_frame_rate+dangerous_frame_rate+CD100+CC100+evidence_full+lag(stringencyPHM, 1), data = reg_data_daily_QC_suppression)
models_QC_suppression[['QC_OLS4']] = lm(lead(stringencyPHM, 1) ~ moderate_frame_rate+CC100+CD100+dangerous_frame_rate+evidence_full+dangerous_frame_rate:evidence_full+lag(stringencyPHM, 1), data = reg_data_daily_QC_suppression)
models_QC_suppression[['QC_OLS5']] = lm(lead(stringencyPHM, 1) ~ moderate_frame_rate+CC100+CD100+dangerous_frame_rate+evidence_full+moderate_frame_rate:evidence_full+lag(stringencyPHM, 1), data = reg_data_daily_QC_suppression)

# Models for Sweden Suppression Measures
input_file_SE_suppression <- file.path(import_data_path, "SWD.frame_database.csv")
reg_data_daily_SE_suppression <- read.csv(input_file_SE_suppression, header = TRUE, sep=",")

models_SE_suppression <- list()
models_SE_suppression[['SE_OLS1']] = lm(lead(SPHM, 1) ~ CD100+CC100+evidence_full+lag(SPHM, 1), data = reg_data_daily_SE_suppression)
models_SE_suppression[['SE_OLS2']] = lm(lead(SPHM, 1) ~ moderate_frame_rate+CD100+CC100+evidence_full+lag(SPHM, 1), data = reg_data_daily_SE_suppression)
models_SE_suppression[['SE_OLS3']] = lm(lead(SPHM, 1) ~ moderate_frame_rate+CC100+dangerous_frame_rate+CD100+evidence_full+lag(SPHM, 1), data = reg_data_daily_SE_suppression)
models_SE_suppression[['SE_OLS4']] = lm(lead(SPHM, 1) ~ moderate_frame_rate+CC100+CD100+dangerous_frame_rate+evidence_full+dangerous_frame_rate:evidence_full+lag(SPHM, 1), data = reg_data_daily_SE_suppression)
models_SE_suppression[['SE_OLS5']] = lm(lead(SPHM, 1) ~ moderate_frame_rate+CC100+CD100+dangerous_frame_rate+evidence_full+moderate_frame_rate:evidence_full+lag(SPHM, 1), data = reg_data_daily_SE_suppression)

# Combine models for Suppression Measures
combined_models_suppression <- c(models_QC_suppression[1], models_SE_suppression[1], models_QC_suppression[2], models_SE_suppression[2], models_QC_suppression[3], models_SE_suppression[3], models_QC_suppression[4], models_SE_suppression[4], models_QC_suppression[5], models_SE_suppression[5])

cm <- c( '(Intercept)' = '(Intercept)', 'lag(mitigation_measure_rate, 1)'='Mitigation measures - 1', 'lag(stringencyPHM, 1)'='Stringency - 1', 'CC100' = 'Cases', 'CD100'='Death', 'TH100'='Hospi', 'moderate_frame_rate' = 'Moderate frame','dangerous_frame_rate'= 'Dangerous frame' , 'suppression_measure_rate'='suppression_measure_rate','evidence_full'='evidence_full', 'dangerous_frame_rate:evidence_full'='evidence_full * Dangerous frame', 'moderate_frame_rate:evidence_full'='evidence_full * Moderate frame')

# Mitigation Policies Table
cap_mitigation <- 'Effects of Frames and Evidence on Mitigation Policies in Quebec and Sweden'
tab_mitigation <- modelsummary(combined_models_mitigation, output='flextable', coef_map=cm, stars = TRUE, title=cap_mitigation)

# Printing results
tab_mitigation %>% autofit()

# Set the export file path for the regression table
table_file_name_mitigation <- "combined_results_OLS_mitigation.docx"
table_full_path_mitigation <- file.path(export_path, table_file_name_mitigation)

# Create a Word document to store the table
doc_mitigation <- read_docx() %>% 
  body_add_flextable(tab_mitigation)

# Save the Word document
print(doc_mitigation, target = table_full_path_mitigation)

# Suppression Policies Table
cap_suppression <- 'Effects of Frames and Evidence on Suppression Policies in Quebec and Sweden'
tab_suppression <- modelsummary(combined_models_suppression, output='flextable', coef_map=cm, stars = TRUE, title=cap_suppression)

# Printing results
tab_suppression %>% autofit()

# Set the export file path for the regression table
table_file_name_suppression <- "combined_results_OLS_suppression.docx"
table_full_path_suppression <- file.path(export_path, table_file_name_suppression)

# Create a Word document to store the table
doc_suppression <- read_docx() %>% 
  body_add_flextable(tab_suppression)

# Save the Word document
print(doc_suppression, target = table_full_path_suppression)