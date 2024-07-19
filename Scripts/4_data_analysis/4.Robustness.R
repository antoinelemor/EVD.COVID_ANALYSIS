#### CALCULATION OF VIFS FOR BOTH COUNTRIES ####

# Load the necessary libraries
library(readr)  # For read_csv function
library(dplyr)  
library(car)

# Import data for Quebec
import_data_path <- "//EVD.COVID_ANALYSIS/Database/annotated_data"
export_path <- "/EVD.COVID_ANALYSIS/Results"
input_file_QC1 <- file.path(import_data_path, "QC.frame_database_2.csv")
input_file_QC2 <- file.path(import_data_path, "QC.frame_database.csv")
reg_data_daily_QC1 <- read_csv(input_file_QC1)
reg_data_daily_QC2 <- read_csv(input_file_QC2)

# Linear regression model for Quebec
model_QC1 <- lm(mitigation_measure_rate ~ CC100 + CD100 + dangerous_frame_rate + moderate_frame_rate + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily_QC1)
model_QC2 <- lm(lead(stringencyPHM, 1) ~ moderate_frame_rate + dangerous_frame_rate + CC100 + CD100 + evidence_full + lag(stringencyPHM, 1), data = reg_data_daily_QC2)

# Calculate VIF for each model and store in a dataframe for Quebec
vif_df_QC1 <- data.frame(variable = names(vif(model_QC1)), QC_Model1 = vif(model_QC1))
vif_df_QC2 <- data.frame(variable = names(vif(model_QC2)), QC_Model2 = vif(model_QC2))

# Merge VIF dataframes for Quebec
vif_df_QC <- full_join(vif_df_QC1, vif_df_QC2, by = "variable")

# Import data for Sweden
input_file_SE1 <- file.path(import_data_path, "SWD.frame_database_2.csv")
input_file_SE2 <- file.path(import_data_path, "SWD.frame_database.csv")
reg_data_daily_SE1 <- read_csv(input_file_SE1)
reg_data_daily_SE2 <- read_csv(input_file_SE2)

# Linear regression model for Sweden
model_SE1 <- lm(mitigation_measure_rate ~ CD100 + CC100 + dangerous_frame_rate + moderate_frame_rate + evidence_full + lag(mitigation_measure_rate, 1), data = reg_data_daily_SE1)
model_SE2 <- lm(lead(SPHM, 1) ~ CD100 + moderate_frame_rate + dangerous_frame_rate + CC100 + evidence_full + lag(SPHM, 1), data = reg_data_daily_SE2)

# Calculate VIF for each model and store in a dataframe for Sweden
vif_df_SE1 <- data.frame(variable = names(vif(model_SE1)), SE_Model1 = vif(model_SE1))
vif_df_SE2 <- data.frame(variable = names(vif(model_SE2)), SE_Model2 = vif(model_SE2))

# Merge VIF dataframes for Sweden
vif_df_SE <- full_join(vif_df_SE1, vif_df_SE2, by = "variable")

# Merge VIF dataframes for Quebec and Sweden
combined_vif_df <- full_join(vif_df_QC, vif_df_SE, by = "variable")

# If a variable is missing in one of the models, it will appear with NA for the missing VIF
# Fill NA with zeros or another appropriate value if necessary
combined_vif_df <- combined_vif_df %>% replace_na(list(QC_Model1 = 0, QC_Model2 = 0, SE_Model1 = 0, SE_Model2 = 0))

# Export combined VIF results to CSV
write_csv(combined_vif_df, file.path(export_path, "combined_vif_comparison.csv"))

# Display the path of the saved file for verification
print(paste("VIF comparison saved to:", file.path(export_path, "combined_vif_comparison.csv")))




#### CORRELATION TABLES FOR BOTH COUNTRIES ####

## CORRELATION TABLE QUEBEC ##

# Load the necessary libraries
library(readr)  # For the read_csv function
library(dplyr)  # For data manipulation
library(ggplot2)  # For creating plots
library(reshape2)  # For data transformation

# Import the data
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data"
export_path <- "/EVD.COVID_ANALYSIS/Results"
input_file <- file.path(import_data_path, "QC.frame_database_2.csv")
reg_data_daily <- read_csv(input_file)

# Verify that the variable names in 'reg_data_daily' are correct
print(colnames(reg_data_daily))

# Create the correlation matrix
variables <- c("CC100", "CD100", "TH100", "dangerous_frame_rate", "moderate_frame_rate", "evidence_full", "mitigation_measure_rate")
cor_data <- reg_data_daily %>% 
  select(all_of(variables)) %>% 
  cor(use = "complete.obs")  # Calculate correlation excluding NAs

# Rename the variables in the correlation matrix
colnames(cor_data) <- c("Cases", "Deaths", "Hospitalizations", "Dangerous frame", "Moderate frame", "Evidence", "Mitigation policies")
rownames(cor_data) <- colnames(cor_data)

# Save the renamed correlation matrix
write.csv(cor_data, file.path(export_path, "QC.cor_data_renamed.csv"), row.names = TRUE)

# Melt the correlation data for use in ggplot
melted_cor_data <- melt(cor_data)

# Create the correlation plot manually with ggplot2
p <- ggplot(melted_cor_data, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "white") + # Add a white border to better distinguish the cells
  geom_text(aes(label = round(value, 2)), color = "black", size = 5) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, name = "Correlation") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust=1, size = 12), # Increase size for X-axis
    axis.text.y = element_text(angle = 45, vjust = 1, hjust=1, size = 12), # Increase size for Y-axis
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "right", # Show the legend
    legend.text = element_text(size = 12) # Increase legend size if necessary
  ) +
  labs(fill = "Correlation") + # Add label to the legend
  coord_fixed()

print(p)

# Save the plot
ggsave(file.path(export_path, "QC.corrplot_manual.png"), p, width = 12, height = 10, dpi = 300)


## CORRELATION TABLE SWEDEN ##

# Load the necessary libraries
library(readr)  # For the read_csv function
library(dplyr)  # For data manipulation
library(ggplot2)  # For creating plots
library(reshape2)  # For data transformation

# Import the data
import_data_path <- "/EVD.COVID_ANALYSIS/Database/annotated_data"
export_path <- "/EVD.COVID_ANALYSIS_1/Results"
input_file <- file.path(import_data_path, "SWD.frame_database_2.csv")
reg_data_daily <- read_csv(input_file)

# Verify that the variable names in 'reg_data_daily' are correct
print(colnames(reg_data_daily))

# Create the correlation matrix
variables <- c("CC100", "CD100", "TH100", "dangerous_frame_rate", "moderate_frame_rate", "evidence_full", "mitigation_measure_rate")
cor_data <- reg_data_daily %>% 
  select(all_of(variables)) %>% 
  cor(use = "complete.obs")  # Calculate correlation excluding NAs

# Rename the variables in the correlation matrix
colnames(cor_data) <- c("Cases", "Deaths", "Hospitalizations", "Dangerous frame", "Moderate frame", "Evidence", "Mitigation policies")
rownames(cor_data) <- colnames(cor_data)

# Save the renamed correlation matrix
write.csv(cor_data, file.path(export_path, "SWD.cor_data_renamed.csv"), row.names = TRUE)

# Melt the correlation data for use in ggplot
melted_cor_data <- melt(cor_data)

# Create the correlation plot manually with ggplot2
p <- ggplot(melted_cor_data, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "white") + # Add a white border to better distinguish the cells
  geom_text(aes(label = round(value, 2)), color = "black", size = 5) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, name = "Correlation") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust=1, size = 12), # Increase size for X-axis
    axis.text.y = element_text(angle = 45, vjust = 1, hjust=1, size = 12), # Increase size for Y-axis
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "right", # Show the legend
    legend.text = element_text(size = 12) # Increase legend size if necessary
  ) +
  labs(fill = "Correlation") + # Add label to the legend
  coord_fixed()

print(p)

# Save the plot
ggsave(file.path(export_path, "SWD.corrplot_manual.png"), p, width = 12, height = 10, dpi = 300)


#### ANNOTATION DISTRIBUTION ####

# Export path
export_path <- "/EVD.COVID_ANALYSIS/Results"

# Import the data
qc_data <- read_csv("/EVD.COVID_ANALYSIS/Database/annotated_data/QC.final_annotated_texts.csv")
swd_data <- read_csv("/EVD.COVID_ANALYSIS/Database/annotated_data/SWD.final_annotated_texts.csv")

# Check the first rows of the data to confirm the format
head(qc_data)
head(swd_data)

# Convert doc_ID columns to character
qc_data$doc_ID <- as.character(qc_data$doc_ID)
swd_data$doc_ID <- as.character(swd_data$doc_ID)

# Convert dates to Date format
qc_data$date <- as.Date(qc_data$date, format = "%Y-%m-%d")
swd_data$date <- dmy(swd_data$date)  # Use dmy for dates in DD/MM/YYYY format

# Add a column to identify the datasets
qc_data$region <- "Quebec"
swd_data$region <- "Sweden"

# Combine the data
combined_data <- bind_rows(qc_data, swd_data)

# Check the first rows of the combined data
head(combined_data)

# Filter the data for detect_covid == 1 and detect_journalist_question == 0
filtered_data <- combined_data %>%
  filter(detect_covid == 1, detect_journalist_question == 0)

# Check the first rows of the filtered data
head(filtered_data)

# Calculate aggregates for each dataset by date
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

# Check the first rows of the aggregated data
head(aggregated_data)

# Create the plot
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

# Save the plot
ggsave(filename = file.path(export_path, "Distribution_through_time.png"), plot = p, width = 10, height = 8)

