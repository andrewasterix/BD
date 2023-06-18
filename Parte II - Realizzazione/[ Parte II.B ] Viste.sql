-- Active: 1684932917946@@127.0.0.1@5432@Labo_BD@OrtiScolastici
/*
Parte II.B - Viste

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

/*
    A. La definizione di una vista che fornisca alcune informazioni riassuntive per ogni attività di biomonitoraggio:
    - per ogni gruppo e per il corrispondente gruppo di controllo mostrare il numero di piante, la specie, l’orto in cui è posizionato il gruppo, 
    - su base mensile, il valore medio dei parametri ambientali e di crescita delle piante
        (selezionare almeno tre parametri, quelli che si ritengono più significativi)
*/

-- Vista per confrontare il numero di repliche tra gruppi di controllo e monitoraggio
DROP VIEW IF EXISTS ConfrontoGruppi CASCADE;
CREATE OR REPLACE VIEW ConfrontoGruppi AS
SELECT DISTINCT G.IdGruppo AS Controllo, G1.IdGruppo AS Monitoraggio, G.NomeComune AS Pianta
FROM Gruppo AS G
JOIN Gruppo AS G1 ON G.NomeComune = G1.NomeComune AND G.TipoGruppo = 'Controllo' AND G1.TipoGruppo = 'Monitoraggio'
ORDER BY G.IdGruppo, G1.IdGruppo;

-- Vista per collegare la Piante - Orto - Gruppo
DROP VIEW IF EXISTS PianteOrtoGruppo CASCADE;
CREATE OR REPLACE VIEW PianteOrtoGruppo AS
SELECT COUNT(DISTINCT P.NumeroReplica) AS Repliche, P.NomeComune AS Pianta, P.Specie AS Specie, 
    O.NomeOrto AS Orto,
    G.Controllo, G.Monitoraggio
FROM Pianta AS P
JOIN Orto AS O ON P.Specie = O.Specie
JOIN ConfrontoGruppi AS G ON P.NomeComune = G.Pianta
GROUP BY P.NomeComune, P.Specie, O.NomeOrto, G.Controllo, G.Monitoraggio
ORDER BY G.Controllo, G.Monitoraggio;

-- TODO fino a qui fa belle cose dopo da rivedere per unire più rilevazioni in base ai gruppi (Unire gruppi e rilevazioni)

-- Vista per collegare la Rilevazione ai Dati (Temperatura, Umidità, Ph, AltezzaPianta, LunghezzaRadice)
DROP VIEW IF EXISTS DatiRilevazione CASCADE;
CREATE OR REPLACE VIEW DatiRilevazione AS
SELECT D.Rilevazione, R.NumeroReplica, R.NomeComune, R.DataOraRilevazione, 
    D.Temperatura AS Temperatura, D.Umidita AS Umidita, D.Ph AS Ph, 
    D.AltezzaPianta AS AltezzaPianta, D.LunghezzaRadice AS LunghezzaRadice
FROM Dati AS D
JOIN Rilevazione AS R ON D.Rilevazione = R.IdRilevazione;

-- Vista per collegare la pianta alla sua rilevazione
DROP VIEW IF EXISTS RiassuntoInformazioni CASCADE;
CREATE OR REPLACE VIEW RiassuntoInformazioni AS
SELECT P.Repliche, P.Pianta AS Pianta, P.Specie AS Specie, P.Orto AS Orto, P.Controllo AS Controllo, P.Monitoraggio AS Monitoraggio,
    DATE_TRUNC('month', D.DataOraRilevazione) AS Mese, 
    AVG(D.Temperatura) AS Temperatura, AVG(D.Umidita) AS Umidita, AVG(D.Ph) AS Ph, AVG(D.altezzapianta) AS AltezzaPianta, 
    AVG(D.LunghezzaRadice) AS LunghezzaRadice
FROM PianteOrtoGruppo AS P
JOIN DatiRilevazione AS D ON P.Repliche = D.NumeroReplica AND P.Pianta = D.NomeComune
GROUP BY P.Repliche, P.Pianta, P.Specie, P.Orto, DATE_TRUNC('month', D.DataOraRilevazione), P.Controllo, P.Monitoraggio
ORDER BY P.Controllo, P.Monitoraggio;