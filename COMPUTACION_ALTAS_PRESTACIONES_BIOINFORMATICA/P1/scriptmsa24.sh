#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 24
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso314/error24.txt
#SBATCH --output=/home/ulc/cursos/curso314/output24.txt

./msaprobs /home/ulc/cursos/curso314/Sesion1/ConjuntosPrueba/BB1101*.tfa -num_threads 24 -o 24hilos.txt


