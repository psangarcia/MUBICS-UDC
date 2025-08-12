#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso314/error4.txt
#SBATCH --output=/home/ulc/cursos/curso314/output4.txt

./msaprobs /home/ulc/cursos/curso314/Sesion1/ConjuntosPrueba/BB1101*.tfa -num_threads 4 -o 4hilos.txt

