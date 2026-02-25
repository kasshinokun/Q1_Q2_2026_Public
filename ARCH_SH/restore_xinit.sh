#!/bin/bash
# Script para reativar o KDE Plasma e habilitar xinit no Arch Linux
# Uso: sudo ./reativar-kde.sh

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Função para imprimir mensagens de erro
error() {
    echo -e "${RED}[ERRO] $1${NC}" >&2
}

# Função para imprimir mensagens de sucesso
success() {
    echo -e "${GREEN}[OK] $1${NC}"
}

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    error "Este script deve ser executado como root. Use: sudo ./reativar-kde.sh"
    exit 1
fi

echo "Iniciando configuração do KDE Plasma..."

# 1. Instalar/atualizar o grupo plasma-meta (inclui o essencial)
echo "Verificando e instalando pacotes do Plasma..."
pacman -S --needed --noconfirm plasma-meta
if [[ $? -eq 0 ]]; then
    success "Pacotes do Plasma verificados/instalados."
else
    error "Falha ao instalar pacotes do Plasma. Verifique sua conexão e repositórios."
    exit 1
fi

# 2. Garantir que o SDDM (gerenciador de exibição) esteja instalado e ativo
echo "Configurando SDDM..."
if ! pacman -Qs sddm > /dev/null; then
    echo "SDDM não encontrado. Instalando..."
    pacman -S --noconfirm sddm
    if [[ $? -ne 0 ]]; then
        error "Falha ao instalar SDDM. Abortando."
        exit 1
    fi
fi

systemctl enable sddm
systemctl start sddm
success "SDDM habilitado e iniciado."

# 3. Configurar .xinitrc para cada usuário com diretório home
echo "Configurando arquivos .xinitrc para usuários..."
for user_home in /home/*; do
    if [[ -d "$user_home" ]]; then
        # Obtém o nome do usuário a partir do diretório
        username=$(basename "$user_home")
        user_xinitrc="$user_home/.xinitrc"

        # Se o arquivo não existir, cria com o conteúdo adequado
        if [[ ! -f "$user_xinitrc" ]]; then
            echo 'exec startplasma-x11' > "$user_xinitrc"
            chown "$username":"$username" "$user_xinitrc"
            success "Criado $user_xinitrc para o usuário $username"
        else
            # Se existir, verifica se já tem a linha do Plasma
            if ! grep -q "exec startplasma" "$user_xinitrc"; then
                # Faz backup antes de alterar
                cp "$user_xinitrc" "$user_xinitrc.backup.$(date +%Y%m%d%H%M%S)"
                echo 'exec startplasma-x11' >> "$user_xinitrc"
                success "Adicionado 'exec startplasma-x11' ao $user_xinitrc (backup criado)"
            else
                success "$user_xinitrc já configurado para Plasma."
            fi
        fi
    fi
done

# 4. Verificação adicional para placas NVIDIA (caso aplicável)
if lspci | grep -i nvidia > /dev/null; then
    echo "Placa NVIDIA detectada. Verificando drivers..."
    if ! pacman -Qs nvidia > /dev/null; then
        echo -e "${RED}Driver NVIDIA não encontrado. Recomenda-se instalar com:${NC}"
        echo "  sudo pacman -S nvidia nvidia-utils"
        echo "Após a instalação, regenere o initramfs: sudo mkinitcpio -P"
    else
        success "Driver NVIDIA parece estar instalado."
    fi
fi

echo ""
success "Configuração concluída!"
echo "Se ainda não estiver na interface gráfica, você pode:"
echo "  - Reiniciar o sistema: sudo reboot"
echo "  - Iniciar manualmente o SDDM agora: sudo systemctl start sddm"
echo "  - Testar o X iniciando com: startx (após fazer login como usuário normal)"