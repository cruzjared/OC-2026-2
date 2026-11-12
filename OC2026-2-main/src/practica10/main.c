#include <stdio.h>
#include <time.h>
#include <stdlib.h>

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);
void updateTemp(int* temps);
void updateFlags(int* temps, int* last_temps, unsigned char *flags);


int main (void)
{
    srand(time(NULL));

    unsigned char valor = 100;
    set_bit(&valor, 0); 
    printf("\n numero: %d \n", valor); 
    printf("\n el valor del bit 6 es de: %d \n", get_bit(valor, 6));




    return 0; 
}



void updateTemp(int* temps)
{



}
void updateFlags(int* temps, int* last_temps, unsigned char *flags)
{



}