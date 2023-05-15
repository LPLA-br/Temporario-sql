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

-- se eu passar o nome de uma disciplina quero saber quais são as
-- outras disciplinas que depedem desta.
SELECT nom_disc
FROM disciplinas
WHERE cod_disc =
(
	SELECT cod_disc_pre
	FROM pre_requisitos
	WHERE cod_disc =
	(
		SELECT cod_disc
		FROM disciplinas
		WHERE nom_disc = 'TEORIA MACROECONOMICA I'
	)
);

