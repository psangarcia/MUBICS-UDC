with open('schizophrenia.fasta','r') as file:
    for line in file:
        if not line.isspace():
            file.write(line)
