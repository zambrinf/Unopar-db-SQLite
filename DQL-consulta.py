import sqlite3

conn = sqlite3.connect('sisvendas.db')

cursor = conn.cursor()

#STRFTIME é uma função do SQLite que retira o ano, ou mês, ou dia de uma data
cursor.execute("""
SELECT
c.cidade_cliente,
s.nome_sku,
strftime('%Y', v.data_venda) as ano,
strftime('%m', v.data_venda) as mes,
SUM(s.peso_sku * v.qtd_venda) as peso_tt

FROM
vendas AS V
LEFT JOIN
sku AS S
ON V.id_sku = S.cod_sku

LEFT JOIN
cliente as C
on V.id_cliente = C.cod_cliente

GROUP BY
c.cidade_cliente,
s.nome_sku,
ano,
mes
""")

results = cursor.fetchall()  # associa à variável results o resultado obtido pela função SELECT acima

for i in results:
    print(i)