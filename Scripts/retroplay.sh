#!/bin/bash

# Passo 1: Baixar o arquivo do GitHub
echo "Baixando o arquivo..."
wget https://github.com/JeversonDiasSilva/retroplay/releases/download/v1.0/run.jc -O run.jc > /dev/null 2>&1
wget https://github.com/JeversonDiasSilva/retroplay/releases/download/v1.0/xdotool -O xdotool > /dev/null 2>&1
# Passo 2: Tornar o arquivo executável
chmod +x run.jc
chmod +x xdotool

sleep 3
clear

./xdotool type "./run.jc"
sleep 2
./xdotool key Return

# Remover xdotool se ele existir
if [ -f xdotool ]; then
    rm xdotool
    if [ $? -eq 0 ]; then
        echo "Arquivo xdotool removido com sucesso."
    else
        echo "Erro ao tentar remover o arquivo xdotool."
    fi
else
    echo "Arquivo xdotool não encontrado para remoção."
fi

: << "END"
END