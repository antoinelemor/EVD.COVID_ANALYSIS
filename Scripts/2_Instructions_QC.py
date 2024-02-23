import os
import pandas as pd

# Chemin relatif vers le dossier contenant le script
script_dir = os.path.dirname(__file__)

# Chemin relatif vers le fichier CSV dans le dossier preprocessed_data
csv_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'QC.processed_conf_texts.csv')

# Charger le dataframe prétraité
df = pd.read_csv(csv_path)
 
# Définition des instructions pour chaque tâche
instructions = {
    'detect_evidence': "Lis l'extrait suivant et indique si celui-ci contient une référence à une preuve scientifique en lien avec la pandémie de COVID-19. Les preuves peuvent inclure des statistiques, des rapports scientifiques, des découvertes nouvelles, des données probantes, etc.",
    'detect_source': "Lis l'extrait suivant et indique si celui-ci contient une référence à une une source scientifique en lien avec la pandémie de COVID-19. Les sources peuvent être des organisations comme l'OMS, l'INSPQ, l'INESSS ou des experts spécifiques.",
    'type_of_evidence': "Une preuve scientifique a été mentionnée dans cet extrait de conférence de presse durant la pandémie de COVID-19, merci d'identifier si elle provient des sciences naturelles (comme la biologie, la médecine) ou des sciences sociales (comme la sociologie, l'économie). Veuillez indiquer 'Sciences naturelles', 'Sciences sociales' ou 'NA' s'il est impossible de déterminer le type.",
    'source_of_evidence': "Une preuve ou une source scientifique a été mentionnée dans cet extrait de conférence de presse durant la pandémie de COVID-19, pouvez-vous identifier la source spécifique mentionnée ? Il peut s'agir d'une organisation, d'une institution ou d'un expert. Si la source est renseignée, veuillez l'indiquer clairement, sinon renseigner 'NA'",
    'evidence_frame': "Analysez le contexte dans lequel la preuve ou la source scientifique de cet extrait de conférence de presse est citée, et choisis parmi l’une des trois options quel est le cadre dominant d’interprétation des preuves scientifiques dans cet extrait. Suppression : Ce cadre considère qu'il faut agir de façon sévère par précaution pour minimiser les risques de la propagation du virus même si le niveau de preuve scientifique est faible et l’incertitude élevée. Ceci justifie des mesures sévères et générales afin de lutter contre le virus même si ces mesures peuvent avoir un impact significatif sur la société. Mitigation : Ce cadre considère qu’il convient d’avoir un niveau plus élevé de preuves scientifiques pour justifier des mesures sévères contre le virus au regard des conséquences que ces mesurs peuvent avoir sur la société. Ceci justifie des mesures souples et volontaristes, voire seulement des recommandations. Neutre : Ce cadre présente les preuves scientifiques sans les cadrer avec l’un des deux cadres précédents.",
    'associated_emotion': "Examinez si la mention d'une preuve ou source scientifique dans l'extrait est associée à des émotions négatives comme la peur, la tristesse ou la colère ou positives comme l'espoir, la joie ou le plaisir. Indique 'positif' si les émotions sont positives, 'négatif' si les émotions sont négatives ou 'neutre' si aucune émotion n'est véhiculée",
    'country_source': "Examinez si la source scientifique mentionnée dans l'extrait provient d'un pays (un autre pays) ou d'une organisation (comme l'OMS, l'UE, etc.) étrangère au Canada. Indiquez 'Oui' ou 'Non' si la source provient d'un pays ou d'une organisation étrangère. Si la source n'est pas clairement identifiée, indiquez 'NA'",
    'journalist_question': "Déterminez si l'extrait contient une question posée par un ou une journaliste. Indique 'Oui' ou 'Non'"
}

# Ajouter les nouvelles colonnes avec les instructions à chaque ligne
for column, instruction in instructions.items():
    df[column] = instruction

# Chemin relatif pour l'enregistrement du nouveau DataFrame
output_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'QC.instructions_conf_texts.csv')

# Enregistrement du nouveau dataframe avec les instructions
df.to_csv(output_path, index=False)
