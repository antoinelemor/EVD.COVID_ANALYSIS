"""
PROJECT:
-------
EVD.COVID_Analysis

TITLE:
------
1_Train_QC.py

MAIN OBJECTIVE:
---------------
This script trains and evaluates BERT-type models
using the Camembert model. It processes training and testing data, encodes text
and labels, and runs training for each QC category.

Dependencies:
-------------
- pandas
- json
- sys
- AugmentedSocialScientist.models.Camembert

MAIN FEATURES:
---------------
1) Loads JSONL data into pandas DataFrames.
2) Encodes text and labels using the Camembert model.
3) Logs training outputs to specified files.
4) Trains models for multiple QC categories with specified parameters.

Author:
--------
Antoine Lemor
"""

import pandas as pd
import json
import sys
from AugmentedSocialScientist.models import Camembert

class Logger(object):
    """
    Logger class to redirect stdout to a file.
    """
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
    """
    Load a JSONL file into a pandas DataFrame.
    
    Parameters:
    ----------
    filepath : str
        The path to the JSONL file.
    
    Returns:
    -------
    pandas.DataFrame
        The DataFrame containing the loaded data.
    """
    data = []
    with open(filepath, 'r', encoding='utf-8') as file:
        for line in file:
            data.append(json.loads(line))
    return pd.DataFrame(data)

bert = Camembert()  # Instantiation

# Paths to your data files
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/frame_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/frame_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/frame_QC_scores.txt')

# Train, validate, and save the model
scores = bert.run_training(
    train_loader,  # Training DataLoader
    test_loader,  # Test DataLoader
    lr=5e-5,  # Learning rate
    n_epochs=17,  # Number of epochs
    random_state=42,  # Random state (for reproducibility)
    save_model_as='frame_QC'  # Name to save the model as
)

# Disable redirection and restore standard output
sys.stdout.close()  # Close the log file properly
sys.stdout = sys.__stdout__  # Restore standard output

print(scores)

# Repeat for other datasets

# Measures QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/measures_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/measures_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/measures_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=6,  
    random_state=42,  
    save_model_as='measures_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect Evidence QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_evidence_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_evidence_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/detect_evidence_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=12,  
    random_state=42,  
    save_model_as='detect_evidence_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect Source QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_source_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_source_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/detect_source_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=7,  
    random_state=42,  
    save_model_as='detect_source_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Detect COVID QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_COVID_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/detect_COVID_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/detect_COVID_QC_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=10,  
    random_state=42,  
    save_model_as='detect_COVID_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Journalist Questions QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/journalist_question_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/journalist_question_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/journalist_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=4,  
    random_state=42,  
    save_model_as='journalist_question_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Associated Emotion QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/associated_emotion_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/associated_emotion_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/associated_emotion_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=6,  
    random_state=42,  
    save_model_as='associated_emotion_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Country Source QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/country_source_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/country_source_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/country_source_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=11,  
    random_state=42,  
    save_model_as='country_source_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)  

# Type of Evidence QC
train_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/type_of_evidence_QC_train.jsonl'
test_filepath = '/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/training_data_per_label_per_country/QC/type_of_evidence_QC_test.jsonl'

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

sys.stdout = Logger('/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/pred/perf_QC/type_of_evidence_scores.txt')

scores = bert.run_training(
    train_loader,  
    test_loader,  
    lr=5e-5,  
    n_epochs=5,  
    random_state=42,  
    save_model_as='type_of_evidence_QC'  
)

sys.stdout.close()  
sys.stdout = sys.__stdout__  

print(scores)
