-- Active: 1684932917946@@127.0.0.1@5432@Labo_BD@OrtiScolastici
/*
Parte II.E - Trigger

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

/*
    A. Verifica del vincolo che ogni scuola dovrebbe concentrarsi su tre specie e ogni gruppo dovrebbe contenere 20 repliche
    -- [TESTATA E FUNZIONANTE]
*/
-- Trigge di verifica del vincolo -> Specie <= 3 per Scuola
CREATE OR REPLACE FUNCTION verifica_numero_specie()
RETURNS TRIGGER AS $$
DECLARE
    numero_specie INTEGER; -- Contatore per il numero di specie
BEGIN
    -- Controlla il numero di specie per la scuola
    SELECT COUNT(DISTINCT Specie), Orto.Scuola
    INTO numero_specie
    FROM Orto
    GROUP BY Orto.Scuola;
    -- Se il numero di specie è maggiore di 3, lancia un'eccezione
    IF numero_specie > 3 THEN
        RAISE EXCEPTION 'La scuola deve concentrarsi su massimo tre specie!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger di verifica del vincolo -> Repliche <= 20 per Gruppo
CREATE OR REPLACE FUNCTION verifica_numero_repliche()
RETURNS TRIGGER AS $$
DECLARE
    numero_repliche INTEGER;
BEGIN
    SELECT COUNT(*)
	INTO numero_repliche
    FROM Gruppo AS G
    WHERE G.IdGruppo = NEW.IdGruppo;

    IF numero_repliche > 20 THEN
        RAISE EXCEPTION 'Il gruppo può contenere al massimo 20 repliche!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione dei trigger
CREATE OR REPLACE TRIGGER controllo_numero_specie
BEFORE INSERT OR UPDATE ON Orto
FOR EACH ROW
EXECUTE FUNCTION verifica_numero_specie();

CREATE OR REPLACE TRIGGER controllo_numero_repliche
BEFORE INSERT OR UPDATE ON Gruppo
FOR EACH ROW
EXECUTE FUNCTION verifica_numero_repliche();

/*
    B. Generazione di un messaggio (o inserimento di una informazione di warning in qualche tabella) 
    quando viene rilevato un valore decrescente per un parametro di biomassa.
    -- [TESTATA E FUNZIONANTE]
*/