"""
PROJECT:
-------
EVD.COVID_ANALYSIS

TITLE:
------
2_Sentences_to_annotate.py

MAIN OBJECTIVE:
---------------
This script preprocesses conference texts by removing English sentences 
(if applicable), tokenizing the text into sentences, and calculating 
the number of sentences to be annotated manually for each country based on statistical parameters.

Dependencies:
-------------
- os
- pandas
- spacy
- langdetect

MAIN FEATURES:
--------------
1) Loads conference texts from CSV files for Quebec and Sweden.
2) Removes English sentences from Quebec texts.
3) Tokenizes texts into sentences using spaCy models.
4) Calculates the total number of sentences per country.
5) Determines the sample size for manual annotation based on confidence level and margin of error.

Author:
-------
Antoine Lemor
"""

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

##############################################################################
#                      Function: remove_english_sentences
#    - Strategy: Splits text into sentences and filters out those detected as English.
##############################################################################
def remove_english_sentences(text):
    """
    Removes English sentences from the provided text.

    Parameters:
    ----------
    text : str
        The text from which to remove English sentences.

    Returns:
    -------
    str
        The text with English sentences removed.
    """
    sentences = text.split('.')
    filtered_sentences = []
    for sentence in sentences:
        try:
            if detect(sentence.strip()) != 'en':
                filtered_sentences.append(sentence.strip())
        except LangDetectException:
            pass
    return '. '.join(filtered_sentences)

##############################################################################
#                      Function: tokenize_and_context
#    - Strategy: Uses spaCy to tokenize text into sentences.
##############################################################################
def tokenize_and_context(text, nlp):
    """
    Tokenizes the provided text into sentences using the specified spaCy model.

    Parameters:
    ----------
    text : str
        The text to tokenize.
    nlp : spacy.lang
        The spaCy language model to use for tokenization.

    Returns:
    -------
    list of str
        A list of tokenized sentences.
    """
    doc = nlp(text)
    return [sent.text.strip() for sent in doc.sents]

##############################################################################
#                      Function: calculate_sentences
#    - Strategy: Calculates the total number of sentences for a given country.
##############################################################################
def calculate_sentences(csv_path, country):
    """
    Calculates the total number of sentences in the CSV file for the specified country.

    Parameters:
    ----------
    csv_path : str
        The file path to the CSV containing conference texts.
    country : str
        The country code ('QC' or 'SWD').

    Returns:
    -------
    int
        The total number of sentences for the country.
    """
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

# Calculate the total number of sentences for each country
total_sentences_by_country = {}

for country, path in csv_paths.items():
    total_sentences_by_country[country] = calculate_sentences(path, country)

# Statistical parameters for calculating sample size
Z = 1.96  # 95% confidence level
E = 0.05  # Margin of error

##############################################################################
#                      Function: calculate_sample_size
#    - Strategy: Computes the adjusted sample size based on population and error margins.
##############################################################################
def calculate_sample_size(N, Z, E, p=0.5):
    """
    Calculates the adjusted sample size for manual annotation.

    Parameters:
    ----------
    N : int
        The total population size.
    Z : float
        The Z-score corresponding to the desired confidence level.
    E : float
        The margin of error.
    p : float, optional
        The estimated proportion of the population (default is 0.5).

    Returns:
    -------
    int
        The adjusted sample size.
    """
    n_unadjusted = ((Z**2) * p * (1 - p)) / (E**2)
    n_adjusted = n_unadjusted / (1 + (n_unadjusted - 1) / N)
    return int(n_adjusted)

# Calculate the number of sentences to manually annotate for each country
sentences_to_annotate_by_country = {country: calculate_sample_size(total, Z, E) for country, total in total_sentences_by_country.items()}

# Display the results
print("Total sentences by country:", total_sentences_by_country)
print("Sentences to annotate by country:", sentences_to_annotate_by_country)
