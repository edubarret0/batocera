
#!/bin/bash
sleep 3
clear

# Códigos de cor para terminal
GREEN="\e[1;32m"
RESET="\e[0m"
BOLD_ORANGE="\e[1;38;5;208m"  # Bold + laranja (256 cores)
WHITE="\e[1;37m"

# Mensagem de abertura
echo -e "${BOLD_ORANGE}╔════════════════════════════════════════════════════╗"
echo -e "║             INSTALAÇÃO DO WINE PARA BATOCERA       ║"
echo -e "║                COMPATÍVEL COM V40 / V41            ║"
echo -e "╚════════════════════════════════════════════════════╝${RESET}"
echo

# Lista dos pacotes para baixar
packages=(
  ge-custom
  proton-ge-custom
  Proton-GE-Proton7-42
  proton-valve
  wine-9.17-amd64
  wine-lutris
  wine-old-stable
  wine-stable
  wine-staging
)

# Diretórios
BASE_DIR="/userdata/system/wine"
DEST_DIR="$BASE_DIR/custom"

# Cria o diretório de destino
mkdir -p "$DEST_DIR"
cd "$BASE_DIR" || exit 1

# Loop pelos pacotes
for pack in "${packages[@]}"; do
  echo -ne "${WHITE}Instalando: ${BOLD_ORANGE}${pack}${RESET} ... "

  # Baixar silenciosamente
  wget -q "https://github.com/JeversonDiasSilva/wine/releases/download/1.0/$pack"

  # Verifica se o download ocorreu
  if [ ! -f "$pack" ]; then
    echo -e "\n${BOLD_ORANGE}Erro ao baixar ${pack}. Pulando...${RESET}"
    continue
  fi

  # Extrair silenciosamente
  unsquashfs -d "$DEST_DIR/$pack" "$pack" > /dev/null 2>&1

  # Remover o arquivo baixado
  rm "$pack"

  # Mensagem de sucesso
  echo -e "${GREEN}INSTALADO COM SUCESSO!${RESET}"
done

echo
echo -e "${GREEN}Todos os pacotes foram instalados com sucesso!${RESET}"
echo
echo -e "${BOLD_ORANGE}══════════════════════════════════════════════════════"
echo -e "        By @JCGAMESCLASSICOS - Batocera Wine Pack     "
echo -e "══════════════════════════════════════════════════════${RESET}"
