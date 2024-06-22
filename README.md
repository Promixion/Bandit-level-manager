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
- **Listar todos los niveles y contraseñas**:
  ```bash
  ./bandit_automation.sh -l
  ```

- **Agregar una nueva contraseña para el nivel 5**:
  ```bash
  ./bandit_automation.sh -a 5
  ```

- **Eliminar la contraseña del nivel 3**:
  ```bash
  ./bandit_automation.sh -d 3
  ```

### Requisitos

- `sshpass`: Asegúrese de tener `sshpass` instalado en su sistema para que el script funcione correctamente.

### Instalación de sshpass

Para instalar `sshpass` en Ubuntu/Debian, use:

```bash
sudo apt-get install sshpass
```

### Contribuciones

Las contribuciones son bienvenidas. Si encuentra algún problema o tiene alguna mejora, no dude en abrir un issue o enviar un pull request.

### Licencia

Este proyecto está licenciado bajo la Licencia MIT.
