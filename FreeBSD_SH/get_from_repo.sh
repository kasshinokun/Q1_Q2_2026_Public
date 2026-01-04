# Tutorial FreeBSD (PT-BR)

# Atualizar repositórios e sistema
pkg update
pkg upgrade
# Instalar componentes básicos
pkg sudo
pkg install nano

# Instalar componentes básicos - interface grafica (GUI)
pkg install xorg
pkg install plasma
pkg install sddm
pkg install kde konsole

# extras
# pkg install -y kde5 sddm xorg plasma5-plasma plasma5-plasma-desktop plasma5-plasma-nm plasma5-kdeplasma-addons

# Verificar grupos e adicionar usuário aos grupos necessários
pw gropshow wheel
pw groupmod wheel -m <name_username>
pw groupmod video -m <name_username>
pw groupmod operator -m <name_username>

# Verificar hardware gráfico
pciconf -lv | grep -B3 VGA

# Instalar drivers gráficos (ajuste conforme sua GPU)
pkg install drm-kmod

# Configurar driver Intel (ajuste conforme sua GPU - pode ser amdgpu, radeonkms, etc.)
sysrc kld_list+="i915kms"

# Instalar Wayland e componentes
pkg install wayland seatd dbus

# Instalar aplicativos
pkg install fastfetch sybench firefox

# Habilitar dbus
sysrc dbus_enable="YES"

# Configurar seatd
pkg info seatd
pw groupadd seatd || true  # '|| true' evita erro se grupo já existir
pw groupmod seatd -m <name_username>
sysrc seatd_enable="YES"

# Habilitar sddm
sysrc sddm_enable="YES"

# Reiniciar para aplicar todas as configurações
echo "Reinicie o sistema com: reboot"
