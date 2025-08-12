#!/bin/bash
#SBATCH -N 2
#SBATCH -n 4
#SBATCH -c 1
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso221/error.txt
#SBATCH --output=/home/ulc/cursos/curso221/output.txt
#SBATCH -p thinnodes

srun HolaMundoMPI

