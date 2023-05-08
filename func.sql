-- press f to make functions


CREATE FUNCTION consulta_aluno( nome TEXT )
RETURNS TABLE( nomeCursoMatriculado TEXT, cred INT, mgp FLOAT )
AS $$
	SELECT cursos.nom_curso, cursos.tot_cred, alunos.mgp
	FROM alunos
	INNER JOIN cursos
	ON alunos.cod_curso = cursos.cod_curso
	WHERE alunos.nom_alu ILIKE nome;
$$ LANGUAGE SQL;


CREATE FUNCTION codigo_disciplina( nomeDisc TEXT )
RETURNS TABLE( cod INT )
AS $$
	SELECT cod_curso 
	FROM cursos
	WHERE nom_curso ILIKE '%' || nomeDisc || '%';
$$ LANGUAGE SQL;


