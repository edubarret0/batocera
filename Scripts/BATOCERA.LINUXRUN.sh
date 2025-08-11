#!/bin/bash
# Curitiba 15 de Fevereiro de 2025
# Editor Jeverson Dias da Silva

cd /userdata/extractions

curl -L https://github.com/JeversonDiasSilva/BATOCERA.LINUX/releases/download/V1.0/OS -o /userdata/extractions/OS

unsquashfs -d DESKTOP OS

rm OS

chmod +x $(pwd)/DESKTOP/desktop
$(pwd)/DESKTOP/desktop
rm -r $(pwd)/DESKTOP/