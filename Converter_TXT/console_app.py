# console_app.py
from converter import listar_txts, converter_txt_para_pdf, BASE_DIR

def interface_console():
    arquivos = listar_txts()
    if not arquivos:
        print(f"\n⚠️ Nenhum arquivo .txt encontrado em: {BASE_DIR}")
        return

    print("\n📂 Arquivos .txt encontrados:")
    for i, nome in enumerate(arquivos, 1):
        print(f"  [{i}] {nome}")

    while True:
        try:
            escolha = int(input("\nEscolha um número (0 para sair): "))
            if escolha == 0:
                return
            if 1 <= escolha <= len(arquivos):
                break
            print("❌ Opção inválida. Tente novamente.")
        except ValueError:
            print("❌ Digite apenas números.")

    arquivo_escolhido = BASE_DIR / arquivos[escolha - 1]
    
    try:
        print("\n⏳ Gerando PDF...")
        pdf_gerado = converter_txt_para_pdf(arquivo_escolhido)
        print(f"\n✅ PDF gerado com sucesso: {pdf_gerado}")
    except Exception as e:
        print(f"\n❌ Erro ao gerar PDF: {e}")

if __name__ == "__main__":
    interface_console()