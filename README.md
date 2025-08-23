![Imagem de Propaganda](https://github.com/Gustavo-de-Lima-G-000-Akiko-Yuuuki/GPU-Selenium-web-search/blob/main/Image2.png?raw=true)

# Python Web Page Reloader

Este projeto oferece uma ferramenta baseada em Python para recarregar páginas web automaticamente usando `undetected_chromedriver`. Ele é projetado para simular o comportamento de um usuário real, evitando detecções de bots e permitindo o recarregamento de páginas para diversos propósitos, como monitoramento, testes de carga ou interação contínua com conteúdo dinâmico.

## Funcionalidades

- **Recarregamento Automático**: Recarrega uma URL específica um número configurável de vezes.
- **Modo Headless**: Opção para executar o navegador em segundo plano, sem interface gráfica.
- **Atraso Configurável**: Define um intervalo entre os recarregamentos para simular um comportamento mais natural.
- **Compatibilidade com `undetected_chromedriver`**: Utiliza `undetected_chromedriver` para evitar detecções e bloqueios.
- **Menu Interativo (Windows)**: Scripts `.bat` fornecem um menu de linha de comando para fácil interação, permitindo:
    - Recarregamentos pré-definidos (100, 500, 1000 vezes).
    - Recarregamento personalizado (N vezes).
    - Definição de URL alvo.
    - Acesso a um shell Python.
    - Ferramentas avançadas para gerenciamento de dependências (instalar, atualizar, listar).
- **Suporte a Múltiplas Linguagens**: Menus de controle em Inglês (`RUN_ENGLISHX.bat`) e Português (`RUN_PTBRX.bat`).

## Requisitos

Para executar este projeto, você precisará de:

- **Python 3.x**: O projeto é configurado para usar uma versão embarcada do Python (e.g., `python-3.11.0rc1-embed-amd64`).
- **Google Chrome**: O `undetected_chromedriver` requer uma instalação do Google Chrome no seu sistema.
- **Dependências Python**: Todas as dependências são listadas no arquivo `requirements.txt`.

## Instalação

1. **Clone o Repositório**:

   ```bash
   git clone <URL_DO_SEU_REPOSITORIO>
   cd <nome_do_seu_repositorio>
   ```

2. **Configure o Python Embarcado**:

   Certifique-se de que a pasta `python-3.11.0rc1-embed-amd64` (ou a versão que você está usando) esteja presente no diretório raiz do projeto e contenha o executável `python.exe`.

   **Importante**: Para que o `pip` funcione corretamente com o Python embarcado, você pode precisar descomentar a linha `import site` no arquivo `python311._pth` (ou equivalente) dentro da pasta do Python embarcado.

3. **Instale as Dependências**:

   Execute um dos scripts `.bat` (por exemplo, `RUN_PTBRX.bat` ou `RUN_ENGLISHX.bat`). No menu principal, selecione a opção para **Ferramentas Avançadas** (ou `Advanced Tools`), e então escolha **Instalar dependências** (ou `Install dependencies`). Isso usará o `pip` para instalar todas as bibliotecas necessárias listadas em `requirements.txt`.

   Alternativamente, você pode instalar manualmente:

   ```bash
   .\python-3.11.0rc1-embed-amd64\python.exe -m pip install -r requirements.txt
   ```

## Uso

Para iniciar o programa, execute um dos scripts `.bat`:

- Para o menu em Português:
  ```bash
  RUN_PTBRX.bat
  ```

- Para o menu em Inglês:
  ```bash
  RUN_ENGLISHX.bat
  ```

### Opções do Menu

Uma vez no menu, você pode:

- Escolher um número pré-definido de recarregamentos.
- Definir um número personalizado de recarregamentos.
- Alterar a URL alvo para recarregamento.
- Acessar um shell Python para executar comandos diretamente.
- Gerenciar as dependências do projeto.

### Execução Direta do Script Python (Avançado)

Você também pode executar o script `main_reloader.py` diretamente via linha de comando, sem usar os menus `.bat`:

```bash
.\python-3.11.0rc1-embed-amd64\python.exe main_reloader.py -n <num_reloads> -u <url> [-H] [-d <delay>] [-c <chrome_version>]
```

**Argumentos:**

- `-n`, `--num_reloads`: Número de vezes para recarregar a página (padrão: 10).
- `-u`, `--url`: URL da página a ser recarregada (padrão: `https://cults3d.com/pt/modelo-3d/arquitetura/metal-intercom-box`).
- `-H`, `--headless`: Executar o navegador em modo headless (sem interface gráfica). (Opcional)
- `-d`, `--delay`: Atraso em segundos entre os recarregamentos (padrão: 1). (Opcional)
- `-c`, `--chrome_version`: Versão principal do Chrome a ser utilizada (ex: 138). (Opcional)

## Estrutura do Projeto

```
.|
├── python-3.11.0rc1-embed-amd64/  # Python embarcado
├── main_reloader.py              # Script principal de recarregamento
├── menu_script.py                # (Possivelmente duplicado de main_reloader.py)
├── reload_script.py              # Script de recarregamento simplificado
├── requirements.txt              # Lista de dependências Python
├── RUN_ENGLISHX.bat              # Script de menu em Inglês (para Windows)
├── RUN_PTBRX.bat                 # Script de menu em Português (para Windows)
└── README.md                     # Este arquivo
```

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes. (Assumindo licença MIT, crie o arquivo se não existir).



![Imagem de Propaganda](https://github.com/Gustavo-de-Lima-G-000-Akiko-Yuuuki/GPU-Selenium-web-search/blob/main/Image2.png?raw=true)




![Imagem de Propaganda](/home/ubuntu/upload/ChatGPTImage13deago.de2025,21_54_12.png)
