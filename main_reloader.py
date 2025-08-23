
import sys
import time
import undetected_chromedriver as uc
from selenium.webdriver.chrome.options import Options
import logging
import argparse

# Configuração básica de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def reload_page(num_reloads, url, headless, delay, chrome_version):
    options = Options()
    if headless:
        options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    logging.info("Iniciando o navegador Chrome com undetected-chromedriver...")
    try:
        driver = uc.Chrome(version_main=chrome_version, options=options)
        logging.info("Navegador Chrome iniciado com sucesso.")
    except Exception as e:
        logging.error(f"Erro ao iniciar o navegador: {e}")
        sys.exit(1)

    logging.info(f"Iniciando recarregamento da página {num_reloads} vezes...")
    for i in range(num_reloads):
        logging.info(f"Tentando recarregar a página {i+1}/{num_reloads}...")
        try:
            driver.get(url)
            logging.info(f"Página recarregada {i+1}/{num_reloads} com sucesso. URL atual: {driver.current_url}")
            logging.debug(f"Título da página: {driver.title}")
        except Exception as e:
            logging.error(f"Erro no recarregamento {i+1}/{num_reloads}: {e}")
        time.sleep(delay)

    driver.quit()
    logging.info("Navegador fechado. Teste de recarregamento concluído.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Script para recarregar páginas web usando undetected_chromedriver.")
    parser.add_argument("-n", "--num_reloads", type=int, default=10, help="Número de vezes para recarregar a página.")
    parser.add_argument("-u", "--url", type=str, default="https://cults3d.com/pt/modelo-3d/arquitetura/metal-intercom-box", help="URL da página a ser recarregada.")
    parser.add_argument("-H", "--headless", action="store_true", help="Executar o navegador em modo headless (sem interface gráfica).")
    parser.add_argument("-d", "--delay", type=int, default=1, help="Atraso em segundos entre os recarregamentos.")
    parser.add_argument("-c", "--chrome_version", type=int, default=138, help="Versão principal do Chrome a ser utilizada (ex: 138).")

    args = parser.parse_args()

    reload_page(args.num_reloads, args.url, args.headless, args.delay, args.chrome_version)


