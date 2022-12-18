Desde la carpeta con los archivos del código fuente y el fichero de entrada


Generación del analizador mediante flex:
	
	flex codflex.l

Compilar:
		
	gcc abb.c errores.c tablaSimbolos.c lex.yy.c analizadorSintactico.c main.c -o ej -Wall

Ejecutar:
	En esa misma carpeta llamar al ejecutable generado adjuntándole el nombre del fichero de entrada .go
	
	./ej concurrentSum.go

