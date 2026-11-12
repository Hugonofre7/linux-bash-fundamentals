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