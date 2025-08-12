#!/bin/bash
#SBATCH -N 2
#SBATCH -n 4
#SBATCH -c 4
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso314/Sesion2/error4.txt
#SBATCH --output=/home/ulc/cursos/curso314/Sesion2/output4.txt
#SBATCH -p thinnodes

srun ./msaprobs-mpi BB1101*.tfa -num_threads 4 -o 2_nodos_4hilos.txt

