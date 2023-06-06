/* GATILHOS */

--NEW nova linha para insert e update
--OLD antiga linha para delete e update

-- BEFORE | AFTER ação
--  

CREATE OR REPLACE FUNCTION disparo()
RETURNS TRIGGER AS
$$
BEGIN
	IF NEW.email IS NOT NULL THEN
		RAISE EXCEPTION 'gatilho negado: email definido !';
	END IF;

	NEW.email := 'undefined@ifac.edu.br';
	RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER algo BEFORE INSERT ON alunos
FOR EACH ROW EXECUTE FUNCTION disparo();

