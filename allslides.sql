-- SUBCONSULTAS

-- curso e a data de nascimento dos alunos mais velhos de cada (pode remover DISTINCT)
SELECT DISTINCT nom_curso,
(
	SELECT min(dat_nasc)
	FROM alunos
	WHERE alunos.cod_curso = cursos.cod_curso
)
AS alunoMaisVelho
FROM cursos;

-- número de matricula com base em data = data.concat(diferêncial);
-- matricula mais recente
SELECT DISTINCT nom_curso,
(
	SELECT max( mat_alu )
	FROM alunos
	WHERE alunos.cod_curso = cursos.cod_curso
)
AS alunoMaisVelho
FROM cursos;

-- disciplinas que não possuem pré requisitos para serem cursadas.
SELECT disciplinas.nom_disc
FROM disciplinas
WHERE disciplinas.cod_disc NOT IN
(
	SELECT DISTINCT cod_disc
	FROM pre_requisitos
);





/*	EXPRESSÕES DE SUBCONSULTAS
EXISTS (subconsulta)		--true ou false
[NOT] IN (subconsulta)		--uma coluna
ANY|SOME (subconsulta)		--uma coluna
operador ALL (subconsulta)	--uma coluna
*/

--apenas alunos que estão na disciplina de Ciencias Economicas (LPLA)
SELECT mat_alu ,nom_alu
FROM alunos
WHERE cod_curso
IN
(
	SELECT cod_curso
	FROM cursos
	WHERE nom_curso = 'Ciencias Economicas'
);

--disciplinas que existem em pre_requisitos.
SELECT disciplinas.nom_disc
FROM disciplinas
WHERE EXISTS
(
	SELECT 1
	FROM pre_requisitos
	WHERE cod_disc = disciplinas.cod_disc
);

-- apenas cursos que existem no curriculo oficial
SELECT cursos.nom_curso
FROM cursos
WHERE EXISTS
(
	SELECT cod_curso
	FROM curriculos
	WHERE cursos.cod_curso = curriculos.cod_curso
);

-- disciplinas que não são pre_requisitos doutras (não igual para todos da sub)
-- noutras palavras: exiba a disciplina onde o código
-- da disciplina não seja igual a todos os resultados da subconsulta.
SELECT disciplinas.nom_disc
FROM disciplinas
WHERE disciplinas.cod_disc <> ALL
(
	SELECT DISTINCT cod_disc FROM pre_requisitos
);

/*JOINS TREINO*/
--todos os cursos de Ciencias Economicas e seus respectivos periodos em ordem crescente.
SELECT cursos.nom_curso, curriculos.periodo, disciplinas.nom_disc
FROM cursos
INNER JOIN curriculos
ON cursos.cod_curso = curriculos.cod_curso
INNER JOIN disciplinas
ON curriculos.cod_disc = disciplinas.cod_disc
WHERE cursos.nom_curso = 'Ciencias Economicas'
ORDER BY curriculos.periodo;

-- autorelacionamento de disciplinas com subconsulta que gera tabela. disciplinas e seus pre_requisitos.
SELECT TABELAO.nome ,TABELAO.codigo, TABELAO.codigopre, disciplinas.nom_disc FROM
(
	SELECT disciplinas.nom_disc AS nome, pre_requisitos.cod_disc AS codigo, pre_requisitos.cod_disc_pre AS codigopre
	FROM disciplinas
	INNER JOIN pre_requisitos
	ON disciplinas.cod_disc = pre_requisitos.cod_disc
) TABELAO
INNER JOIN disciplinas ON TABELAO.codigopre = disciplinas.cod_disc ;

-- o mesmo de cima sem ALIAS
SELECT TABELAO.nom_disc ,TABELAO.cod_disc, TABELAO.cod_disc_pre, disciplinas.nom_disc, disciplinas.cod_disc
FROM
(
	SELECT disciplinas.nom_disc, pre_requisitos.cod_disc, pre_requisitos.cod_disc_pre
	FROM disciplinas
	INNER JOIN pre_requisitos
	ON disciplinas.cod_disc = pre_requisitos.cod_disc
) TABELAO
INNER JOIN disciplinas
ON TABELAO.cod_disc_pre = disciplinas.cod_disc ;

