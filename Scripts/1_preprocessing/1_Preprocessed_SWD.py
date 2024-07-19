import os
import pandas as pd
import spacy
from sklearn.utils import shuffle
from langdetect import detect, DetectorFactory, LangDetectException

# Relative path to the folder containing the script
script_dir = os.path.dirname(__file__)

# Relative path to the CSV file in the Database folder
csv_path = os.path.join(script_dir, '..', '..', 'Database', 'original_data', 'SWD.conf_texts.csv')

# Loading the Swedish spaCy model
nlp = spacy.load('sv_core_news_lg')

# Setting the seed for language detection
DetectorFactory.seed = 0

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

# Loading the CSV file
df = pd.read_csv(csv_path)
selected_confs = df

# Applying functions and creating the new dataframe
new_data = []
for _, row in selected_confs.iterrows():
    contexts = tokenize_and_context(row['conf_txt'])
    for id, context in contexts:
        new_data.append({'doc_ID': row['doc_ID'], 'date': row['date'], 'sentence_id': id, 'context': context})

new_df = pd.DataFrame(new_data)

# Displaying the first rows for verification
print(new_df.head())

# Relative path for saving the new DataFrame
output_path = os.path.join(script_dir, '..', '..', 'Database', 'preprocessed_data', 'SWD.processed_conf_texts.csv')

# Saving the new dataframe
new_df.to_csv(output_path, index=False)
