#!/bin/bash
# Curitiba 27 de Janeiro de 2025
# Editor Jeverson Dias da Silva ..........Youtube/@JCGAMESCLASSICOS
# Instalação do switch para o Batocera.Linux v40 e v41...
# https://github.com/JeversonDiasSilva/switch-2025
# mksquashfs * SYS

######
# Caminho do arquivo onde a versão está localizada
file_path="/userdata/system/data.version" 
#file_path="/userdata/data.version"

# Verifica se o arquivo existe
if [ ! -f "$file_path" ]; then
    echo "Arquivo não encontrado!"
    exit 1
fi

# Lê o conteúdo do arquivo
line=$(cat "$file_path")

# Extrai apenas o primeiro número de dois dígitos
version=$(echo "$line" | grep -oP '\b\d{2}\b' | head -n 1)

# Verifica se encontrou a versão
if [ -n "$version" ]; then
    echo "Versão detectada: $version"
    
    # Se a versão for 40, roda o comando l3afpad
    if [ "$version" == "40" ]; then
        echo "Versão 40 detectada, executando o comando l3afpad..."

    fi
    
    # Se a versão for 41, roda o comando pcmanfm
    if [ "$version" == "41" ]; then
        echo "Versão 41 detectada, executando o comando pcmanfm..."

    fi
else
    echo "Versão não encontrada."
fi
######

##
# Adicionar as bios e afins...
mkdir -p /userdata/bios/switch
mkdir -p /userdata/system
mkdir -p /userdata/system/configs/evmapy
mkdir -p /userdata/system/.local/share
mkdir -p /userdata/roms/switch

:<< "END"
cd /userdata/system
if [ -d /userdata/system/switch ]; then
    rm -r switch
    rm -r /userdata/bios/switch
fi
END
cd /userdata/system
curl -L https://github.com/JeversonDiasSilva/switch-2025/releases/download/v1.0/SYS_v1.0 -o /userdata/system/SYS_v1.0
unsquashfs -d _switch  SYS_v1.0 
find switch -type f -exec chmod +x {} \;

rm SYS_v1.0
cd /userdata/system/_switch
mv /userdata/system/_switch/switch /userdata/system
cd /userdata/system/switch/SYS
mv es_features_switch.cfg /userdata/system/configs/emulationstation/es_features_switch.cfg
mv es_systems_switch.cfg /userdata/system/configs/emulationstation/es_systems_switch.cfg
mv switch.keys /userdata/system/configs/evmapy
cd ..
###################$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#mv yuzu /userdata/system/configs/yuzu
#ln -s /userdata/system/configs/yuzu /userdata/system/.config/yuzu
	
cd /userdata/system/_switch/share
mv YUZU /userdata/system/configs/yuzu
ln -s /userdata/system/configs/yuzu /userdata/system/.config/yuzu
mv suyu "/userdata/system/.local/share/suyu"
mv yuzu "/userdata/system/.local/share/yuzu"
############!!!!!!!!!!!!! 
cp /userdata/system/.local/share/suyu/keys/* /userdata/bios/switch
curl -L https://github.com/JeversonDiasSilva/switch-2025/releases/download/v1.0/Firmware.17.0.0.zip -o /userdata/bios/switch/Firmware.17.0.0.zip

cd ..
rm -r share

cd extra
cp /userdata/system/switch/extra/yuzuEA.desktop /usr/share/applications
cp /userdata/system/switch/extra/yuzu.desktop /usr/share/applications
cp /userdata/system/switch/extra/Ryujinx-LDN.desktop /usr/share/applications
cp /userdata/system/switch/extra/Ryujinx.desktop /usr/share/applications
cp /userdata/system/switch/extra/switch-updater.desktop /usr/share/applications

rm -r /userdata/system/_switch 

###
echo "SALVANDO AS ALTERAÇÕES CRIADAS NO SISTEMA AGUARDE..."
batocera-save-overlay	

clear
echo ""
echo ""
echo -e "\033[1;32mTE AJUDOU ?\033[0m"
echo -e "\033[1;32mQUER ME PAGAR UM CAFÉ ?\033[0m"
echo -e "\033[1;32mPIX\033[0m"
echo -e "\033[1;32m41 998205080\033[0m"
echo -e "\033[1;32mCAUÃ BATISTA DIAS DA SILVA\033[0m"
echo -e "\033[1;35mby @RETROLUXXO\033[0m"