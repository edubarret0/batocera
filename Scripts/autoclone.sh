#!/bin/bash
# Curitiba, 07 de Julho de 2025.
# Editor: Jeverson D. Silva /// @JCGAMESCLASSICOS

# INSTALAÇÃO DO SYSTEMCLONE

# URL do pacote squashfs
url="https://github.com/JeversonDiasSilva/autoclone/releases/download/v1.0/SYSTEMCLONE"
squash=$(basename "$url")

# Diretórios de destino
base_scripts="/userdata/system/.dev/apps"
dir_work="$base_scripts/systemclone"
local_apps="/userdata/system/.local/share/applications"

# Criação dos diretórios necessários
mkdir -p "$base_scripts"
mkdir -p "$local_apps"

# Baixar o pacote
wget "$url" -O "$base_scripts/$squash" > /dev/null 2>&1

# Extrair o conteúdo do squashfs
unsquashfs -d "$dir_work" "$base_scripts/$squash" > /dev/null 2>&1

# Remover o arquivo squash após extração
rm "$base_scripts/$squash"

# Definir permissões
chmod -R 777 "$dir_work"

# Mover o atalho para o diretório de aplicativos locais
mv "$dir_work/autoclone.desktop" "$local_apps"
"/userdata/system/.dev/apps/systemclone/Python" -m pip install customtkinter
"/userdata/system/.dev/apps/systemclone/Python" -m pip install --upgrade pip
# Mensagem final
echo "Instalação concluída com sucesso!"