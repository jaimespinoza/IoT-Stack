#!/bin/sh
set -e

# Ruta donde se descargara el repo de TTN lorawan-devices
REPO_DIR="/etc/chirpstack-application-server/lorawan-devices"

# Si el repo no existe, clonar e importar
if [ ! -d "$REPO_DIR" ]; then
    echo "Importando TTN lorawan-devices..."
    git clone https://github.com/TheThingsNetwork/lorawan-devices.git "$REPO_DIR"
    cd "$REPO_DIR"
    make import-lorawan-devices
else
    echo "Repositorio TTN lorawan-devices ya existe. Saltando importacion."
fi

# Mantener el contenedor corriendo
exec chirpstack-application-server
