import os
import json
import deepl

# Paths to the JSONL files for annotation
jsonl_paths = [
    "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_SWD_additional_data_for_evaluation.jsonl",
    "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS/EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_SWD_additional_data.jsonl",
]

# Make sure to use your correct API key here
auth_key = "YOUR_AUTH_KEY"

# Create a Translator object, explicitly specifying the endpoint for the free API
translator = deepl.Translator(auth_key=auth_key, server_url="https://api.deepl.com")

# Function to process and translate each JSONL file
def process_and_translate_jsonl(file_path):
    # Generate the output file path
    output_file_path = f"{file_path[:-6]}_translated.jsonl"
    
    # Open the source JSONL file
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Prepare the output file
    with open(output_file_path, 'w', encoding='utf-8') as f_out:
        for line in lines:
            # Load the JSON line
            data = json.loads(line)

            # Extract the original text
            original_text = data['text']

            # Translate the text using DeepL
            result = translator.translate_text(original_text, source_lang="SV", target_lang="FR")
            translated_text = result.text

            # Add the translation to the original text
            data['text'] = original_text + "\n--- TRANSLATION ---\n" + translated_text

            # Save the modified line to the output file
            json.dump(data, f_out, ensure_ascii=False)
            f_out.write('\n')  # Add a new line after each JSON object

    print(f"Completed translation for: {file_path}")

# Loop through each JSONL file path and process them
for path in jsonl_paths:
    process_and_translate_jsonl(path)

print("All files have been processed and translations added.")
