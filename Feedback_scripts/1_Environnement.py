import pandas as pd
import json
import os

def process_csv_to_jsonl(csv_file_path, jsonl_file_path):
    # Charger le fichier CSV
    data = pd.read_csv(csv_file_path)

    # Préparer les données pour l'exportation en JSONL
    jsonl_data = []
    for _, row in data.iterrows():
        # Créer des labels uniques pour chaque réponse
        labels = []
        for col in ["detect_evidence_response", "detect_source_response", 
                    "type_of_evidence_response", "evidence_frame_response", 
                    "associated_emotion_response", "journalist_question_response", 
                    "country_source_response"]:
            if pd.notna(row[col]):
                labels.append(f"{col}: {row[col]}")

        # Ajouter les métadonnées et les labels à l'objet JSON
        json_obj = {
            "meta": {
                "doc_ID": row["doc_ID"],
                "sentence_id": row["sentence_id"],
                "date": row["date"]
            },
            "text": row["context"],
            "labels": labels
        }
        jsonl_data.append(json_obj)

    # Exporter les données modifiées en format JSONL
    with open(jsonl_file_path, 'w', encoding='utf-8') as file:
        for json_obj in jsonl_data:
            file.write(json.dumps(json_obj, ensure_ascii=False) + '\n')


# Chemins relatifs pour les fichiers CSV
csv_files = ["../EVD.COVID_ANALYSIS/Database/annotated_data/QC.processed_conf_texts_with_new_responses_2.csv",
             "../EVD.COVID_ANALYSIS/Database/annotated_data/SWD.processed_conf_texts_with_new_responses_2.csv"]

# Chemins relatifs pour les fichiers JSONL de sortie
jsonl_files = ["../EVD.COVID_ANALYSIS/Database/verification_annotation_data/QC.annotation_verification.jsonl",
               "../EVD.COVID_ANALYSIS/Database/verification_annotation_data/SWD.annotation_verification.jsonl"]

# Traiter chaque fichier CSV et créer un fichier JSONL correspondant
for csv_file, jsonl_file in zip(csv_files, jsonl_files):
    process_csv_to_jsonl(csv_file, jsonl_file)
