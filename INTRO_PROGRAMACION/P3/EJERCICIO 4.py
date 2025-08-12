print('EJERCICIO 4, BOLETÍN 3')

# Introducción de la cadena de texto
frase = 'Las clases de las asignaturas se cambian por las clases de exposiciones sobre emprendimiento'.upper() 
frase_en_lista = sorted(frase.split(' '))

# Diccionario para hallar las repeticiones de cada palabra en la cadena de texto
dicc = {}
for i in frase_en_lista:
    dicc [i] = frase_en_lista.count(i)
for clave,valor in dicc.items():
    print(clave.title()+': '+ str(valor))



