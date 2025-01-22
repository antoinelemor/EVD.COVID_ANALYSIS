"""
PROJECT:
-------
EVD.COVID_Analysis

TITLE:
------
2_Supplementary_sent_JSONL_FR.py

MAIN OBJECTIVE:
---------------
This script processes raw data to filter out already annotated sentences
and exports new sentences to a JSONL file for further annotation.

Dependencies:
-------------
- pandas
- json
- os

MAIN FEATURES:
---------------
1) Loads already annotated data to avoid duplicates.
2) Filters out sentences that have already been annotated.
3) Exports the filtered data to JSONL format.

Author:
--------
Antoine Lemor
"""

import pandas as pd
import json
import os

##############################################################################
#                      Load Annotated Data
#    - Strategy: Load previously annotated data to collect annotated IDs
##############################################################################
def load_annotated_data(paths):
    """
    Load already annotated data to avoid duplicates.

    Parameters:
    ----------
    paths : list of str
        List of file paths to JSONL annotated data files.

    Returns:
    -------
    set of tuples
        A set containing tuples of (doc_ID, sentence_id) for annotated sentences.
    """
    annotated_ids = set()
    for path in paths:
        with open(path, 'r', encoding='utf-8') as file:
            for line in file:
                data = json.loads(line)
                doc_id = data['meta']['doc_ID']
                sentence_id = data['meta']['sentence_id']
                annotated_ids.add((doc_id, sentence_id))
    return annotated_ids

##############################################################################
#                      Filter New Sentences
#    - Strategy: Filter out sentences that have already been annotated
##############################################################################
def filter_new_sentences(data, annotated_ids):
    """
    Filter out sentences that have already been annotated.

    Parameters:
    ----------
    data : pandas.DataFrame
        The raw data containing sentences.
    annotated_ids : set of tuples
        Set of (doc_ID, sentence_id) tuples that have been annotated.

    Returns:
    -------
    pandas.DataFrame
        DataFrame containing only new sentences that have not been annotated.
    """
    return data[~data.apply(lambda x: (x['doc_ID'], x['sentence_id']) in annotated_ids, axis=1)]

##############################################################################
#                      Export to JSONL
#    - Strategy: Export the filtered data to JSONL format
##############################################################################
def export_to_jsonl(data, jsonl_path):
    """
    Export the filtered data to JSONL format.

    Parameters:
    ----------
    data : pandas.DataFrame
        Data to be exported.
    jsonl_path : str
        File path where the JSONL data will be saved.
    """
    with open(jsonl_path, 'w', encoding='utf-8') as file:
        for _, row in data.iterrows():
            json_obj = {
                "meta": {
                    "doc_ID": row["doc_ID"],
                    "sentence_id": row["sentence_id"],
                    "date": row["date"]
                },
                "text": row["context"],
                "labels": [f"{col}: {row[col]}" for col in data.columns if col.endswith('_response') and pd.notna(row[col])]
            }
            file.write(json.dumps(json_obj, ensure_ascii=False) + '\n')

# Path to the annotated files
annotated_files = [
    'EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.evaluation_data.jsonl',
    'EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.training_data.jsonl',
    'EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.test_data.jsonl'
]

# Load the IDs of already annotated sentences
annotated_ids = load_annotated_data(annotated_files)

# Load the raw data for Quebec
csv_file_path = 'EVD.COVID_ANALYSIS/Database/preprocessed_data/QC.processed_conf_texts.csv'  # Adjust the path as needed
raw_data = pd.read_csv(csv_file_path)

# Filter to get only new sentences
new_sentences = filter_new_sentences(raw_data, annotated_ids)

# Randomly select 200 new sentences for annotation
new_sentences_for_annotation = new_sentences.sample(n=200, random_state=37)

# Export the new sentences to a JSONL file
export_to_jsonl(new_sentences_for_annotation, 'EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_QC_additional_data.jsonl')  # Adjust the output path
