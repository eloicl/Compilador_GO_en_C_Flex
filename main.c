#include <stdlib.h>
#include <stdio.h>
#include "lex.yy.h"
#include "abb.h"
#include "tablaSimbolos.h"
#include "definiciones.h"
#include "analizadorSintactico.h"



int main(int argc, char *argv[]){
    if(argc!=2){
        printf("Número de parámetros inválido, debe introducir el nombre del fichero de entrada.\n");
        exit(1);
    }
    //Declaramos variable del tipo tabla de simbolos, de momento a null
    tablaSimbolos tabla=NULL;
    //Inicializamos tabla
    inicializarTabla(&tabla);
    //Imprimimos estado inicial da tabla
    printf("\nTABLA DE SIMBOLOS\n");
    ImprimirTabla(tabla);
    printf("\n\n");

    //Inicializamos o analizador léxico
    InicializarLexico(tabla,argv[1]);
    //Iniciamos o analizador sintáctico, que comenzará a pedir componentes léxicos ao analizador léxico
    iniciarAnalisis();

    //Imprimimos estado final tabla de símbolos
    printf("\nTABLA DE SIMBOLOS\n");
    ImprimirTabla(tabla);
    printf("\n\n");
    //Liberamos a memoria da tabla
    destruirTabla(&tabla);
    tabla=NULL;
    //cerramos o fichero de entrada
    cerrar();
    
}