#include <stdlib.h>
#include <stdio.h>



#include "abb.h"
#include "definiciones.h"
#include "lex.yy.h"

//Función para iniciar el análisis sintáctico
void iniciarAnalisis(){
    //declaramos elemento co que traballaremos, de momento vacío
    tipoelem e;
    e.lexema=NULL;
    //Comezo bucle productor-consumidor
    do{
        //Pedimos siguiente componente léxico
        e= sigComponenteLexico();
        if(e.num == 0){
            printf("\nSe alcanzó el fin de fichero.\n\n");
        }
        else{
            printf("<%s,%d>\n",e.lexema,e.num);
        }
        //Si non é un identificador liberamos a memoria do lexema
        //no caso dos identificadores xa se libera ao destruir a tabla de símbolos
        if(e.lexema!=NULL && e.num!=ID_ && (e.num>309||e.num<300)){
            free(e.lexema);
        }
    }while(e.num!=0);
    //Fin análisis
}
