"""
PROJECT:
-------
EVD.COVID_ANALYSIS

TITLE:
------
2_Translate_JSONL_for_annotation.py

MAIN OBJECTIVE:
-------------------
This script processes JSONL files by translating text from Swedish to French using the DeepL API.
It appends the translation to the original text and saves the result in a new JSONL file.

Dependencies:
-------------
- os
- json
- deepl

MAIN FEATURES:
----------------------------
1) Reads specified JSONL files containing annotation data.
2) Translates the 'text' field from Swedish (SV) to French (FR) using the DeepL API.
3) Appends the translation to the original text with a separator.
4) Writes the translated data to a new JSONL file.

Author : 
--------
Antoine Lemor
"""

import os
import json
import deepl

# Paths to the JSONL files for annotation
jsonl_paths = [
    "EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_SWD_additional_data_for_evaluation.jsonl",
    "EVD.COVID_ANALYSIS/Database/verification_annotation_data/new_SWD_additional_data.jsonl",
]

# Make sure to use your correct API key here
auth_key = "YOUR_AUTH_KEY"

# Create a Translator object, explicitly specifying the endpoint for the free API
translator = deepl.Translator(auth_key=auth_key, server_url="https://api.deepl.com")

##############################################################################
#                      Function: process_and_translate_jsonl
#    - Purpose: Process a JSONL file by translating text from Swedish to French,
#               appending the translation, and saving to a new file.
##############################################################################
def process_and_translate_jsonl(file_path):
    """
    Processes a JSONL file by translating the 'text' field from Swedish to French,
    appending the translation to the original text, and saving the result to a new file.

    Parameters:
    ----------
    file_path : str
        The path to the JSONL file to be processed.

    Returns:
    -------
    None
    """
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
