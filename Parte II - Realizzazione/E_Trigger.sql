
-- Trigger per il controllo della presenza di un referente per ogni progetto
CREATE OR REPLACE FUNCTION check_referente_progetto()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.IdProgetto IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1
            FROM Persona p
            JOIN Ruolo r ON p.Email = r.Persona
            WHERE r.NomeRuolo = 'Referente'
            AND p.Cod_Meccanografico = NEW.Cod_Meccanografico
        ) THEN
            RAISE EXCEPTION 'Deve essere memorizzata una persona con ruolo "Referente" per la scuola';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_check_referente_progetto
BEFORE INSERT OR UPDATE OF IdProgetto ON Scuola
FOR EACH ROW
EXECUTE FUNCTION check_referente_progetto();

-- Creazione della funzione checkCondizioneAmbientale
CREATE OR REPLACE FUNCTION checkCondizioneAmbientale() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Orto O
        WHERE O.Scuola = NEW.Cod_Meccanografico
        AND O.CondizioneAmbientale = 'Pulito'
    ) THEN
        -- Aggiorna il TipoGruppo a "Controllo"
        NEW.TipoGruppo := 'Controllo';
        -- Imposta Collabora a true
        NEW.Collabora := true;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Collegamento del trigger per checkCondizioneAmbientale
CREATE TRIGGER checkCondizioneAmbientaleTrigger
BEFORE INSERT OR UPDATE ON Scuola
FOR EACH ROW
EXECUTE FUNCTION checkCondizioneAmbientale();

-- Creazione della funzione checkNreplicaBiomonitoraggio
CREATE OR REPLACE FUNCTION checkNreplicaBiomonitoraggio() RETURNS TRIGGER AS $$
DECLARE
    controlloCount INT;
    monitoraggioCount INT;
BEGIN
    IF NEW.Scopo = 'Biomonitoraggio' THEN
        -- Conta il numero di record con TipoGruppo 'Controllo' e lo salva in controlloCount
        SELECT COUNT(*)
        INTO controlloCount
        FROM Gruppo
        WHERE Pianta = NEW.NomeComune AND TipoGruppo = 'Controllo';

        -- Conta il numero di record con TipoGruppo 'Monitoraggio' e lo salva in monitoraggioCount
        SELECT COUNT(*)
        INTO monitoraggioCount
        FROM Gruppo
        WHERE Pianta = NEW.NomeComune AND TipoGruppo = 'Monitoraggio';

        -- Se il numero di replica di TipoGruppo 'Controllo' è diverso da quello di 'Monitoraggio', genera un errore
        IF controlloCount <> monitoraggioCount THEN
            RAISE EXCEPTION 'Il numero di replica per TipoGruppo "Controllo" deve essere uguale a quello di "Monitoraggio"';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Collegamento del trigger per checkNreplicaBiomonitoraggio
CREATE TRIGGER checkNreplicaBiomonitoraggioTrigger
BEFORE INSERT OR UPDATE ON Pianta
FOR EACH ROW
EXECUTE FUNCTION checkNreplicaBiomonitoraggio();

-- Creazione della funzione checkResponsabili
CREATE OR REPLACE FUNCTION checkResponsabili() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Inserimento = NEW.ResponsabileR THEN
        -- Se Inserimento è uguale a ResponsabileR, inserire solo una Persona o una Classe in ResponsabileR
        IF EXISTS (SELECT 1 FROM Persona WHERE Email = NEW.Inserimento) THEN
            -- Se Inserimento è una Persona, inserire solo la Persona in ResponsabileR
            NEW.Rilevatore := NEW.Inserimento;
            NEW.Inserimento := NULL;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Collegamento del trigger per checkResponsabili
CREATE TRIGGER checkResponsabiliTrigger
BEFORE INSERT OR UPDATE ON Rilevazione
FOR EACH ROW
EXECUTE FUNCTION checkResponsabili();