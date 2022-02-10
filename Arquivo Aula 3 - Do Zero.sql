# --- AULA 3: ANÁLISES DE DADOS COM SQL --- #

-- Agrupamentos
-- Filtragem avançada
-- Joins
-- Subqueries
-- Criação de Views

-- Lembrando das tabelas do banco de dados...

SELECT * FROM alugueis;
SELECT * FROM atores;
SELECT * FROM atuacoes;
SELECT * FROM clientes;
SELECT * FROM filmes;

# =======        PARTE 1:        =======#
# =======  CRIANDO AGRUPAMENTOS  =======#

-- CASE 1. Você deverá começar fazendo uma análise para descobrir o preço médio de aluguel dos filmes.
--
select avg(preco_aluguel) from filmes;

-- Agora que você sabe o preço médio para se alugar filmes na hashtagmovie, você deverá ir além na sua análise e descobrir qual é o preço médio para cada gênero de filme.

/*
genero                   | preco_medio
______________________________________
Comédia                  | X
Drama                    | Y
Ficção e Fantasia        | Z
Mistério e Suspense      | A
Arte                     | B
Animação                 | C
Ação e Aventura          | D
*/

-- Você seria capaz de mostrar os gêneros de forma ordenada, de acordo com a média?

 select genero, 
 avg(preco_aluguel) as preco_medio 
 from filmes group by genero ;
    
    
-- Altere a consulta anterior para mostrar na nossa análise também a quantidade de filmes para cada gênero, conforme exemplo abaixo.

/*
genero                   | preco_medio      | qtd_filmes
_______________________________________________________
Comédia                  | X                | .
Drama                    | Y                | ..
Ficção e Fantasia        | Z                | ...
Mistério e Suspense      | A                | ....
Arte                     | B                | .....
Animação                 | C                | ......
Ação e Aventura          | D                | .......
*/

select genero, avg(preco_aluguel) as preco_medio,
count(*) as qtd_filmes
from filmes group by genero;


-- CASE 2. Para cada filme, descubra a classificação média, o número de avaliações e a quantidade de vezes que cada filme foi alugado. Ordene essa consulta a partir da avaliacao_media, em ordem decrescente.

/*
id_filme  | avaliacao_media   | num_avaliacoes  | num_alugueis
_______________________________________________________
1         | X                 | .               | .
2         | Y                 | ..              | ..
3         | Z                 | ...             | ...
4         | A                 | ....            | ....
5         | B                 | .....           | .....
...
*/
select id_filme, avg(nota) as avaliacao_media,
count(nota) as num_avaliacoes,
count(*) as num_alugueis
 from alugueis group by id_filme
 order by avaliacao_media desc; 


# =======              PARTE 2:               =======#
# =======  FILTROS AVANÇADOS EM AGRUPAMENTOS  =======#

-- CASE 3. Você deve alterar a consulta DO CASE 1 e considerar os 2 cenários abaixo:
-- case 1 modificado
select genero, 
 avg(preco_aluguel) as preco_medio ,
 count(*) as qtd_filmes
 from filmes where(ano_lancamento=2011) 
 group by genero ;
 
 
-- Cenário 1: Fazer a mesma análise, mas considerando apenas os filmes com ANO_LANCAMENTO igual a 2011.



-- Cenário 2: Fazer a mesma análise, mas considerando apenas os filmes dos gêneros com mais de 10 filmes.

select genero, 
 avg(preco_aluguel) as preco_medio ,
 count(*) as qtd_filmes
 from filmes group by genero
 having (qtd_filmes >= 10);
 


# =======              PARTE 3:              =======#
# =======  RELACIONANDO TABELAS COM O JOIN   =======#


-- CASE 4. Selecione a tabela de Atuações. Observe que nela, existem apenas os ids dos filmes e ids dos atores. Você seria capaz de completar essa tabela com as informações de títulos dos filmes e nomes dos atores?
-- 
select
atuacoes.*,
filmes.titulo,
atores.nome_ator 
 from atuacoes
left join filmes on atuacoes.id_filme = filmes.id_filme
left join atores on atuacoes.id_ator = atores.id_ator;


-- CASE 5. faça uma analise daMédia de avaliações para cada um  dos clientes

-- listar todos os clientes e agrupar e fazer a media 

select 
clientes.nome_cliente,
avg(alugueis.nota) as aval_med
 from alugueis 
 left join clientes
 on alugueis.id_cliente = clientes.id_cliente 
 group by clientes.nome_cliente;

# =======                         PARTE 4:                           =======#
# =======  SUBQUERIES: UTILIZANDO UM SELECT DENTRO DE OUTRO SELECT   =======#

-- CASE 6. Você precisará fazer uma análise de desempenho dos filmes. Para isso, uma análise comum é identificar quais filmes têm uma nota acima da média. Você seria capaz de fazer isso?

select 
filmes.titulo,
avg(alugueis.nota) as aval_med
 from alugueis 
 left join filmes
 on alugueis.id_filme = filmes.id_filme 
 group by filmes.titulo 
 having aval_med >= 7.94; -- nao e legal escrever isso na mão 
 
 select 
filmes.titulo,
avg(alugueis.nota) as aval_med
 from alugueis 
 left join filmes
 on alugueis.id_filme = filmes.id_filme 
 group by filmes.titulo 
 having aval_med >= (select avg(nota) from alugueis);

-- CASE 7. A administração da MovieNow quer relatar os principais indicadores de desempenho (KPIs) para o desempenho da empresa em 2018. Eles estão interessados em medir os sucessos financeiros, bem como o envolvimento do usuário. Os KPIs importantes são, portanto, a receita proveniente da locação de filmes, o número de locações de filmes e o número de clientes ativos (descubra também quantos clientes não estão ativos).




# =======   PARTE 5:     =======#
# =======  CREATE VIEW   =======#
-- CREATE/DROP VIEW: Guardando o resultado de uma consulta no nosso banco de dados
-- CASE 8. Crie uma view para guardar o resultado do SELECT abaixo.
create view Resultados as
 (
SELECT
	titulo,
    COUNT(*) AS num_alugueis,
    AVG(nota) AS media_nota,
    SUM(preco_aluguel) AS receita_total
FROM alugueis
LEFT JOIN filmes
ON alugueis.id_filme = filmes.id_filme
GROUP BY titulo
ORDER BY num_alugueis DESC
);

select * from resultados ;

