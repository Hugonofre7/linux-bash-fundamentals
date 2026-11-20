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

> **Nota sobre permisos y lectura (`sudo` y `zstd`):** Las imágenes `/boot/initrd.img-*` tienen permisos restringidos a `root` (`-rw------- root root`), por lo que leer su contenido con `lsinitramfs` sin `sudo` devuelve `Permission denied`. Además, al cortar la salida con comandos como `head` o `grep` de forma limitada, puede aparecer `unmkinitramfs: zstd failed` porque el flujo comprimido en `zstd` se cierra antes de completarse.

## Capítulo 5 (Parte 2): Parámetros del Kernel, `dmesg` y Arranque con `systemd`

### 1. Parámetros de Arranque del Kernel (`/proc/cmdline`)
```bash
# Consultar la línea de parámetros entregada al kernel en el arranque actual
cat /proc/cmdline

Observación: Incluye BOOT_IMAGE=..., root=UUID=... (identificación estable de la raíz), ro (montaje inicial de solo lectura), parámetros de consola y reserva de memoria crashkernel=....

### 2. Inspección del Buffer del Kernel (dmesg) y Transición a systemd
Bash
# Filtrar línea de comandos, montaje de raíz y actividad de systemd con marcas de tiempo
sudo dmesg -T | grep -iE "command line|root|systemd|dracut" | head -n 20

# Revisar fases posteriores del arranque y remount de sistemas de archivos
sudo dmesg -T | grep -iE "mounted root|switching root|initrd|systemd[1]" | tail -n 25
Observación: Se observa la descompresión del initramfs, la ejecución de systemd[1] en initrd sobre qemu (arm64), la espera del dispositivo raíz por UUID, el remount de sistemas de archivos (systemd-remount-fs.service), la carga de módulos (systemd-modules-load.service) y el inicio de systemd-journald.service.

## Capítulo 5 (Parte 3): Rendimiento de Arranque, Targets y Estado con `systemd`

### 1. Medición de Tiempos de Arranque (`systemd-analyze`)
```bash
# Desglose total del tiempo de arranque (kernel + initrd + userspace)
systemd-analyze time

# Top 10 de unidades más lentas durante la inicialización
systemd-analyze blame | head -n 10

Observación: Se midieron los tiempos de kernel (273ms), initrd (1.293s) y userspace (1min 36.250s hasta graphical.target), identificando servicios como fwupd-refresh.service y plymouth-quit-wait.service junto con dispositivos virtuales QEMU/SPICE.

### 2. Objetivo Predeterminado y Unidades Fallidas (systemctl)
Bash
# Consultar el target por defecto del sistema
systemctl get-default

# Verificar si existen unidades en estado fallido
systemctl --failed
Observación: El target por defecto es graphical.target y systemctl --failed reporta 0 loaded units listed.