#!/bin/bash 
# =============> Example code backup for future reference, if needed.

echo "Main Language Choice | Escolha do Idioma Principal"
echo "1) EN-US: English | 1) EN-US: Inglês Americano"
echo "2) PT-BR: Brazilian Portuguese | 2) PT-BR: Português Brasileiro"
echo "press Ctrl+C to exit. | Pressione Ctrl+C para sair."
echo "Please choice your language | Por favor escolha seu idioma."

while true; do
    read option_choice

    # Verifica se a entrada é um número
    if [[ ! "$option_choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter 1 or 2. | Entrada inválida. Por favor digite 1 ou 2."
        continue
    fi

    if [ "$option_choice" -eq 1 ]; then
        echo "English setted, initializing...."

        echo "Collecting username from the system's home folder"
        echo "Please enter your username from the home folder:"
        read OS_USER

        # Verifica se o diretório home existe
        if [ ! -d "/home/$OS_USER" ]; then
            echo "Error: User home directory not found!"
            continue
        fi

        # Cria diretório se não existir
        mkdir -p "/home/$OS_USER/Downloads/restore_xinit"

        cd "/home/$OS_USER/Downloads/restore_xinit" || exit

        echo "Downloading file to folder ...."
        curl -o restore_xinit.sh https://raw.githubusercontent.com/kasshinokun/Q1_Q2_2026_Public/refs/heads/main/ARCH_SH/restore_xinit.sh

        echo "Thank you very much, processes completed"
        break  # Sai do loop após sucesso

    elif [ "$option_choice" -eq 2 ]; then
        echo "Português Brasileiro, inicializando...."

        echo "Coletando nome do usuario da pasta home do sistema"
        echo "Por favor, digite seu nome de usuario da pasta home:"
        read USER

        # Verifica se o diretório home existe
        if [ ! -d "/home/$USER" ]; then
            echo "Erro: Diretório home do usuário não encontrado!"
            continue
        fi

        # Cria diretório se não existir
        mkdir -p "/home/$USER/Downloads/restore_xinit"

        cd "/home/$USER/Downloads/restore_xinit" || exit

        echo "Baixando arquivo na pasta ...."
        curl -o restore_xinit.sh https://raw.githubusercontent.com/kasshinokun/Q1_Q2_2026_Public/refs/heads/main/ARCH_SH/restore_xinit.sh

        echo "Muito obrigado, processos concluidos"
        break  # Sai do loop após sucesso

    else
        echo "Please try again. | Por favor tente novamente."
        echo "Please choice your language | Por favor escolha seu idioma:"
    fi
done

echo "Thank you so much, end's script | Muito obrigado, fim do script."
