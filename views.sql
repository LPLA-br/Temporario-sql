/* views */

CREATE OR REPLACE VIEW alunos_cursos
AS
SELECT alunos.nom_alu, cursos.nom_curso
FROM alunos
INNER JOIN
cursos
ON alunos.cod_curso = cursos.cod_curso;

CREATE OR REPLACE VIEW curso_professores
AS
SELECT BETA.nom_prof, BETA.email, BETA.cod_prof, BETA.cod_curso, ALPHA.nom_curso
FROM
(
	SELECT *
	FROM professores
) BETA
INNER JOIN
(
	SELECT *
	FROM cursos
) ALPHA
ON BETA.cod_curso = ALPHA.cod_curso;
