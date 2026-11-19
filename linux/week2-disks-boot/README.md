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

## Capítulo 4 (Parte 2): Montaje Persistente con `/etc/fstab`

### 1. Obtención del UUID de la partición
```bash
# Consultar el identificador único del sistema de archivos
sudo blkid /dev/loop24p1
# Resultado obtenido: UUID="fc2ace48-7830-4492-8e97-c736b5bf5077"

### 2. Configuración en /etc/fstab
Bash
# Crear un respaldo de seguridad del archivo actual
sudo cp /etc/fstab /etc/fstab.bak

# Agregar la regla de montaje persistente usando el UUID
UUID=fc2ace48-7830-4492-8e97-c736b5bf5077 /mnt/datos_practica ext4 defaults 0 2
### 3. Recarga y Validación del Sistema
Bash
# Actualizar el demonio de systemd para reconocer los cambios
sudo systemctl daemon-reload

# Aplicar y validar los montajes configurados
sudo mount -a
Verificación: lsblk /dev/loop24 confirma que la partición monta automáticamente su punto de montaje /mnt/datos_practica.

## Capítulo 5 (Parte 1): Arranque del Kernel e `initramfs`

### 1. Identificación del Kernel y Archivos de Arranque
```bash
# Consultar la versión del kernel en ejecución (arquitectura aarch64)
uname -r
# Salida: 6.17.0-8-generic

# Revisar imágenes de kernel (vmlinuz) e initramfs (initrd.img) y sus enlaces simbólicos
ls -lh /boot/vmlinuz* /boot/initrd.img*

### 2. Inspección del Contenido del initramfs
Bash
# Listar contenido usando sudo (permisos restringidos a root) y compresión zstd
sudo lsinitramfs /boot/initrd.img-$(uname -r) | head -n 25

# Verificar módulos de almacenamiento y virtualización incluidos en la imagen
sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep -E "ext4|virtio|nvme|sd_mod" | head -n 15
Observación: Se identificaron módulos comprimidos (*.ko.zst) como nvme, nvme-core y variantes virtio, necesarios antes de montar el sistema de archivos raíz definitivo.

### 3. Regeneración de la Imagen con dracut
Bash
# Regenerar la imagen initramfs del kernel activo en modo detallado
sudo update-initramfs -u -k $(uname -r) -v | tail -n 20
Observación: El sistema delega en dracut con compresión zstd e incluye módulos tempranos de systemd, rootfs-block, virtiofs y qemu para generar /boot/initrd.img-6.17.0-8-generic.