## G7: Cristian Morillo Losada | Pedro Sánchez García
## Script Spark de la práctica 2 de ICDAD:

# Pregunta 3. Paralelización con 1,2,4 y 8 workers:

from pyspark import SparkContext, SparkConf
conf = SparkConf().setAppName("p3_2_workers").setMaster("local[2]") # 2 workers
sc = SparkContext(conf=conf)

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

rdddataset=sc.textFile('/media/sf_PR_ICDAD/Materiales_parte2/dataset.txt')

rddmax=rdddataset.map(lambda w: fitting_alignment(w, cadena)).max(lambda s: s[0])

rddmin=rdddataset.map(lambda w: fitting_alignment(w, cadena)).min(lambda s: s[0])

print("El score más alto es {0} con cadena 1: {1} \n\n y cadena 2: {2} \n\n El score más bajo es {3} con cadena 3: {4} \n\n y cadena 4: {5}".format(rddmax[0],rddmax[1], rddmax[2],rddmin[0],rddmin[1], rddmin[2]));

sc.stop()
