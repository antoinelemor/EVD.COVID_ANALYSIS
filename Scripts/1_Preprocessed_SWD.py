import os
import pandas as pd
import spacy
from sklearn.utils import shuffle
from langdetect import detect, DetectorFactory, LangDetectException

# Chemin relatif vers le dossier contenant le script
script_dir = os.path.dirname(__file__)

# Chemin relatif vers le fichier CSV dans le dossier Database
csv_path = os.path.join(script_dir, '..', 'Database', 'original_data', 'SWD.conf_texts.csv')

# Chargement du modèle français de spaCy
nlp = spacy.load('fr_core_news_sm')

# Fixation de la seed pour la détection de langue
DetectorFactory.seed = 0

# Fonction pour détecter et supprimer les phrases en anglais
def remove_english_sentences(text):
    sentences = text.split('.')
    filtered_sentences = []
    for sentence in sentences:
        try:
            if detect(sentence.strip()) == 'fr':
                filtered_sentences.append(sentence.strip())
        except LangDetectException:
            # Gestion des erreurs pour les textes trop courts ou vides
            pass
    return '. '.join(filtered_sentences)

# Fonction pour tokéniser et créer le contexte des phrases
def tokenize_and_context(text):
    doc = nlp(text)
    sentences = [sent.text.strip() for sent in doc.sents]
    contexts = []
    for i, sentence in enumerate(sentences):
        start = max(i-2, 0)
        end = min(i+3, len(sentences))
        context = ' '.join(sentences[start:end])
        contexts.append((i, context))
    return contexts

# Chargement du fichier CSV
df = pd.read_csv(csv_path)

# Sélection aléatoire de 3 conférences de presse
selected_confs = shuffle(df).head(3)

# Application des fonctions et création du nouveau dataframe
new_data = []
for _, row in selected_confs.iterrows():
    clean_text = remove_english_sentences(row['conf_txt'])
    contexts = tokenize_and_context(clean_text)
    for id, context in contexts:
        new_data.append({'doc_ID': row['doc_ID'], 'date': row['date'], 'sentence_id': id, 'context': context})

new_df = pd.DataFrame(new_data)

# Affichage des premières lignes pour vérification
print(new_df.head())

# Chemin relatif pour l'enregistrement du nouveau DataFrame
output_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'SWD.processed_conf_texts.csv')

# Enregistrement du nouveau dataframe
new_df.to_csv(output_path, index=False)
