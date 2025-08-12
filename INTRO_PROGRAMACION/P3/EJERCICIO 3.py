print('EJERCICIO 3, BOLETÍN 3')

# Introducción de la lista de secuencias
secuencias = ['ttgaatgccttacaactgatcattacacaggcggcatgaagcaaaaatatactgtgaaccaatgcaggcg',
 'gauuauuccccacaaagggagugggauuaggagcugcaucauuuacaagagcagaauguuucaaaugcau',
 'gaaagcaagaaaaggcaggcgaggaagggaagaagggggggaaacc',
 'guuuccuacaguauuugaugagaaugagaguuuacuccuggaagauaauauuagaauguuuacaacugcaccugaucagguggauaaggaagaugaagacu',
 'gauaaggaagaugaagacuuucaggaaucuaauaaaaugcacuccaugaauggauucauguaugggaaucagccggguc']

# Bucle for para ítems de la lista de secuencias y determinación del tipo de secuencias
print('-Resultados-')
for i in range(len(secuencias)):
    conjunto=set(secuencias[i])
    if {'a','t','c','g'} <= conjunto:
        print('Secuencia', i+1,': ADN')
    elif {'a','u','c','g'} <= conjunto:
        print('Secuencia', i+1,': ARN')
    elif {'a','c','g'} <= conjunto:
        print('Secuencia', i+1,': UNK')
    else:
        {'u','t'} <= conjunto
        print('Secuencia', i+1,': UNK')


