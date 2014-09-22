Tarea 1 Programación de Sistemas
================================

Nombre
------

	fn2u.sh -- Analiza y/o corrige nombre de archivos o carpetas con carácteres acentuados, eñes y espacios en blanco

Sinopsis
--------

	fn2u.sh [directorio] [n]

Descripción
-----------

Para [n] omitido o equivalente a 1, el programa revisa el directorio especificado por archivos o carpetas con nombres conflictivos para POSIX. Si se omite [directorio] y [n] se asume que es el directorio local. 

En particular *fn2u* realiza un enlistado de archivos y luego los filtra contra la expresión regular:

	/[áéíóúÁÉÍÓÚÑñ ]/

Si se especifica [directorio], y [n] equivalente a 2, *fn2u* cambia el nombre de cada archivo que haya pasado la expresion regular anterior a un conjunto sanitizado de carácteres equivalentes:

	sed 'y/áéíóúÁÉÍÓÚÑñ /aeiouAEIOUNn_/'  

Ejemplos
--------

La siguiente línea enlista todo los elementos conflictivos en la carpeta actual

	$ fn2u.sh

Para cambiar todos los elementos conflictivos de la carpeta actual

	$ fn2u.sh . 2

Retorno
-------

*fn2u* retorna 0 si no tuvo problemas, y > 0 en caso contrario.