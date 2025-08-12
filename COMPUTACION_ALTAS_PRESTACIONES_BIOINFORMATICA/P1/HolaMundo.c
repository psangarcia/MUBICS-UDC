#include <stdio.h>
#include <omp.h>
   
int main(int argc, char * agrv[]){
  #pragma omp parallel num_threads(4)
  {
    int id = omp_get_thread_num();
    int numH = omp_get_num_threads();
    printf("Hola Mundo desde hilo %d de %d\n", id, numH);
  }
}   
