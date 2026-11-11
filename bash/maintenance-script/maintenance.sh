#!/usr/bin/env bash
# ==============================================================================
# Repositorio: linux-bash-fundamentals
# Semana:      Semana 1 - Capítulos 1, 2 y 3 (Ward / Barrett)
# Módulo:      Laboratorio de Comandos y Jerarquía de Archivos
# Descripción: Script de prueba para validar variables del sistema y uptime.
# Autor:       Hugo Antonio Onofre
# ==============================================================================

# Detener la ejecución si ocurre un error
set -euo pipefail

echo "=============================================="
echo " INICIANDO DIAGNÓSTICO BÁSICO - SEMANA 1"
echo "=============================================="

# 1. Mostrar el tiempo de actividad del sistema (Uptime)
echo -n "Uptime del sistema: "
uptime -p

# 2. Mostrar el usuario actual y el directorio de trabajo
echo "Usuario actual: $(whoami)"
echo "Directorio actual: $(pwd)"

# 3. Mostrar espacio disponible en disco (Primer vistazo al filesystem)
echo "----------------------------------------------"
echo "Uso del sistema de archivos principal:"
df -h / | awk 'NR==1 || NR==2'

echo "=============================================="
echo " Diagnóstico finalizado con éxito."
echo "=============================================="