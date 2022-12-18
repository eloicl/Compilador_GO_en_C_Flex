%{
#include <stdlib.h>
#include <stdio.h>
#include "abb.h"
#include "definiciones.h"
#include "tablaSimbolos.h"
#include "errores.h"


tablaSimbolos TablaSimbolos;

%}
%option nounput
%option noinput
%option noyywrap
%option yylineno


ESPACIO                       [ ]
SEPARADORES                     (\t|\r|{ESPACIO})+

NEWLINE                       \n
UNICODE_CHAR                  .
UNICODE_LETTER                [A-Za-z]
UNICODE_DIGIT                 [0-9]


LETTER                        {UNICODE_LETTER}|_
DECIMAL_DIGIT                 [0-9]
BINARY_DIGIT                  [0-1]
OCTAL_DIGIT                   [0-7]
HEX_DIGIT                     [0-9A-Fa-f]


SEMICOLON                     ;

COMENT_LIN                    \/\/.*
COMENT_G                      \/\*(.|{NEWLINE})*\*\/

IDENTIFIER                    {LETTER}({LETTER}|{UNICODE_DIGIT})*

OPERATORS                     [+*/%&|^<>=!~()[\]{}},.:-]|{SEMICOLON}
DOS_PTOSIGUAL                 :=
PICO_D_MENOS                  <-
MAS_IGUAL                     \+=

DECIMAL_DIGITS                  {DECIMAL_DIGIT}((_)?{DECIMAL_DIGIT})*
DECIMAL_LIT                     0|[1-9]((_)?{DECIMAL_DIGITS})?
BINARY_DIGITS                   {BINARY_DIGIT}((_)?{BINARY_DIGIT})*
BINARY_LIT                      0[bB]((_)?{BINARY_DIGITS})?
OCTAL_DIGITS                    {OCTAL_DIGIT}((_)?{OCTAL_DIGIT})*
OCTAL_LIT                       0[oO]((_)?{OCTAL_DIGITS})?
HEX_DIGITS                      {HEX_DIGIT}((_)?{HEX_DIGIT})*
HEX_LIT                         0[xX]((_)?{HEX_DIGITS})?
INT_LIT                         {DECIMAL_LIT}|{BINARY_LIT}|{OCTAL_LIT}|{HEX_LIT}
INT_ERROR                       0([1-9]*[xX]{HEX_DIGITS}*|[bB][2-9])

FLOAT_LIT                       {DECIMAL_DIGITS}\.({DECIMAL_DIGITS})?({DECIMAL_EXPONENT})?|{DECIMAL_DIGITS}{DECIMAL_EXPONENT}|\.{DECIMAL_DIGITS}({DECIMAL_EXPONENT})?
FLOAT_ERROR                     {DECIMAL_DIGITS}\.e|\.({DECIMAL_EXPONENT})
DECIMAL_EXPONENT                [eE][+-]?{DECIMAL_DIGITS}

IMAGINARY_LIT                   ({DECIMAL_DIGITS}|{INT_LIT}|{FLOAT_LIT})i

ESCAPED_CHAR                  \\[abfnrtv'"\\]
BYTE_VALUE                    {OCTAL_BYTE_VALUE}|{HEX_BYTE_VALUE}
OCTAL_BYTE_VALUE              \\{OCTAL_DIGIT}{3}
HEX_BYTE_VALUE                \\x{HEX_DIGIT}{2}
LITTLE_U_VALUE                \\u{HEX_DIGIT}{4}
BIG_U_VALUE                   \\U{HEX_DIGIT}{8}
UNICODE_VALUE                 {UNICODE_CHAR}|{LITTLE_U_VALUE}|{BIG_U_VALUE}|{ESCAPED_CHAR}

RAW_STRING_LIT                [`]({UNICODE_CHAR}|{NEWLINE})+[`]
INTERPRETED_STRING_LIT        ["]({UNICODE_VALUE}|{BYTE_VALUE})+["]
STRING_LIT                    {RAW_STRING_LIT}|{INTERPRETED_STRING_LIT}
STRING_ERROR                  (["]({UNICODE_VALUE}|{BYTE_VALUE}))|([`]({UNICODE_CHAR}|{NEWLINE}))



%%
{NEWLINE}                       
{SEPARADORES}                     
{COMENT_LIN}
{COMENT_G}  
{IDENTIFIER}                    return (ID_);
{STRING_LIT}                    return (STRING);
{INT_LIT}                       return (INT);
{FLOAT_LIT}                     return (FLOAT);
{IMAGINARY_LIT}                 return (IMAGIN);
{DOS_PTOSIGUAL}                 return (DOSPTOSIG);
{PICO_D_MENOS}                  return (PICODMENOS);
{MAS_IGUAL}                     return (MASIGUAL);
{OPERATORS}                     return ((int) *yytext);
{INT_ERROR}                     ImprimirError(1,yylineno);
{FLOAT_ERROR}                   ImprimirError(2,yylineno);
{STRING_ERROR}                  ImprimirError(3,yylineno);
.                                return (-1);
<<EOF>>                       {yyterminate();}

%%

//Función para inicializar el analizador léxico, pasándole la tabla de símbolos creada en main
//y el fichero a abrir
void InicializarLexico(tablaSimbolos tabla,char* archivo){
    TablaSimbolos=tabla;
    yyin = fopen(archivo, "r");
    //Si no se abrió correctamente imprimimos error
    if(yyin  == NULL){
        ImprimirError(0,0);
    } 
}





//Función que permite al analizador sintáctico solicitar el siguiente componente léxico
tipoelem sigComponenteLexico(){
    tipoelem resul;
    //extraemos componente léxico
    resul.num = yylex();
    //copiamos lexema
    resul.lexema = strdup(yytext);
    //Se é unha posible identificador consultamos a tabla de símbolos pasando a dirección da variable onde gardar o resultado da consulta
    if(resul.num == ID_) esPalabraReservada(&resul,&TablaSimbolos);
    else if(resul.num == -1) ImprimirError(5,yylineno);//Imprimimos error si componente léxico igual a -1 (no coincidencia)

    //devolvemos estructura
    return resul;
    
}
//Función para finalizar análisis y cerrar fichero de entrada
void cerrar(){
    //Cerramos fichero
    if(fclose(yyin)!=0){
        ImprimirError(4,0);
    }
    yylex_destroy();
}