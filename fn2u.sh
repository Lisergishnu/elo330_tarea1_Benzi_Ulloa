#!/bin/bash

workingDir="";
option=0;
if (( $# > 2 )); then
  echo "Usage: $0 [directory] [n]";
  exit 1
elif (( $# == 0 )); then
  #Default sin opciones
  #Solo analisis en directorio actual
  workingDir="";
  option=1;
elif (( $# == 1 )); then
  #Analisis en directorio especificado
  workingDir=$1;
  option=1;
else
  workingDir=$1;
  option=$2;
fi

#Analisis y/o operacion en $1
if (( $option == 1 )); then
  #echo Solo analisis en $workingDir;
  ls -F -d1 $PWD/$workingDir/** | sed -n '/[áéíóúÁÉÍÓÚÑñ ]/p'
  exit $? #Regresa el retorno de la operacion anterior
elif (( $option == 2 )); then
  #echo Analisis y operacion en $workingDir;
  ls $workingDir | sed -n '/[áéíóúÁÉÍÓÚÑñ ]/p' > /tmp/op$$
  #Transformar:
  while read archivo; do
    archivoSano="$(echo $archivo | sed 'y/áéíóúÁÉÍÓÚÑñ /aeiouAEIOUNn_/')"
    #echo Cambiando nombre de $archivo a $archivoSano
    if [[ -e "$workingDir/$archivoSano" ]]; then
      echo $archivoSano exists. It will be writen as $archivoSano"_"1
      mv "$workingDir/$archivo" "$workingDir"/"$archivoSano"_1
    else
      mv "$workingDir/$archivo" "$workingDir/$archivoSano"
    fi
  done < /tmp/op$$
  rm /tmp/op$$
  exit $?
else
  echo ERROR: Option unspecified: $option;
  exit 1
fi
