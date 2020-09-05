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
    
INSERT INTO vendas(data_venda,id_cliente,id_sku,qtd_venda)
    VALUES('2020-08-11',1,1,80),('2020-08-12',1,2,100),('2020-08-11',2,1,40),('2020-08-10',3,2,200),('2020-08-01',3,1,160);

/* Consulta os dados para somar o peso das vendas por cidade e produto em determinado mês + view E ÍNDICE (serve para colunas ordenadas, melhorar performance) */
 
create index idx_data on vendas(data_venda);

CREATE VIEW  v_cidade_sku_mes AS
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

	WHERE
	c.cidade_cliente in (select cidade_cliente from cliente where nome_cliente LIKE '%Mercado%')

	GROUP BY
	c.cidade_cliente,
	s.nome_sku,
	ano,
	mes;

select * from v_cidade_sku_mes;

/* savepoint e commits */
SET AUTOCOMMIT = 0;
savepoint sp2;
update vendas set id_cliente = 1;
select * from vendas;
rollback to savepoint sp2;
select * from vendas;
commit;
savepoint sp3;

/* Funções e procedures */

SET GLOBAL log_bin_trust_function_creators = 1; /* para liberar criação de funções */

CREATE FUNCTION fn_mult (x DECIMAL(10,2), y DECIMAL(10,2))
	RETURNS DECIMAL(10,2)
    RETURN  x * y;

select cod_sku, fn_mult(qtd_pallet_sku, peso_sku) as Peso_Pallet from sku order by peso_pallet;

CREATE PROCEDURE proc_somano (var_ano int)
	SELECT cidade_cliente, nome_sku, ano, sum(peso_tt) FROM v_cidade_sku_mes where ano = var_ano group by cidade_cliente, nome_sku, ano;
    
CREATE PROCEDURE proc_somames (var_mes int)
	SELECT cidade_cliente, nome_sku, mes, sum(peso_tt) FROM v_cidade_sku_mes where mes = var_mes group by cidade_cliente, nome_sku, mes;

CALL proc_somano (2020);
CALL proc_somames (8);
