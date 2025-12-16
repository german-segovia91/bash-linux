#!/usr/bin/env bash

set -euo pipefail

# Imagen de origen a descargar/exportar. Puedes sobreescribirla como primer argumento.
DOCKER_IMAGE="nexus.mitrol.net:8083/social-media-message-processor:1.0.1-10-dev"

# Nombre/etiqueta destino que quieres conservar en el tar.
# Puedes sobreescribirla como segundo argumento (ej: "social-media-message-processor:1.0.1").
OUTPUT_REFERENCE="social-media-message-processor:1.0.1"

if [ $# -ge 1 ]; then
    DOCKER_IMAGE="$1"
fi

if [ $# -ge 2 ]; then
    OUTPUT_REFERENCE="$2"
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "[ERROR] Docker no está instalado o no está en el PATH" >&2
    exit 1
fi

echo "[INFO] Descargando imagen: ${DOCKER_IMAGE}"
docker pull "${DOCKER_IMAGE}"

# Etiquetar la imagen localmente con el nombre que queremos conservar.
echo "[INFO] Etiquetando imagen local como ${OUTPUT_REFERENCE}"
docker tag "${DOCKER_IMAGE}" "${OUTPUT_REFERENCE}"

# Generar el nombre del archivo tar (sanitizamos la etiqueta para el sistema de archivos).
SANITIZED_NAME=${OUTPUT_REFERENCE//[:\/]/_}
OUTPUT_TAR="${SANITIZED_NAME}.tar"

echo "[INFO] Exportando imagen a ${OUTPUT_TAR}"
docker save -o "${OUTPUT_TAR}" "${OUTPUT_REFERENCE}"

echo "[INFO] Listo. Copia ${OUTPUT_TAR} al otro servidor y ejecútalo con:"
echo "       docker load -i ${OUTPUT_TAR}"

