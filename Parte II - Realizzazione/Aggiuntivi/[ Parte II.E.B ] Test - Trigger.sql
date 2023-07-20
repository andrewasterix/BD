/*
Parte II.E.B - Test - Trigger

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

-- Funzione per la lettura dei Log nella Tabella LogWarning
CREATE OR REPLACE FUNCTION get_warnings()
RETURNS TABLE (LogId INT, Warning TEXT, SettingTime TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT IdLog AS LogId, Messaggio AS Warning, DataOra AS SettingTime
    FROM LogWarning;
END;
$$ LANGUAGE plpgsql;

-- Warning per la tabella Dati -> AltezzaPianta
UPDATE Dati SET AltezzaPianta = 17.5 WHERE Rilevazione = 1; -- Genera Warning
UPDATE Dati SET AltezzaPianta = 18.2 WHERE Rilevazione = 2; -- NON Genera Warning
UPDATE Dati SET AltezzaPianta = 15.9 WHERE Rilevazione = 3; -- Genera Warning
UPDATE Dati SET AltezzaPianta = 19.4 WHERE Rilevazione = 4; -- NON Genera Warning
UPDATE Dati SET AltezzaPianta = 16.8 WHERE Rilevazione = 5; -- Genera Warning

-- Warning per la tabella Dati -> LunghezzaRadice
UPDATE Dati SET LunghezzaRadice = 12.8 WHERE Rilevazione = 1; -- NON Genera Warning
UPDATE Dati SET LunghezzaRadice = 9.5 WHERE Rilevazione = 2; -- Genera Warning
UPDATE Dati SET LunghezzaRadice = 13.2 WHERE Rilevazione = 3; -- NON Genera Warning
UPDATE Dati SET LunghezzaRadice = 12.7 WHERE Rilevazione = 4; -- Genera Warning
UPDATE Dati SET LunghezzaRadice = 12.1 WHERE Rilevazione = 5; -- NON Genera Warning

-- Query per la lettura dei Log nella Tabella LogWarning
SELECT * FROM get_warnings();