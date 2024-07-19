##### GRAPHS FOR QUEBEC #####

# Base path
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data"
export_path <- "/EVD.COVID_ANALYSIS/Results"


# Necessary packages
library(lme4)
library(ggplot2)
library(dplyr)

# Load data for Quebec
input_file <- file.path(import_data_path, "QC.frame_database.csv")
reg_data_daily <- read.csv(input_file, header = TRUE, sep=",")

# Define models
models <- list()
models[['OLS1']] <- lm(lead(stringencyPHM, 1) ~ moderate_frame_rate + dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(stringencyPHM, 1), data = reg_data_daily)
models[['OLS2']] <- lm(lead(stringencyPHM, 1) ~ moderate_frame_rate + CC100 + CD100 + dangerous_frame_rate + evidence_full + dangerous_frame_rate:evidence_full + lag(stringencyPHM, 1), data = reg_data_daily)
models[['OLS3']] <- lm(lead(stringencyPHM, 1) ~ moderate_frame_rate + CC100 + CD100 + dangerous_frame_rate + evidence_full + moderate_frame_rate:evidence_full + lag(stringencyPHM, 1), data = reg_data_daily)

# Extract coefficients for OLS3
coefficients_OLS3 <- coef(models[['OLS3']])

# Create dataframe for simulated values
simulation_data_MOD <- data.frame()

# Levels of 'evidence_full' for simulation
levels_EVD <- seq(0, 100, by = 20)

# Simulate policy stringency values for each level of 'evidence_full'
for (EVD_val in levels_EVD) {
  MOD_vals <- seq(0, 100, by = 1)
  SPHM_simulated <- coefficients_OLS3['(Intercept)'] +
    coefficients_OLS3['moderate_frame_rate'] * MOD_vals +
    coefficients_OLS3['evidence_full'] * EVD_val +
    coefficients_OLS3['moderate_frame_rate:evidence_full'] * MOD_vals * EVD_val
  
  temp_data <- data.frame(MOD = MOD_vals, SPHM = SPHM_simulated, EVD = EVD_val)
  simulation_data_MOD <- rbind(simulation_data_MOD, temp_data)
}

# Plot with 'evidence_full' as the x-axis
p <- ggplot(simulation_data_MOD, aes(x = MOD, y = SPHM, color = as.factor(EVD))) +
  geom_line(size = 2) + 
  labs(title = "Effect of Moderate Frame on Policy Stringency as a Function of Evidence Level in Quebec",
       x = "Moderate Frame Level",
       y = "Projected Stringency",
       color = "Evidence Level") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 15)
  )

print(p)

# Save plot
ggsave(filename = "QC.unc.results_moderate_frame_and_evidence_stringency_projections.pdf", plot = p, path = export_path, width = 12, height = 10)

# Load data for Quebec mitigation measures
input_file <- file.path(import_data_path, "QC.frame_database_2.csv")
reg_data_daily <- read.csv(input_file, header = TRUE, sep=",")

# Define models
models <- list()
models[['OLS1']] <- lm(mitigation_measure_rate ~ CC100 + CD100 + moderate_frame_rate + dangerous_frame_rate + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS2']] <- lm(mitigation_measure_rate ~ CC100 + CD100 + moderate_frame_rate + dangerous_frame_rate + evidence_full + moderate_frame_rate:evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS3']] <- lm(mitigation_measure_rate ~ CC100 + CD100 + moderate_frame_rate + dangerous_frame_rate + evidence_full + dangerous_frame_rate:evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)

# Extract coefficients for OLS2
coefficients_OLS2 <- coef(models[['OLS2']])

# Prepare dataframe for simulated values
simulation_data_MOD <- data.frame()

# Levels of 'evidence_full' for simulation
levels_EVD <- seq(0, 100, by = 20)

# Simulate mitigation policy values for each level of 'evidence_full'
for (EVD_val in levels_EVD) {
  MOD_vals <- seq(0, 100, by = 1)
  SPHM_simulated <- coefficients_OLS2['(Intercept)'] +
    coefficients_OLS2['moderate_frame_rate'] * MOD_vals +
    coefficients_OLS2['evidence_full'] * EVD_val +
    coefficients_OLS2['moderate_frame_rate:evidence_full'] * MOD_vals * EVD_val
  
  temp_data <- data.frame(MOD = MOD_vals, SPHM = SPHM_simulated, EVD = EVD_val)
  simulation_data_MOD <- rbind(simulation_data_MOD, temp_data)
}

# Plot
p <- ggplot(simulation_data_MOD, aes(x = MOD, y = SPHM, color = as.factor(EVD))) +
  geom_line(size = 2) +
  labs(title = "Effect of Moderate Frame on Mitigation Policies as a Function of Evidence Level in Quebec",
       x = "Moderate Frame Level",
       y = "Projected Mitigation Policies",
       color = "Evidence Level") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 15),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11)
  ) +
  coord_cartesian(ylim = c(0, 95))

print(p)

# Save plot
ggsave(filename = "QC.unc.results_moderate_frame_and_evidence_mitigation_projections.pdf", plot = p, path = export_path, width = 12, height = 10)

##### GRAPHS FOR SWEDEN #####

# Load data for Sweden mitigation measures
input_file <- file.path(import_data_path, "SWD.frame_database_2.csv")
reg_data_daily <- read.csv(input_file, header = TRUE, sep=",")

# Define models
models <- list()
models[['OLS1']] <- lm(mitigation_measure_rate ~ dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS2']] <- lm(mitigation_measure_rate ~ moderate_frame_rate + CC100 + CD100 + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS3']] <- lm(mitigation_measure_rate ~ moderate_frame_rate + dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS4']] <- lm(mitigation_measure_rate ~ moderate_frame_rate + CC100 + CD100 + dangerous_frame_rate + evidence_full + dangerous_frame_rate:evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)
models[['OLS5']] <- lm(mitigation_measure_rate ~ moderate_frame_rate + CC100 + CD100 + dangerous_frame_rate + evidence_full + moderate_frame_rate:evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily)

# Extract coefficients for OLS5
coefficients_OLS5 <- coef(models[['OLS5']])

# Prepare dataframe for simulated values
simulation_data_MOD <- data.frame()

# Levels of 'evidence_full' for simulation
levels_EVD <- seq(0, 100, by = 20)

# Simulate mitigation policy values for each level of 'evidence_full'
for (EVD_val in levels_EVD) {
  MOD_vals <- seq(0, 100, by = 1)
  SPHM_simulated <- coefficients_OLS2['(Intercept)'] +
    coefficients_OLS5['moderate_frame_rate'] * MOD_vals +
    coefficients_OLS5['evidence_full'] * EVD_val +
    coefficients_OLS5['moderate_frame_rate:evidence_full'] * MOD_vals * EVD_val
  
  temp_data <- data.frame(MOD = MOD_vals, SPHM = SPHM_simulated, EVD = EVD_val)
  simulation_data_MOD <- rbind(simulation_data_MOD, temp_data)
}

# Plot
p <- ggplot(simulation_data_MOD, aes(x = MOD, y = SPHM, color = as.factor(EVD))) +
  geom_line(size = 2) +
  labs(title = "Effect of Moderate Frame on Mitigation Policies as a Function of Evidence Level in Sweden",
       x = "Moderate Frame Level",
       y = "Projected Mitigation Policies",
       color = "Evidence Level") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 15),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11)
  ) +
  coord_cartesian(ylim = c(0, 95))

print(p)


# Save plot
ggsave(filename = "SWD.unc.results_mitigation_measures_and_moderate_frame_projections.pdf", plot = p, path = export_path, width = 12, height = 10)

# Load data for Sweden policy stringency
input_file <- file.path(import_data_path, "SWD.frame_database.csv")
reg_data_daily <- read.csv(input_file, header = TRUE, sep=",")

# Define models
models <- list()
models[['OLS1']] <- lm(lead(SPHM, 1) ~ dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS2']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CC100 + CD100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS3']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + dangerous_frame_rate + CC100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS4']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + CC100 + dangerous_frame_rate + evidence_full + dangerous_frame_rate:evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS5']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + CC100 + dangerous_frame_rate + evidence_full + moderate_frame_rate:evidence_full + lag(SPHM, 1), data = reg_data_daily)

# Extract coefficients for OLS4
coefficients_OLS4 <- coef(models[['OLS4']])

# Prepare dataframe for simulated values
simulation_data_MOD <- data.frame()

# Levels of 'evidence_full' for simulation
levels_EVD <- seq(0, 100, by = 20)

# Simulate policy stringency values for each level of 'evidence_full'
for (EVD_val in levels_EVD) {
  MOD_vals <- seq(0, 100, by = 1)
  SPHM_simulated <- coefficients_OLS4['(Intercept)'] +
    coefficients_OLS4['dangerous_frame_rate'] * MOD_vals +
    coefficients_OLS4['evidence_full'] * EVD_val +
    coefficients_OLS4['dangerous_frame_rate:evidence_full'] * MOD_vals * EVD_val
  
  temp_data <- data.frame(MOD = MOD_vals, SPHM = SPHM_simulated, EVD = EVD_val)
  simulation_data_MOD <- rbind(simulation_data_MOD, temp_data)
}

# Plot
p <- ggplot(simulation_data_MOD, aes(x = MOD, y = SPHM, color = as.factor(EVD))) +
  geom_line(size = 2) +
  labs(title = "Effect of Dangerous Frame on Policy Stringency as a Function of Evidence Level in Sweden",
       x = "Dangerous Frame Level",
       y = "Projected Stringency",
       color = "Evidence Level") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 15),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11)
  ) +
  coord_cartesian(ylim = c(-1, 6))

print(p)

# Save plot
ggsave(filename = "SWD.unc.results_suppression_measures_and_dangerous_frame_projections.pdf", plot = p, path = export_path, width = 12, height = 10)

# Load data for Sweden policy stringency with moderate frame
input_file <- file.path(import_data_path, "SWD.frame_database.csv")
reg_data_daily <- read.csv(input_file, header = TRUE, sep=",")

# Define models
models <- list()
models[['OLS1']] <- lm(lead(SPHM, 1) ~ dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS2']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CC100 + CD100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS3']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + dangerous_frame_rate + CC100 + evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS4']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + CC100 + dangerous_frame_rate + evidence_full + dangerous_frame_rate:evidence_full + lag(SPHM, 1), data = reg_data_daily)
models[['OLS5']] <- lm(lead(SPHM, 1) ~ moderate_frame_rate + CD100 + CC100 + dangerous_frame_rate + evidence_full + moderate_frame_rate:evidence_full + lag(SPHM, 1), data = reg_data_daily)

# Extract coefficients for OLS5
coefficients_OLS5 <- coef(models[['OLS5']])

# Prepare dataframe for simulated values
simulation_data_MOD <- data.frame()

# Levels of 'evidence_full' for simulation
levels_EVD <- seq(0, 100, by = 20)

# Simulate policy stringency values for each level of 'evidence_full'
for (EVD_val in levels_EVD) {
  MOD_vals <- seq(0, 100, by = 1)
  SPHM_simulated <- coefficients_OLS4['(Intercept)'] +
    coefficients_OLS5['moderate_frame_rate'] * MOD_vals +
    coefficients_OLS5['evidence_full'] * EVD_val +
    coefficients_OLS5['moderate_frame_rate:evidence_full'] * MOD_vals * EVD_val
  
  temp_data <- data.frame(MOD = MOD_vals, SPHM = SPHM_simulated, EVD = EVD_val)
  simulation_data_MOD <- rbind(simulation_data_MOD, temp_data)
}

# Plot
p <- ggplot(simulation_data_MOD, aes(x = MOD, y = SPHM, color = as.factor(EVD))) +
  geom_line(size = 2) +
  labs(title = "Effect of Moderate Frame on Policy Stringency as a Function of Evidence Level in Sweden",
       x = "Moderate Frame Level",
       y = "Projected Stringency",
       color = "Evidence Level") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 15),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11)
  ) +
  coord_cartesian(ylim = c(-1, 10))

print(p)

# Save plot
ggsave(filename = "SWD.unc.results_suppression_measures_and_moderate_frame_projections.pdf", plot = p, path = export_path, width = 12, height = 10)
