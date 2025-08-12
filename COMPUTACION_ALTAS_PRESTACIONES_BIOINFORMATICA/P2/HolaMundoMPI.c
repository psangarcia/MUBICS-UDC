#include "mpi.h"
#include "stdio.h"

int main (int argc, char *argv[]){
	// Inicializa MPI
	MPI_Init(&argc,&argv);

	// Recoge el numero de procesos
	int numP, myId;
	MPI_Comm_size(MPI_COMM_WORLD, &numP);

	// Coge el ID del proceso
	MPI_Comm_rank(MPI_COMM_WORLD, &myId);

	// Cada proceso imprime Hola
	printf("Proceso %d de %d: Hola Mundo!\n", myId, numP);

	// Terminata MPI
	MPI_Finalize();
	return 0;
}
