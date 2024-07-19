import json
import os

# Mappings to convert responses into numerical values
response_mappings = {
    "oui": 1,
    "non": 0,
    "dangereux": 2,
    "modéré": 1,
    "neutre": 0,
    "suppression": 2,
    "mitigation": 1,
    "positif": 2,
    "négatif": 1,
    "sciences naturelles": 1,
    "sciences sociales": 0
}

def process_annotations(input_path, base_output_dir, country_code, data_type):
    if country_code == "QC":
        output_dir = os.path.join(base_output_dir, 'QC')
    elif country_code == "SWD":
        output_dir = os.path.join(base_output_dir, 'SWD')
    else:
        raise ValueError("Unsupported country code")
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    annotation_details = {}
    
    with open(input_path, 'r', encoding='utf-8') as infile:
        for line in infile:
            try:
                annotation = json.loads(line)
            except json.decoder.JSONDecodeError as e:
                print(f"JSON decoding error: {e}")
                continue

            if country_code == "SWD":
                translation_marker = "--- TRANSLATION ---"
                if translation_marker in annotation["text"]:
                    annotation["text"] = annotation["text"].split(translation_marker)[0].strip()

            label_responses = {}
            label_keys = []  # To keep track of encountered keys
            for label in annotation["labels"]:
                label_key = label.split(": ")[0].replace("_response", "")
                response = label.split(": ")[1].strip()
                
                if label_key in label_keys:
                    print(f"Duplicate detected for '{label_key}' in annotation ID {annotation['id']} in file {country_code}: {data_type}")
                    break  # Break the current loop to avoid adding duplicates
                else:
                    label_keys.append(label_key)
                    if response in response_mappings:
                        response_value = response_mappings[response]
                        label_responses[label_key] = response_value
                    else:
                        continue

            for label_key, response_value in label_responses.items():
                filename = f"{label_key}_{country_code}_{data_type}.jsonl"
                output_path = os.path.join(output_dir, filename)
                
                formatted_annotation = {
                    "text": annotation["text"],
                    "labels": response_value
                }
                
                with open(output_path, 'a', encoding='utf-8') as outfile:
                    json.dump(formatted_annotation, outfile, ensure_ascii=False)
                    outfile.write('\n')
                
                if output_path not in annotation_details:
                    annotation_details[output_path] = {'total': 0, 'distribution': {}}
                annotation_details[output_path]['total'] += 1
                annotation_details[output_path]['distribution'][response_value] = annotation_details[output_path]['distribution'].get(response_value, 0) + 1
    
    for path, details in annotation_details.items():
        distribution_str = ", ".join([f"{k}: {v}" for k, v in details['distribution'].items()])
        print(f"{path}: {details['total']} annotations, distribution - {distribution_str}")

countries = ['QC', 'SWD']
script_dir = os.path.dirname(os.path.realpath('__file__'))
verification_annotation_dir = os.path.join(script_dir, 'Database', 'verification_annotation_data')
training_data_dir = os.path.join(script_dir, 'Database', 'training_data_per_label_per_country')

for country_code in countries:
    input_train_path = os.path.join(verification_annotation_dir, f"{country_code}.training_data.jsonl")
    process_annotations(input_train_path, training_data_dir, country_code, "train")

    input_test_path = os.path.join(verification_annotation_dir, f"{country_code}.evaluation_data.jsonl")
    process_annotations(input_test_path, training_data_dir, country_code, "test")

    input_test_path = os.path.join(verification_annotation_dir, f"{country_code}.test_data.jsonl")
    process_annotations(input_test_path, training_data_dir, country_code, "predict")

print("JSONL files for training, testing, and prediction successfully generated with label distribution.")
