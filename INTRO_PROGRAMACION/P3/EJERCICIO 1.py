print('EJERCICIO 1, BOLETÍN 3')

print('\nConvertidor de centímetros a kilómetros, metros y centímetros')

# Solicitud de una distancia en centímetros
distancia = float(input('Introduzca una distancia en centímetros: '))

# Cálculos correspondientes de kilometros, metros y centímetros

km = distancia // 100000

m = (distancia % 100000) // 100

cm = distancia % 100

# Se establecen las sentencias selectivas para mostrar los resultados según corresponda

if km !=0 and m !=0 and cm !=0:
    print('{0} centímetros son {1} km, {2} cm y {3} cm'.format(distancia,km,m,cm))

if km !=0 and m !=0 and cm ==0:
    print('{0} centímetros son {1} km y {2} m'.format(distancia,km,m))

if km !=0 and m ==0 and cm !=0:
    print('{0} centímetros son {1} km y {2} cm'.format(distancia,km,cm))

if km !=0 and m ==0 and cm ==0:
    print('{0} centímetros son {1} km'.format(distancia,km))

if km ==0 and m ==0 and cm ==0:
    print('Debe introducirse una distancia con valor superior')

if km ==0 and m !=0 and cm !=0:
    print('{0} centímetros son {1} m y {2} cm'.format(distancia,m,cm))

if km ==0 and m ==0 and cm !=0:
    print('{0} centímetros son {1} cm'.format(distancia, cm))

if km ==0 and m !=0 and cm ==0:
    print('{0} centímetros son {1} m'.format(distancia,m))


