# main.py
from ctk_app import interface_gui
from console_app import interface_console

def select_interface(option: int):
    if option == 1:
        print("\n🖥️ Iniciando interface console...")
        interface_console()
    elif option == 2:
        print("\n🎨 Iniciando interface gráfica (CustomTkinter)...")
        interface_gui()

def operation_mode():
    while True:
        print("\n" + "=" * 45)
        print("       🔄 Conversor de .txt em .pdf 🔄")
        print("=" * 45)
        print(" Escolha uma das Interfaces para Iniciar:")
        print(" 1) Interface Console (CLI)")
        print(" 2) Interface Gráfica (GUI)")
        print(" 0) Sair")
        print("=" * 45)
        
        try:
            entrada = int(input("Digite um valor --> "))
        except ValueError:
            print("❌ Entrada inválida. Digite apenas números.")
            continue

        if entrada in (1, 2):
            select_interface(entrada)
        elif entrada == 0:
            print("\n" + "=" * 45)
            print("       Encerrando programa...")
            print("       👋 Obrigado por usar!")
            print("=" * 45 + "\n")
            break
        else:
            print("❌ Opção Inválida. Use 0, 1 ou 2.")

if __name__ == "__main__":
    operation_mode()