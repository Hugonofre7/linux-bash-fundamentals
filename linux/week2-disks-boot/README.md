cat << 'EOF' > README.md
# Semana 2: Administración de Discos, Sistemas de Archivos y Proceso de Arranque

Notas de laboratorio, comandos, procedimientos y evidencias correspondientes a la gestión de almacenamiento y arranque en Linux.

## Índice de Prácticas
- [Práctica 1: Particionado y Estructura de Discos](#)
- [Práctica 2: Montaje y Sistemas de Archivos](#)
- [Práctica 3: Análisis del Arranque (Boot)](#)
EOF

## Capítulo 4 (Parte 1): Gestión de Discos, Particiones y Sistemas de Archivos

### 1. Creación de disco virtual e imagen de bloque
```bash
# Crear un archivo de imagen de 500 MB para pruebas
dd if=/dev/zero of=~/disco_practica.img bs=1M count=50000

# Vincular la imagen como un dispositivo de bucle con soporte de particiones
sudo losetup -fP ~/disco_practica.img

### 2. Particionamiento con fdisk
Bash
# Crear la tabla de particiones y la partición primaria en el loop device asignado
sudo fdisk /dev/loop24
# (Secuencia utilizada: n -> p -> 1 -> [Enter] -> [Enter] -> w)
### 3. Formateo y Montaje Manual
Bash
# Dar formato con el sistema de archivos ext4
sudo mkfs.ext4 /dev/loop24p1

# Crear el punto de montaje y montar el dispositivo
sudo mkdir -p /mnt/datos_practica
sudo mount /dev/loop24p1 /mnt/datos_practica
Verificación: df -h /mnt/datos_practica confirma el espacio disponible y lsblk /dev/loop24 muestra el punto de montaje activo.