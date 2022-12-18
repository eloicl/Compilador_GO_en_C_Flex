#ifndef LEX_H
#define LEX_H
#include "abb.h"
#include "tablaSimbolos.h"
//Función para inicializar el analizador léxico, pasándole la tabla de símbolos creada en main
//y el fichero a abrir
void InicializarLexico(tablaSimbolos tabla,char* archivo);

//Función que permite al analizador sintáctico solicitar el siguiente componente léxico
tipoelem sigComponenteLexico();

//Función para finalizar el análisis y cerrar el fichero
void cerrar();

#endif	
