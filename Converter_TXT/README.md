# 🔄 Conversor de TXT em PDF

Um conversor de arquivos `.txt` para `.pdf` em Python, com **duas interfaces** disponíveis: uma interface de linha de comando (CLI) e uma interface gráfica (GUI) construída com `customtkinter`.

O programa lista automaticamente todos os arquivos `.txt` encontrados no diretório do projeto, permite selecionar um deles e gera um PDF correspondente, com quebra de linha automática e paginação.

---

## ✨ Funcionalidades

- 📂 Listagem automática dos arquivos `.txt` disponíveis no diretório do projeto
- 🖥️ Interface Console (CLI) simples e direta
- 🎨 Interface Gráfica (GUI) com `customtkinter`, incluindo:
  - Pré-visualização do conteúdo do `.txt` (input)
  - Pré-visualização estimada do PDF gerado (output)
  - Estimativa de número de páginas
  - Geração do PDF em thread separada, sem travar a interface
- 📄 Geração de PDF com quebra de linha automática (`textwrap`) e paginação automática via `reportlab`
- 🚪 Menu inicial para escolher entre as interfaces (Console ou Gráfica)

---

## 📁 Estrutura do Projeto

```
.
├── main.py            # Ponto de entrada — menu de seleção de interface
├── console_app.py      # Interface de linha de comando (CLI)
├── ctk_app.py           # Interface gráfica (GUI) com customtkinter
├── converter.py        # Lógica central de conversão TXT → PDF
└── README.md
```

| Arquivo | Responsabilidade |
|---|---|
| `main.py` | Exibe o menu principal e direciona para a interface escolhida |
| `console_app.py` | Implementa o fluxo de conversão via terminal |
| `ctk_app.py` | Implementa o fluxo de conversão via interface gráfica |
| `converter.py` | Contém as funções `listar_txts()` e `converter_txt_para_pdf()`, usadas por ambas as interfaces |

---

## ⚙️ Requisitos

- Python 3.10 ou superior (uso de `list[str]` e `str \| Path` nas anotações de tipo)
- Dependências:
  - [`reportlab`](https://pypi.org/project/reportlab/)
  - [`customtkinter`](https://pypi.org/project/customtkinter/) (apenas para a interface gráfica)

### Instalação das dependências

```bash
pip install reportlab customtkinter
```

---

## ▶️ Como Usar

1. Coloque os arquivos `.txt` que deseja converter no mesmo diretório dos scripts.
2. Execute o programa principal:

```bash
python main.py
```

3. Escolha uma das opções no menu:

```
=============================================
       🔄 Conversor de .txt em .pdf 🔄
=============================================
 Escolha uma das Interfaces para Iniciar:
 1) Interface Console (CLI)
 2) Interface Gráfica (GUI)
 0) Sair
=============================================
```

- **Opção 1 — Console:** lista os `.txt` encontrados, escolha o número correspondente e o PDF será gerado no mesmo diretório.
- **Opção 2 — Gráfica:** selecione o arquivo no menu suspenso, visualize o conteúdo de entrada e a prévia do PDF, depois clique em **"⚙️ Gerar PDF"**.

O PDF gerado terá o mesmo nome do `.txt` de origem, com a extensão `.pdf`, salvo no mesmo diretório.

Também é possível executar cada interface isoladamente:

```bash
python console_app.py
# ou
python ctk_app.py
```

---

## 🧩 Detalhes Técnicos

- A conversão é feita lendo o `.txt` linha a linha e aplicando `textwrap.wrap()` para evitar que o texto ultrapasse a largura da página A4.
- A paginação é calculada dinamicamente: quando o conteúdo atinge o limite inferior da página, uma nova página é criada automaticamente (`canvas.showPage()`).
- Na interface gráfica, a geração do PDF roda em uma `threading.Thread` separada para manter a UI responsiva, com atualização segura da interface via `self.after(...)`.

---

## 👤 Autor

**Gabriel da Silva Cassino**

---

## 📜 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0 (GPLv3)**.

Consulte o texto completo da licença em:
[GNU_LICENSE.md](https://github.com/kasshinokun/Q1_Q2_2026_Public/blob/main/Converter_TXT/GNU_LICENSE.md)
