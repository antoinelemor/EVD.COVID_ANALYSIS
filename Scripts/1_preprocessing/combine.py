import os

# Chemin du repository
repo_path = "/Users/antoine/Documents/GitHub/EVD.COVID_ANALYSIS"

# Chemin du fichier de sortie
output_file = "/Users/antoine/Desktop/code.txt"

def collect_code_files(repo_path, output_file):
    """
    Parcourt le repository, lit les fichiers .py et .R, et les écrit dans un fichier texte.
    """
    with open(output_file, "w", encoding="utf-8") as outfile:
        for root, _, files in os.walk(repo_path):
            for file in files:
                if file.endswith(".py") or file.endswith(".R"):
                    file_path = os.path.join(root, file)
                    with open(file_path, "r", encoding="utf-8") as infile:
                        outfile.write(f"### Content from: {file_path} ###\n")
                        outfile.write(infile.read())
                        outfile.write("\n\n")  # Séparateur entre les fichiers
    print(f"Code concatenated into: {output_file}")

# Exécuter la fonction
collect_code_files(repo_path, output_file)