#!/bin/bash
set -e

CONFIG_DIR="/etc/chirpstack-application-server"
HOST_CONFIG_DIR="/config/chirpstack-application-server"

# Crear carpeta en host si no existe
mkdir -p "$HOST_CONFIG_DIR"

# Copiar archivos por defecto si el host config esta vacio
if [ -z "$(ls -A "$HOST_CONFIG_DIR")" ]; then
    echo "Copiando archivos de configuración por defecto a la carpeta montada..."
    cp -r $CONFIG_DIR/* "$HOST_CONFIG_DIR/"
fi

# Ejecutar import de TTN lorawan-devices si existe el script
IMPORT_SCRIPT="$HOST_CONFIG_DIR/import-lorawan.sh"
if [ -f "$IMPORT_SCRIPT" ]; then
    echo "Ejecutando import-lorawan.sh..."
    chmod +x "$IMPORT_SCRIPT"
    "$IMPORT_SCRIPT"
fi

# Iniciar Chirpstack Application Server
echo "Iniciando Chirpstack Application Server..."
exec chirpstack-application-server
