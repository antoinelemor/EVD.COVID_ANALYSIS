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
    'detect_COVID': "Lis l’extrait de conférence de presse suivant et indique si celui-ci fait référence au virus ou à la maladie de la COVID-19. Réponds uniquement par oui ou par non",
    'detect_evidence': "Lis l'extrait suivant et indique si celui-ci contient une référence à une preuve scientifique en lien avec la pandémie de COVID-19. Les preuves peuvent inclure des statistiques, des rapports scientifiques, des découvertes nouvelles, des données probantes, etc.",
    'detect_source': "Lis l'extrait suivant et indique si celui-ci contient une référence à une une source scientifique en lien avec la pandémie de COVID-19. Les sources peuvent être des organisations comme l'OMS, l'Agence de santé publique, d'autres organisations ou des experts spécifiques  mais ne concernent pas les personnes présentes durant les conférences..",
    'type_of_evidence': "Une preuve scientifique a été mentionnée dans cet extrait de conférence de presse durant la pandémie de COVID-19, merci d'identifier si elle provient des sciences naturelles (comme la biologie, la médecine) ou des sciences sociales (comme la sociologie, l'économie). Veuillez indiquer 'Sciences naturelles', 'Sciences sociales' ou 'NA' s'il est impossible de déterminer le type.",
    'source_of_evidence': "Une preuve ou une source scientifique a été mentionnée dans cet extrait de conférence de presse durant la pandémie de COVID-19, pouvez-vous identifier la source spécifique mentionnée ? Il peut s'agir d'une organisation, d'une institution ou d'un expert. Si la source est renseignée, veuillez l'indiquer clairement, sinon renseigner 'NA'",
    'frame': "Analyse cet extrait de conférence de presse sur la pandémie de COVID-19, et choisis parmi l’une des trois options suivantes quel est le cadre dominant d’interprétation du virus ou de la maladie de COVID-19 contenu dans cet extrait (le simple fait de tenir une conférence de presse ne doit pas faire partie de l'analyse). Commence par nommer exclusivement le nom du cadre que tu choisis sans autre explications : Dangereux : Ce cadre considère le virus ou la maladie de la COVID-19 comme étant d'une dangerosité particulièrement élevée, présentant des risques majeurs pour la santé publique. Il privilégie le risque sur la santé de la population à d’autres dimensions sociales, politiques ou économiques. Acceptable : Ce cadre considère le virus ou la maladie de la COVID-19 comme un risque relativement acceptable pour la santé publique. Il privilégie un certain équilibre entre les risques sur la santé de la population et d’autres dimensions sociales, politiques ou économiques. Neutre : Le virus ou la maladie n'est cadrée avec aucun des cadres précédents ou est cadrée de manière neutre.",
    'measures': "Analyse cet extrait de conférence de presse sur la pandémie de COVID-19, et choisis parmi l’une des trois options suivantes quelle est la stratégie mise en place. Commence exclusivement ta réponse par le nom de l'option que tu choisis : Suppression : Cette stratégie vise à supprimer ou fortement minimiser la transmission du virus. Elle se traduit par la mise en œuvre de mesures particulièrement sévères comme le confinement, la fermeture de lieux publics, ou l’interdiction des rassemblements. Mitigation : Cette stratégie ne vise pas à supprimer la transmission du virus, mais à la mitiger en autorisant un certain niveau de transmission. Elle se traduit par la mise en œuvre de mesures peu sévères et ciblées comme des recommandations, des ouvertures contrôlées de lieux publics, ou des mesures d’hygiène. Neutre : Aucune des deux stratégies suivantes est mise en place.",
    'associated_emotion': "Examinez si la mention d'une preuve ou source scientifique dans l'extrait est associée à des émotions négatives comme la peur, la tristesse ou la colère ou positives comme l'espoir, la joie ou le plaisir. Indique 'positif' si les émotions sont positives, 'négatif' si les émotions sont négatives ou 'neutre' si aucune émotion n'est véhiculée. Commence exclusivement ta réponse par le nom de l'option que tu choisis.",
    'country_source': "Examinez si la source scientifique mentionnée dans l'extrait provient d'un pays (un autre pays) ou d'une organisation (comme l'OMS, l'UE, etc.) étrangère à la Suède. Indiquez 'Oui' ou 'Non' si la source provient d'un pays ou d'une organisation étrangère. Si la source n'est pas clairement identifiée, indiquez 'NA'",
    'journalist_question': "Déterminez si l'extrait contient une question posée par un ou une journaliste. Indique 'Oui' ou 'Non'"
}

# Ajouter les nouvelles colonnes avec les instructions à chaque ligne
for column, instruction in instructions.items():
    df[column] = instruction

# Chemin relatif pour l'enregistrement du nouveau DataFrame
output_path = os.path.join(script_dir, '..', 'Database', 'preprocessed_data', 'QC.instructions_conf_texts.csv')

# Enregistrement du nouveau dataframe avec les instructions
df.to_csv(output_path, index=False)
