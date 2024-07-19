import os
import pandas as pd
import spacy
from langdetect import detect, DetectorFactory, LangDetectException

# Relative path to the folder containing the script
script_dir = os.path.dirname(__file__)

# Relative path to the CSV files in the Database folder for Quebec and Sweden
csv_paths = {
    'QC': os.path.join(script_dir, '..', '..', 'Database', 'original_data', 'QC.conf_texts.csv'),
    'SWD': os.path.join(script_dir, '..', '..', 'Database', 'original_data', 'SWD.conf_texts.csv')
}

# Loading spaCy models for French and Swedish
nlp_fr = spacy.load('fr_core_news_sm')
nlp_swd = spacy.load('sv_core_news_lg')

# Setting the seed for language detection
DetectorFactory.seed = 0

def remove_english_sentences(text):
    sentences = text.split('.')
    filtered_sentences = []
    for sentence in sentences:
        try:
            if detect(sentence.strip()) != 'en':
                filtered_sentences.append(sentence.strip())
        except LangDetectException:
            pass
    return '. '.join(filtered_sentences)

def tokenize_and_context(text, nlp):
    doc = nlp(text)
    return [sent.text.strip() for sent in doc.sents]

# Calculate the total number of sentences for each country
def calculate_sentences(csv_path, country):
    df = pd.read_csv(csv_path)
    total_sentences = 0

    for _, row in df.iterrows():
        text = row['conf_txt']
        if country == 'QC':
            text = remove_english_sentences(text)
            sentences = tokenize_and_context(text, nlp_fr)
        elif country == 'SWD':
            sentences = tokenize_and_context(text, nlp_swd)
        total_sentences += len(sentences)

    return total_sentences

total_sentences_by_country = {}

for country, path in csv_paths.items():
    total_sentences_by_country[country] = calculate_sentences(path, country)

# Statistical parameters for calculating sample size
Z = 1.96  # 95% confidence level
E = 0.05  # Margin of error

# Function to calculate adjusted sample size
def calculate_sample_size(N, Z, E, p=0.5):
    n_unadjusted = ((Z**2) * p * (1 - p)) / (E**2)
    n_adjusted = n_unadjusted / (1 + (n_unadjusted - 1) / N)
    return int(n_adjusted)

# Calculate the number of sentences to manually annotate for each country
sentences_to_annotate_by_country = {country: calculate_sample_size(total, Z, E) for country, total in total_sentences_by_country.items()}

# Display the results
print("Total sentences by country:", total_sentences_by_country)
print("Sentences to annotate by country:", sentences_to_annotate_by_country)
