from pathlib import Path
import duckdb

# 1. Resolução dinâmica de caminhos
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data" / "olist_dataset"
DB_DIR = BASE_DIR / "database"

# Garante que a pasta database/ existe
DB_DIR.mkdir(parents=True, exist_ok=True)
DB_PATH = DB_DIR / "olist.duckdb"

print(f"📦 Criando/Conectando ao banco em: {DB_PATH}")
con = duckdb.connect(str(DB_PATH))

# 2. Mapeamento de Arquivos -> Tabelas
files_and_tables = [
    ("olist_customers_dataset.csv", "customers"),
    ("olist_sellers_dataset.csv", "sellers"),
    ("olist_products_dataset.csv", "products"),
    ("product_category_name_translation.csv", "product_category_name_translation"),
    ("olist_geolocation_dataset.csv", "geolocation"),
    ("olist_orders_dataset.csv", "orders"),
    ("olist_order_items_dataset.csv", "order_items"),
    ("olist_order_payments_dataset.csv", "order_payments"),
    ("olist_order_reviews_dataset.csv", "order_reviews"),
]

# 3. Ingestão direta via SQL
for file_name, table_name in files_and_tables:
    file_path = DATA_DIR / file_name

    if not file_path.is_file():
        print(f"❌ [AVISO] Arquivo não encontrado: {file_path}")
        continue

    print(f"⏳ Ingerindo {file_name} -> tabela '{table_name}'...")

    # O read_csv_auto lida com aspas, quebras de linha de reviews e tipos de data automaticamente
    query = f"""
        CREATE OR REPLACE TABLE {table_name} AS 
        SELECT * FROM read_csv_auto('{file_path.as_posix()}', header=True);
    """
    con.execute(query)

    count = con.execute(f"SELECT count(*) FROM {table_name}").fetchone()[0]
    print(f"✅ Tabela '{table_name}' criada com {count:,} registros.")

con.close()
print("\n🚀 Ingestão concluída com sucesso! Banco pronto para uso.")