# converter.py
import os
import textwrap
from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas

# Diretório base do projeto
BASE_DIR = Path(__file__).parent.resolve()

def listar_txts() -> list[str]:
    """Lista todos os arquivos .txt no diretório do script."""
    return [f.name for f in BASE_DIR.iterdir() if f.is_file() and f.suffix.lower() == ".txt"]

def converter_txt_para_pdf(caminho_txt: str | Path, caminho_pdf: str | Path = None) -> str:
    """
    Lê o .txt linha a linha e escreve em PDF.
    Inclui quebra de linha automática para textos que excedem a largura da página.
    """
    caminho_txt = Path(caminho_txt)
    if caminho_pdf is None:
        caminho_pdf = caminho_txt.with_suffix(".pdf")
    else:
        caminho_pdf = Path(caminho_pdf)

    if not caminho_txt.exists():
        raise FileNotFoundError(f"Arquivo não encontrado: {caminho_txt}")

    largura, altura = A4
    c = canvas.Canvas(str(caminho_pdf), pagesize=A4)

    # Configurações de fonte e margem
    tamanho_fonte = 12
    fonte = "Helvetica"
    c.setFont(fonte, tamanho_fonte)
    
    margem_topo = altura - 50
    margem_esq = 50
    margem_dir = 50
    
    # Altura da linha padrão (tamanho da fonte + 20% de espaçamento)
    height_linha = tamanho_fonte * 1.20 
    
    # Calcula quantos caracteres cabem na linha para fazer o textwrap
    largura_util = largura - margem_esq - margem_dir
    # Estimativa: 1 caractere em Helvetica 12 tem aprox 0.5 de largura
    max_chars = int(largura_util / (tamanho_fonte * 0.5)) 

    y = margem_topo

    with open(caminho_txt, "r", encoding="utf-8") as f:
        for linha_original in f:
            linha = linha_original.rstrip('\n\r')
            
            # Quebra a linha se for muito longa para não sair da margem
            linhas_quebradas = textwrap.wrap(linha, width=max_chars) if linha else [""]
            
            for linha_formatada in linhas_quebradas:
                if y - height_linha < 0:  # Fim da folha → nova página
                    c.showPage()
                    c.setFont(fonte, tamanho_fonte)
                    y = margem_topo

                c.drawString(margem_esq, y, linha_formatada)
                y -= height_linha

    c.save()
    return str(caminho_pdf)