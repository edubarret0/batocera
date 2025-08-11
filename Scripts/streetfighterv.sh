#!/bin/bash
# Curitiba 03 de Junho de 2025
# Editor Jeverson Dias da Silva
# Youtube/@JCGAMESCLASSICOS
# Script de desbloqueio "ONLINE" do game "Street Fighter V - Champion Edition"

url="https://github.com/JeversonDiasSilva/streetfighterv/releases/download/v1.0/SFV.jc"
dep="https://github.com/JeversonDiasSilva/streetfighterv/releases/download/v1.0/xdotool"

# Nome do script que será baixado
squash=$(basename "$url")

# Baixando o script e a dependência xdotool
wget "$url" -O "$squash" > /dev/null 2>&1
wget "$dep" -O xdotool > /dev/null 2>&1

# Tornando ambos executáveis
chmod +x "$squash"
chmod +x xdotool

# Simula digitação do comando para executar o script
./xdotool type "./$squash"
./xdotool key Return

# Remove o xdotool após o uso
rm -f xdotool