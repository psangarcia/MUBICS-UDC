# BA5G

import Bio
from Bio import SeqIO
from Bio import pairwise2
from Bio.Align import substitution_matrices
from Bio.pairwise2 import format_alignment

secuencia1 = open("S_original.fasta").read()
secuencia2 = open("S_omicron.fasta").read()

for a in pairwise2.align.globalms(secuencia1, secuencia2, 0, -1, open=-1, extend=-1):
    resultado = format_alignment(*a)

print(resultado)
