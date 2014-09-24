#!/bin/bash
MAX_NUM=127
IFS=$'\n' # Para evitar problemas con los espacios
files=($(find $1))

# Check de argumentos
case $# in
0) dir=. 
	mode=1 ;;
1) dir=. 
	mode=$1 ;;
2) dir=$1 
	mode=$2 
	# Chequeo del modo elegido
	if (( "$mode" != 1 && "$mode" != 2 )); then
		echo "Argumento n invalido"
		exit 1
	fi
	;;
esac



# $1: char de entrada
function analyze {
	# Value: valor (int) del char, no supe hacerlo mejor
	# Temp: valor de retorno
	value=$(printf "%d" "'$1")
	local temp="?";
	if [[ "$value" -gt "$MAX_NUM" ]]
	then
		#printf "%d (%s) mayor que %d\n" $value $1 $MAX_NUM # Linea bugiada
		
		# ACCORDING TO UNICODE CHAR CODES
		case "$value" in
		"192" | "193" | "194" | "195" | "196" | "197" | "198")
			temp="A"
			;;
		"200" | "201" | "202" | "203")
			temp="E"
			;;
		"204" | "205" | "206" | "207")
			temp="I"
			;;
		"208")
			temp="D"
			;;
		"209")
			temp="N"
			;;
		"210" | "211" | "212" | "213" | "214" | "216")
			temp="O"
			;;
		"217" | "218" | "219" | "220")
			temp="U"
			;;
		"221")
			temp="Y"
			;;
		"223")
			temp="B"
			;;
		"224" | "225" | "226" | "227" | "228" | "229" | "230")
			temp="a"
			;;
		"231")
			temp="c"
			;;
		"232" | "233" | "234" | "235")
			temp="e"
			;;
		"236" | "237" | "238" | "239")
			temp="i"
			;;
		"240" | "242" | "243" | "244" | "245" | "246" | "248")
			temp="o"
			;;
		"241")
			temp="n"
			;;
		"249" | "250" | "251" | "252")
			temp="u"
			;;
		"253" | "255")
			temp="y"
			;;
		"199")
			temp="C"
			;;
		"252")
			temp="u"
			;;
		*)
			temp="-"
			;;
		esac
	else 
		if [ "$value" == "32" ]
		then
			temp="_"
		else
			temp="$1"
		fi
	fi
	echo $temp
}

# Cambia los nombres de los archivos
for file in $dir/*
do
	if test -d $file
	then
		echo "dir: $file"
		oldname=$file
		newname=$file
		
		changed=0
		
		for i in $(seq 0 $(expr length $oldname))
		# Se recorren los caracteres en el nombre en busca de algo extranio
			do
				# Char: char actual
				# New char: Char que reemplazara a un Char extranio en el nombre
				char=${oldname:$i:1}
				newchar=$(analyze $char)
				if [ "$newchar" != "$char" ]
				# Si el char de reemplazo es diferente al de entrada (habia char extranio)
				then
					# Index: indice ajustado para reemplazo
					index=$(($i+1));
					newname=$(echo $newname | sed "s/./$newchar/$index") # Se cambia el nombre en cuestion
					changed=1 # Flag de nombre cambiado
				fi
			done
		
		# Cambio de nombre
		case "$mode" in
		"1") 
			if (( "$changed" == 1 ))
			then
				echo "Directorio con caracter raro:"
				printf "%s" $dir/$oldname # Se muestran el nombre antiguo y el nuevo
			fi
			$0 $file 1
			;;
		"2") 
			if (( "$changed" == 1 ))
			then
				echo "Cambiando nombres:"
				printf "%s -> %s\n-----\n" $oldname $newname # Se muestran el nombre antiguo y el nuevo
				mv $oldname/ $newname/
				$0 $dir 2
			else
				$0 $file 2
			fi
			;;
		esac
	else
		if [ "$(basename $file)" != "*" ]
		then
			oldname=$(basename $file)
			newname=$(basename $file)
			changed=0
			echo "file: $dir/$oldname"
			
			for i in $(seq 0 $(expr length $oldname))
			# Se recorren los caracteres en el nombre en busca de algo extranio
				do
					# Char: char actual
					# New char: Char que reemplazara a un Char extranio en el nombre
					char=${oldname:$i:1}
					newchar=$(analyze $char)
					if [ "$newchar" != "$char" ]
					# Si el char de reemplazo es diferente al de entrada (habia char extranio)
					then
						# Index: indice ajustado para reemplazo
						index=$(($i+1));
						newname=$(echo $newname | sed "s/./$newchar/$index") # Se cambia el nombre en cuestion
						changed=1 # Flag de nombre cambiado
					fi
				done
			
			# Cambio de nombre
			case "$mode" in
			"1") 
				if (( "$changed" == 1 ))
				then
					echo "Archivo con caracter raro:"
					printf "%s\n" $dir/$oldname # Se muestran el nombre antiguo y el nuevo
				fi
				;;
			"2") 
				if (( "$changed" == 1 ))
				then
					echo "Cambiando nombres:"
					printf "%s -> %s\n-----\n" $dir/$oldname $dir/$newname # Se muestran el nombre antiguo y el nuevo
					if [[ -e "$dir/$newname" ]]; then
      					echo $newname exists. It will be writen as $newname"_"1
						mv $dir/$oldname $dir/"$newname"_1
					else
						mv $dir/$oldname $dir/$newname
					fi
				fi
				;;
			esac
		fi
	fi
done
