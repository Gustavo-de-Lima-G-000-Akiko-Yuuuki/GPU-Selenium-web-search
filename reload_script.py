import sys
import time
import undetected_chromedriver as uc
from selenium.webdriver.chrome.options import Options
import logging

# Configuração básica de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Opcional: Configurar o nível de log para módulos específicos do Selenium/urllib3
# logging.getLogger('selenium').setLevel(logging.DEBUG)
# logging.getLogger('urllib3').setLevel(logging.DEBUG)

def reload_page(num_reloads):
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    logging.info("Iniciando o navegador Chrome com undetected-chromedriver...")
    try:
        # undetected_chromedriver não precisa de um Service object como o Selenium padrão
        # Ele gerencia o chromedriver automaticamente
        # Especificando a versão principal do Chrome para garantir compatibilidade
        driver = uc.Chrome(version_main=138, options=options)
        logging.info("Navegador Chrome iniciado com sucesso.")
    except Exception as e:
        logging.error(f"Erro ao iniciar o navegador: {e}")
        sys.exit(1)

    url = "https://cults3d.com/pt/modelo-3d/casa/metal-intercom-box"

    logging.info(f"Iniciando recarregamento da página {num_reloads} vezes...")
    for i in range(num_reloads):
        logging.info(f"Tentando recarregar a página {i+1}/{num_reloads}...")
        try:
            driver.get(url)
            logging.info(f"Página recarregada {i+1}/{num_reloads} com sucesso. URL atual: {driver.current_url}")
            # Exemplo de log de uma operação: obter o título da página
            logging.debug(f"Título da página: {driver.title}")
        except Exception as e:
            logging.error(f"Erro no recarregamento {i+1}/{num_reloads}: {e}")
        time.sleep(1) # Adiciona um pequeno atraso para simular o uso real

    driver.quit()
    logging.info("Navegador fechado. Teste de recarregamento concluído.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        try:
            reloads = int(sys.argv[1])
            reload_page(reloads)
        except ValueError:
            print("Uso: python reload_page.py <numero_de_recarregamentos>")
            logging.error("Número de recarregamentos inválido. Deve ser um inteiro.")
    else:
        print("Uso: python reload_page.py <numero_de_recarregamentos>")
        logging.warning("Nenhum número de recarregamentos especificado. Use: python reload_page.py <numero_de_recarregamentos>")


