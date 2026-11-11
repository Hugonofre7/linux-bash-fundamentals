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

