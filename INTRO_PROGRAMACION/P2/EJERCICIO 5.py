print('EJERCICIO 5')

# Secuencia de ADN
secuencia = input('Introducir una secuencia: ')

# Diccionario para almacenar el recuento
dicc= {
    'adenine': (secuencia.count('A') + secuencia.count('a')),
    'thymine': (secuencia.count('T') + secuencia.count('t')),
    'cytosine': (secuencia.count('C') + secuencia.count('c')),
    'guanine': (secuencia.count('G') + secuencia.count('g')),
    'caracteres extraños': (len(secuencia) - (secuencia.count('A') + secuencia.count('a') + secuencia.count('T') + secuencia.count('t') + secuencia.count('C') + secuencia.count('c') + secuencia.count('G') + secuencia.count('g')))
}

# Recuento

print('Contiene {0} bases, con la siguiente distribución: \nadenine: {1} \nthymine: {2} \ncytosine: {3} \nguanine: {4} \ny {5} caracteres extraños'.format(len(dicc),dicc.get('adenine'),dicc.get('thymine'),dicc.get('cytosine'),dicc.get('guanine'),dicc.get('caracteres extraños')))
