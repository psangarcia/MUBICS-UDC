## G7: Cristian Morillo Losada | Pedro Sánchez García

# Pregunta 6:

#coding=utf8
from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("p6_practica2_ICDAD").setMaster("local[8]")
sc=SparkContext.getOrCreate(conf=conf)

def fitting_alignment(v, w):
    v = "-" + v
    w = "-" + w
    indel_penalty=1
    score_mat = [[0 for _ in range(len(w))] for _ in range(len(v))]
    backtrack_mat = [[None for _ in range(len(w))] for _ in range(len(v))]
    for i in range(1, len(v)):
        for j in range(1, len(w)):
            score1 = score_mat[i - 1][j - 1] + (1 if v[i] == w[j] else - 1)
            score2 = score_mat[i - 1][j] - indel_penalty
            score3 = score_mat[i][j - 1] - indel_penalty
            score_mat[i][j] = max(score1, score2, score3)
            if score_mat[i][j] == score1:
                backtrack_mat[i][j] = "d"
            elif score_mat[i][j] == score2:
                backtrack_mat[i][j] = "u"
            elif score_mat[i][j] == score3:
                backtrack_mat[i][j] = "l"
    j = len(w) - 1
    i = max(enumerate([score_mat[row][j] for row in range(len(w) - 1, len(v) - 1)]), key=lambda x: x[1])[0] + len(w) - 1
    max_score = score_mat[i][j]
    aligned_1 = aligned_2 = ""
    while backtrack_mat[i][j] is not None:
        direction = backtrack_mat[i][j]
        if direction == "d":
            aligned_1 = v[i] + aligned_1
            aligned_2 = w[j] + aligned_2
            i -= 1
            j -= 1
        elif direction == "u":
            aligned_1 = v[i] + aligned_1
            aligned_2 = "-" + aligned_2
            i -= 1
        else:
            aligned_1 = "-" + aligned_1
            aligned_2 = w[j] + aligned_2
            j -= 1
    return max_score, aligned_1, aligned_2

cadena = 'TAATCCGGACAATATTAGTGATATAGGGGGTCGTCTCGTGCTGTCAAAATCGGGGTCGGGAGTCATAATGGTGTACGGTGTGATTGACCGAACCTCCGTCCTATCCCCCTCCCACAAGGAGCGCACTTTGCGAATCTACCACGCGTTAGAGCGCGTCGCACCACATCACCGACAACCCGGCGCCGAGCCTAGAGAAAACGGCTCTAGACGCAGGACGACTAATCGAATTAGAAAAATGTCCCATATGAGCGAGTTTAACTGTGGTGTTAGAAGTCTCAACAGAGACTCATCATCTCCACATGCTCCAATACGCACCGATGATCATGAGGCGTGGCTTCACCCTTTACACTTGCCGTGTTATTGAGATAGGGGATAGCATAACCGGACCCTAAGGATGGCCTATAGACGAATTGATCCTTTTAATGTTCAGGGTACGTCGGGTGCCGAGTTCTCTATCCATGGAGCTGGCGAACAGATCACTTCTGTAAATTCGGTACCTG'

rdddataset=sc.textFile("hdfs://localhost:9000/p5/sequencesRDD.txt")

### Función auxiliar obtenida de stackoverflow para transformación eficiente de str a tupla:
def conversion(c):
    c=eval(c)
    return c

rddprocesado=rdddataset.map(lambda w: conversion(w))

tupla=rddprocesado.map(lambda w: (w[0], fitting_alignment(w[1], cadena)))

rddmax=tupla.map(lambda x: x).max(lambda s: s[1][0])

rddmin=tupla.map(lambda x: x).min(lambda s: s[1][0])

### Salida con la información correspondiente:
print("El score más alto se logra con {0} es {1} con cadena 1: {2} \n\n y cadena 2: {3} \n\n El score más bajo con {4} es {5} con cadena 3: {6} \n\n y cadena 4: {7}".format(rddmax[0],rddmax[1][0], rddmax[1][1],rddmax[1][2],rddmin[0],rddmin[1][0], rddmin[1][1],rddmin[1][2]));

sc.stop()
exit()
