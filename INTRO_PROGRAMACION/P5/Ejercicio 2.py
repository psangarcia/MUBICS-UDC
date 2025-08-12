# EJERCICIO 2 BOLETÍN 5

import os

# Función para solicitar el fichero y evaluar si es correcto para lectura
def apertura_fichero():
    '''
    Esta función solicita el fichero y evalúa si es correcto
    En caso de que sea correcto, devuelve el fichero introducido
    '''
    fichero = input('Introduzca el nombre del fichero: ')
    if os.path.isfile(fichero) == False:
        print('Error: el fichero no existe')
    else:
        return fichero

# Función para pedir la familia
def solicitud_familia(fichero):
    '''
    Se trata de una función que solicita la familia para buscar y comprobar en el fichero
    Requiere el fichero introducido y devuelto anteriormente
    Devuelve la correspondiente familia para la siguiente función
    '''
    familia = input('Introduzca el nombre de la familia: ')
    with open(fichero, 'rt') as mamiferos:
        mamiferos.readline()
        for linea in mamiferos:
            if familia in linea:
                return(familia)
            else:
                pass
        print('La familia introducida no se ha podido encontrar')
                
# Función para obtener resultados de las consultas en el fichero
def lectura_fichero(fichero, familia):
    '''
    En esta función, se lleva a cabo la búsqueda de especies cuya cría
    supera el 15% del peso de su madre
    Requiere el fichero y la familia introducidas anteriormente
    Devuelve los resultados con un determinado formato que hemos establecido
    '''
    with open(fichero, 'rt') as mamiferos:
        mamiferos.readline()
        for linea in mamiferos:
            if familia in linea:
                datos = linea.split(',')
                género = datos[2]
                especie = datos[3]
                peso_madre = float(datos[4])
                peso_cría = float(datos[5])
                if peso_cría > (0.15 * peso_madre):
                    print('{0}  \t {1}  \t {2}  \t\t {3}'.format(género, especie, peso_madre, peso_cría))

# Cuerpo del programa
fichero = apertura_fichero()
if fichero != None:
    familia = solicitud_familia(fichero)
    if familia != None:
        print('\nFamilia', familia)
        print('Género \t\t Especie\t \tPeso madre(g)\t Peso cría (g)')
        print('----------------------------------------------------------------')
        lectura_fichero(fichero, familia)
