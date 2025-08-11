#!/bin/bash
# Curitiba 09 de Maio de 2025
# Editor: Jeverson Dias da Silva

# Diretório de trabalho
app="heroic"
squash="HEROIC"
exe="/usr/share/applications"
dir_app="/userdata/system/.dev/apps"
url="https://github.com/JeversonDiasSilva/releses/releases/download/v1.0.0/$squash"
url_dep="https://github.com/JeversonDiasSilva/releses/releases/download/v1.0.0/DEPENDENCIAS"
pack=$(basename "$url")
pack_dep=$(basename "$url_dep")
limbo="> /dev/null 2>&1"
save="batocera-save-overlay"
roms=/userdata/roms/heroic

mkdir -p $roms

echo "<?xml version="1.0"?>
<systemList>
  <system>
        <fullname>heroic</fullname>
        <name>heroic</name>
        <manufacturer>Linux</manufacturer>
        <release>2017</release>
        <hardware>console</hardware>
        <path>/userdata/roms/heroic</path>
        <extension>.TXT</extension>
        <command>/userdata/system/pro/heroic/SystemLauncher %ROM%</command>
        <platform>pc</platform>
        <theme>heroic</theme>
        <emulators>
            <emulator name="heroic">
                <cores>
                    <core default="true">heroic</core>
                </cores>
            </emulator>
        </emulators>
  </system>

</systemList>
" > /userdata/system/configs/emulationstation/es_systems_heroic.cfg

# Arquivo de log de erros
log_file="/tmp/install_error_log.txt"

# Função para registrar erro
log_error() {
    echo "$(date) - $1" >> "$log_file"
    echo -e "${VERDE}$1${RESET}"
}

# Função para baixar pacotes
download_package() {
    local url=$1
    local file_name=$(basename "$url")
    
    echo -e "${AZUL}Baixando $file_name...${RESET}"
    wget "$url" -q --show-progress || { log_error "Erro ao baixar $file_name. Verifique sua conexão com a internet e tente novamente."; exit 1; }
}

# Estilização das saídas no terminal 
clear
echo ""
echo ""
echo ""
echo ""
ROXO="\033[1;35m"
VERDE="\033[1;92m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
RESET="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"

echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO DO APLICATIVO ${RESET} ${VERDE} $squash  ${RESET}"
echo -e "${ROXO}${BOLD}  V40 E V41 - JEVERTON DIAS DA SILVA - 06 DE MAIO DE 2025  ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
sleep 2

echo -e "${AMARELO}Iniciando o processo de instalação...${RESET}"
echo -e "${AZUL}Preparando o ambiente...${RESET}"
sleep 2

# Verificar se o diretório existe
if [ ! -d "$dir_app" ]; then
    mkdir -p "$dir_app"  # Criar o diretório, caso não exista
fi

# Verificar se as dependências já foram baixadas
if [ -d "$dir_app/.dep" ]; then
    echo -e "${AMARELO}As dependências já foram baixadas anteriormente. Pulando o download das dependências...${RESET}"
else
    # Baixar as dependências
    echo -e "${AZUL}Baixando DEPENDENCIAS...${RESET}"
    download_package "$url_dep"

    # Extrair as dependências
    echo -e "${AZUL}Extraindo dependências...${RESET}"
    unsquashfs -d "$dir_app/.dep" "$pack_dep" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log_error "Erro ao extrair dependências. Verifique se o arquivo $pack_dep não está corrompido."
        exit 1
    fi

    # Remover o arquivo de dependências
    rm -f "$pack_dep" > /dev/null 2>&1
fi

# Baixar o pacote principal
echo -e "${AZUL}Baixando o pacote principal...${RESET}"
download_package "$url"

# Verificar se o arquivo foi baixado corretamente
if [ ! -f "$pack" ]; then
    log_error "Erro: o arquivo $pack não foi baixado corretamente."
    exit 1
fi

# Extrair o pacote principal
echo -e "${AZUL}Extraindo o pacote principal...${RESET}"
unsquashfs -d "$dir_app/$app" "$pack" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    log_error "Erro ao extrair o pacote principal. Verifique se o arquivo $pack não está corrompido ou se o comando unsquashfs está funcionando corretamente."
    exit 1
fi

# Remover o pacote principal
rm -f "$pack" > /dev/null 2>&1
sleep 5

# Copiar o aplicativo para o diretório de execuções
echo -e "${AZUL}Copiando o aplicativo...${RESET}"
cp "/userdata/system/.dev/apps/heroic/extra/heroic.desktop" /usr/share/applications/ 2>/dev/null || { log_error "Erro ao copiar o aplicativo para o diretório de execução."; exit 1; }

# Executar o comando de salvar
echo -e "${AZUL}Salvando as configurações de overlay...${RESET}"
$save || { log_error "Erro ao salvar as configurações. Certifique-se de que o comando $save está disponível."; exit 1; }

echo -e "${AMARELO}Removendo arquivos temporários...${RESET}"
sleep 2

echo -e "${AMARELO}Salvando as configurações de overlay...${RESET}"
sleep 2

# Exibindo WhatsApp com destaque
echo -e "${AMARELO}${BOLD}🔔 Para mais informações ou suporte, entre em contato pelo WhatsApp: ${RESET}${VERDE}${BOLD}(41) 99820-5080${RESET}"

# Exibindo @JCGAMESCLASSICOS com destaque
echo -e "${AMARELO}${BOLD}🚀 Siga-nos no YouTube para mais novidades: ${RESET}${VERDE}${BOLD}@JCGAMESCLASSICOS${RESET}"

# Finalizando com mensagem
echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO CONCLUÍDA COM SUCESSO!                          ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"



# Finalizando
cd || exit 1