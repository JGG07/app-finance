#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build/web"
LOCAL_GCLOUD="${ROOT_DIR}/google-cloud-sdk/bin/gcloud"
LOCAL_CLOUDSDK_CONFIG="${ROOT_DIR}/.gcloud-config"

if [[ -x "${LOCAL_GCLOUD}" ]]; then
  GCLOUD="${LOCAL_GCLOUD}"
elif command -v gcloud >/dev/null 2>&1; then
  GCLOUD="gcloud"
else
  echo "No se encontro gcloud. Instala la CLI o descarga google-cloud-sdk en el proyecto."
  exit 1
fi

mkdir -p "${LOCAL_CLOUDSDK_CONFIG}"
export CLOUDSDK_CONFIG="${CLOUDSDK_CONFIG:-${LOCAL_CLOUDSDK_CONFIG}}"

PROJECT_ID="${1:-${PROJECT_ID:-}}"
BUCKET_NAME="${2:-${BUCKET_NAME:-}}"
LOCATION="${3:-${LOCATION:-us-central1}}"

if [[ -z "${PROJECT_ID}" || -z "${BUCKET_NAME}" ]]; then
  echo "Uso: $0 <project-id> <bucket-name> [location]"
  echo "Tambien puedes usar PROJECT_ID, BUCKET_NAME y LOCATION como variables de entorno."
  exit 1
fi

if [[ ! -d "${BUILD_DIR}" ]]; then
  echo "No existe ${BUILD_DIR}. Genera la app web antes de desplegar."
  exit 1
fi

echo "Usando gcloud: ${GCLOUD}"
echo "Proyecto: ${PROJECT_ID}"
echo "Bucket: gs://${BUCKET_NAME}"
echo "Region: ${LOCATION}"

"${GCLOUD}" config set project "${PROJECT_ID}" >/dev/null

if ! "${GCLOUD}" storage buckets describe "gs://${BUCKET_NAME}" >/dev/null 2>&1; then
  echo "Creando bucket gs://${BUCKET_NAME}..."
  "${GCLOUD}" storage buckets create "gs://${BUCKET_NAME}" \
    --project="${PROJECT_ID}" \
    --location="${LOCATION}" \
    --uniform-bucket-level-access
else
  echo "El bucket ya existe. Se reutilizara."
fi

echo "Configurando bucket para sitio estatico..."
"${GCLOUD}" storage buckets update "gs://${BUCKET_NAME}" \
  --web-main-page-suffix=index.html \
  --web-error-page=index.html >/dev/null

echo "Haciendo objetos publicos..."
"${GCLOUD}" storage buckets add-iam-policy-binding "gs://${BUCKET_NAME}" \
  --member=allUsers \
  --role=roles/storage.objectViewer >/dev/null

echo "Sincronizando build/web..."
"${GCLOUD}" storage rsync "${BUILD_DIR}" "gs://${BUCKET_NAME}" \
  --recursive \
  --delete-unmatched-destination-objects

echo
echo "Despliegue completado."
echo "URL HTTPS directa: https://storage.googleapis.com/${BUCKET_NAME}/index.html"
echo "URL HTTP de website: http://${BUCKET_NAME}.storage.googleapis.com"
