/* PROCEDIMENTOS */

CREATE OR REPLACE PROCEDURE renomear_aluno( IN mat INT, IN novo_nome TEXT )
AS
$$
	UPDATE alunos
	SET nom_alu = novo_nome
	WHERE mat_alu = mat;
$$
LANGUAGE SQL;

CALL renomear_aluno( 912590, 'genicleciae' );

CREATE OR REPLACE PROCEDURE marcar_professor( IN codProf INT )
AS
$$
DECLARE
	nome TEXT;
BEGIN
	SELECT nom_prof
	INTO nome
	FROM professores
	WHERE cod_prof = codProf;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'professor com o código % não encontrado', codProf;
	END IF;

	UPDATE professores
	SET nom_prof = nome || '·'
	WHERE cod_prof = codProf;
END
$$
LANGUAGE PLPGSQL;

CALL marcar_professor( 666 );

CREATE PROCEDURE defenestrar_aluno( IN matricula INT )
AS
$$
DECLARE
	encontrado INT;
BEGIN
	SELECT mat_alu
	INTO encontrado
	FROM alunos
	WHERE mat_alu = matricula;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'o aluno com matricula % não existe', matricula;
	ELSE
		DELETE FROM turmas_matriculadas
		WHERE mat_alu = matricula;

		DELETE FROM historicos_escolares
		WHERE mat_alu = matricula;

		DELETE FROM alunos
		WHERE mat_alu = matricula;
	END IF;
END
$$
LANGUAGE PLPGSQL;
