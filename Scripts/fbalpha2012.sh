
#!/bin/bash
# Curitiba 06 de Maio de 2025
# Editor: Jeverson Dias da Silva

# Ajuste do batocera.conf
echo "fba_libretro.core=fbalpha2012
fba_libretro.emulator=libretro
fba_libretro.tdp=100.000000" >> /userdata/system/batocera.conf

# Caminho da pasta do Retroarch
diretorio="/userdata/system/configs/retroarch"

# Verifica se o diretório existe
if [ -d "$diretorio" ]; then
  # Diretório existe, nada a fazer
  echo "Diretório do Retroarch já existe."
else
  # Diretório não existe, cria o diretório e baixa o RetroarchConfig
  echo "Diretório do Retroarch não encontrado. Baixando retroarchconfig..."
  wget https://github.com/JeversonDiasSilva/fbalpha2012/releases/download/V1.1/RETROCONFIG -O RETROCONFIG > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Erro ao baixar o RETROCONFIG. Verifique sua conexão."
    exit 1
  fi

  unsquashfs -d "/userdata/system/configs/retroarch" RETROCONFIG > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Erro ao extrair o RETROCONFIG."
    rm RETROCONFIG
    exit 1
  fi

  rm RETROCONFIG
fi

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
echo -e "${ROXO}${BOLD}  INSTALAÇÃO DO SISTEMA FINAL BURN ALPHA 2012 PARA BATOCERA  ${RESET}"
echo -e "${ROXO}${BOLD}  V40 E V41 - JEVERTON DIAS DA SILVA - 06 DE MAIO DE 2025  ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
sleep 2

echo -e "${AMARELO}Iniciando o processo de instalação...${RESET}"
echo -e "${AZUL}Preparando o ambiente...${RESET}"
sleep 2

# Verificando e criando diretório fbalpha, se necessário
cd /userdata/roms || { echo -e "${VERDE}Erro ao acessar o diretório /userdata/roms${RESET}"; exit 1; }
mkdir -p /userdata/system/configs/retroarch/cores || { echo -e "${VERDE}Erro ao criar o diretório retroarch/cores${RESET}"; exit 1; }

# Verifica se o core já existe
if [ -f "/userdata/system/configs/retroarch/cores/fbalpha2012_libretro.so" ]; then
  echo "Core 'fbalpha2012_libretro.so' já está instalado."
else
  echo -e "${AMARELO}Baixando pacotes...${RESET}"
  wget https://github.com/JeversonDiasSilva/fbalpha2012/releases/download/V1.1/FBAH -O FBAH > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${VERDE}Erro ao baixar pacotes. Tente novamente mais tarde.${RESET}"
    exit 1
  fi

  sleep 2

  echo -e "${AZUL}Instalando pacotes...${RESET}"
  unsquashfs -d fba_libretro FBAH > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${VERDE}Erro ao extrair pacotes. Tente novamente.${RESET}"
    rm FBAH
    exit 1
  fi

  sleep 2

  echo -e "${AMARELO}Preparando os arquivos para o Batocera...${RESET}"
  sleep 1
fi

# Verificando se o diretório 'dep' existe
if [ -d "/userdata/roms/fba_libretro/dep" ]; then
    echo -e "${ROXO}✔️  Diretório /userdata/roms/fba_libretro/dep encontrado! Iniciando a cópia dos arquivos...${RESET}"

    # Movendo os arquivos para os destinos corretos
    if [ -f "/userdata/roms/fba_libretro/dep/es_systems_fba_libretro.cfg" ]; then
        mv /userdata/roms/fba_libretro/dep/es_systems_fba_libretro.cfg /userdata/system/configs/emulationstation > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao mover o arquivo de configuração${RESET}"; exit 1; }
        sed -i '/<core>fbneo<\/core>/d' /userdata/system/configs/emulationstation/es_systems_fba_libretro.cfg
        chattr +i "/userdata/system/configs/emulationstation/es_systems_fba_libretro.cfg" > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao proteger o arquivo de configuração${RESET}"; exit 1; }
        echo -e "${AZUL}✔️  Arquivo de configuração 'es_systems_fba_libretro.cfg' movido com sucesso!${RESET}"
    else
        echo -e "${VERDE}⚠️  Arquivo 'es_systems_fba_libretro.cfg' não encontrado!${RESET}"
        exit 1
    fi

    if [ -f "/userdata/roms/fba_libretro/dep/fbalpha2012_libretro.so" ]; then
        mv /userdata/roms/fba_libretro/dep/fbalpha2012_libretro.so /userdata/system/configs/retroarch/cores > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao mover o core${RESET}"; exit 1; }
        ln -sf /userdata/system/configs/retroarch/cores/fbalpha2012_libretro.so /usr/lib/libretro/fbalpha2012_libretro.so > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao criar o link simbólico${RESET}"; exit 1; }
        echo -e "${AZUL}✔️  Core 'fbalpha2012_libretro.so' movido e link simbólico criado com sucesso!${RESET}"
    else
        echo -e "${VERDE}⚠️  Core 'fbalpha2012_libretro.so' não encontrado!${RESET}"
        exit 1
    fi

    # Remover a pasta /userdata/roms/fba_libretro/dep após mover os arquivos
    echo -e "${AMARELO}Removendo diretório temporário '/userdata/roms/fba_libretro/dep'...${RESET}"
    rm -rf /userdata/roms/fba_libretro/dep || { echo -e "${VERDE}Erro ao remover diretório '/userdata/roms/fba_libretro/dep'${RESET}"; exit 1; }
    echo -e "${AZUL}✔️  Diretório '/userdata/roms/fba_libretro/dep' removido com sucesso!${RESET}"

else
    echo -e "${VERDE}⚠️  Diretório '/userdata/roms/fba_libretro/dep' não encontrado!${RESET}"
    exit 1
fi

sleep 2

echo -e "${AMARELO}Removendo arquivos temporários...${RESET}"
rm -f FBAH > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao remover o arquivo temporário FBAH${RESET}"; exit 1; }
sleep 2

echo -e "${AMARELO}Salvando as configurações de overlay...${RESET}"
batocera-save-overlay > /dev/null 2>&1 || { echo -e "${VERDE}Erro ao salvar overlay. Tente novamente.${RESET}"; exit 1; }
sleep 2

echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO CONCLUÍDA COM SUCESSO!                          ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"

# Exibindo WhatsApp com destaque
echo -e "${AMARELO}${BOLD}🔔 Para mais informações ou suporte, entre em contato pelo WhatsApp: ${RESET}${VERDE}${BOLD}(41) 99820-5080${RESET}"

# Exibindo @JCGAMESCLASSICOS com destaque
echo -e "${AMARELO}${BOLD}🚀 Siga-nos no Youtuba para mais novidades: ${RESET}${VERDE}${BOLD}@JCGAMESCLASSICOS${RESET}"

# Finalizando
cd || exit 1
