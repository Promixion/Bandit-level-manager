## Bandit Script

### Descripción

Este script de Bash automatiza la interacción con el juego Bandit de OverTheWire mediante la gestión de conexiones SSH y el almacenamiento de contraseñas de nivel. Bandit es un juego de seguridad donde los jugadores progresan a través de diferentes niveles resolviendo desafíos de seguridad informática. Este script facilita la conexión a los niveles y la gestión de contraseñas obtenidas, permitiendo al usuario concentrarse en resolver los desafíos.

### Funcionalidades

- **Conexión a niveles de Bandit**: Conéctese fácilmente a cualquier nivel especificado usando la opción `-c`.
- **Almacenamiento de contraseñas**: Almacena de manera segura las contraseñas obtenidas en un archivo local para un fácil acceso.
- **Listado de niveles completados**: Muestra una lista de todos los niveles y sus contraseñas almacenadas usando la opción `-l`.
- **Agregar nuevos niveles**: Permite agregar manualmente nuevas contraseñas para niveles específicos con la opción `-a`.
- **Eliminar niveles**: Facilita la eliminación de contraseñas de niveles específicos usando la opción `-d`.
- **Panel de ayuda**: Proporciona información sobre el uso del script con la opción `-h`.

### Uso

```bash
./bandit.sh [opciones]

Opciones:
  -h        Mostrar este panel de ayuda.
  -c <num>  Conectarse al nivel especificado de Bandit (por ejemplo, -c 7).
  -l        Listar todos los niveles y contraseñas almacenadas.
  -a <num>  Agregar una nueva contraseña para el nivel especificado (por ejemplo, -a 5).
  -d <num>  Eliminar la contraseña del nivel especificado (por ejemplo, -d 3).
```

### Ejemplos

- **Conectar al nivel 7**:
  ```bash
  ./bandit.sh -c 7
  ```

- **Listar todos los niveles y contraseñas**:
  ```bash
  ./bandit.sh -l
  ```

- **Agregar una nueva contraseña para el nivel 5**:
  ```bash
  ./bandit.sh -a 5
  ```

- **Eliminar la contraseña del nivel 3**:
  ```bash
  ./bandit.sh -d 3
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
