#include <stdio.h>
#include <stdlib.h>
#define MAX 5


extern int _minimo(int* arreglo, int len);
extern int _maximo(int* arreglo, int len);
extern int _sumatoria(int* arreglo,int len );

int minimoC(int* arreglo, int len);



int main(void)
{

    int arreglo [MAX] = {11,2,-10,0,1}; 
    //int arreglo [MAX] = {2,3,1,5,4};
    printf("ARREGLO: ");
    for(int i = 0; i<MAX; i++)
    {
        printf("%d ", arreglo[i]);
    }

    printf("\n\n MINIMO EN C: %d \n\n",minimoC(arreglo, MAX));
    printf("\n\n MINIMO ASM: %d \n", _minimo(arreglo, MAX));
    printf("\n\n MAXIMO ASM: %d \n", _maximo(arreglo, MAX));
    printf("\n\n SUMATORIA ASM: %d \n", _sumatoria(arreglo, MAX));


    return 0; 
}


int minimoC(int* arreglo, int len)
{

    int minimo = arreglo[0];

    for(int i=0; i<len; i++)
    {
        if(arreglo[i] < minimo)
            minimo = arreglo[i];
    }

    return minimo;

}