#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define SENSORS 2

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);
void updateTemp(int* temps);
void updateFlags(int* temps, int* last_temps, unsigned char *flags);
void printFlag(unsigned char flags); 


int main (void)
{
    srand(time(NULL));
    int temps[SENSORS] = {25,25};
    int lastTemps[SENSORS] = {25,25};
    unsigned char flagsRegister[SENSORS] = {0b00000001,0b00000001};

   char c; 
   int opc; 
   
   do
   {
        system("clear");
        printf("\n SENSOR 1: ~%d °C ",temps[0]);
        printFlag(flagsRegister[0]);
        printf("\n SENSOR 2: ~%d °C ",temps[1]);
        printFlag(flagsRegister[1]);
        printf("\n\n MENU");
        printf("\n[1] Actualizar");
        printf("\n[2] Salir");
        printf("\n SELECCIONE OPCION: ");
        scanf("%d", &opc); 
        while ((c = getchar()) != '\n' && c != EOF);

        switch(opc)
        {

            case 1:
            updateTemp(temps);
            updateFlags(temps, lastTemps, flagsRegister);
            printf("\n\n valores actualizados");
            break;

            case 2:
            printf("Terminando...");
            break;

            default:
            printf("Opcion no valida");
            break;


        }

        printf("\n\n presione ENTER para continuar");
        c = getchar();
		
		if (c != '\n')
             while ((c = getchar()) != '\n' && c != EOF);
			
		



   }while(opc!=2); 



    return 0; 
}



void updateTemp(int* temps)
{
    int min = -5,max = 5;
	for(int i = 0 ; i < SENSORS; i++)
	{
		temps[i]+=rand() % (max - min + 1) + min;
	}



}
void updateFlags(int* temps, int* last_temps, unsigned char *flags)
{
    int resta = 0;
    for(int i = 0; i<SENSORS; i++)
    {
        flags[i] = 0;
        resta = temps[i]-last_temps[i];
        //si se mantuvo igual
        if(resta == 0)
            set_bit(&flags[i], 0);
        else
        {
            //si subio o bajo
            if(resta < 0)
            set_bit(&flags[i],4);
            else 
                set_bit(&flags[i], 5);

            //cuanto subio o bajo
            if(resta == 1 || resta == -1)
                set_bit(&flags[i], 1);
            else if(resta == 2 || resta == -2)
                set_bit(&flags[i],2);
            else
                set_bit(&flags[i],3);
        }
        
        last_temps[i] = temps[i];
    }

    

}


void printFlag(unsigned char flag)
{

    

    /*
    < : bajo un grado
    <<: bajo dos grados
    <<<: bajo +3 grados
    >: subio un grado
    >>: subio dos grados
    >>>: subio mas 3 grados
    
    
    */

    if(get_bit(flag, 0))
        printf("-");
    //diferencia de un grado
    else if(get_bit(flag,1))
    {
        //ver si diferencia + o -
        if(get_bit(flag,4))
            printf("<");
        else
            printf(">");
    }
    //diferencia de dos grados
    else if(get_bit(flag,2))
    {
        //ver si diferencia + o -
        if(get_bit(flag,4))
            printf("<<");
        else
            printf(">>");
    }
    //diferencia 3 grados
    else if(get_bit(flag,3))
    {
        //ver si diferencia + o -
        if(get_bit(flag,4))
            printf("<<<");
        else
            printf(">>>");
    }


}