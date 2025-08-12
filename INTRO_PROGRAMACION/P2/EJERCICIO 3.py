print ('EJERCICIO 3')

# Introducción de la cadena
CADENA = '_las plantas son organismos muy interesantes'

# Sentencia a
print('Sentencia a: ', CADENA.replace('_','').capitalize ())

# Sentencia b 
nueva_cadena = CADENA.replace('_','').replace(' ', '')
cadena_inversa = nueva_cadena[::-1]
print('¿Es reversible?: ', nueva_cadena == cadena_inversa)

# Sentencia c
conjunto_CADENA = set(CADENA)
print('¿Contiene todas las vocales?: ',{'a','e','i','o','u'} <= conjunto_CADENA)

# Sentencia d
nueva_CADENA = ('l{a}s pl{a}nt{a}s s{o}n {o}rg{a}n{i}sm{o}s m{u}y {i}nt{e}r{e}s{a}nt{e}s'.format(a='1', e='2', i='3', o='4', u='5'))
print('La cadena codificada es: ', nueva_CADENA)

# Sentencia e
print('La cadena en formato original es: ', nueva_CADENA.replace('1', 'a').replace('2', 'e').replace('3', 'i').replace('4', 'o').replace('5', 'u'))
