import os
import sys
import yaml
import psycopg2

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__)) 

PROJECT_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))

SQL_SCRIPTS_DIR = os.path.join(PROJECT_ROOT, "scripts") 

YAML_CONFIG_FILE = os.path.join(PROJECT_ROOT, "config.yaml") 

# DB_HOST = os.getenv("DB_HOST")
DB_HOST = "localhost"
# DB_USER = os.getenv("DB_USER")
DB_USER = "postgres"
# DB_PASS = os.getenv("DB_PASS")
DB_PASS = "P@ssw0rd" 
# DB_NAME = os.getenv("DB_NAME")
DB_NAME = "testescripts"

def get_scripts_from_yaml(config_file):
    """Carrega a lista de scripts a partir do arquivo YAML."""
    print(f"Lendo configuração de scripts em: {config_file}")
    if not os.path.exists(config_file):
        print(f"ERRO: Arquivo de configuração YAML não encontrado em {config_file}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)
            # Espera a chave 'scripts' conforme sua estrutura
            return config.get('scripts', [])
    except yaml.YAMLError as e:
        print(f"ERRO ao parsear o YAML: {e}", file=sys.stderr)
        sys.exit(1)

def connect_and_execute(filename):
    """Conecta ao DB e executa o conteúdo de um arquivo SQL."""
    # Monta o caminho completo usando a variável resolvida
    script_path = os.path.join(SQL_SCRIPTS_DIR, filename) 
    print(f"-> Executando script: {script_path}")

    if not os.path.exists(script_path):
        print(f"AVISO: Arquivo SQL '{filename}' não encontrado em {SQL_SCRIPTS_DIR}. Pulando.", file=sys.stderr)
        return

    conn = None
    try:
        # 1. Conexão (Ajuste o 'port' se necessário)
        conn = psycopg2.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            dbname=DB_NAME,
            port=5432 
        )
        conn.autocommit = True
        cursor = conn.cursor()

        # 2. Execução
        with open(script_path, 'r') as f:
            sql_command = f.read()

        cursor.execute(sql_command)
        print(f"   ✅ Script {filename} executado com sucesso.")

    except psycopg2.Error as e:
        print(f"ERRO de Banco de Dados ao executar {filename}: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    print(SCRIPT_DIR)
    print(PROJECT_ROOT)
    print(SQL_SCRIPTS_DIR)
    print(YAML_CONFIG_FILE)
    # Verifica se as variáveis de conexão estão presentes
    if not all([DB_HOST, DB_USER, DB_PASS]):
        print("ERRO: Variáveis de ambiente (DB_HOST, DB_USER, PGPASSWORD) não configuradas.", file=sys.stderr)
        sys.exit(1)

    # 1. Carrega a lista de scripts do YAML
    scripts_to_run = get_scripts_from_yaml(YAML_CONFIG_FILE)

    if not scripts_to_run:
        print("AVISO: Nenhuma script encontrada no arquivo YAML. Nenhuma migração executada.", file=sys.stderr)
        sys.exit(0)
    
    print(f"Iniciando a execução de {len(scripts_to_run)} scripts definidos no YAML...")

    # 2. Itera e executa os scripts na ordem do YAML
    for script in scripts_to_run:
        if isinstance(script, str):
            connect_and_execute(script)

    print("\n✅ Todos os scripts de inicialização foram processados com sucesso.")
