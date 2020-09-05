import sqlite3  # importa biblioteca do SQLite

conn = sqlite3.connect('sisvendas.db')  # cria um banco de dados

cursor = conn.cursor() #cria o cursor que vai executar os comandos sql

# Algumas mudanças no primary key para se adequar ao SQLite
# não há o tipo "ENUM" também

cursor.execute("""
CREATE TABLE IF NOT EXISTS cliente (
    cod_cliente INTEGER,
    nome_cliente VARCHAR(50) NOT NULL,
    cidade_cliente VARCHAR(50) NOT NULL,
    atividade_cliente VARCHAR(7) DEFAULT 'Ativo' NOT NULL,
    PRIMARY KEY (cod_cliente)
);
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS sku (
    cod_sku INTEGER,
    nome_sku VARCHAR(50) NOT NULL,
    peso_sku SMALLINT UNSIGNED NOT NULL,
    qtd_pallet_sku SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (cod_sku)
);
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS vendas (
    id_venda INTEGER,
    data_venda DATE NOT NULL,
    id_cliente SMALLINT UNSIGNED NOT NULL,
    id_sku SMALLINT UNSIGNED NOT NULL,
    qtd_venda SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_venda),
    CONSTRAINT fk_id_cliente 
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(cod_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_sku 
        FOREIGN KEY (id_sku)
        REFERENCES sku(cod_sku)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
""")

conn.commit()  # esse commit funciona como se fosse o commit do SQL mesmo, vai salvar os dados no BD