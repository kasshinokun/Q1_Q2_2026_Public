pkg update
pkg upgrade
pkg install xorg
pkg install plasma
pkg install sddm
pkg sudo
pkg install kde konsole
pkg install nano
pw gropshow wheel
pw groupmod wheel -m <name_username>
pw groupmod video -m <name_username>
pw groupmod operator -m <name_username>
pciconf -lv | grep -B3 VGA
pkg install drm-kmod
sysrc kld_list+="i915kms"
pkg install wayland seatd dbus
pkg install fastfetch sybench firefox
sysrc dbus_enable="YES"

pkg info seatd
pw groupadd seatd
pw groupmod seatd -m <name_username>
sysrc seatd_enable="YES"

sysrc sddm_enable="YES"

