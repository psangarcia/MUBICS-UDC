#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso221/error.txt
#SBATCH --output=/home/ulc/cursos/curso221/output.txt

./HolaMundo

