import pandas as pd
import json
import os

def load_annotated_data(paths):
    """
    Load already annotated data to avoid duplicates.
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

def filter_new_sentences(data, annotated_ids):
    """
    Filter out sentences that have already been annotated.
    """
    return data[~data.apply(lambda x: (x['doc_ID'], x['sentence_id']) in annotated_ids, axis=1)]

def export_to_jsonl(data, jsonl_path):
    """
    Export the filtered data to JSONL format.
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
    '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.evaluation_data.jsonl',
    '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.training_data.jsonl',
    '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.test_data.jsonl'
]

# Load the IDs of already annotated sentences
annotated_ids = load_annotated_data(annotated_files)

# Load the raw data for Quebec
csv_file_path = '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/preprocessed_data/QC.processed_conf_texts.csv'  # Adjust the path as needed
raw_data = pd.read_csv(csv_file_path)

# Filter to get only new sentences
new_sentences = filter_new_sentences(raw_data, annotated_ids)

# Randomly select 200 new sentences for annotation
new_sentences_for_annotation = new_sentences.sample(n=200, random_state=37)

# Export the new sentences to a JSONL file
export_to_jsonl(new_sentences_for_annotation, '/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_QC_additional_data.jsonl')  # Adjust the output path
