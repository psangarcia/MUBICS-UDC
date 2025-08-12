# EJERCICIO 2 BOLETÍN 4
# Función para calcular el porcentaje de aminoácidos presentes en una lista por defecto en una secuencia

def porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']):
    '''
    Cálculo del porcentaje de aminoácidos de una lista por defecto en una secuencia
    Requiere una secuencia proteínica y una lista de aminoácidos por defecto
    como ['A','V','L','I','M','P','F','W']
    Devuelve un número entero correspondiente al porcentaje
    '''
    lista_porcentajes = list()
    suma = 0
    for i in lista_aminoácidos:
        suma += (int((secuencia.count(i)/len(secuencia)*100)))
    return suma
    
    
# Cuerpo del programa principal
secuencia = 'AVDIPMFWA'
assert (porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']) != 84)

secuencia = 'AVQQCNPPI'
assert (porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']) == 55)

secuencia = 'AAAAALVLV'
assert (porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']) != 90)

secuencia = 'AMMPFIAIA' # En este caso se comprueba que no devuelve este resultado
assert (porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']) == 75)

secuencia = 'AIPPFMIVA'
assert (porcentaje_amino(secuencia, lista_aminoácidos = ['A','V','L','I','M','P','F','W']) != 85)
