#!/bin/bash

#sudo apt update
#sudo apt upgrade -y


#sudo apt install nginx -y


#sudo systemctl start nginx


# sudo systemctl enable nginx
######################################################################################################################################

# Função para imprimir mensagens com cores e formatação
function print_message {
    echo -e "\n\e[1;32m$1\e[0m"
}

# Inicia o processo de instalação
print_message "==========================================="
print_message "Iniciando a instalação do Nginx e Certbot"
print_message "==========================================="

# Atualiza o sistema e instala pacotes necessários
echo "Atualizando o sistema e instalando pacotes necessários..."
sudo apt update && sudo apt upgrade -y

# Instala o Nginx
echo "Instalando o Nginx..."
sudo apt install nginx -y

# Inicia e habilita o Nginx
print_message "Iniciando o Nginx e configurando para iniciar automaticamente..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Verifica se o Nginx foi instalado corretamente
if [ $? -eq 0 ]; then
    print_message "Nginx instalado e iniciado com sucesso!"
else
    echo "Erro ao iniciar o Nginx."
    exit 1
fi

# Instala o Certbot e o plugin Nginx
print_message "====================================="
print_message "Instalando o Certbot e o Plugin Nginx"
print_message "====================================="
sudo apt install certbot python3-certbot-nginx -y

# Verifica se o Certbot foi instalado com sucesso
if [ $? -eq 0 ]; then
    print_message "Certbot e o plugin Nginx instalados com sucesso!"
else
    echo "Erro ao instalar o Certbot."
    exit 1
fi

# Solicita o e-mail para o Let's Encrypt
read -p "Digite seu e-mail para o Let's Encrypt: " email

# Solicita os domínios para o certificado SSL
read -p "Digite os domínios separados por espaço (ex: exemplo.com www.exemplo.com): " domains

# Obtem o certificado SSL com Certbot
print_message "Obtendo o certificado SSL para os domínios: $domains..."
sudo certbot --nginx --agree-tos --no-eff-email --email "$email" -d $domains

# Verifica se o Certbot obteve o certificado com sucesso
if [ $? -eq 0 ]; then
    print_message "Certificado SSL instalado e configurado com sucesso!"
else
    echo "Houve um erro ao obter o certificado SSL."
    exit 1
fi

# Configura a renovação automática do certificado
print_message "====================================="
print_message "Configurando a renovação automática"
print_message "====================================="
echo "0 0,12 * * * root certbot renew --quiet && systemctl reload nginx" | sudo tee -a /etc/crontab > /dev/null

# Verifica se a configuração da renovação foi bem-sucedida
if [ $? -eq 0 ]; then
    print_message "Renovação automática configurada com sucesso!"
else
    echo "Erro ao configurar a renovação automática."
    exit 1
fi

# Finaliza a instalação
print_message "================================================="
print_message "Configuração concluída com sucesso!"
print_message "Seu servidor Nginx está agora configurado com HTTPS!"
print_message "==============================================="