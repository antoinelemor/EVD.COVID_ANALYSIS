import pandas as pd
import json
import os
from sklearn.utils import shuffle

def load_existing_training_ids(training_jsonl_path):
    """
    Load existing training data IDs to avoid duplicates.
    """
    existing_ids = set()
    if os.path.exists(training_jsonl_path):
        with open(training_jsonl_path, 'r', encoding='utf-8') as file:
            for line in file:
                data = json.loads(line)
                existing_ids.add((data['meta']['doc_ID'], data['meta']['sentence_id']))
    return existing_ids

def filter_out_existing_data(data, existing_ids):
    """
    Filter out data that already exists in the training set.
    """
    return data[~data.apply(lambda row: (row['doc_ID'], row['sentence_id']) in existing_ids, axis=1)]

def split_data_for_train_validation_test(data, training_size, evaluation_fraction=0.2, test_fraction=0.1):
    """
    Split data into training, validation, and test sets.
    """
    total_size = len(data)
    evaluation_size = int(total_size * evaluation_fraction)
    test_size = int(total_size * test_fraction)

    shuffled_data = shuffle(data, random_state=None).reset_index(drop=True)
    training_data = shuffled_data.iloc[:training_size]
    evaluation_data = shuffled_data.iloc[training_size:training_size + evaluation_size]
    test_data = shuffled_data.iloc[training_size + evaluation_size:training_size + evaluation_size + test_size]
    return training_data, evaluation_data, test_data

def process_and_export_jsonl(data, jsonl_path):
    """
    Prepare data and export it in JSONL format.
    """
    jsonl_data = []
    for _, row in data.iterrows():
        labels = [f"{col}: {row[col]}" for col in data.columns if col.endswith('_response') and pd.notna(row[col])]
        json_obj = {"meta": {"doc_ID": row["doc_ID"], "sentence_id": row["sentence_id"], "date": row["date"]}, "text": row["context"], "labels": labels}
        jsonl_data.append(json_obj)
    
    with open(jsonl_path, 'w', encoding='utf-8') as file:
        for obj in jsonl_data:
            file.write(json.dumps(obj, ensure_ascii=False) + '\n')

def generate_training_validation_test_jsonl(csv_file_path, training_jsonl_path, evaluation_jsonl_path, test_jsonl_path, training_size):
    """
    Generate JSONL files for training, validation, and test sets.
    """
    data = pd.read_csv(csv_file_path)
    existing_ids = load_existing_training_ids(training_jsonl_path)
    filtered_data = filter_out_existing_data(data, existing_ids)
    
    training_data, evaluation_data, test_data = split_data_for_train_validation_test(filtered_data, training_size)
    process_and_export_jsonl(training_data, training_jsonl_path)
    process_and_export_jsonl(evaluation_data, evaluation_jsonl_path)
    process_and_export_jsonl(test_data, test_jsonl_path)

script_dir = os.path.dirname(__file__)
annotated_data_dir = os.path.join(script_dir, '..', '..', 'Database', 'preprocessed_data')
verification_annotation_dir = os.path.join(script_dir, '..', '..', 'Database', 'verification_annotation_data')

csv_files = {
    'QC': os.path.join(annotated_data_dir, 'QC.processed_conf_texts.csv'),
    'SWD': os.path.join(annotated_data_dir, 'SWD.processed_conf_texts.csv')
}

training_sizes = {
    'QC': 382,
    'SWD': 381
}

for country, csv_file in csv_files.items():
    training_jsonl_path = os.path.join(verification_annotation_dir, f"{country}.training_data.jsonl")
    evaluation_jsonl_path = os.path.join(verification_annotation_dir, f"{country}.evaluation_data.jsonl")
    test_jsonl_path = os.path.join(verification_annotation_dir, f"{country}.test_data.jsonl")
    generate_training_validation_test_jsonl(csv_file, training_jsonl_path, evaluation_jsonl_path, test_jsonl_path, training_sizes[country])
