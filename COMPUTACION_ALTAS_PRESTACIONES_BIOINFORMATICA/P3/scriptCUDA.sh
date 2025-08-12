#!/bin/bash
#SBATCH -N 1
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso200/error.txt
#SBATCH --output=/home/ulc/cursos/curso200/output.txt
#SBATCH --gres=gpu
#SBATCH -p gpu-shared

./HolaMundoCUDA

