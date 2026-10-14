#!/bin/bash

set -e

VM_HOST="${1:-raven@10.0.2.15}"
VM_PATH="/tmp/ravenfantom-deploy"

echo "[deploy] Création du dossier distant..."
ssh "$VM_HOST" "mkdir -p $VM_PATH"

echo "[deploy] Envoi des fichiers..."
scp -q -r config/* "$VM_HOST:$VM_PATH/"
scp -q -r scripts/* "$VM_HOST:$VM_PATH/"

echo "[deploy] Application des scripts..."
ssh "$VM_HOST" "cd $VM_PATH && sudo sh scripts/01-firstboot.sh"

echo "[deploy] Terminé."
