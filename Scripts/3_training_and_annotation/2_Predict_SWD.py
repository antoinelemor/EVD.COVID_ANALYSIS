"""
PROJECT:
-------
EVD.COVID_Analysis

TITLE:
------
2_Predict_SWD.py

MAIN OBJECTIVE:
---------------
This script processes preprocessed Swedish COVID data, applies the SwedishBert model to encode text,
performs multiple predictions using trained models, integrates the results into the dataset, and
saves the annotated data for further analysis.

Dependencies:
-------------
- pandas
- numpy
- AugmentedSocialScientist.models.SwedishBert

MAIN FEATURES:
---------------
1) Load prediction data from a CSV file.
2) Encode text data using SwedishBert.
3) Predict 'detect_covid' labels and probabilities.
4) Filter data based on 'detect_covid' predictions for further analysis.
5) Perform additional predictions: 'detect_evidence', 'detect_frame', 'detect_country_source',
   'detect_measures', 'detect_source', 'detect_journalist_question', 'detect_associated_emotions'.
6) Integrate all prediction results into the original DataFrame.
7) Save the final annotated DataFrame to a CSV file.

Author:
-------
Antoine Lemor
"""

import pandas as pd
import numpy as np
from AugmentedSocialScientist.models import SwedishBert

bert = SwedishBert()  # Instantiation

# Load prediction data
pred_data_path = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/preprocessed_data/SWD.processed_conf_texts.csv'
pred_data = pd.read_csv(pred_data_path)

# Preprocess prediction data
pred_loader = bert.encode(pred_data['context'].values)

# Predict with the trained model
pred = bert.predict_with_model(
    pred_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_COVID_SWD'
)

# Compute the predicted label as the one with the highest probability
pred_data['detect_covid'] = np.argmax(pred, axis=1)
pred_data['detect_covid_proba'] = np.max(pred, axis=1)

# Select texts where 'detect_covid' is 1 for further prediction
data_to_be_predicted = pred_data[pred_data['detect_covid'] == 1].copy()

# Load and predict with the 'detect_evidence_SWD' model for filtered texts
bert_evidence = SwedishBert()
evidence_loader = bert_evidence.encode(data_to_be_predicted['context'].values)

evidence_pred = bert_evidence.predict_with_model(
    evidence_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_evidence_SWD'
)

data_to_be_predicted['detect_evidence'] = np.argmax(evidence_pred, axis=1)
data_to_be_predicted['detect_evidence_proba'] = np.max(evidence_pred, axis=1)

# Update pred_data with detect_evidence results
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_evidence'] = row['detect_evidence']
    pred_data.at[idx, 'detect_evidence_proba'] = row['detect_evidence_proba']

# Load and predict with the 'frame_SWD' model for texts where 'detect_covid' is 1
bert_frame = SwedishBert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/frame_SWD'
)

# Filter to select only data where 'detect_evidence' is 1
data_with_evidence = data_to_be_predicted[data_to_be_predicted['detect_evidence'] == 1].copy()

# Load and predict with the 'country_source_SWD' model for texts where 'detect_evidence' is 1
bert_country_source = SwedishBert()
country_source_loader = bert_country_source.encode(data_with_evidence['context'].values)

country_source_pred = bert_country_source.predict_with_model(
    country_source_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/country_source_SWD'
)

# Update predictions for 'country_source' and their probabilities
data_with_evidence['detect_country_source'] = np.argmax(country_source_pred, axis=1)
data_with_evidence['detect_country_source_proba'] = np.max(country_source_pred, axis=1)

# Integrate 'detect_country_source' and 'detect_country_source_proba' results into the original DataFrame
for idx, row in data_with_evidence.iterrows():
    pred_data.at[idx, 'detect_country_source'] = row['detect_country_source']
    pred_data.at[idx, 'detect_country_source_proba'] = row['detect_country_source_proba']

data_to_be_predicted['detect_frame'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_frame_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_frame' and 'frame_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_frame'] = row['detect_frame']
    pred_data.at[idx, 'detect_frame_proba'] = row['detect_frame_proba']

# Load and predict with the 'measures_SWD' model for texts where 'detect_covid' is 1
bert_frame = SwedishBert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/measures_SWD'
)

data_to_be_predicted['detect_measures'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_measures_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_measures' and 'measures_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_measures'] = row['detect_measures']
    pred_data.at[idx, 'detect_measures_proba'] = row['detect_measures_proba']

# Load and predict with the 'detect_source_SWD' model for texts where 'detect_covid' is 1
bert_frame = SwedishBert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_source_SWD'
)

data_to_be_predicted['detect_source'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_source_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_source' and 'source_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_source'] = row['detect_source']
    pred_data.at[idx, 'detect_source_proba'] = row['detect_source_proba']

# Load and predict with the 'journalist_question_SWD' model for texts where 'detect_covid' is 1
bert_frame = SwedishBert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/journalist_question_SWD'
)

data_to_be_predicted['detect_journalist_question'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_journalist_question_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_journalist_question' and 'journalist_question_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_journalist_question'] = row['detect_journalist_question']
    pred_data.at[idx, 'detect_journalist_question_proba'] = row['detect_journalist_question_proba']

# Load and predict with the 'associated_emotion_SWD' model for texts where 'detect_covid' is 1
bert_frame = SwedishBert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/associated_emotion_SWD'
)

data_to_be_predicted['detect_associated_emotions'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_associated_emotions_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_associated_emotions' and 'associated_emotions_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_associated_emotions'] = row['detect_associated_emotions']
    pred_data.at[idx, 'detect_associated_emotions_proba'] = row['detect_associated_emotions_proba']

# Save the final DataFrame with annotations
final_output_filepath = "/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/annotated_data/SWD.final_annotated_texts.csv"
pred_data.to_csv(final_output_filepath, index=False)
