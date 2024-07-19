import pandas as pd
import numpy as np
from AugmentedSocialScientist.models import Camembert

bert = Camembert()  # Instantiation

# Load prediction data
pred_data_path = '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/preprocessed_data/QC.processed_conf_texts.csv'
pred_data = pd.read_csv(pred_data_path)

# Preprocess prediction data
pred_loader = bert.encode(pred_data['context'].values)

# Predict with the trained model
pred = bert.predict_with_model(
    pred_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_COVID_QC'
)

# Compute the predicted label as the one with the highest probability
pred_data['detect_covid'] = np.argmax(pred, axis=1)
pred_data['detect_covid_proba'] = np.max(pred, axis=1)

# Select texts where 'detect_covid' is 1 for further prediction
data_to_be_predicted = pred_data[pred_data['detect_covid'] == 1].copy()

# Load and predict with the 'detect_evidence_QC' model for filtered texts
bert_evidence = Camembert()
evidence_loader = bert_evidence.encode(data_to_be_predicted['context'].values)

evidence_pred = bert_evidence.predict_with_model(
    evidence_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_evidence_QC'
)

data_to_be_predicted['detect_evidence'] = np.argmax(evidence_pred, axis=1)
data_to_be_predicted['detect_evidence_proba'] = np.max(evidence_pred, axis=1)

# Update pred_data with detect_evidence results
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_evidence'] = row['detect_evidence']
    pred_data.at[idx, 'detect_evidence_proba'] = row['detect_evidence_proba']

# Load and predict with the 'frame_QC' model for texts where 'detect_covid' is 1
bert_frame = Camembert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/frame_QC'
)

# Filter to select only data where 'detect_evidence' is 1
data_with_evidence = data_to_be_predicted[data_to_be_predicted['detect_evidence'] == 1].copy()

# Load and predict with the 'country_source_QC' model for texts where 'detect_evidence' is 1
bert_country_source = Camembert()
country_source_loader = bert_country_source.encode(data_with_evidence['context'].values)

country_source_pred = bert_country_source.predict_with_model(
    country_source_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/country_source_QC'
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

# Load and predict with the 'measures_QC' model for texts where 'detect_covid' is 1
bert_frame = Camembert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/measures_QC'
)

data_to_be_predicted['detect_measures'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_measures_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_measures' and 'measures_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_measures'] = row['detect_measures']
    pred_data.at[idx, 'detect_measures_proba'] = row['detect_measures_proba']

# Load and predict with the 'detect_source_QC' model for texts where 'detect_covid' is 1
bert_frame = Camembert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/detect_source_QC'
)

data_to_be_predicted['detect_source'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_source_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_source' and 'source_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_source'] = row['detect_source']
    pred_data.at[idx, 'detect_source_proba'] = row['detect_source_proba']

# Load and predict with the 'journalist_question_QC' model for texts where 'detect_covid' is 1
bert_frame = Camembert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/journalist_question_QC'
)

data_to_be_predicted['detect_journalist_question'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_journalist_question_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_journalist_question' and 'journalist_question_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_journalist_question'] = row['detect_journalist_question']
    pred_data.at[idx, 'detect_journalist_question_proba'] = row['detect_journalist_question_proba']

# Load and predict with the 'associated_emotion_QC' model for texts where 'detect_covid' is 1
bert_frame = Camembert()
frame_loader = bert_frame.encode(data_to_be_predicted['context'].values)

frame_pred = bert_frame.predict_with_model(
    frame_loader,
    model_path='/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/models/associated_emotion_QC'
)

data_to_be_predicted['detect_associated_emotions'] = np.argmax(frame_pred, axis=1)
data_to_be_predicted['detect_associated_emotions_proba'] = np.max(frame_pred, axis=1)

# Integrate 'detect_associated_emotions' and 'associated_emotions_proba' results into the original DataFrame
for idx, row in data_to_be_predicted.iterrows():
    pred_data.at[idx, 'detect_associated_emotions'] = row['detect_associated_emotions']
    pred_data.at[idx, 'detect_associated_emotions_proba'] = row['detect_associated_emotions_proba']

# Save the final DataFrame with annotations
final_output_filepath = "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/annotated_data/QC.final_annotated_texts.csv"
pred_data.to_csv(final_output_filepath, index=False)
