-- press f to make functions

-- consultar dados do aluno
CREATE OR REPLACE FUNCTION consulta_aluno( nome TEXT )
RETURNS TABLE( nomeCursoMatriculado TEXT, cred INT, mgp FLOAT )
AS $$
BEGIN
	SELECT cursos.nom_curso, cursos.tot_cred, alunos.mgp
	FROM alunos
	INNER JOIN cursos
	ON alunos.cod_curso = cursos.cod_curso
	WHERE alunos.nom_alu ILIKE nome;
END
$$ LANGUAGE PLPGSQL;

-- consultar código da disciplina pelo nome
CREATE OR REPLACE FUNCTION codigo_disciplina( nomeDisc TEXT )
RETURNS TABLE( nome TEXT, codigo INT )
AS $$
BEGIN
	SELECT nom_disc, cod_disc
	FROM disciplinas
	WHERE nom_disc  ILIKE '%' || nomeDisc || '%';
END
$$ LANGUAGE PLPGSQL;

-- consultar código do curso pelo nome
CREATE OR REPLACE FUNCTION codigo_curso( nomeCurso TEXT )
RETURNS TABLE( nome TEXT, codigo INT )
AS $$
BEGIN
	SELECT nom_curso, cod_curso
	FROM cursos
	WHERE nom_curso ILIKE '%' || nomeCurso || '%'; 
END
$$ LANGUAGE PLPGSQL;

-- consultar pre_requisitos de disciplina pelo seu código
CREATE OR REPLACE FUNCTION pre_requisitos( codDisc INT )
RETURNS TABLE( discPreReqNom TEXT )
AS $$
BEGIN
	SELECT nom_disc
	FROM disciplinas
	WHERE cod_disc IN
	(
		SELECT cod_disc_pre
		FROM pre_requisitos 
		WHERE cod_disc = codDisc
	);	
END
$$ LANGUAGE PLPGSQL;

--AAA
CREATE OR REPLACE FUNCTION disciplinas_dependentes( discNome TEXT )
RETURNS TABLE( disc_nome TEXT, cod_disc INT, cod_disc_pre INT, nom_disc_pre TEXT )
AS $$
BEGIN
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
END
$$ LANGUAGE PLPGSQL;

--Produto cartesiando com cross join para distribuir um
--valor de código de curso para cada tupla da tabela gerada.
--Copiamos tuplas em curriculo apenas alterando curso.
CREATE OR REPLACE FUNCTION copia_curso( codigoCursoAlvo INT, codigoCursoDestino INT )
RETURNS VOID
AS $$
BEGIN
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
END
$$ LANGUAGE PLPGSQL;

/*

dbacademico=> select * from curriculos limit 1;
 cod_curso | cod_disc | periodo 
-----------+----------+---------
         3 |   200070 |       1

	dbacademico=> select * from cursos limit 1;
	 cod_curso | tot_cred |      nom_curso      | cod_coord 
	-----------+----------+---------------------+-----------
		 3 |      180 | Ciencias Economicas |       241

		dbacademico=> select * from professores limit 1;
		 cod_prof | cod_curso | nom_prof | email 
		----------+-----------+----------+-------
		       11 |        26 | DOMINGOS | 

		dbacademico=> select * from alunos limit 1;
		 mat_alu | cod_curso |  dat_nasc  | tot_cred | mgp | nom_alu | email 
		---------+-----------+------------+----------+-----+---------+-------
		  911094 |        10 | 1979-07-02 |      158 | 4.8 | Benetti | 
 */

--migra curso
CREATE OR REPLACE FUNCTION migra_curso( codigoCursoAntigo INT, codigoCursoNovo INT )
RETURNS VOID
AS $$
DECLARE
	codigoDoCoordenador INT;
BEGIN
	--migrar professores para novo curso.
	UPDATE professores
	SET cod_curso = codigoCursoNovo
	WHERE cod_curso = codigoCursoAntigo;

	--migrar alunos para novo curso.
	UPDATE alunos
	SET cod_curso = codigoCursoNovo
	WHERE cod_curso = codigoCursoAntigo;

	--migrar o coordenador.
	codigoDoCoordenador :=
	(
		SELECT cod_coord
		FROM cursos
		WHERE cod_curso = codigoCursoAntigo
	);

	UPDATE cursos
	SET cod_coord = NULL
	WHERE cod_curso = codigoCursoAntigo;

	UPDATE cursos
	SET cod_coord = codigoDoCoordenador
	WHERE cod_curso = codigoCursoNovo;


END
$$ LANGUAGE PLPGSQL;

