#!/bin/bash
# Curitiba 20 de Junho de 2025...
# Editor Jeverson D. Silva   ///@JCGAMESCLASSICOS

# Instalação do Linux MiniOS dentro do Batocera.Linux.
# /uaerdata/system/.dev ...


### CORES ###



# Definindo cores básicas
PRETO="\033[0;30m"
VERMELHO="\033[0;31m"
VERDE="\033[0;32m"
AMARELO="\033[0;33m"
AZUL="\033[0;34m"
MAGENTA="\033[0;35m"
CIANO="\033[0;36m"
BRANCO="\033[0;37m"

# Definindo cores brilhantes (negrito)
PRETO_B="\033[1;30m"
VERMELHO_B="\033[1;31m"
VERDE_B="\033[1;32m"
AMARELO_B="\033[1;33m"
AZUL_B="\033[1;34m"
MAGENTA_B="\033[1;35m"
CIANO_B="\033[1;36m"
BRANCO_B="\033[1;37m"

# Definindo cores de fundo
FUNDO_PRETO="\033[40m"
FUNDO_VERMELHO="\033[41m"
FUNDO_VERDE="\033[42m"
FUNDO_AMARELO="\033[43m"
FUNDO_AZUL="\033[44m"
FUNDO_MAGENTA="\033[45m"
FUNDO_CIANO="\033[46m"
FUNDO_BRANCO="\033[47m"

# Definindo efeitos
NEGRITO="\033[1m"
SUBLINHADO="\033[4m"
PISCANDO="\033[5m"
REVERSO="\033[7m"
RESET="\033[0m"  # Reseta as cores e efeitos




#############
clear 
echo ""

url=https://github.com/JeversonDiasSilva/minios/releases/download/v1.0/LINUX
squash=$(basename "$url")
dir_work="/userdata/system/.dev/apps"
app="Linux_MiniOS"

# Baixando os arquivos...
echo -e "${VERDE_B}BAIXANDO O PACK${RESET}"
sleep 5
mkdir -p "$dir_work" 
cd "$dir_work"
wget "$url" > /dev/null 2>&1

echo -e "${VERDE_B}INSTALANDO...${RESET}"
sleep 5
unsquashfs -d "$dir_work/$app" "$squash"
rm "$squash"
chmod -R 777 "$dir_work"
cp "$dir_work/Linux_MiniOS/usr/share/applications/linux.desktop" /userdata/system/.local/share/applications/linux.desktop > /dev/null 2>&1
cp "$dir_work/Linux_MiniOS/usr/share/applications/linux.desktop" /usr/share/applications/linux.desktop > /dev/null 2>&1
cp "$dir_work/Linux_MiniOS/usr/share/applications/linux" /usr/bin > /dev/null 2>&1


echo -e "${AMARELO_B}SALVANDO A INSTALAÇÂO...${RESET}"
batocera-save-overlay
sleep 2.5
clear
sleep 2.5
echo ""
linux -h
sleep 8
linux