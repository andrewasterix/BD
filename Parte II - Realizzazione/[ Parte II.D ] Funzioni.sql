/*
Parte II.D - Funzioni

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

/*
    A - Funzione che realizza l’abbinamento tra gruppo e gruppo di controllo nel caso di operazioni di bio-monitoraggio.
    -- [TESTATA E FUNZIONANTE]
*/
CREATE OR REPLACE FUNCTION match_groups()
RETURNS TABLE (group_id BIGINT, control_group_id BIGINT, common_name VARCHAR(100)) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT g1.IdGruppo, g2.IdGruppo, g1.NomeComune
    FROM Gruppo g1, Gruppo g2
    WHERE g1.NomeComune = g2.NomeComune AND g1.TipoGruppo = 'Controllo' AND g2.TipoGruppo = 'Monitoraggio';
END;
$$ LANGUAGE plpgsql;

-- Query di test
SELECT * FROM MATCH_GROUPS();

/* 
    B - Funzione che corrisponde alla seguente query parametrica: 
    - Data una replica con finalità di fitobonifica e due date, determina i valori medi dei parametri rilevati per tale replica
        nel periodo com-preso tra le due date.
    -- [TESTATA E FUNZIONANTE]
*/
CREATE OR REPLACE FUNCTION average_values(replica BIGINT, start_date DATE, end_date DATE)
RETURNS TABLE (average_temperature FLOAT, average_humidity FLOAT, average_ph FLOAT) AS $$
BEGIN
    RETURN QUERY
    SELECT AVG(Temperatura), AVG(Umidita), AVG(Ph)
    FROM Dati
    JOIN Rilevazione ON Dati.Rilevazione = Rilevazione.IdRilevazione
    WHERE Rilevazione.NumeroReplica = replica
    AND Rilevazione.DataOraRilevazione BETWEEN start_date AND end_date;
END;
$$ LANGUAGE plpgsql;

-- Query di test
SELECT * FROM average_values(5, '2023-01-01', '2023-12-31');