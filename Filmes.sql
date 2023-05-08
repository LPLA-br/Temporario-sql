
create table if not exists atores(
	id serial not null,
	nome varchar(10) not null,
	constraint atores_pk primary key( id )
);

create table if not exists filmes(
	id serial not null,
	titulo varchar(10) not null,
	constraint filmes_pk primary key( id )
);

create table if not exists atua (
	id serial not null,
	id_ator int,
	id_filme int,
	constraint ator_e_filme_fk foreign key( id_ator ) references atores( id ),
	constraint filme_e_ator_fk foreign key( id_filme ) references filmes( id )
);

/*

Evite pensar em valores numéricos de chaves primárias. Use subqueries para abstrair

INSERT INTO atua( id_ator, id_filme )
VALUES
((SELECT id FROM atores WHERE nome = 'Zildo'),(SELECT id FROM filmes WHERE titulo = 'Zacarias' ));


selects em sequênciais para atingir as informações requisitadas

SELECT atores.nome, filmes.titulo
FROM atores
INNER JOIN atua ON atores.id = atua.id_ator
INNER JOIN filmes ON atua.id_filme = filmes.id;
*/

