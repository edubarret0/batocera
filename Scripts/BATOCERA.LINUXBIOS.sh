#!/bin/bash
# Curitiba de Fevereiro de 2025
# Editor Jeverson Dias da Silva ......Youtube/@JCGAMESCLASSICOS
clear
# Definir cores
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Definir a URL do arquivo SquashFS e o diretório de destino
URL="https://github.com/JeversonDiasSilva/BATOCERA.LINUX/releases/download/V1.0/BIOS"
TMP_DIR="/userdata/system/.tmp"
BIOS_DIR="/userdata/bios"
BIOS_FILE="$TMP_DIR/BIOS"  # Apenas 'BIOS', sem a extensão .squashfs

# Função para mostrar mensagens com espera de 5 segundos e limpar a tela
show_message() {
    echo -e "$1"
    sleep 5  # Aguarda 5 segundos
    clear  # Limpa a tela
}

# Passo 1: Baixar o arquivo BIOS
echo -e "${BOLD}${CYAN}BAIXANDO O ARQUIVO BIOS...${RESET}"
mkdir -p $TMP_DIR
wget -O $BIOS_FILE $URL > /dev/null 2>&1 &  # Baixando o arquivo em segundo plano
DOWNLOAD_PID=$!  # Pega o PID do processo de download

# Espera o processo de download terminar
wait $DOWNLOAD_PID  # Aguarda o download ser concluído

# Passo 2: Criar diretório de BIOS e limpar os arquivos antigos
show_message "${BOLD}${CYAN}PREPARANDO O DIRETÓRIO DE DESTINO PARA OS ARQUIVOS BIOS...${RESET}"
mkdir -p $BIOS_DIR
rm -r $BIOS_DIR/*

# Passo 3: Instalar o conteúdo do BIOS para o diretório /userdata/bios/
show_message "${BOLD}${CYAN}INSTALANDO O CONTEÚDO DO BIOS PARA O DIRETÓRIO...${RESET}"
unsquashfs -d $BIOS_DIR $BIOS_FILE > /dev/null 2>&1 &

# Passo 4: Aguardar a extração do arquivo
wait $!  # Espera a extração ser concluída

# Passo 5: Verificar se a extração foi bem-sucedida
if [ $? -eq 0 ]; then
    show_message "${BOLD}${CYAN}EXTRAÇÃO BEM-SUCEDIDA!${RESET}"
else
    show_message "${BOLD}${CYAN}ERRO NA EXTRAÇÃO. VERIFIQUE OS LOGS.${RESET}"
    exit 1
fi

# Passo 6: Limpar o arquivo temporário
show_message "${BOLD}${CYAN}REMOVENDO O ARQUIVO TEMPORÁRIO BIOS...${RESET}"
rm -f $BIOS_FILE

show_message "${BOLD}${CYAN}PROCESSO CONCLUÍDO!${RESET}"