#include <stdlib.h>
#include <stdio.h>
//Función que imprime la información del error producido
void ImprimirError(int codigo,int linea){
    switch(codigo){
        case 0:
            printf("\n==Error abriendo el archivo==\n\n");
            exit(1);
            break;
        case 1:
            printf("\n==Error de formato en el entero---Linea: %d==\n\n",linea);
            break;
        case 2:
            printf("\n==Error de formato en el float---Linea: %d==\n\n",linea);
            break;
        case 3:
            printf("\n==Error de formato en el string---Linea: %d==\n\n",linea);
            break;
        case 4:
            printf("\n==Error cerrando el archivo==\n\n");
            exit(1);
            break;
        case 5:
        	printf("\n==Error léxico---Linea: %d==\n\n",linea);
            break;
    }
}
