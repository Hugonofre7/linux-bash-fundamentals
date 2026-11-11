# Semana 1: Big Picture, Comandos y Dispositivos (/dev)

## 1. Conceptos Clave
- **User space vs. Kernel space:** El kernel gestiona el hardware directamente; los programas de usuario operan mediante llamadas al sistema (*syscalls*).
- **El modelo de archivos:** Todo en Linux es un archivo, incluidos los dispositivos de hardware ubicados en `/dev/`.

## 2. Evidencias del Laboratorio
- Configuración de la red local y verificación de interfaces con `ip a`.
- Inspección de tablas de particiones y discos físicos mediante `lsblk`.