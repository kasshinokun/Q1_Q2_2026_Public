# Secure Permissions Changer Script

## Descrição

Este script Bash fornece uma maneira segura e interativa de alterar as permissões de um diretório especificado no sistema de arquivos Linux. Ele foi desenvolvido para corrigir as vulnerabilidades de segurança e os erros lógicos encontrados em scripts de alteração de permissões menos robustos, garantindo que as permissões sejam aplicadas de forma controlada e com a devida validação.

## Funcionalidades

*   **Validação de Caminho**: Verifica se o caminho do diretório fornecido pelo usuário realmente existe antes de prosseguir.
*   **Validação de Permissões**: Garante que as permissões inseridas estejam no formato octal correto (3 ou 4 dígitos).
*   **Uso Seguro de `sudo`**: Utiliza `sudo` para executar o comando `chmod`, garantindo que as permissões sejam alteradas com os privilégios necessários, mas exigindo a autenticação do usuário.
*   **Confirmação do Usuário**: Solicita uma confirmação explícita do usuário antes de aplicar as alterações de permissão, prevenindo modificações acidentais.
*   **Feedback Claro**: Fornece mensagens claras sobre o sucesso ou falha da operação.

## Pré-requisitos

*   Um sistema operacional baseado em Linux.
*   Acesso ao comando `sudo` e permissão para executar `chmod` com `sudo`.

## Como Usar

Siga os passos abaixo para usar o script:

1.  **Salve o Script**: Salve o conteúdo do script `fakeroot_permissions.sh` em um arquivo, por exemplo, `/home/ubuntu/fakeroot_permissions.sh`.

2.  **Torne o Script Executável**: Abra um terminal e execute o seguinte comando para dar permissão de execução ao script:
    ```bash
    chmod +x /home/ubuntu/fakeroot_permissions.sh
    ```

3.  **Execute o Script**: Execute o script a partir do terminal:
    ```bash
    ./home/ubuntu/fakeroot_permissions.sh
    ```

4.  **Siga as Instruções**: O script irá guiá-lo através dos seguintes passos:
    *   Será solicitado o **caminho completo do diretório** cujas permissões você deseja alterar.
    *   Em seguida, será solicitado que você insira as **permissões desejadas no formato octal** (por exemplo, `755` para permissões padrão de diretório, `644` para arquivos).
    *   O script exibirá um resumo das alterações propostas e pedirá sua **confirmação** (`y` ou `N`).
    *   Se confirmado, o script tentará alterar as permissões usando `sudo`. Você pode ser solicitado a inserir sua senha de `sudo`.

### Exemplo de Uso

```bash
====================================== Permissions Folder Changer ===================================
Please, type the path to the folder: /var/www/html
Please, enter the desired permissions in octal format (e.g., 755): 755

You are about to change the permissions of '/var/www/html' to '755'. Are you sure? (y/N) y

Attempting to change permissions with sudo...
[sudo] password for ubuntu: 
Successfully changed permissions for '/var/www/html' to '755'.
Script finished.
```

## Considerações de Segurança

*   **Princípio do Menor Privilégio**: Sempre aplique o princípio do menor privilégio ao definir permissões. Isso significa conceder apenas as permissões mínimas necessárias para que um usuário ou processo funcione corretamente.
*   **Evite `777` ou `7777`**: **Nunca use `chmod 777` ou `chmod 7777`** em ambientes de produção ou em qualquer diretório que contenha dados sensíveis. Essas permissões concedem acesso total a todos os usuários no sistema, criando uma enorme vulnerabilidade de segurança. O script foi projetado para aceitar qualquer valor octal válido, mas a responsabilidade de escolher permissões seguras é do usuário.
*   **Compreenda as Permissões Octais**: Certifique-se de entender o significado das permissões octais (leitura, escrita, execução para proprietário, grupo e outros, bem como bits especiais como setuid, setgid e sticky bit) antes de aplicá-las. Consulte a documentação do `chmod` ou recursos online para obter mais informações.
*   **Uso de `sudo`**: O script utiliza `sudo` para executar o `chmod`. Isso significa que o usuário que executa o script deve ter permissões `sudo` configuradas para o comando `chmod`. Se você não tiver certeza, consulte o administrador do sistema.

## Autor

Manus AI
