#include <stdio.h> 

__global__ void hello_kernel() {

    // calculate global thread identifier, note blockIdx.x=0 here
    const int thid = blockDim.x*blockIdx.x + threadIdx.x;

    // print a greeting message
    printf("Hola desde hilo %d!\n", thid);
}

int main (int argc, char * argv[]) {

    // set the ID of the CUDA device
    cudaSetDevice(0);

    // invoke kernel using 16 threads executed in 1 thread block
    hello_kernel<<<1, 16>>>();

    // synchronize the GPU preventing premature termination
    cudaDeviceSynchronize();
}
