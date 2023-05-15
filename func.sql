-- press f to make functions

-- consultar dados do aluno
CREATE FUNCTION consulta_aluno( nome TEXT )
RETURNS TABLE( nomeCursoMatriculado TEXT, cred INT, mgp FLOAT )
AS $$
	SELECT cursos.nom_curso, cursos.tot_cred, alunos.mgp
	FROM alunos
	INNER JOIN cursos
	ON alunos.cod_curso = cursos.cod_curso
	WHERE alunos.nom_alu ILIKE nome;
$$ LANGUAGE SQL;

-- consultar código da disciplina pelo nome
CREATE FUNCTION codigo_disciplina( nomeDisc TEXT )
RETURNS TABLE( nome TEXT, codigo INT )
AS $$
	SELECT nom_disc, cod_disc
	FROM disciplinas
	WHERE nom_disc  ILIKE '%' || nomeDisc || '%';
$$ LANGUAGE SQL;

-- consultar código do curso pelo nome
CREATE FUNCTION codigo_curso( nomeCurso TEXT )
RETURNS TABLE( nome TEXT, codigo INT )
AS $$
	SELECT nom_curso, cod_curso
	FROM cursos
	WHERE nom_curso ILIKE '%' || nomeCurso || '%'; 
$$ LANGUAGE SQL;

-- consultar pre_requisitos de disciplina pelo seu código
CREATE FUNCTION pre_requisitos( codDisc INT )
RETURNS TABLE( discPreReqNom TEXT )
AS $$
	SELECT nom_disc
	FROM disciplinas
	WHERE cod_disc IN
	(
		SELECT cod_disc_pre
		FROM pre_requisitos 
		WHERE cod_disc = codDisc
	);	
$$ LANGUAGE SQL;

--AAA
/*
CREATE FUNCTION disciplinas_dependentes( discNome TEXT )
RETURNS TABLE( disc_nome TEXT, cod_disc INT, cod_disc_pre INT, nom_disc_pre TEXT )
AS $$
SELECT * FROM
(
	SELECT TABELAO.nom_disc, TABELAO.cod_disc, TABELAO.cod_disc_pre, disciplinas.nom_disc
	FROM disciplinas
	INNER JOIN
	(
		SELECT disciplinas.nom_disc, pre_requisitos.cod_disc, pre_requisitos.cod_disc_pre 
		FROM disciplinas
		INNER JOIN pre_requisitos
		ON disciplinas.cod_disc = pre_requisitos.cod_disc
	) TABELAO
	ON TABELAO.cod_disc_pre = disciplinas.cod_disc
) BIGCHUNGUS
WHERE BIGCHUNGUS.cod_disc_pre =
(
	SELECT cod_disc
	FROM disciplinas
	WHERE nom_disc = discNome
);
$$ LANGUAGE SQL;*/

--Produto cartesiando com cross join para distribuir um
--valor de código de curso para cada tupla da tabela gerada.
--Copiamos tuplas em curriculo apenas alterando curso.
CREATE FUNCTION copia_curso( codigoCursoAlvo INT, codigoCursoDestino INT )
AS $$
INSERT INTO
curriculos( cod_curso, cod_disc, periodo )
SELECT cod_curso, cod_disc, periodo
FROM cursos
CROSS JOIN
(
	SELECT cod_disc, periodo 
	FROM curriculos
	WHERE cod_curso = codigoCursoAlvo
) COPIA
WHERE cod_curso = codigoCursoDestino;
$$ LANGUAGE SQL;

