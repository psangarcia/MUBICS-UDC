# EJERCICIO 3 BOLETÍN 5

# Se plantea la siguiente función para procesar el fichero y generar la tabla en formato solicitado

def apertura_fichero():
    '''
    Se abre el fichero titanic.csv y se determinan
    supervivientes y fallecidos en cada clase.
    Se devuelven los valores determinados en cada caso
    '''
    vivos_1 = fallecidos_1 = vivos_2 = fallecidos_2 = vivos_3 = fallecidos_3 = 0
    with open('titanic.csv', 'rt') as fichero:
        fichero.readline()
        for linea in fichero:
            datos = linea.split(';')
            supervivencia = int(datos[0])
            clase = int(datos[1])
            if clase == 1:
                if supervivencia == 1:
                    vivos_1 += 1
                elif supervivencia == 0:
                    fallecidos_1 += 1
            total_1 = vivos_1 + fallecidos_1
            if clase == 2:
                if supervivencia == 1:
                    vivos_2 += 1
                elif supervivencia == 0:
                    fallecidos_2 += 1
            total_2 = vivos_2 + fallecidos_2
            if clase == 3:
                if supervivencia == 1:
                    vivos_3 += 1
                elif supervivencia == 0:
                    fallecidos_3 += 1
            total_3 = vivos_3 + fallecidos_3
        supervivientes_totales = vivos_1 + vivos_2 + vivos_3 
        fallecidos_totales = fallecidos_1 + fallecidos_2 + fallecidos_3
        totales = supervivientes_totales + fallecidos_totales
    return fallecidos_1, vivos_1, fallecidos_2, vivos_2,fallecidos_3, vivos_3, supervivientes_totales,fallecidos_totales, totales, total_1, total_2, total_3  

# Se plantean las siguientes funciones para generar los ficheros CSV y txt respectivamente

def creación_ficheroCSV():
    '''
    Se obtienen datos del titanic.csv para los rangos de edad correspondientes
    Devuelve el fichero CSV correspondiente a los rangos de edad con un formato establecido
    '''
    rango_1 = rango_2 = rango_3 = 0
    with open('titanic.csv', 'rt') as fichero:
        fichero.readline()
        for linea in fichero:
            datos = linea.split(';')
            supervivencia = int(datos[0])
            edad = float(datos[4])
            if supervivencia == 1:
                if edad <= 10:
                    rango_1 += 1
                if edad > 10 and edad <= 50:
                    rango_2 += 1
                if edad > 50 and edad <= 100:
                    rango_3 += 1
    nombrefichero = 'rangos.csv' 
    import csv
    import os
    if os.path.isdir('./resultados/') == False:
        os.mkdir('resultados')
    os.chdir('resultados')
    with open(nombrefichero, 'wt') as fichero:
        fichero.write('Rango_edad' + ';' + 'número' + '\n' + '0-10' + ';' + str(rango_1) + '\n' + '10-50' + ';' + str(rango_2) + '\n' + '50-100' + ';' + str(rango_3) + '\n')
    return fichero
        
def creación_txt ():
    '''
    Se obtienen datos del titanic.csv dada una cantidad solicitada por teclado
    Devuelve el fichero txt correspondiente con la lista de nombres que cumplen condición
    '''
    cantidad_pedida = float(input('Introduzca la cantidad: '))
    ficherotxt = 'nombres.txt'
    lista = []
    import os
    os.chdir('..')
    with open('titanic.csv', 'rt') as fichero:
        fichero.readline()
        for linea in fichero:
            datos = linea.split(';')
            supervivencia = int(datos[0])
            nombre = datos[2]
            cantidad = float(datos[5])
            if supervivencia == 0:
                if cantidad > cantidad_pedida:
                    lista.append(nombre)
    os.chdir('resultados')
    with open(ficherotxt, 'wt') as txt:
        for i in lista:
            txt.writelines(i + '\n')
    return txt

# Cuerpo del programa
fallecidos_1, vivos_1, fallecidos_2, vivos_2,fallecidos_3, vivos_3, supervivientes_totales,fallecidos_totales, totales, total_1, total_2, total_3  = apertura_fichero()
print('\t\tClase \nSuperv.\t 1\t 2\t 3\tTotal')
print('No\t {0}\t {1}\t {2}\t {3}'.format(fallecidos_1, fallecidos_2, fallecidos_3, fallecidos_totales))
print('Sí\t {0}\t {1}\t {2}\t {3}'.format(vivos_1, vivos_2, vivos_3, supervivientes_totales))
print('Total\t {0}\t {1}\t {2}\t {3}'.format(total_1, total_2, total_3, totales))
print('\n---------------------------------------')
creación_ficheroCSV()
creación_txt()
