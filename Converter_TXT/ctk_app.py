# ctk_app.py
import os
import threading
import customtkinter as ctk
from tkinter import messagebox
from converter import listar_txts, converter_txt_para_pdf, BASE_DIR

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("TXT → PDF  |  Preview")
        self.geometry("1200x700")

        self.grid_columnconfigure((0, 1), weight=1)
        self.grid_rowconfigure(0, weight=1)

        self.arquivos = []

        # ===== FRAME ESQUERDO — INPUT =====
        self.frame_in = ctk.CTkFrame(self)
        self.frame_in.grid(row=0, column=0, sticky="nsew", padx=10, pady=10)
        self.frame_in.grid_columnconfigure(0, weight=1)
        self.frame_in.grid_rowconfigure(2, weight=1)

        ctk.CTkLabel(self.frame_in, text="📥 INPUT — Arquivo .txt", 
                     font=("", 16, "bold")).grid(row=0, column=0, pady=10)

        self.lista = ctk.CTkComboBox(self.frame_in, values=[], state="readonly", width=380)
        self.lista.grid(row=1, column=0, padx=20, pady=5)

        self.preview_in = ctk.CTkTextbox(self.frame_in, wrap="word")
        self.preview_in.grid(row=2, column=0, sticky="nsew", padx=20, pady=10)

        self.btn_preview = ctk.CTkButton(self.frame_in, text="🔄 Atualizar lista", 
                                         command=self.carregar_lista)
        self.btn_preview.grid(row=3, column=0, pady=10)

        # ===== FRAME DIREITO — OUTPUT =====
        self.frame_out = ctk.CTkFrame(self)
        self.frame_out.grid(row=0, column=1, sticky="nsew", padx=10, pady=10)
        self.frame_out.grid_columnconfigure(0, weight=1)
        self.frame_out.grid_rowconfigure(2, weight=1)

        ctk.CTkLabel(self.frame_out, text="📤 OUTPUT — Preview do PDF", 
                     font=("", 16, "bold")).grid(row=0, column=0, pady=10)

        self.lbl_pdf = ctk.CTkLabel(self.frame_out, text="(nenhum PDF gerado)", text_color="gray")
        self.lbl_pdf.grid(row=1, column=0, pady=5)

        self.preview_out = ctk.CTkTextbox(self.frame_out, wrap="word")
        self.preview_out.grid(row=2, column=0, sticky="nsew", padx=20, pady=10)

        self.btn_gerar = ctk.CTkButton(self.frame_out, text="⚙️ Gerar PDF", 
                                       command=self.iniciar_geracao_pdf)
        self.btn_gerar.grid(row=3, column=0, pady=10)

        # Binding
        self.lista.configure(command=self.on_selecionar)
        self.carregar_lista()

    def carregar_lista(self):
        self.arquivos = listar_txts()
        if not self.arquivos:
            self.lista.configure(values=["(nenhum .txt encontrado)"])
            self.lista.set("(nenhum .txt encontrado)")
            self.preview_in.delete("1.0", "end")
            return
            
        self.lista.configure(values=self.arquivos)
        self.lista.set(self.arquivos[0])
        self.on_selecionar(self.arquivos[0])

    def on_selecionar(self, nome):
        if nome not in self.arquivos:
            return
            
        caminho = BASE_DIR / nome
        try:
            with open(caminho, "r", encoding="utf-8") as f:
                conteudo = f.read()
        except Exception as e:
            conteudo = f"Erro ao ler: {e}"

        self.preview_in.delete("1.0", "end")
        self.preview_in.insert("1.0", conteudo)

        paginas = self._estimar_paginas(conteudo)
        self.preview_out.delete("1.0", "end")
        self.preview_out.insert("1.0",
            f"─── PRÉ-VISUALIZAÇÃO DO PDF ───\n\n"
            f"Arquivo de origem: {nome}\n"
            f"Páginas estimadas: {paginas}\n\n"
            f"{'─' * 40}\n\n"
            f"{conteudo}\n"
        )

    def _estimar_paginas(self, texto: str) -> int:
        linhas = texto.splitlines()
        linhas_por_pagina = 50
        return max(1, (len(linhas) + linhas_por_pagina - 1) // linhas_por_pagina)

    def iniciar_geracao_pdf(self):
        """Inicia a geração do PDF em uma thread separada para não travar a GUI."""
        nome = self.lista.get()
        if nome not in self.arquivos:
            messagebox.showwarning("Atenção", "Selecione um arquivo válido.")
            return

        self.btn_gerar.configure(state="disabled", text="⏳ Gerando...")
        self.lbl_pdf.configure(text="Processando...", text_color="orange")
        
        caminho_txt = BASE_DIR / nome
        threading.Thread(target=self._gerar_pdf_thread, args=(caminho_txt,), daemon=True).start()

    def _gerar_pdf_thread(self, caminho_txt):
        try:
            pdf = converter_txt_para_pdf(caminho_txt)
            # Atualiza a GUI de forma segura usando 'after'
            self.after(0, self._sucesso_geracao, pdf)
        except Exception as e:
            self.after(0, self._erro_geracao, str(e))

    def _sucesso_geracao(self, pdf_path):
        self.btn_gerar.configure(state="normal", text="⚙️ Gerar PDF")
        self.lbl_pdf.configure(text=f"✅ {os.path.basename(pdf_path)}", text_color="#4CAF50")
        messagebox.showinfo("Sucesso", f"PDF gerado em:\n{pdf_path}")

    def _erro_geracao(self, erro):
        self.btn_gerar.configure(state="normal", text="⚙️ Gerar PDF")
        self.lbl_pdf.configure(text="❌ Erro na geração", text_color="red")
        messagebox.showerror("Erro", f"Falha ao gerar PDF:\n{erro}")

def interface_gui():
    app = App()
    app.mainloop()

if __name__ == "__main__":
    interface_gui()