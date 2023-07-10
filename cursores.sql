/*TESTANDO CURSORES*/

/*
[ [NO] SCROLL ] cursor capaz de correr às aversas também.
 */

CREATE OR REPLACE FUNCTION foo( IN bid INT )
RETURNS void AS $$
DECLARE
	-- Variável capaz de obter resultados
	-- advindos de consultas cursoras.
	-- UNBOUND - não é vinculado a uma consulta.
	teste REFCURSOR;

	--BOUND=vinculado
	testi CURSOR FOR SELECT media, mat_alu FROM historicos_escolares;

	--?
	testo CURSOR ( curso INT ) FOR SELECT * FROM alunos WHERE cod_curso = curso;

	------------------
	a REFCURSOR;

BEGIN
	--abertura é única e não pode ser repetida.

	--UNBOUND não vinculado necessita de uma consulta quando aberto.
	OPEN teste FOR SELECT nom_alu, mat_alu, faltas FROM alunos INNER JOIN historicos_escolares
	ON alunos.mat_alu = historicos_escolares.mat_alu WHERE faltas > 10;

	FOR tupla IN teste LOOP
		IF tupla.faltas > 20 THEN
			RAISE 'REPROVADUM POR TER NÚMERO DE FALTAS SUPERIOR À VINTE: %', tupla.nom_alu;
		ELSE
			RAISE NOTICE 'COM MAIS DE 10 FALTAS % %', tupla.nom_alu, tupla.faltas;
		END IF;
	END LOOP;

	--BOUND vinculados apenas são chamados. No máximo eles necessitam de parâmetros quando os exigem.
	OPEN testi;
	
	--FETCH=buscar [ direção {FROM|IN} ] cursor INTO var_alvo;
	--MOVE
	--UPDATE table SET ... WHERE CURRENT OF cursor;
	--DELETE

	WHILE TRUE LOOP
		IF testi IS NULL THEN
			EXIT;
		ELSEIF testi.media > 60 THEN
			RAISE NOTICE '% DE MÉDIA % ESTA APROVADO ', testi.mat_alu, testi.media;
		ELSE
			RAISE NOTICE '% DE MÉDIA % ESTA APROVADO ', testi.mat_alu, testi.media;
		END IF;
		FETCH NEXT FROM testi INTO a;
	END LOOP;

	CLOSE testi;


	OPEN testo ( curso := 10 );
	
	

	CLOSE testo;

	CLOSE teste;


END;
$$ LANGUAGE plpgsql;
