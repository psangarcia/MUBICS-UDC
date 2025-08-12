# EJERCICIO 3 BOLETÍN 4
# Función para determinar si una secuencia de bases corresponde al tipo especificado

def valida_secuencia(secuencia, tipo='ADN'):
    '''
    Determinación de la correspondencia de una secuencia de bases a un tipo especificado
    Requiere una secuencia de bases del conjunto {AGTCU} y, opcionalmente, un tipo de
    secuencia: 'ADN', 'ARN' o 'ADN/ARN'. La opción por defecto será 'ADN'.
    Devuelve True o False en función de la correspondencia
    '''
    conjunto=set(secuencia)
    
    if tipo == 'ADN':     # Se verifica si Timina está en la secuencia
            if {'T'} <= conjunto:
                return True
            else:
                return False
            
    if tipo == 'ARN':
            if {'U'} <= conjunto: # Se verifica si Uracilo está en la secuencia
                return True
            else:
                return False
        
    if tipo == 'ADN/ARN':    # Se verifica si Uracilo o Timina están presentes en la secuencia
            if {'U'} or {'T'} <= conjunto:
                return False
            else:
                return True
    
    
# Cuerpo del programa principal
secuencia = 'GTCATTTCCAC'
assert (valida_secuencia(secuencia) == True)

secuencia = 'ACUGACCCCGG'
assert (valida_secuencia(secuencia) == False)

secuencia = 'ACUUUCCCCGG'
assert (valida_secuencia(secuencia) != True)

secuencia = 'TATATAGAGCC'
assert (valida_secuencia(secuencia) != False)

secuencia = 'GCCGCGCGCGC'
assert (valida_secuencia(secuencia) != True)


