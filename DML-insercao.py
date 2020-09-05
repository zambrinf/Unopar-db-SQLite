import sqlite3

conn = sqlite3.connect('sisvendas.db')

cursor = conn.cursor()

cursor.execute("""
INSERT INTO cliente(nome_cliente,cidade_cliente,atividade_cliente)
    VALUES('Mercado Madre','Londrina','Ativo'),('Mercado Duque','Londrina','Ativo'),('Mercado Apucarana','Apucarana','Ativo');
""")

cursor.execute("""
INSERT INTO sku(nome_sku,peso_sku,qtd_pallet_sku) 
    VALUES('Arroz',30,40),('Feijão',12,50);
""")

cursor.execute("""
INSERT INTO vendas(data_venda,id_cliente,id_sku,qtd_venda)
    VALUES('2020-08-18',1,1,80),('2020-08-18',1,2,100),('2020-08-18',2,1,40),('2020-08-18',3,2,200),('2020-08-18',3,1,160);
""")

conn.commit()