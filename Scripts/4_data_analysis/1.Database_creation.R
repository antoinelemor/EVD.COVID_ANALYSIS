# PROJECT:
# -------
# EVD.COVID_ANALYSIS
#
# TITLE:
# ------
# 1.Database_creation.R
#
# MAIN OBJECTIVE:
# -------------------
# This script creates and processes epidemiological and textual databases for COVID-19 analysis.
# It includes data loading, normalization, aggregation, and merging tasks for Quebec and Sweden datasets.
#
# Dependencies:
# -------------
# - readr
# - dplyr
# - readxl
# - purrr
# - lubridate
#
# MAIN FEATURES:
# ----------------------------
# 1) Load and import datasets for Quebec and Sweden.
# 2) Normalize data indices for hospitalization, vaccination, cases, and deaths.
# 3) Calculate textual aggregates based on annotated texts.
# 4) Merge epidemiological data with textual aggregates.
# 5) Export the final databases for suppression and mitigation policy models.
#
# Author:
# --------
# Antoine Lemor

library(readr)
library(dplyr)
library(readxl)
library(purrr)
library(lubridate) 

#### DATABASE FOR SUPPRESSION POLICY MODELS ####

## CREATING DATABASE FOR QUEBEC ##

# Base path for imports
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data/"
import_data_epidemiology_path <- "/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/epidemiology"
export_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data"

# Loading datasets
# ----------------
# Import hospitalization, vaccination, and stringency data for Quebec.

hospi_file <- file.path(import_data_epidemiology_path, "QC.COVID_data.xlsx")
hospi <- read_excel(hospi_file, sheet = 1)

vacc_file <- file.path(import_data_epidemiology_path, "QC.vax_data.csv")
vacc <- read_csv2(vacc_file, col_types = cols())
vacc$date <- as.Date(vacc$date, format = "%Y-%m-%d")

SPHM_file <- file.path(import_data_epidemiology_path, "QC.IRPPstringency_data.csv")
SPHM_data <- read_csv(SPHM_file, col_types = cols())
SPHM_data$date <- as.Date(SPHM_data$date, format = "%Y-%m-%d")

# Load the textual database
db_file <- file.path(import_data_path, "QC.final_annotated_texts.csv")
db <- read_csv(db_file, col_types = cols())

# Convert dates to datetime to harmonize formats
hospi$date <- as.Date(hospi$date)
vacc$date <- as.Date(vacc$date, format = "%Y-%m-%d")
db$date <- as.Date(db$date)

# Preparing the epidemiological database for indices
# ---------------------------------------------------
# Normalize the hospitalization, vaccination, cases, and deaths data to a scale of 0 to 100.

epi_data <- hospi %>%
  full_join(vacc, by = "date") %>%
  mutate(
    TH100 = (hospi_total - min(hospi_total, na.rm = TRUE)) / (max(hospi_total, na.rm = TRUE) - min(hospi_total, na.rm = TRUE)) * 100,
    VAX100 = (VAX - min(VAX, na.rm = TRUE)) / (max(VAX, na.rm = TRUE) - min(VAX, na.rm = TRUE)) * 100,
    CC100 = (cases - min(cases, na.rm = TRUE)) / (max(cases, na.rm = TRUE) - min(cases, na.rm = TRUE)) * 100,
    CD100 = (death - min(death, na.rm = TRUE)) / (max(death, na.rm = TRUE) - min(death, na.rm = TRUE)) * 100
  ) %>%
  select(date, TH100, VAX100, CC100, CD100) %>%
  distinct()

# Integrating SPHM_data into epi_data
# -----------------------------------
# Merge stringency policy data into the epidemiological dataset based on the date.

epi_data <- epi_data %>%
  left_join(SPHM_data %>% select(date, stringencyPHM, stringencyIndex), by = "date")

# Calculating aggregates with the new 'evidence_full' variable
# -----------------------------------------------------------
# Compute various rates and the 'evidence_full' metric from the textual database.

text_aggregates <- db %>%
  filter(detect_covid == 1, detect_journalist_question == 0) %>%
  group_by(date) %>%
  summarise(
    evidence_rate = mean(detect_evidence, na.rm = TRUE) * 100,
    country_source_rate = mean(detect_country_source[detect_evidence == 1], na.rm = TRUE) * 100,
    neutral_frame_rate = mean(detect_frame == 0, na.rm = TRUE) * 100,
    moderate_frame_rate = mean(detect_frame == 1, na.rm = TRUE) * 100,
    dangerous_frame_rate = mean(detect_frame == 2, na.rm = TRUE) * 100,
    neutral_measure_rate = mean(detect_measures == 0, na.rm = TRUE) * 100,
    mitigation_measure_rate = mean(detect_measures == 1, na.rm = TRUE) * 100,
    suppression_measure_rate = mean(detect_measures == 2, na.rm = TRUE) * 100,
    source_rate = mean(detect_source, na.rm = TRUE) * 100,
    neutral_emotion_rate = mean(detect_associated_emotions == 0, na.rm = TRUE) * 100,
    negative_emotion_rate = mean(detect_associated_emotions == 1, na.rm = TRUE) * 100,
    positive_emotion_rate = mean(detect_associated_emotions == 2, na.rm = TRUE) * 100,
    evidence_full = mean(detect_evidence == 1 | detect_source == 1, na.rm = TRUE) * 100,
  )

# Adding the wave variable based on the date in epi_data
# -----------------------------------------------------
# Assign a wave number to each entry based on the date to categorize different phases of the pandemic.

epi_data <- epi_data %>%
  mutate(
    wave = case_when(
      date >= as.Date("2020-02-25") & date <= as.Date("2020-07-11") ~ 1,
      date >= as.Date("2020-07-12") & date <= as.Date("2021-03-20") ~ 2,
      date >= as.Date("2021-03-21") & date <= as.Date("2021-07-17") ~ 3,
      date >= as.Date("2021-07-18") & date <= as.Date("2021-12-05") ~ 4,
      date >= as.Date("2021-12-06") & date <= as.Date("2022-03-17") ~ 5,
      date >= as.Date("2022-03-18") & date <= as.Date("2022-05-28") ~ 6,
      TRUE ~ NA_integer_
    )
  )

# Merging epidemiological data with textual aggregates
# -----------------------------------------------------
# Combine the normalized epidemiological data with the computed textual aggregates.

final_db <- epi_data %>%
  left_join(text_aggregates, by = "date")

# Exporting the final database for Quebec
# ---------------------------------------
# Save the processed Quebec database to a CSV file.

write_csv(final_db, file.path(export_path, "QC.frame_database.csv"))

## CREATING DATABASE FOR SWEDEN ##

# Loading datasets for Sweden
# ---------------------------
# Import vaccination, stringency, hospitalization, and case/death data for Sweden.

# Importing and processing vaccination data
vax_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.vax.csv")) %>%
  filter(location == "Sweden") %>%
  select(date, vax = daily_vaccinations)

# Importing and processing stringency data
stringency_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.stringency.csv")) %>%
  filter(Entity == "Sweden") %>%
  select(date = Day, SPHM = containment_index)

# Loading the textual database
db_file_SWD <- file.path(import_data_path, "SWD.final_annotated_texts.csv")
db_SWD <- read_csv(db_file_SWD, col_types = cols())

# Importing and processing hospitalization data
hospital_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.hospitalizations.csv")) %>%
  filter(location == "Sweden") %>%
  select(date, TH = hosp_patients)

# Importing and processing case and death data
cases_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.cases.csv")) %>%
  filter(countriesAndTerritories == "Sweden") %>%
  select(dateRep, CC = cases, CD = deaths) %>%
  mutate(date = dmy(dateRep)) %>%  # Convert dateRep from 'dd/mm/yyyy' format to Date
  select(-dateRep)  # Remove the old dateRep column

# Pre-merging data for normalization
combined_data <- reduce(list(vax_data, stringency_data, hospital_data, cases_data), full_join, by = "date")

# Calculating normalization for each variable
SWD.frame_database <- combined_data %>%
  mutate(VAX100 = (vax - min(vax, na.rm = TRUE)) / (max(vax, na.rm = TRUE) - min(vax, na.rm = TRUE)) * 100,
         TH100 = (TH - min(TH, na.rm = TRUE)) / (max(TH, na.rm = TRUE) - min(TH, na.rm = TRUE)) * 100,
         CC100 = (CC - min(CC, na.rm = TRUE)) / (max(CC, na.rm = TRUE) - min(CC, na.rm = TRUE)) * 100,
         CD100 = (CD - min(CD, na.rm = TRUE)) / (max(CD, na.rm = TRUE) - min(CD, na.rm = TRUE)) * 100)

db_SWD <- db_SWD %>%
  mutate(date = dmy(date))

text_aggregates_SWD <- db_SWD %>%
  filter(detect_covid == 1, detect_journalist_question == 0) %>%
  group_by(date) %>%
  summarise(
    evidence_rate = mean(detect_evidence, na.rm = TRUE) * 100,
    country_source_rate = mean(detect_country_source[detect_evidence == 1], na.rm = TRUE) * 100,
    neutral_frame_rate = mean(detect_frame == 0, na.rm = TRUE) * 100,
    moderate_frame_rate = mean(detect_frame == 1, na.rm = TRUE) * 100,
    dangerous_frame_rate = mean(detect_frame == 2, na.rm = TRUE) * 100,
    neutral_measure_rate = mean(detect_measures == 0, na.rm = TRUE) * 100,
    mitigation_measure_rate = mean(detect_measures == 1, na.rm = TRUE) * 100,
    suppression_measure_rate = mean(detect_measures == 2, na.rm = TRUE) * 100,
    source_rate = mean(detect_source, na.rm = TRUE) * 100,
    neutral_emotion_rate = mean(detect_associated_emotions == 0, na.rm = TRUE) * 100,
    negative_emotion_rate = mean(detect_associated_emotions == 1, na.rm = TRUE) * 100,
    positive_emotion_rate = mean(detect_associated_emotions == 2, na.rm = TRUE) * 100,
    evidence_full = mean(detect_evidence == 1| detect_source == 1, na.rm = TRUE) * 100,
  )

# Merging epidemiological data with textual aggregates
SWD.frame_database_final <- SWD.frame_database %>%
  left_join(text_aggregates_SWD, by = "date")

# Merging epidemiological data with textual aggregates
SWD.frame_database_final <- SWD.frame_database %>%
  left_join(text_aggregates_SWD, by = "date") %>%
  # Filter to remove rows with missing data in textual aggregates
  filter(!is.na(evidence_rate) & !is.na(country_source_rate) & !is.na(neutral_frame_rate) &
           !is.na(moderate_frame_rate) & !is.na(dangerous_frame_rate) & !is.na(neutral_measure_rate) &
           !is.na(mitigation_measure_rate) & !is.na(suppression_measure_rate) & !is.na(source_rate) &
           !is.na(neutral_emotion_rate) & !is.na(negative_emotion_rate) & !is.na(positive_emotion_rate) & 
           !is.na(evidence_full))

# Exporting normalized and merged data for Sweden
# -----------------------------------------------
# Save the processed Sweden database to a CSV file.

write_csv(SWD.frame_database_final, file.path(export_path, "SWD.frame_database_2.csv"))

#### DATABASE FOR MITIGATION POLICY MODELS ####

# Base path for imports
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data/"
import_data_epidemiology_path <- "/EVD.COVID_ANALYSIS/Database/epidemiology"
export_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data"

# Loading datasets
hospi_file <- file.path(import_data_epidemiology_path, "QC.COVID_data.xlsx")
hospi <- read_excel(hospi_file, sheet = 1)

vacc_file <- file.path(import_data_epidemiology_path, "QC.vax_data.csv")
vacc <- read_csv2(vacc_file, col_types = cols())
vacc$date <- as.Date(vacc$date, format = "%Y-%m-%d")

# Load the initial database
db_file <- file.path(import_data_path, "QC.final_annotated_texts.csv")
db <- read_csv(db_file, col_types = cols())

# Convert dates to datetime to harmonize formats
hospi$date <- as.Date(hospi$date)
vacc$date <- as.Date(vacc$date, format = "%Y-%m-%d")
db$date <- as.Date(db$date)

# Merging datasets based on date
merged_db <- db %>%
  left_join(hospi, by = "date") %>%
  left_join(vacc, by = "date")

# Calculating indices on 100 for hospitalization, vaccination, cases, and deaths
merged_db <- merged_db %>%
  mutate(
    TH100 = (hospi_total - min(hospi_total, na.rm = TRUE)) / (max(hospi_total, na.rm = TRUE) - min(hospi_total, na.rm = TRUE)) * 100,
    VAX100 = (VAX - min(VAX, na.rm = TRUE)) / (max(VAX, na.rm = TRUE) - min(VAX, na.rm = TRUE)) * 100,
    CC100 = (cases - min(cases, na.rm = TRUE)) / (max(cases, na.rm = TRUE) - min(cases, na.rm = TRUE)) * 100,
    CD100 = (death - min(death, na.rm = TRUE)) / (max(death, na.rm = TRUE) - min(death, na.rm = TRUE)) * 100,
    wave = case_when(
      date >= as.Date("2020-02-25") & date <= as.Date("2020-07-11") ~ 1,
      date >= as.Date("2020-07-12") & date <= as.Date("2021-03-20") ~ 2,
      date >= as.Date("2021-03-21") & date <= as.Date("2021-07-17") ~ 3,
      date >= as.Date("2021-07-18") & date <= as.Date("2021-12-05") ~ 4,
      date >= as.Date("2021-12-06") & date <= as.Date("2022-03-17") ~ 5,
      date >= as.Date("2022-03-18") & date <= as.Date("2022-05-28") ~ 6,
      TRUE ~ NA_integer_
    )
  )

# Calculating aggregates
db_aggregates <- merged_db %>%
  filter(detect_covid == 1, detect_journalist_question == 0) %>%
  group_by(date) %>%
  summarise(
    evidence_rate = mean(detect_evidence, na.rm = TRUE) * 100,
    country_source_rate = mean(detect_country_source[detect_evidence == 1], na.rm = TRUE) * 100,
    neutral_frame_rate = mean(detect_frame == 0, na.rm = TRUE) * 100,
    moderate_frame_rate = mean(detect_frame == 1, na.rm = TRUE) * 100,
    dangerous_frame_rate = mean(detect_frame == 2, na.rm = TRUE) * 100,
    neutral_measure_rate = mean(detect_measures == 0, na.rm = TRUE) * 100,
    mitigation_measure_rate = mean(detect_measures == 1, na.rm = TRUE) * 100,
    suppression_measure_rate = mean(detect_measures == 2, na.rm = TRUE) * 100,
    source_rate = mean(detect_source, na.rm = TRUE) * 100,
    neutral_emotion_rate = mean(detect_associated_emotions == 0, na.rm = TRUE) * 100,
    negative_emotion_rate = mean(detect_associated_emotions == 1, na.rm = TRUE) * 100,
    positive_emotion_rate = mean(detect_associated_emotions == 2, na.rm = TRUE) * 100,
    evidence_full = mean(detect_evidence == 1 | detect_source == 1, na.rm = TRUE) * 100,
    .groups = 'drop'
  )

# Merging aggregates with indices from merged_db
merged_db_simplified <- merged_db %>%
  select(date, TH100, VAX100, CC100, CD100, wave)

# Merging aggregates with merged_db_simplified
final_db <- merged_db_simplified %>%
  distinct() %>%
  left_join(db_aggregates, by = "date")

# Saving the new final database
write_csv(final_db, file.path(export_path, "QC.frame_database_2.csv"))

## CREATING DATABASE FOR SWEDEN ##

# Importing and processing vaccination data
vax_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.vax.csv")) %>%
  filter(location == "Sweden") %>%
  select(date, vax = daily_vaccinations)

# Importing and processing stringency data
stringency_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.stringency.csv")) %>%
  filter(Entity == "Sweden") %>%
  select(date = Day, SPHM = containment_index)

# Loading the textual database
db_file_SWD <- file.path(import_data_path, "SWD.final_annotated_texts.csv")
db_SWD <- read_csv(db_file_SWD, col_types = cols())

# Importing and processing hospitalization data
hospital_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.hospitalizations.csv")) %>%
  filter(location == "Sweden") %>%
  select(date, TH = hosp_patients)

# Importing and processing case and death data
cases_data <- read_csv(file.path(import_data_epidemiology_path, "SWD.cases.csv")) %>%
  filter(countriesAndTerritories == "Sweden") %>%
  select(dateRep, CC = cases, CD = deaths) %>%
  mutate(date = dmy(dateRep)) %>%  # Convert dateRep from 'dd/mm/yyyy' format to Date
  select(-dateRep)  # Remove the old dateRep column

# Pre-merging data for normalization
combined_data <- reduce(list(vax_data, stringency_data, hospital_data, cases_data), full_join, by = "date")

# Calculating normalization for each variable
SWD.frame_database <- combined_data %>%
  mutate(VAX100 = (vax - min(vax, na.rm = TRUE)) / (max(vax, na.rm = TRUE) - min(vax, na.rm = TRUE)) * 100,
         TH100 = (TH - min(TH, na.rm = TRUE)) / (max(TH, na.rm = TRUE) - min(TH, na.rm = TRUE)) * 100,
         CC100 = (CC - min(CC, na.rm = TRUE)) / (max(CC, na.rm = TRUE) - min(CC, na.rm = TRUE)) * 100,
         CD100 = (CD - min(CD, na.rm = TRUE)) / (max(CD, na.rm = TRUE) - min(CD, na.rm = TRUE)) * 100)

db_SWD <- db_SWD %>%
  mutate(date = dmy(date))

text_aggregates_SWD <- db_SWD %>%
  filter(detect_covid == 1, detect_journalist_question == 0) %>%
  group_by(date) %>%
  summarise(
    evidence_rate = mean(detect_evidence, na.rm = TRUE) * 100,
    country_source_rate = mean(detect_country_source[detect_evidence == 1], na.rm = TRUE) * 100,
    neutral_frame_rate = mean(detect_frame == 0, na.rm = TRUE) * 100,
    moderate_frame_rate = mean(detect_frame == 1, na.rm = TRUE) * 100,
    dangerous_frame_rate = mean(detect_frame == 2, na.rm = TRUE) * 100,
    neutral_measure_rate = mean(detect_measures == 0, na.rm = TRUE) * 100,
    mitigation_measure_rate = mean(detect_measures == 1, na.rm = TRUE) * 100,
    suppression_measure_rate = mean(detect_measures == 2, na.rm = TRUE) * 100,
    source_rate = mean(detect_source, na.rm = TRUE) * 100,
    neutral_emotion_rate = mean(detect_associated_emotions == 0, na.rm = TRUE) * 100,
    negative_emotion_rate = mean(detect_associated_emotions == 1, na.rm = TRUE) * 100,
    positive_emotion_rate = mean(detect_associated_emotions == 2, na.rm = TRUE) * 100,
    evidence_full = mean(detect_evidence == 1| detect_source == 1, na.rm = TRUE) * 100,
  )

# Merging epidemiological data with textual aggregates
SWD.frame_database_final <- SWD.frame_database %>%
  left_join(text_aggregates_SWD, by = "date")

# Merging epidemiological data with textual aggregates
SWD.frame_database_final <- SWD.frame_database %>%
  left_join(text_aggregates_SWD, by = "date") %>%
  # Filter to remove rows with missing data in textual aggregates
  filter(!is.na(evidence_rate) & !is.na(country_source_rate) & !is.na(neutral_frame_rate) &
           !is.na(moderate_frame_rate) & !is.na(dangerous_frame_rate) & !is.na(neutral_measure_rate) &
           !is.na(mitigation_measure_rate) & !is.na(suppression_measure_rate) & !is.na(source_rate) &
           !is.na(neutral_emotion_rate) & !is.na(negative_emotion_rate) & !is.na(positive_emotion_rate) & 
           !is.na(evidence_full))

# Exporting normalized and merged data
write_csv(SWD.frame_database_final, file.path(export_path, "SWD.frame_database_2.csv"))
