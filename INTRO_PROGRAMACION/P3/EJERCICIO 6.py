print('EJERCICIO 6, BOLETÍN 3')

# Importación del módulo random e iteración para generar la secuencia aleatoria
import random
lista = ['A','T','C','G']
secuencia_aleatoria = ''
for i in range(1,101):
    secuencia_aleatoria += random.choice(lista)
print('Secuencia aleatoria:', secuencia_aleatoria)

# Cálculo de la frecuencia de cada base
frecuencia_bases = {
        'A': secuencia_aleatoria.count('A')/len(secuencia_aleatoria),
        'T': secuencia_aleatoria.count('T')/len(secuencia_aleatoria),
        'G': secuencia_aleatoria.count('G')/len(secuencia_aleatoria),
        'C': secuencia_aleatoria.count('C')/len(secuencia_aleatoria),
        }
for clave,valor in frecuencia_bases.items():
    print(clave +'= {0:5.2f}'.format(valor))
