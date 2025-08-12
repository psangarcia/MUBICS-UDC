#       Análisis de Imágenes Biomédicas: Práctica 2
#   Máster en Bioinformática para las Ciencias de la Salud
#                       Curso 2021/2022
#                    Pedro Sánchez García

from matplotlib import pyplot as plt
import numpy as np
import cv2
import glob
import os

# Importación de las imágenes del dataset proporcionado:
images = [(os.path.basename(file), cv2.imread(file,cv2.IMREAD_GRAYSCALE)) for file in glob.glob("dataset/*.*")]
print('\t Imagen \t\t Distancia media \t Desviación estándar')

# Implementación de la metodología planteada en las imágenes del dataset proporcionado:
for element in images:
    nombre = element[0]
    i = element[1]
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(21,21)) # Ecualización local
    eq = clahe.apply(i)
    gaussian = cv2.GaussianBlur(eq, (21,17), 0) # Suavizado con filtro gaussiano
    canny = cv2.Canny(gaussian,20,90) # Filtro de Canny con umbrales mínimo/máximo de 20/90

    # Se muestra un plot con los resultados alcanzados en cada fase:
    f, axarr = plt.subplots(1,4)
    axarr[0].imshow(i, cmap='gray')
    axarr[0].set_title(nombre)
    axarr[1].imshow(eq, cmap='gray')
    axarr[1].set_title('Ecualización local')
    axarr[2].imshow(gaussian, cmap='gray')
    axarr[2].set_title('Filtro gaussiano')
    axarr[3].imshow(canny, cmap='gray')
    axarr[3].set_title('Canny')

    # Cálculo de las distancias entre la región anterior de la córnea y la región anterior de la lente:
    distancias = []
    for i in range (0,len(canny[0,:])):
        columna_canny = canny[:,i]
        blanco = np.where(columna_canny==255)
        distancia = blanco[0][4]-blanco[0][0]
        distancias.append(distancia)
        distancia_media = round(np.mean(distancias),2)
        std_distancia = round(np.std(distancias),2)
    print('\n \t {0} \t {1} \t\t\t {2}'.format(nombre, distancia_media, std_distancia))
    axarr[3].set_xlabel('Distancia: {0} ± {1}'.format(distancia_media, std_distancia))
    plt.show()
