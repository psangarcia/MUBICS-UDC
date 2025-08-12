# BA5E

import Bio
from Bio import pairwise2
from Bio import SeqIO
from Bio.Align import substitution_matrices
from Bio.pairwise2 import format_alignment

secuencia1 = SeqIO.read("S_original.fasta", "fasta")
secuencia2 = SeqIO.read("S_omicron.fasta", "fasta")
matrix = substitution_matrices.load("BLOSUM62")

for a in pairwise2.align.globalds(secuencia1.seq, secuencia2.seq, matrix, open=-5, extend=-5):
    resultado = format_alignment(*a)

print(resultado)
