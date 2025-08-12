print ('EJERCICIO 4')

# Secuencia de ADN
secuencia = input('Introducir secuencia: ') 

# Sentencia a
subsecuencia = input('Introducir subsecuencia: ')
print('Número de ocurrencias: ', secuencia.count(subsecuencia))

# Sentencia b
print('Posición de la primera ocurrencia:', subsecuencia + ' =', secuencia.find(subsecuencia))

# Sentencia c
print('Longitud de la secuencia' + ' =', len(secuencia))
bases_diferentes = set(secuencia)
print('Número de bases diferentes' + ' =', len(bases_diferentes))

# Sentencia d
c = (secuencia.count('G') + secuencia.count('C'))/len(secuencia)*100
print('Contenido GC = {0:5.2f}'.format(c),'%') 

# Sentencia e
Bases_a_rotar = int(input('Nº bases a rotar: '))

# Toma e inversión del fragmento correspondiente al número de bases del final
n_bases_final = secuencia[len(secuencia)-Bases_a_rotar:]
fragmento_inverso = n_bases_final[::-1]

# Inserción del fragmento inverso en la primera posición de la secuencia de ADN
secuencia_sin_bases_finales = secuencia[:len(secuencia)-Bases_a_rotar]
lista_secuencia = list(secuencia_sin_bases_finales)
lista_secuencia.insert(0, fragmento_inverso)
cadena_ADN_rotada = ''.join(lista_secuencia)
print('Cadena ADN rotada =', cadena_ADN_rotada)



