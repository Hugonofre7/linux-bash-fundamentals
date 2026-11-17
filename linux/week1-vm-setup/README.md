# Semana 1: Diagnóstico del Sistema, Jerarquía y Flujos Estándar

Notas de laboratorio, comandos y procedimientos correspondientes al inicio del curso de Linux y Bash.

## Índice de Contenidos
- [Semana 1: Diagnóstico del Sistema, Jerarquía y Flujos Estándar](#semana-1-diagnóstico-del-sistema-jerarquía-y-flujos-estándar)
  - [Índice de Contenidos](#índice-de-contenidos)
    - [1. Diagnóstico del Sistema y Entorno](#1-diagnóstico-del-sistema-y-entorno)
    - [2. Creación y Filtrado de Archivos de Texto](#2-creación-y-filtrado-de-archivos-de-texto)
    - [3. Redirección de Flujos y Canales (`stdout` y `stderr`)](#3-redirección-de-flujos-y-canales-stdout-y-stderr)
    - [4. Permisos y Enlaces Simbólicos](#4-permisos-y-enlaces-simbólicos)
    - [5. Inspección Rápida de Archivos](#5-inspección-rápida-de-archivos)

---

### 1. Diagnóstico del Sistema y Entorno
* `uptime -p`: Muestra el tiempo de actividad del sistema de forma abreviada.
* `whoami`: Imprime el nombre del usuario actual en la sesión de terminal.
* `pwd`: Muestra la ruta absoluta del directorio de trabajo actual.
* `df -h /`: Informa sobre el espacio en disco disponible y utilizado en la partición raíz en formato legible (`-h`).

### 2. Creación y Filtrado de Archivos de Texto
* `cat << 'EOF' > archivo.conf`: Heredoc para escribir múltiples líneas directamente en un archivo. Las comillas simples en `'EOF'` evitan la expansión de variables.
* `cat archivo.conf`: Vuelca el contenido completo del archivo en la terminal.
* `grep -v "^#" archivo.conf`: Filtra el contenido omitiendo (`-v`) las líneas que empiezan con `#` (comentarios).

### 3. Redirección de Flujos y Canales (`stdout` y `stderr`)
* `ls archivo_inexistente.txt 2> error.log`: Envía únicamente el error estándar (`2>`) a un archivo de registro.
* `ls app_config.conf archivo_inexistente.txt > todo_junto.log 2>&1`: Combina la salida correcta (`stdout`) y los errores (`stderr`) en un solo archivo de log.

### 4. Permisos y Enlaces Simbólicos
* `chmod 600 app_config.conf`: Otorga permisos de lectura y escritura exclusivamente al usuario propietario (`u=rw`).
* `ln -s app_config.conf config_actual.conf`: Crea un enlace simbólico (`-s`) apuntando al archivo original sin duplicar espacio en disco.
* `ls -l config_actual.conf`: Permite verificar los detalles del enlace y su destino (`->`).

### 5. Inspección Rápida de Archivos
* `head -n 3 app_config.conf`: Muestra las primeras 3 líneas del archivo.
* `tail -n 2 app_config.conf`: Muestra las últimas 2 líneas del archivo.
* `wc -l app_config.conf`: Cuenta el número total de líneas del archivo.