#!/bin/bash
# Editor: Gemini (baseado na solicitação de usuário)
# Data: 11/08/2025
#
# Script para instalação LOCAL do MiniOS no Batocera.
# Este script assume a seguinte estrutura de pastas:
# ../
# ├── script/ (onde este script está)
# │   └── instalar_minios_local.sh
# └── app/
#     └── LINUX (o arquivo SquashFS)
#
# A instalação será feita em /userdata/roms/ports, que é o local padrão para "Ports".

### CORES E FORMATAÇÃO ###
VERDE_B="\033[1;32m"
AMARELO_B="\033[1;33m"
VERMELHO_B="\033[1;31m"
CIANO_B="\033[1;36m"
RESET="\033[0m"
NEGRITO="\033[1m"

### VARIÁVEIS DE CONFIGURAÇÃO ###

# Nome do aplicativo que aparecerá no Batocera
APP_NAME="Linux MiniOS"

# Nome do diretório de instalação (convenção .port para Batocera) e do script de inicialização
DIR_NAME="Linux_MiniOS"

# Diretório de destino para aplicações "Ports" no Batocera
DEST_DIR_ROMS="/userdata/roms/ports"
INSTALL_DIR="$DEST_DIR_ROMS/$DIR_NAME.port"

# Encontra o caminho do script e, a partir dele, o caminho do arquivo de origem
SCRIPT_PATH=$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)
SOURCE_FILE="$SCRIPT_PATH/../app/LINUX"

# Caminho do executável principal DENTRO da estrutura do SquashFS
EXEC_PATH_INSIDE_APP="usr/bin/linux"


############# INÍCIO DO SCRIPT #############
clear
echo -e "${CIANO_B}==============================================${RESET}"
echo -e "${CIANO_B}   Instalador Local do ${APP_NAME} para Batocera   ${RESET}"
echo -e "${CIANO_B}==============================================${RESET}"
echo ""
sleep 2

### 1. VERIFICAÇÕES INICIAIS ###
echo -e "${AMARELO_B}[1/5] Verificando o ambiente...${RESET}"

# Verificar se o arquivo de origem existe
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${VERMELHO_B}ERRO: Arquivo de origem não encontrado!${RESET}"
    echo -e "Verifique se o arquivo ${NEGRITO}'$SOURCE_FILE'${RESET} existe."
    exit 1
fi

# Verificar se o comando 'unsquashfs' está disponível
if ! command -v unsquashfs &> /dev/null; then
    echo -e "${VERMELHO_B}ERRO: Utilitário 'unsquashfs' não encontrado.${RESET}"
    echo -e "Este script não pode continuar sem ele."
    exit 1
fi

echo -e "${VERDE_B}Verificações concluídas com sucesso!${RESET}"
echo ""
sleep 1

### 2. PREPARANDO A INSTALAÇÃO ###
echo -e "${AMARELO_B}[2/5] Preparando a instalação...${RESET}"

# Remover instalação antiga, se existir
if [ -d "$INSTALL_DIR" ]; then
    echo " -> Removendo instalação anterior em '$INSTALL_DIR'..."
    rm -rf "$INSTALL_DIR"
fi
if [ -f "$DEST_DIR_ROMS/$DIR_NAME.sh" ]; then
    echo " -> Removendo script de inicialização anterior..."
    rm -f "$DEST_DIR_ROMS/$DIR_NAME.sh"
fi

# Criar o diretório de instalação
echo " -> Criando diretório de instalação: '$INSTALL_DIR'"
mkdir -p "$INSTALL_DIR"
echo ""
sleep 1

### 3. INSTALANDO OS ARQUIVOS ###
echo -e "${AMARELO_B}[3/5] Extraindo os arquivos do MiniOS...${RESET}"

unsquashfs -f -d "$INSTALL_DIR" "$SOURCE_FILE"
if [ $? -ne 0 ]; then
    echo -e "${VERMELHO_B}ERRO: Falha ao extrair o arquivo SquashFS!${RESET}"
    exit 1
fi

echo -e "${VERDE_B}Arquivos extraídos com sucesso!${RESET}"
echo ""
sleep 1

### 4. CONFIGURANDO PERMISSÕES E INICIALIZADOR ###
echo -e "${AMARELO_B}[4/5] Configurando permissões e o inicializador...${RESET}"

# Conceder permissão de execução APENAS ao binário principal (MUITO MAIS SEGURO)
if [ -f "$INSTALL_DIR/$EXEC_PATH_INSIDE_APP" ]; then
    chmod +x "$INSTALL_DIR/$EXEC_PATH_INSIDE_APP"
    echo " -> Permissão de execução concedida ao binário principal."
else
    echo -e "${VERMELHO_B}AVISO: O executável principal não foi encontrado em '$EXEC_PATH_INSIDE_APP'. O atalho pode não funcionar.${RESET}"
fi

# Criar o script de inicialização (.sh) no diretório de Ports
echo " -> Criando script de inicialização em '$DEST_DIR_ROMS/$DIR_NAME.sh'"
cat << EOF > "$DEST_DIR_ROMS/$DIR_NAME.sh"
#!/bin/bash
# Script de inicialização para ${APP_NAME}
cd "$INSTALL_DIR"
./$EXEC_PATH_INSIDE_APP "\$@"
EOF

# Tornar o script de inicialização executável
chmod +x "$DEST_DIR_ROMS/$DIR_NAME.sh"
echo ""
sleep 1

### 5. SALVANDO AS ALTERAÇÕES ###
echo -e "${AMARELO_B}[5/5] Salvando as alterações no sistema...${RESET}"
batocera-save-overlay

echo ""
echo -e "${VERDE_B}==============================================${RESET}"
echo -e "${VERDE_B}  ${APP_NAME} instalado com sucesso!           ${RESET}"
echo -e "${VERDE_B}==============================================${RESET}"
echo ""
echo -e "Para ver o novo atalho, atualize a lista de jogos no EmulationStation"
echo -e "ou simplesmente reinicie o seu sistema."
echo ""