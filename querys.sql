-- Aula 02 - Atualizando e excluindo dados

--use controle_compras;

--CREATE DATABASE controle_compras;


--	CREATE TABLE compras(
--		id int primary key identity not null,
--		valor decimal(18,2),
--		data date,
--		observacoes nvarchar(200),
--		recebida bit
--	)


--INFORMAÇOES DA TABELA
--sp_help compras

/*
	insert into compras (valor, data, observacoes, recebida) 
	values (200, '2008-02-19', 'MATERIAL RAPEL', true)

	insert into compras (valor, data, observacoes, recebida) 
	values (3500, '2008-05-21', 'TELEVISAO', 1)
*/

/*SELECT * from compras
WHERE observacoes like 'parcela%'*/

/*_____________________________________________________________________________________________________________________________*/
/* PERGUNTAS AULA 01*/

-- Selecione VALOR e OBSERVAÇÕES de todas as compras cuja data seja maior-ou-igual que 15/12/2008.

SELECT DATA, VALOR, OBSERVACOES FROM compras WHERE data >= '2008-12-15'

-- Selecione todas as compras cuja data seja maior-ou-igual que 15/12/2008 e menor do que 15/12/2010.

SELECT * FROM compras WHERE data BETWEEN '2008-12-15' AND '2010-12-15'

-- Selecione todas as compras cujo valor esteja entre R$15,00 e R$35,00 e a observação comece com a palavra 'LANCHONETE'.

SELECT * FROM compras WHERE (valor BETWEEN 15 AND 35) AND observacoes LIKE 'LANCHONETE%'

-- Selecione todas as compras que já foram recebidas.

SELECT * FROM compras WHERE recebida = 1

-- Selecione todas as compras que ainda não foram recebidas.

SELECT * FROM compras WHERE recebida = 0

-- Selecione todas as compras com valor maior que 5.000,00 ou que já foram recebidas.

SELECT * FROM compras WHERE valor > 5000 AND recebida = 1

-- Selecione todas as compras que o valor esteja entre 1.000,00 e 3.000,00 ou maior que 5.000,00.

SELECT * FROM compras WHERE (valor BETWEEN 1000 AND 3000) OR valor > 5000
/*_____________________________________________________________________________________________________________________________*/

/*_____________________________________________________________________________________________________________________________*/
/* PERGUNTAS AULA 02*/

-- Altere as compras, colocando a observação 'preparando o natal' para todas as que foram efetuadas no dia 20/12/2010.
UPDATE compras SET
observacoes = 'preparando o natal'
WHERE data = '2010-12-20'

SELECT * FROM compras WHERE data = '2010-12-20'

-- Altere o VALOR das compras feitas antes de 01/06/2009. Some R$10,00 ao valor atual.

SELECT * FROM compras WHERE data < '2009-06-01'

UPDATE compras SET
valor = valor + 10
WHERE data < '2009-06-01'

-- Atualize todas as compras feitas entre 01/07/2009 e 01/07/2010 para que elas tenham a observação 'entregue antes de 2011' e a coluna recebida com o valor TRUE.

SELECT * FROM compras WHERE data BETWEEN '2009-07-01' AND '2010-07-01'

UPDATE compras SET
observacoes = 'entregue antes de 2011',
recebida = 'true'
WHERE DATA BETWEEN '2009-07-01' AND '2010-07-01'

-- Exclua as compras realizadas entre 05 e 20 março de 2009. 

SELECT * FROM compras WHERE data BETWEEN '2009-04-05' AND '2009-04-20'

DELETE FROM compras
WHERE data BETWEEN '2009-04-05' AND '2009-04-20'

-- Use o operador NOT e monte um SELECT que retorna todas as compras com valor diferente de R$ 108,00.

SELECT * FROM compras WHERE /*NOT valor = 108*/ valor <> 108
/*_____________________________________________________________________________________________________________________________*/

/*_____________________________________________________________________________________________________________________________*/
/* PERGUNTAS AULA 03*/

-- Configure o valor padrão para a coluna recebida

alter table compras add default '0' for recebida

insert into compras (valor, data, observacoes) values ('200', '2015‐10‐04', 'testando default')

select * from compras where observacoes = 'testando default'

-- Configure a coluna observacoes para não aceitar valores nulos.

alter table compras alter column observacoes nvarchar(400) not null

/*_____________________________________________________________________________________________________________________________*/

/*_____________________________________________________________________________________________________________________________*/
/* PERGUNTAS AULA 04*/


SELECT COUNT(*) valor FROM compras

SELECT MAX(valor) PREÇO_MAXIMO FROM compras

SELECT MIN(valor) PREÇO_MINIMO FROM compras

SELECT AVG(valor) MÉDIA FROM compras

SELECT SUM(valor) PREÇO_TOTAL FROM compras

SELECT observacoes, valor 
FROM compras
WHERE valor = (SELECT MIN(valor) FROM compras)

-- Calcule a média de todas as compras com datas inferiores a 12/05/2009.

select avg(valor) from compras where data < '2009-05-12'

-- Calcule a soma de todas as compras, agrupadas se a compra foi recebida ou não.

select sum(valor) as soma, recebida from compras
group by recebida





/*_____________________________________________________________________________________________________________________________*/
/* PERGUNTAS AULA 04*/

--Crie a tabela compradores com id , nome , endereco e telefone

create table compradores(
	id int primary key identity not null,
	nome nvarchar(200),
	endereco nvarchar(200),
	telefone nvarchar(30)
)

-- Insira os compradores: Guilherme Silveira e Gabriel Ferreira.

insert into compradores values ('Guilherme Silveira', 'Rua 1', '123456789')
insert into compradores values ('Gabriel Ferreira', 'Rua 2', '987654321')

-- Adicione a coluna comprador_id na tabela compras e defina a chave estrangeira ( foreign key ) referenciando o id da tabela compradores

alter table compras add comprador_id int
alter table compras add constraint FK_compras_comprador_id foreign key (comprador_id) references compradores (id)


-- Atualize a tabela compras e insira o id dos compradores na coluna comprador_id

update compras set comprador_id = 1 where id <= 23
update compras set comprador_id = 2 where id > 23

-- Exiba o NOME do comprador e o VALOR de todas as compras feitas antes de 09/08/2010.

select compradores.nome, compras.valor, compras.data from compras
inner join compradores on compras.comprador_id = compradores.id
where compras.data < '2010-08-09'

-- Exiba todas as compras do comprador que possui ID igual a 2.

select * from compras 
inner join compradores on compras.comprador_id = compradores.id
where compradores.id = 2

-- Exiba todas as compras (mas sem os dados do comprador), cujo comprador tenha nome que começa com 'GABRIEL'.

select compras.* from compras 
inner join compradores on compras.comprador_id = compradores.id
where compradores.nome like 'GABRIEL%'

-- Exiba o nome do comprador e a soma de todas as suas compras.

select compradores.nome, sum(compras.valor) as soma
from compras
inner join compradores on compras.comprador_id = compradores.id
group by compradores.nome
