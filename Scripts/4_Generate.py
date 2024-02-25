import ollama
from ollama import generate

model = 'mixtral:8x7b-instruct-v0.1-q5_K_M'

# Les options doivent être passées en tant que dictionnaire
options = {
    "temperature": 0,
    "top_p": 0.99,
    "top_k": 100,
    "num_predict":5
}

# Appel de la fonction generate avec les options correctement intégrées
response = generate(model, "Qu'est-ce que tu es?", options=options)

print(response['response'])

