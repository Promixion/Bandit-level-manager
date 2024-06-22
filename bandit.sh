#!/bin/bash

# Script de bash que automatiza juego de bandit de OverTheWire (gestionar conexiones por protocolo SSH y almacenar claves)

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Gestionar salida
function ctrl_c(){
  echo -e "\n\n${redColour}[+] Saliendo...${endColour}\n"
  exit 1
} 

trap ctrl_c INT

# Panel de ayuda
function helpPanel(){
  echo -e "\n${greenColour}[+]${endColour}${grayColour} Modo de uso:${endColour}\n"
  echo -e "\t${greenColour}[i]${endColour}${grayColour} Para conectarse a un determinado nivel de bandit utilice${endColour}${blueColour} -c${endColour}${yellowColour} (EX: $0 -c 7).${endColour}"
  echo -e "\t${greenColour}[i]${endColour}${grayColour} Para listar los niveles completados utilice${endColour}${blueColour} -l${endColour}"
  echo -e "\t${greenColour}[i]${endColour}${grayColour} Para agregar un nuevo nivel y password utilice${endColour}${blueColour} -a${endColour}${yellowColour} (EX: $0 -a 5)${endColour}"
  echo -e "\t${greenColour}[i]${endColour}${grayColour} Para eliminar un nivel y password utilice${endColour}${blueColour} -d${endColour}${yellowColour} (EX: $0 -d 3)${endColour}"
}

# Almacena claves al ganar nivel
function storePass(){
  level=$1
  password=$2
  echo -e "bandit$level: $password" >> .bandit_pass && echo -e "${yellowColour}[+]${endColour}${greenColour} Clave almacenada exitosamente.${endColour}"
}

# Gestiona la conexion a bandit
function connectLevel(){
  level=$1 
  checker=$(cat .bandit_pass | grep "bandit$level")
  if [ -f .bandit_pass ] && [ "$checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${greenColour} Se procedera a conectarse al nivel de bandit$level...${endColour}"
    pass_to_connect="$(cat .bandit_pass | grep bandit$level | awk 'NF{print $NF}')"
    if [ $pass_to_connect ]; then
      bash -c "(sshpass -p '$pass_to_connect' ssh bandit$level@bandit.labs.overthewire.org -p 2220)"
      clear
      echo -en "${yellowColour}[?]${endColour}${greenColour} Has conseguido la clave para el siguiente nivel (si/no)?:${endColour} " && read response; echo
      if [ $response == "si" ]; then
        level=$(($level+1))
        echo -en "\n${yellowColour}[+]${endColour}${greenColour} Introduce la clave para el nivel de bandit$level: ${endColour}" && read new_pass; echo 
        storePass $level $new_pass
        echo -en "\n${yellowColour}[+]${endColour}${greenColour} Desea continuar al nivel de bandit$level?(si/no): ${endColour}" && read continuar 
        if [ $continuar == "si" ]; then
          connectLevel $level
        else
          helpPanel
        fi
      else
        exit 1
      fi
    else
      echo -e "\n${redColour}[!] No hay una password disponible para ese nivel.${endColour}\n"
      helpPanel
    fi
  else
    touch .bandit_pass
    echo "bandit0: bandit0" > .bandit_pass
    connectLevel $level
  fi

}

# Lista niveles
function listLevels(){
  if [ -f .bandit_pass ]; then
    cat .bandit_pass | sort | while read line; do echo -e "${greenColour}$(echo $line | awk '{print $1}')${endColour}${purpleColour} $(echo $line | awk '{print $2}')${endColour}" ; done
  else
    echo -e "\n${redColour}[!] No hay claves de niveles para mostrar${endColour}"
  fi
}

# Agrega niveles nuevos
function addLevel(){
  level_to_add=$1
  echo -en "\n${greenColour}[+]${endColour}${grayColour} Introduzca la password para bandit$level_to_add: ${endColour}" && read password
  echo -e "bandit$level_to_add: $password" >> .bandit_pass
  echo -e "\n${greenColour}[+]${endColour}${grayColour} Password almacenada exitosamente.${endColour}"
}

# Eliminar nivel
function deleteLevel(){
  level=$1
  checker=$(cat .bandit_pass | grep "bandit$level")
  if [ -f .bandit_pass ] && [ "$checker" ]; then
    cat .bandit_pass | grep -v "bandit$level" | sort | sponge .bandit_pass
    echo -e "\n${redColour}[-]${endColour}${grayColour} Se ha eliminado el nivel de bandit$level exitosamente.${endColour}\n"
  else
    echo -e "\n${redColour}[!] No existe el nivel proporcionado en los datos almacenados.${endColour}\n"
  fi
}

# Chivato
declare -i flujo=0

# Declaracion de parametros
while getopts "lhc:a:d:" arg; do 
  case $arg in
    h) ;;
    c) nivel=$OPTARG ; let flujo+=1 ;;
    l) let flujo+=2 ;;
    a) level=$OPTARG ; let flujo+=3 ;;
    d) level=$OPTARG ; let flujo+=4 ;;
  esac 
done 2>/dev/null

# Control de flujo del programa
if [ $flujo -eq 0 ]; then
  helpPanel
elif [ $flujo -eq 1 ]; then
  connectLevel $nivel
elif [ $flujo -eq 2 ]; then
  listLevels
elif [ $flujo -eq 3 ]; then
  addLevel $level
elif [ $flujo -eq 4 ]; then
  deleteLevel $level
else
  echo -e "${redColour}\n\n[!] Opcion invalida.${endColour}"
  helpPanel
fi
