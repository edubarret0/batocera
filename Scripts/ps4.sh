
#!/bin/bash
# Curitiba 08 de Maio de 2025
# Editor Jeverson Dias da Silva
# Instalação do sistema Sony Playstation 4 no Batocera v40 e 41.

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

# Exibindo cabeçalho estilizado
echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO DO SISTEMA SONY PLAYSTATION 4 PARA BATOCERA  ${RESET}"
echo -e "${ROXO}${BOLD}  V40 E V41 - JEVERTON DIAS DA SILVA - 09 DE MAIO DE 2025  ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
sleep 2

# Definindo diretórios como variáveis
PS4_DIR="/userdata/system/.dev/apps/ps4"
PS4_CONFIG_DIR="/userdata/system/configs/emulationstation"
PS4_DESKTOP_FILE="/userdata/system/.dev/apps/ps4/extra/ps4.desktop"
PS4_EXEC_DIR="/usr/bin"
PS4_SCRIPTS_DIR="/userdata/system/.dev/scripts"
PS4_LOCAL_DIR="/userdata/system/.local/share"
ROM_DIR="/userdata/roms/ps4"


# Criando backup da pasta de roms caso haja...
if [ -d /userdata/roms/ps4 ]; then
    mv /userdata/roms/ps4 /userdata/roms/ps4.bkp_$(date +%Y%m%d%H%M%S)
fi

# Função para verificar erro de execução e continuar o script sem mostrar erros
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${VERDE}Erro na execução de: $1. Continuando a instalação...${RESET}"
    fi
}

# Iniciando o processo de instalação
echo -e "${AMARELO}Iniciando o processo de instalação...${RESET}"
echo -e "${AZUL}Preparando o ambiente...${RESET}"
sleep 2

# Baixando o arquivo PS4
echo -e "${AMARELO}Baixando o arquivo PS4...${RESET}"
wget -q --show-progress https://github.com/JeversonDiasSilva/every_time/releases/download/v1.1/PS4 -O PS4
check_error "wget PS4"

# Criando diretórios necessários
echo -e "${AMARELO}Criando diretórios necessários...${RESET}"
mkdir -p "$PS4_DIR" "$PS4_CONFIG_DIR" "$PS4_SCRIPTS_DIR"
check_error "mkdir"

# Descompactando o arquivo PS4
echo -e "${AMARELO}Descompactando o arquivo PS4...${RESET}"
unsquashfs -d "$PS4_DIR" PS4 > /dev/null 2>&1
check_error "unsquashfs"

# Removendo o arquivo PS4 baixado
echo -e "${AMARELO}Removendo o arquivo PS4 baixado...${RESET}"
rm -f PS4 2>/dev/null
check_error "rm PS4"

# Ajustando permissões (não usamos 777 por questões de segurança)
echo -e "${AMARELO}Ajustando permissões...${RESET}"
chmod -R 755 "$PS4_DIR"
check_error "chmod"

# Removendo arquivos antigos se existirem
echo -e "${AMARELO}Removendo arquivos antigos se existirem...${RESET}"
[ -d "$PS4_LOCAL_DIR/shadPS4" ] && rm -rf "$PS4_LOCAL_DIR/shadPS4" 2>/dev/null
[ -f "$PS4_EXEC_DIR/kill4" ] && rm -f "$PS4_EXEC_DIR/kill4" 2>/dev/null
[ -f "$PS4_EXEC_DIR/XPS4" ] && rm -f "$PS4_EXEC_DIR/XPS4" 2>/dev/null
check_error "remover arquivos antigos"

# Renomeando a pasta /userdata/roms/ps4 para .bkp se existir
if [ -d "$ROM_DIR" ]; then
    echo -e "${AMARELO}A pasta /userdata/roms/ps4 já existe. Renomeando para .bkp...${RESET}"
    mv "$ROM_DIR" "/userdata/roms/.bkp_ps4_$(date +%Y%m%d%H%M%S)" 2>/dev/null
    check_error "renomear pasta /userdata/roms/ps4"
fi

# Movendo arquivos para os diretórios corretos
echo -e "${AMARELO}Movendo arquivos para os diretórios corretos...${RESET}"
mv "$PS4_DIR/ps4" "$ROM_DIR" 2>/dev/null
check_error "mv ps4"

# Movendo o diretório shadPS4 para .local/share
if [ -d "$PS4_DIR/shadPS4" ]; then
    echo -e "${AMARELO}Movendo o diretório shadPS4...${RESET}"
    mv "$PS4_DIR/shadPS4" "$PS4_LOCAL_DIR/shadPS4" 2>/dev/null
    check_error "mv shadPS4"
else
    echo -e "${AMARELO}Diretório shadPS4 não encontrado, pulando a movimentação...${RESET}"
fi

# Movendo arquivos de configuração
mv "$PS4_DIR/es_systems_ps4.cfg" "$PS4_CONFIG_DIR/es_systems_ps4.cfg" 2>/dev/null
check_error "mv es_systems_ps4.cfg"

# Criando links simbólicos para os executáveis
echo -e "${AMARELO}Criando links simbólicos...${RESET}"
if [ ! -f "$PS4_EXEC_DIR/ps4" ]; then
    ln -s "$PS4_DIR/ps4.AppImage" "$PS4_EXEC_DIR/ps4" 2>/dev/null
    check_error "ln -s ps4.AppImage"
else
    echo -e "${AMARELO}Link simbólico 'ps4' já existe, substituindo...${RESET}"
    rm -f "$PS4_EXEC_DIR/ps4" 2>/dev/null
    ln -s "$PS4_DIR/ps4.AppImage" "$PS4_EXEC_DIR/ps4" 2>/dev/null
    check_error "substituir link simbólico ps4"
fi

if [ ! -f "$PS4_EXEC_DIR/XPS4" ]; then
    mv "$PS4_DIR/XPS4" "$PS4_EXEC_DIR/XPS4" 2>/dev/null
    check_error "mv XPS4"
else
    echo -e "${AMARELO}Arquivo XPS4 já existe, substituindo...${RESET}"
    rm -f "$PS4_EXEC_DIR/XPS4" 2>/dev/null
    mv "$PS4_DIR/XPS4" "$PS4_EXEC_DIR/XPS4" 2>/dev/null
    check_error "substituir arquivo XPS4"
fi

if [ ! -f "$PS4_EXEC_DIR/kill4" ]; then
    mv "$PS4_DIR/kill4" "$PS4_EXEC_DIR/kill4" 2>/dev/null
    check_error "mv kill4"
else
    echo -e "${AMARELO}Arquivo kill4 já existe, substituindo...${RESET}"
    rm -f "$PS4_EXEC_DIR/kill4" 2>/dev/null
    mv "$PS4_DIR/kill4" "$PS4_EXEC_DIR/kill4" 2>/dev/null
    check_error "substituir arquivo kill4"
fi

# Movendo script ps4_kill
echo -e "${AMARELO}Movendo script ps4_kill...${RESET}"
mv "$PS4_DIR/ps4_kill" "$PS4_SCRIPTS_DIR" 2>/dev/null
check_error "mv ps4_kill"

# Copiando arquivo de desktop
echo -e "${AMARELO}Copiando arquivo de desktop...${RESET}"
cp "$PS4_DESKTOP_FILE" /usr/share/applications 2>/dev/null
check_error "cp ps4.desktop"

# Salvando configurações de overlay
echo -e "${AMARELO}Salvando as configurações de overlay...${RESET}"
batocera-save-overlay > /dev/null 2>&1 || echo -e "${VERDE}Erro ao salvar overlay. Continuando a instalação...${RESET}"
sleep 2

# Exibindo a mensagem de conclusão
echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO CONCLUÍDA COM SUCESSO!                          ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"

# Exibindo WhatsApp com destaque
echo -e "${AMARELO}${BOLD}🔔 Para mais informações ou suporte, entre em contato pelo WhatsApp: ${RESET}${VERDE}${BOLD}(41) 99820-5080${RESET}"

# Exibindo @JCGAMESCLASSICOS com destaque
echo -e "${AMARELO}${BOLD}🚀 Siga-nos no Youtube para mais novidades: ${RESET}${VERDE}${BOLD}@JCGAMESCLASSICOS${RESET}"

# Finalizando
cd || exit 1