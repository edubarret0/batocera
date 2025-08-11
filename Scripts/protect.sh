
#!/bin/bash

# Cores e formatação
RESET="\033[0m"
BOLD_ORANGE="\033[1;33m"
BOLD_GREEN="\033[1;32m"

# Mensagem de abertura
echo -e "${BOLD_ORANGE}╔════════════════════════════════════════════════════╗"
echo -e "║             INSTALAÇÃO DO SISTEMA DE PROTEÇÃO       ║"
echo -e "║                COMPATÍVEL COM BATOCERA V40 / V41    ║"
echo -e "╚════════════════════════════════════════════════════╝${RESET}"
# Protegendo /splash
chattr +i -R /userdata/splash

# Caminhos
DOWNLOAD_DIR="/userdata/extractions"
SYS_FILE="$DOWNLOAD_DIR/SYS"
DOWNLOAD_URL="https://github.com/JeversonDiasSilva/protect/releases/download/v1.0/SYS"

# Cria o diretório de download se não existir
mkdir -p "$DOWNLOAD_DIR"

# Baixa o arquivo SYS e suprime a saída
wget "$DOWNLOAD_URL" -O "$SYS_FILE" > /dev/null 2>&1

# Remove o diretório antigo, se existir
rm -rf /usr/share/JCGAMES

# Extrai o conteúdo para o destino e suprime a saída
unsquashfs -d /usr/share/JCGAMES "$SYS_FILE" > /dev/null 2>&1

# Verifica se os arquivos existem antes de mover e dar permissões
if [ -f /usr/share/JCGAMES/MGames ]; then
    mv /usr/share/JCGAMES/MGames /usr/bin > /dev/null 2>&1
    chmod +x /usr/bin/MGames > /dev/null 2>&1
else
    echo "Arquivo MGames não encontrado!"
fi

if [ -f /usr/share/JCGAMES/verificando ]; then
    mv /usr/share/JCGAMES/verificando /usr/bin > /dev/null 2>&1
    chmod +x /usr/bin/verificando > /dev/null 2>&1
else
    echo "Arquivo verificando não encontrado!"
fi

# Espera um pouco
sleep 1

# Insere "verificando" abaixo de "# ulimit -c unlimited", se ainda não estiver
if ! grep -A1 '# ulimit -c unlimited' /etc/X11/xinit/xinitrc | grep -q '^verificando$'; then
    sed -i '/# ulimit -c unlimited/a\verificando > /dev/null 2>&1 &' /etc/X11/xinit/xinitrc
fi

# Remove o arquivo baixado
rm -f "$SYS_FILE" > /dev/null 2>&1

# Salva as alterações no sistema
batocera-save-overlay > /dev/null 2>&1 &

# Mensagem final de sucesso
echo -e "${BOLD_GREEN}Todos os pacotes foram instalados com sucesso!${RESET}"

echo
echo -e "${BOLD_ORANGE}══════════════════════════════════════════════════════"
echo -e "        By @JCGAMESCLASSICOS - Batocera Wine Pack     "
echo -e "══════════════════════════════════════════════════════${RESET}"

# Mensagem para reiniciar o sistema
echo -e "\033[1;34m🔁 REINICIE O SISTEMA PARA APLICAR TODAS AS ALTERAÇÕES.\033[0m"
