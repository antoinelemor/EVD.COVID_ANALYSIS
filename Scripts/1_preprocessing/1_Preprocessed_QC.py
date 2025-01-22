"""
PROJECT:
-------
EVD.COVID_Analysis

TITLE:
------
1_Preprocessed_QC.py

MAIN OBJECTIVE:
---------------
Preprocessing and quality checking of press conference texts, removing English sentences,
creating sentence-level contexts, and saving the processed data.

Dependencies:
-------------
- os
- pandas
- spacy
- sklearn
- langdetect

MAIN FEATURES:
--------------
1) Detect and remove English sentences.
2) Tokenize French texts using spaCy and create sentence contexts.
3) Save the transformed data in CSV format.

Author:
-------
Antoine Lemor
"""

import os
import pandas as pd
import spacy
from sklearn.utils import shuffle
from langdetect import detect, DetectorFactory, LangDetectException

# Relative path to the folder containing the script
script_dir = os.path.dirname(__file__)

# Relative path to the CSV file in the Database folder
csv_path = os.path.join(script_dir, '..', '..', 'Database', 'original_data', 'QC.conf_texts.csv')

# Loading the spaCy model for French language processing
nlp = spacy.load('fr_dep_news_trf')

# Setting the seed for language detection
DetectorFactory.seed = 0

def remove_english_sentences(text):
    """
    Detects and removes English sentences from the provided text.

    Parameters
    ----------
    text : str
        The input text to filter.

    Returns
    -------
    str
        A string containing only French sentences.
    """
    sentences = text.split('.')
    filtered_sentences = []
    for sentence in sentences:
        try:
            if detect(sentence.strip()) == 'fr':
                filtered_sentences.append(sentence.strip())
        except LangDetectException:
            # Handling errors for texts that are too short or empty
            pass
    return '. '.join(filtered_sentences)

def tokenize_and_context(text):
    """
    Tokenizes the provided text using a French spaCy model and creates sentence contexts.

    Parameters
    ----------
    text : str
        The input text to tokenize.

    Returns
    -------
    list
        A list of tuples where each tuple contains a sentence index and its context.
    """
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

# Random selection of 3 press conferences
selected_confs = df

# Applying functions and creating the new dataframe
new_data = []
for _, row in selected_confs.iterrows():
    clean_text = remove_english_sentences(row['conf_txt'])
    contexts = tokenize_and_context(clean_text)
    for id, context in contexts:
        new_data.append({'doc_ID': row['doc_ID'], 'date': row['date'], 'sentence_id': id, 'context': context})

new_df = pd.DataFrame(new_data)

# Displaying the first rows for verification
print(new_df.head())

# Relative path for saving the new DataFrame
output_path = os.path.join(script_dir, '..', '..', 'Database', 'preprocessed_data', 'QC.processed_conf_texts.csv')

# Saving the new dataframe
new_df.to_csv(output_path, index=False)
