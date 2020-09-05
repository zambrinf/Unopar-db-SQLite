/* Sistema de Vendas com tabelas cliente, sku e vendas; Populando as tabelas ; Query para consultar peso vendido por produto/cidade/mes */

CREATE DATABASE IF NOT EXISTS sisvendas
	DEFAULT CHARSET = utf8mb4
	DEFAULT COLLATE = utf8mb4_0900_ai_ci;

USE sisvendas;

CREATE TABLE IF NOT EXISTS cliente (
    cod_cliente SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_cliente VARCHAR(50) NOT NULL,
    cidade_cliente VARCHAR(50) NOT NULL,
    atividade_cliente ENUM('Ativo','Inativo') NOT NULL DEFAULT 'Ativo',
    PRIMARY KEY (cod_cliente)
);

CREATE TABLE IF NOT EXISTS sku (
    cod_sku SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_sku VARCHAR(50) NOT NULL,
    peso_sku SMALLINT UNSIGNED NOT NULL,
    qtd_pallet_sku SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (cod_sku)
);

CREATE TABLE IF NOT EXISTS vendas (
    id_venda INT UNSIGNED NOT NULL AUTO_INCREMENT,
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

/* Populando tabelas */

INSERT INTO cliente(nome_cliente,cidade_cliente,atividade_cliente)
    VALUES('Mercado Madre','Londrina','Ativo'),('Mercado Duque','Londrina','Ativo'),('Mercado Apucarana','Apucarana','Ativo');

INSERT INTO sku(nome_sku,peso_sku,qtd_pallet_sku) 
    VALUES('Arroz',30,40),('Feijão',12,50);

INSERT INTO vendas(data_venda,id_cliente,id_sku,qtd_venda)
    VALUES('2020-08-18',1,1,80),('2020-08-18',1,2,100),('2020-08-18',2,1,40),('2020-08-18',3,2,200),('2020-08-18',3,1,160);


/* Consulta os dados para somar o peso das vendas por cidade e produto em determinado mês */

SELECT
c.cidade_cliente,
s.nome_sku,
year(v.data_venda) as ano,
month(v.data_venda) as mes,
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
