# EJERCICIO 1 BOLETÍN 5

import os

# Función para solicitar y evaluar si el fichero es correcto
def apertura_fichero():
    '''
    Verifica la existencia del fichero
    Si es correcto, el fichero se devuelve
    '''
    fichero = input('Introduzca el nombre del fichero: ')
    if os.path.isfile(fichero) == False:
        print('El fichero no existe. Vuelva a intentarlo')
        fichero = input('Introduzca de nuevo el nombre del fichero: ')
    else:
        print('El fichero es correcto')
    return fichero

# Función para realizar recuento del número de secuencias
def recuento(fichero):
    '''
    Realización del recuento de número de secuencias en el fichero de análisis
    Requiere el fichero cuya existencia se ha verificado con la anterior función
    Devuelve un número entero correspondiente al número de secuencias determinado
    '''
    with open(fichero, 'tr') as fichero_FASTA:
        número_secuencias = 0
        lineas = fichero_FASTA.readlines()
        for linea in lineas:
            if linea.startswith('>'):
                número_secuencias += 1
        return número_secuencias


# Función para realizar el recuento del total de bases y de cada una de ellas (A, T, C y G) en el fichero
def recuento_bases(fichero):
    '''
    Realización del recuento total de bases y de cada una de ellas en el fichero
    Requiere el fichero cuya existencia se ha verificado con la función apertura_fichero()
    Devuelve un número entero correspondiente al número total de bases y un diccionario con el recuento
    de cada una de ellas
    '''
    recuento_bases = {'A':0, 'T':0, 'C':0, 'G':0}
    with open(fichero, 'tr') as fichero_FASTA:
        lineas = fichero_FASTA.readlines()
        for linea in lineas:
            if linea.startswith('>'):
                pass
            elif len(linea) > 0:
                recuento_bases['A'] += linea.count('A')
                recuento_bases['T'] += linea.count('T')
                recuento_bases['C'] += linea.count('C')
                recuento_bases['G'] += linea.count('G')
        bases = recuento_bases['A']+recuento_bases['T']+recuento_bases['C']+recuento_bases['G']
    return recuento_bases,bases


# Cuerpo del programa
fichero= apertura_fichero()
número_secuencias = recuento(fichero)
recuento_bases,bases = recuento_bases(fichero)
print('Fichero FASTA:\n{0} secuencias \n{1} bases {2}'.format(número_secuencias, bases,recuento_bases))


