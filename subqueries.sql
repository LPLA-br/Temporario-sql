/*I
APENAS DISCIPLINAS QUE TEM "ALGORITMO E ESTRUTURA DE DADOS I" 501869
COMO PRÉ-REQUISITO (apenas subquerie):
*/

SELECT cod_disc, nom_disc
	FROM disciplinas
	WHERE cod_disc
	IN
	(
		SELECT cod_disc
		FROM pre_requisitos
		WHERE cod_disc_pre = 
		(
			SELECT cod_disc
			FROM disciplinas
			WHERE nom_disc = 'ALGORITMOS E ESTRUTURAS DE DADOS I'
		)
	);
/*II
Escreva uma consulta que retorne as disciplinas que possuem "ALGORITMOS DE ESTRUTURAS DE DADOS I"
como pré requisito usando join (e subquerie se necessário).*/

SELECT disciplinas.nom_disc
FROM disciplinas
INNER JOIN pre_requisitos
ON disciplinas.cod_disc = pre_requisitos.cod_disc
WHERE pre_requisitos.cod_disc_pre =
(
	SELECT cod_disc
	FROM disciplinas
	WHERE nom_disc = 'ALGORITMOS E ESTRUTURAS DE DADOS I'
);

/*
III
Escreva uma consulta que retorne os códigos das disciplinas e as quantidades de disciplinas
depedentes que elas possuem exemplo(programação em banco de dados depende de (bancos de dados) e
(introdução à programação)) 000000 2*/

SELECT cod_disc, count(cod_disc_pre) FROM pre_requisitos GROUP BY cod_disc;

/*
IIII
Escreva uma consulta que retorne a disciplina com o maior número de
dependentes (que é pré-requisito mais vezes)*/

SELECT disciplinas.cod_disc, disciplinas.nom_disc, COOL.count
FROM disciplinas
INNER JOIN 
(
	SELECT cod_disc, count(cod_disc_pre)
	FROM pre_requisitos
	GROUP BY cod_disc
	ORDER BY count DESC
) COOL
ON disciplinas.cod_disc = COOL.cod_disc
ORDER BY count DESC;

/*V
Construa um select que mostre a quantidade de alunos matriculados por curso.*/

SELECT cursos.nom_curso, COOL.cod_curso
FROM cursos
INNER JOIN
(
	SELECT count(nom_alu), cod_curso
	FROM alunos
	GROUP BY cod_curso
) COOL
ON cursos.cod_curso = COOL.cod_curso;

