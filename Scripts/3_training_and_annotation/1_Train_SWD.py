"""
PROJECT:
-------
EVD.COVID_Analysis

TITLE:
------
1_Train_SWD.py

MAIN OBJECTIVE:
---------------
This script trains multiple SwedishBert models on various datasets for COVID-19 analysis.
It preprocesses data, trains models, logs performance scores, and saves the trained models.

Dependencies:
-------------
- pandas
- json
- sys
- AugmentedSocialScientist.models.SwedishBert

MAIN FEATURES:
--------------
1) Loads JSONL data files into pandas DataFrames.
2) Preprocesses data using SwedishBert.
3) Trains models with specified hyperparameters.
4) Logs performance scores to text files.

Author: 
--------
Antoine Lemor
"""

import pandas as pd
import json
import sys
from AugmentedSocialScientist.models import SwedishBert

class Logger(object):
    def __init__(self, filename):
        self.terminal = sys.stdout
        self.log = open(filename, "w", encoding='utf-8')

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def flush(self):
        pass

    def close(self):
        self.log.close()

def load_jsonl_to_dataframe(filepath):
    """Load a JSONL file into a pandas DataFrame."""
    data = []
    with open(filepath, 'r', encoding='utf-8') as file:
        for line in file:
            data.append(json.loads(line))
    return pd.DataFrame(data)

bert = SwedishBert()  # Instantiation

# Paths to your data files
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/frame_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/frame_SWD_test.jsonl'

# Load the training and test data
train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

# Preprocess the training and test data
train_loader = bert.encode(
    train_data.text.values,  # List of texts
    train_data.labels.values  # List of labels
)
test_loader = bert.encode(
    test_data.text.values,  # List of texts
    test_data.labels.values  # List of labels
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/frame_scores_SWD.txt')

# Train, validate, and save the model
scores = bert.run_training(
    train_loader,  # Training DataLoader
    test_loader,  # Test DataLoader
    lr=5e-5,  # Learning rate
    n_epochs=10,  # Number of epochs
    random_state=42,  # Random state (for reproducibility)
    save_model_as='frame_SWD'  # Name to save the model as
)

# Disable redirection and restore standard output
sys.stdout.close()  # Close the log file properly
sys.stdout = sys.__stdout__  # Restore standard output

print(scores)

# Repeat for other datasets

# Measures SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/measures_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/measures_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/measures_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=10,  
    random_state=42,  
    save_model_as='measures_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect Evidence SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_evidence_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_evidence_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/detect_evidence_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=10,  
    random_state=42,  
    save_model_as='detect_evidence_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect Source SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_source_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_source_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/detect_source_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=9,  
    random_state=42,  
    save_model_as='detect_source_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect COVID SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_COVID_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/detect_COVID_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/detect_COVID_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=6,  
    random_state=42,  
    save_model_as='detect_COVID_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Journalist Questions SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/journalist_question_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/journalist_question_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/journalist_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=6,  
    random_state=42,  
    save_model_as='journalist_question_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Associated Emotion SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/associated_emotion_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/associated_emotion_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/associated_emotion_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=12,  
    random_state=42,  
    save_model_as='associated_emotion_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Country Source SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/country_source_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/country_source_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/country_source_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=12,  
    random_state=42,  
    save_model_as='country_source_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Type of Evidence SWD
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/type_of_evidence_SWD_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/SWD/type_of_evidence_SWD_test.jsonl'

train_data = load_jsonl_to_dataframe(train_filepath)
test_data = load_jsonl_to_dataframe(test_filepath)

train_loader = bert.encode(
    train_data.text.values,  
    train_data.labels.values  
)
test_loader = bert.encode(
    test_data.text.values,  
    test_data.labels.values  
)

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_SWD/type_of_evidence_scores_SWD.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=12,  
    random_state=42,  
    save_model_as='type_of_evidence_SWD'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)
