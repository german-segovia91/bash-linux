#!/usr/bin/env bash
# ===========================================
# Script para configurar permisos del directorio /shared en cada nodo
# ===========================================
# Ejecuta este script en cada nodo worker para que blessuser (UID 1000) pueda acceder

set -euo pipefail

AUDIO_DIR="/shared"

echo ">> Configurando permisos para directorio de audio..."

# Crear directorio si no existe
sudo mkdir -p "${AUDIO_DIR}"

# Establecer permisos: grupo 999 (blessuser) puede leer/escribir
# 775 = rwxrwxr-x (dueño y grupo tienen permisos completos)
sudo chmod 775 "${AUDIO_DIR}"

# Cambiar propietario a UID 999:GID 999 (blessuser)
sudo chown 999:999 "${AUDIO_DIR}" || {
    echo "⚠️  Nota: chown falló. Asegúrate de que el directorio tenga permisos 775"
    echo "   El fsGroup en securityContext debería manejar los permisos automáticamente"
}

# Si hay archivos dentro, también cambiar sus permisos
if [ -n "$(ls -A ${AUDIO_DIR} 2>/dev/null)" ]; then
    echo ">> Ajustando permisos de archivos existentes..."
    sudo chmod 664 "${AUDIO_DIR}"/* 2>/dev/null || true
    sudo chown -R 999:999 "${AUDIO_DIR}"/* 2>/dev/null || true
fi

echo "✅ Permisos configurados para ${AUDIO_DIR}"
echo "   Permisos: $(stat -c '%a %U:%G' ${AUDIO_DIR} 2>/dev/null || echo 'verifica manualmente')"

# Verificación
echo ""
echo ">> Verificando configuración:"
ls -ld "${AUDIO_DIR}"

