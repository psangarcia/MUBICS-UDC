#       Análisis de Imágenes Biomédicas: Práctica 1
#   Máster en Bioinformática para las Ciencias de la Salud
#                       Curso 2021/2022
#                    Pedro Sánchez García

from matplotlib import pyplot as plt
import glob
import os
import numpy as np
import cv2
import skimage
from skimage import measure

# Importación de las imágenes del dataset proporcionado:
images = [(os.path.basename(file), cv2.imread(file,cv2.IMREAD_GRAYSCALE)) for file in glob.glob("dataset/*.*")]

# Implementación de la metodología planteada en las imágenes del dataset proporcionado:
print('Referencia de la clasificación del especialista y de la metodología: \n')
print('\t Clasificación Especialista \t Clasificación Metodología \n')
print('\t\t 1 - 1.5 \t\t\t Nivel bajo')
print('\t\t 1.5 - 2.5 \t\t\t Nivel medio')
print('\t\t 2.5 - 3 \t\t\t Nivel alto')

print('\n Resultados del biomarcador establecido: \n')
print('\n \t\t Imagen \t Biomarcador \n')
for element in images:
    nombre = element[0]
    imagen = element[1]
    imagen_rgb = cv2.cvtColor(imagen, cv2.COLOR_GRAY2RGB) # Conversión al espacio de color RGB y extracción de canales R y G
    imagen_r = imagen_rgb[:,:,0] 
    imagen_g = imagen_rgb[:,:,0] 

    # Umbralización Otsu y thres_tozero, con posterior apertura para eliminación de ruido:
    thr, dstOTSU = cv2.threshold(imagen_g,cv2.THRESH_OTSU, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU) 
    thr, dst31 = cv2.threshold(dstOTSU, 100, 255, cv2.THRESH_TOZERO) 
    dst3 = cv2.morphologyEx(dst31, cv2.MORPH_OPEN, np.ones((5,5)))

    # Extracción del mayor área en la imagen resultante de la etapa anterior con scikit-image:
    labels_mask = measure.label(dst3)                       
    regions = measure.regionprops(labels_mask)
    regions.sort(key=lambda x: x.area, reverse=True)
    if len(regions) > 1:
        for rg in regions[1:]:
            labels_mask[rg.coords[:,0], rg.coords[:,1]] = 0
    labels_mask[labels_mask!=0] = 1
    mask = labels_mask # Esta máscara contiene la región de la conjuntiva bulbar de interés

    # Filtro de medianas sobre el canal G con tamaño 7:
    median = cv2.medianBlur(imagen_g, 7)

    # Umbralización adaptativa en canal G para la segmentación y tratar la luminosidad variable en las imágenes:
    adaptThr = cv2.adaptiveThreshold(median, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 21, 5)

    # Aplicación de bottom hat (tamaño: 15):
    kernel = np.ones((15,15), np.uint8)
    bottom = cv2.morphologyEx(adaptThr, cv2.MORPH_BLACKHAT, kernel)

    # Producto del resultado de la imagen resultante por la máscara generada anteriormente:
    región_final = bottom * mask

    # Cálculo del biomarcador planteado:
    mask_binary = mask.astype(np.uint8)
    región_final = región_final.astype(np.uint8)

    mask_binary = cv2.adaptiveThreshold(mask_binary, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 21, 5)
    región_final_binary = cv2.adaptiveThreshold(región_final, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 21, 5)
    pixeles_blancos = np.sum(región_final == 255)
    pixeles_blancos_mask = np.sum(mask_binary == 255)

    biomarcador = (pixeles_blancos/ pixeles_blancos_mask)*100

    # Se muestran los resultados correspondientes al biomarcador:
    print('\t\t {0} \t {1}'.format(nombre, round(biomarcador,1)))

    # Se muestra un plot con los resultados alcanzados en fases representativas de la metodología:
    f, axarr = plt.subplots(1,3)
    axarr[0].imshow(imagen_rgb, cmap='gray')
    axarr[0].set_title(nombre)
    axarr[1].imshow(mask, cmap='gray')
    axarr[1].set_title('Máscara obtenida')
    axarr[2].imshow(región_final, cmap='gray')
    axarr[2].set_title('Región de interés con vasos segmentados')
    axarr[2].set_xlabel('Biomarcador: {0}'.format(round(biomarcador,1)))
    plt.show()
