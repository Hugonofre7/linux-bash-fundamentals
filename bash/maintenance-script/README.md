# Semana 1: Big Picture, Comandos y Dispositivos (/dev)

- **Libros de referencia:** *How Linux Works* (Caps. 1-3) | *Linux Pocket Guide*
- **Entorno:** Ubuntu Desktop 24.04 LTS (ARM64) sobre UTM (macOS)
- **Fecha de ejecución:** Marzo 2026

---

## 1. Contexto Técnico
- **Kernel vs User Space:** Explicación del aislamiento entre las llamadas al sistema (*syscalls*) y los procesos de usuario.
- **Archivos de Dispositivo (`/dev`):** Abstracción de block devices (`/dev/sda` o `/dev/vda`) e character devices (`/dev/null`, `/dev/tty`).

## 2. Comandos Ejecutados
```bash
# Inspección de interfaces de red
ip a

# Verificación de dispositivos de almacenamiento detectados por el kernel
lsblk

# Revisamos los registros iniciales del kernel y el comportamiento de systemd al arrancar
sudo dmesg | grep -i disk

## Laboratorio Capítulo 2: Manipulación de Archivos y Permisos

### 1. Creación de archivos de configuración (Heredoc)
Creamos un archivo de configuración simulado utilizando la redirección por bloques (`Heredoc`):
```bash
cat << 'EOF' > app_config.conf
# Configuración del servicio de epidemiología
SERVER_HOST=127.0.0.1
PORT=8080
DEBUG_MODE=false
DB_USER=admin_local
EOF


### 2. Filtrado de flujos de texto
grep -v "^#" app_config.conf

### 3. Gestión y restricción de permisos (chmod)
chmod 600 app_config.conf
ls -l app_config.conf

## Laboratorio Capítulo 2 (Parte 2): Redirección Avanzada, Enlaces y Sucesos

### 1. Redirección de errores estándar (`stderr` vs `stdout`)
Capturamos y separamos la salida correcta de los errores del sistema utilizando los descriptores de archivos:
```bash
# Enviar el error estándar a un archivo de registro específico (descriptor 2)
ls archivo_inexistente.txt 2> error.log

# Combinar salida estándar y errores en un solo archivo log
ls app_config.conf archivo_inexistente.txt > todo_junto.log 2>&1

### 2. Enlaces simbólicos (`ln -s`)
Creamos accesos directos inteligentes que apuntan a archivos o directorios sin duplicar espacio en el disco:
```bash
# Crear un enlace simbólico apuntando al archivo de configuración
ln -s app_config.conf config_actual.conf

# Verificar los detalles del enlace y su destino
ls -l config_actual.conf

### 3. Inspección rápida de archivos (`head`, `tail`, `wc`)
Inspeccionamos contenidos pesados o de registros sin necesidad de abrir editores completos:
```bash
# Ver las primeras 3 líneas
head -n 3 app_config.conf

# Ver las últimas 2 líneas
tail -n 2 app_config.conf

# Contar el número total de líneas del archivo
wc -l app_config.conf