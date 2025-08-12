# EJERCICIO 1 BOLETÍN 4
# Función para devolver una cadena ordenada como resultado de concatenar dos cadenas, eliminando letras repetidas

def mas_larga(cad1, cad2):
    '''
    Generación de cadena ordenada tras concatenación y eliminación de letras repetidas
    Requiere dos cadenas(sólo contienen letras)
    Devuelve una nueva cadena ordenada
    '''
    cadenas_unidas = cad1+cad2
    separación_cadenas = set(cadenas_unidas)
    nueva_cadena = ''.join(sorted(separación_cadenas))
    return(nueva_cadena)
    
    
    
# Cuerpo del programa principal
cad1 = 'aaccb'
cad2 = 'xyzzz'
assert (mas_larga(cad1, cad2) == 'abcxyz')

cad1 = 'zazz'
cad2 = 'xyza'
assert (mas_larga(cad1, cad2) == 'axyz')

cad1 = 'zzxa'
cad2 = 'zzxb'
assert (mas_larga(cad1, cad2) != 'axzb')

cad1 = 'xazy'
cad2 = 'befw'
assert (mas_larga(cad1, cad2) != 'aebfxywz')

cad1 = 'xyac'
cad2 = 'apqx'
assert (mas_larga(cad1, cad2) != 'acpxq')


