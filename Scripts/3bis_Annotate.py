import pandas as pd
import os
import re
from llama_index.llms.ollama import Ollama
from transformers import AutoTokenizer
from llama_index.core import Settings
from unidecode import unidecode

# Configuration des paramètres du modèle
Settings.llm = Ollama(model="mixtral:8x7b-instruct-v0.1-q5_K_M")
llm = Settings.llm

# Définition des chemins de fichiers
script_dir = os.path.dirname(os.path.abspath(__file__))
data_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'instructions_conf_texts.csv')
output_path = os.path.join(script_dir, '..', 'Database', 'annotated_data', 'processed_conf_texts_with_new_responses_2.csv')

# Initialisation du tokenizer
tokenizer = AutoTokenizer.from_pretrained("mistralai/Mixtral-8x7B-Instruct-v0.1")

# Chargement du fichier CSV
df = pd.read_csv(data_path)

# Création d'un nouveau DataFrame
new_df = df[['doc_ID', 'date', 'sentence_id', 'context']].copy()
columns_to_add = ['detect_evidence_response', 'type_of_evidence_response', 'source_of_evidence_response',
                  'evidence_frame_response', 'associated_emotion_response', 'detect_source_response',
                  'journalist_question_response', 'country_source']
for col in columns_to_add:
    new_df[col] = ''

# Fonction pour extraire les réponses des réponses complètes
def extract_response(response):
    lines = response.split('\n')
    return lines[-1]  # Supposant que la dernière ligne contient la réponse

# Traitement de chaque ligne
for index, row in new_df.iterrows():
    context, date, sentence_id = row['context'], row['date'], row['sentence_id']
    base_prompt = "Tu es un annotateur de texte en français. Ta réponse doit être exclusivement 'oui' ou 'non'"

    for instruction in ['detect_evidence', 'detect_source', 'journalist_question']:
        prompt = f"{base_prompt}\n{df.at[index, instruction]}\n{context}"
        response = llm.complete(prompt).text.strip()
        response = 'oui' if 'oui' in response.lower() else 'non'
        new_df.at[index, f'{instruction}_response'] = response
        print(f"Date: {date}, Sentence ID: {sentence_id}, {instruction}: {response}")

    # Instructions supplémentaires si 'detect_evidence' ou 'detect_source' est 'oui'
    if new_df.at[index, 'detect_evidence_response'] == 'oui' or new_df.at[index, 'detect_source_response'] == 'oui':
        for additional_instruction in ['source_of_evidence', 'associated_emotion', 'country_source']:
            prompt = f"Tu es un annotateur de texte en français.\n{df.at[index, additional_instruction]}\n{context}"
            full_response = llm.complete(prompt).text.strip().lower()
            full_response = unidecode(full_response)

            # Traitement personnalisé pour chaque instruction supplémentaire
            if additional_instruction == 'source_of_evidence':
                response = full_response
            elif additional_instruction == 'associated_emotion':
                response = 'négatif' if re.search(r'\bneg', full_response) else 'positif' if re.search(r'\bposi', full_response) else 'neutre'
            elif additional_instruction == 'country_source':
                response = 'oui' if 'oui' in full_response else 'non' if 'non' in full_response else 'NA' if 'na' in full_response else full_response

            new_df.at[index, f'{additional_instruction}_response'] = response
            print(f"Date: {date}, Sentence ID: {sentence_id}, {additional_instruction}: {response}")

    # Instructions supplémentaires si 'detect_evidence' est 'oui'
    if new_df.at[index, 'detect_evidence_response'] == 'oui':
        # Traitement pour 'evidence_frame'
        prompt = f"Tu es un annotateur de texte en français.\n{df.at[index, 'evidence_frame']}\n{context}"
        full_response = llm.complete(prompt).text.strip().lower()
        full_response = unidecode(full_response)
        response = 'suppression' if re.search(r'\bsuppressi', full_response) else 'mitigation' if re.search(r'\bmitigat', full_response) else 'neutre' if re.search(r'\bneutr', full_response) else full_response
        new_df.at[index, 'evidence_frame_response'] = response
        print(f"Date: {date}, Sentence ID: {sentence_id}, evidence_frame: {response}")

        # Traitement pour 'type_of_evidence'
        prompt = f"Tu es un annotateur de texte en français.\n{df.at[index, 'type_of_evidence']}\n{context}"
        full_response = llm.complete(prompt).text.strip().lower()
        full_response = unidecode(full_response)
        response = 'sciences naturelles' if re.search(r'\bnatur', full_response) else 'sciences sociales' if re.search(r'\bsocial', full_response)  else full_response        
        new_df.at[index, 'type_of_evidence_response'] = response
        print(f"Date: {date}, Sentence ID: {sentence_id}, type_of_evidence: {response}")

# Enregistrement du nouveau DataFrame
new_df.to_csv(output_path, index=False)
print("Le nouveau fichier CSV avec les réponses individuelles a été enregistré.")
