import pandas as pd
import os
from llama_index.llms.ollama import Ollama
from transformers import AutoTokenizer
from llama_index.core import Settings

# Configure the settings for the LLM
Settings.llm = Ollama(model="mixtral:8x7b-instruct-v0.1-q5_K_M")

# Initialize the Ollama model with the modified settings
llm = Settings.llm

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the relative file paths
data_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'SWD.instructions_conf_texts.csv')
output_path = os.path.join(script_dir, '..', 'Database', 'annotated_data', 'SWD.processed_conf_texts_with_new_responses_1.csv')

# Initialize the tokenizer
tokenizer = AutoTokenizer.from_pretrained("mistralai/Mixtral-8x7B-Instruct-v0.1")

# Load the CSV file
df = pd.read_csv(data_path)

# Create a new DataFrame with specific columns
new_df = df[['doc_ID', 'date', 'sentence_id', 'context']].copy()
new_df['detect_evidence_response'] = ''
new_df['type_of_evidence_response'] = ''
new_df['source_of_evidence_response'] = ''
new_df['evidence_frame_response'] = ''
new_df['associated_emotion_response'] = ''
new_df['detect_source_response'] = ''
new_df['journalist_question_response'] = ''
new_df['country_source'] = ''

# Function to process additional instruction
def process_additional_instruction(instruction, index, context):
    base_prompt = "Tu es un annotateur de texte en français."
    prompt = f"{base_prompt}\n{df.at[index, instruction]}\n{context}"
    response = llm.complete(prompt).text
    new_df.at[index, f'{instruction}_response'] = response
    print(f"Date: {new_df.at[index, 'date']}, Sentence ID: {new_df.at[index, 'sentence_id']}, {instruction}: {response}")

# Process each row in the DataFrame
for index, row in new_df.iterrows():
    context = row['context']
    date = row['date']  # Ensure 'date' is defined in the loop
    sentence_id = row['sentence_id']  # Ensure 'sentence_id' is defined in the loop
    base_prompt = "Tu es un annotateur de texte en français. Ta réponse doit être exclusivement 'oui' ou 'non'"

    # Process each instruction
    for instruction in ['detect_evidence', 'detect_source', 'journalist_question']:
        prompt = f"{base_prompt}\n{df.at[index, instruction]}\n{context}"
        response = llm.complete(prompt).text
        # Extract 'oui' or 'non' only
        response = 'oui' if 'oui' in response.lower() else 'non'
        new_df.at[index, f'{instruction}_response'] = response
        print(f"Date: {date}, Sentence ID: {sentence_id}, {instruction}: {response}")

    # Additional instructions based on responses
    if new_df.at[index, 'detect_evidence_response'] == 'oui':
        # Execute 'type_of_evidence' only if 'detect_evidence' is 'oui'
        process_additional_instruction('type_of_evidence', index, context)

    # Additional instructions if 'detect_evidence' is 'oui'
    if new_df.at[index, 'detect_evidence_response'] == 'oui' or new_df.at[index, 'detect_source_response'] == 'oui':
        base_prompt = "Tu es un annotateur de texte en français."
        for instruction in ['source_of_evidence', 'associated_emotion', 'country_source', 'evidence_frame']:
            # Ne pas inclure 'evidence_frame' si la réponse vient de 'detect_source'
            if new_df.at[index, 'detect_source_response'] == 'oui' and instruction == 'evidence_frame':
                continue
            process_additional_instruction(instruction, index, context)

# Write the new DataFrame to a new CSV file
new_df.to_csv(output_path, index=False)
print("Processing complete. The new CSV file with individual responses has been saved.")