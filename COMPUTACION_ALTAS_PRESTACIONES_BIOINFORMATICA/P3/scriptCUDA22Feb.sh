#!/bin/bash
#SBATCH -N 1
#SBATCH -t 00:10:00
#SBATCH --error=/home/ulc/cursos/curso314/Sesion3/errorCUDA.txt
#SBATCH --output=/home/ulc/cursos/curso314/Sesion3/outputCUDA.txt
#SBATCH --gres=gpu
#SBATCH -p gpu-shared
#SBATCH --reservation=CAPB_22Feb_GPU

./HolaMundoCUDA
