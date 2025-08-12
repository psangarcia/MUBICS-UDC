print('EJERCICIO 2, BOLETÍN 3')

# Secuencia de ARN
secuencia = input('Introducir una secuencia de ARN: ').upper()

# Recuento de codones de parada
codones_parada = secuencia.count('UAG')+secuencia.count('UAA')+secuencia.count('UGA')

# Determinación de presencia y cantidad de codones de parada
if codones_parada > 0:
    print('La secuencia {0} tendrá {1} codón/es de parada'.format(secuencia,codones_parada))
else:
    print('La secuencia introducida no presenta codones de parada')
                                                                                                

