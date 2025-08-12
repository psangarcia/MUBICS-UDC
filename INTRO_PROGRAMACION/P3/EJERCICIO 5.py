print('EJERCICIO 5, BOLETÍN 3')

# Secuencia de ADN
secuencia = input('Introduzca una secuencia de ADN: ').upper()

# Recuento de caracteres extraños
caracteres_extraños = len(secuencia)-(secuencia.count('A')+secuencia.count('C')+secuencia.count('G')+secuencia.count('T'))

# Verificar si la secuencia es correcta y hacer el cálculo de la frecuencia de cada base
if caracteres_extraños == 0:
    frecuencia_bases = {
        'A': secuencia.count('A')/len(secuencia),
        'T': secuencia.count('T')/len(secuencia),
        'G': secuencia.count('G')/len(secuencia),
        'C': secuencia.count('C')/len(secuencia),
        }
    for clave,valor in frecuencia_bases.items():
        print(clave +'= {0:5.2f}'.format(valor))
else:
    print('La secuencia introducida es incorrecta')
