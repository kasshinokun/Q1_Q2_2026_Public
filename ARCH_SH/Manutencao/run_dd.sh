LISTA_ISO=('LainOS-2025.12.31-x86_64.iso' 'linuxmint-22.3-cinnamon-64bit.iso' 'nebios-x-10.2-amd64+nvidia.iso' 'omegalinux-2026.02.27-x86_64.iso' 'LastOSLinux_Mint_22.3_amd64_2026-02-05_2057.iso' 'MocaccinoOS-KDE-0.20260228.iso' 'NuTyX_x86_64-systemd-26.02.2-XFCE4.iso')

while true; do
    clear
    echo "=============================="
    echo "Lista de ISO's:"
    for i in "${!LISTA_ISO[@]}"; do
        echo "$((i+1)). ${LISTA_ISO[$i]}"
    done
    echo "0. Sair"
    echo "------------------------------"
    read -p "Selecione uma opção [0-${#LISTA_ISO[@]}]: " opcao

    if [[ "$opcao" == "0" ]]; then
        echo "Encerrando...."
        break
    elif [[ "$opcao" =~ ^[0-9]+$ ]] && [[ "$opcao" -le ${#LISTA_ISO[@]} ]]; then
        # Subtraímos 1 para voltar ao índice correto da array
        ARQUIVO="${LISTA_ISO[$((opcao-1))]}"
        echo "Gravando: $ARQUIVO"
        sudo dd if="$ARQUIVO" of=/dev/sdb bs=4M status=progress conv=fsync
    else
        echo "Opção inválida: Tente novamente"
    fi

    read -p "Pressione [Enter] para voltar ao menu..."
done
