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
CREATE VIEW BiomonitoringSummary AS
SELECT Gruppo.IdGruppo, Gruppo.TipoGruppo, COUNT(DISTINCT Pianta.NumeroReplica) AS NumberOfPlants, 
    Specie.NomeScientifico AS Species, Orto.NomeOrto AS Garden, 
    AVG(Dati.Temperatura) AS AvgTemperature, 
    AVG(Dati.Umidita) AS AvgHumidity, 
    AVG(Dati.AltezzaPianta) AS AvgPlantHeight
FROM Gruppo
JOIN Pianta ON Gruppo.NumeroReplica = Pianta.NumeroReplica
JOIN Specie ON Pianta.Specie = Specie.NomeScientifico
JOIN Orto ON Gruppo.IdGruppo = Orto.IdOrto
JOIN Dati ON Pianta.NumeroReplica = Dati.Rilevazione
GROUP BY Gruppo.IdGruppo, Gruppo.TipoGruppo, Specie.NomeScientifico, Orto.NomeOrto;

CREATE VIEW VistaBiomonitoraggio AS
SELECT g.IdGruppo, g.TipoGruppo, g.NumeroReplica AS ReplicaGruppo, g.NomeComune AS ComuneGruppo,
       c.NumeroReplica AS ReplicaControllo, c.NomeComune AS ComuneControllo,
       p.NumeroReplica AS NumeroPiante, p.Specie, o.NomeOrto,
       AVG(d.Temperatura) AS MediaTemperatura, AVG(d.Umidita) AS MediaUmidita, AVG(d.AltezzaPianta) AS MediaAltezzaPianta
FROM Gruppo g
JOIN Pianta p ON g.NumeroReplica = p.NumeroReplica AND g.NomeComune = p.NomeComune
JOIN Specie s ON p.Specie = s.NomeScientifico
JOIN Orto o ON o.Specie = s.NomeScientifico
JOIN Rilevazione r ON p.NumeroReplica = r.NumeroReplica AND p.NomeComune = r.NomeComune
JOIN Dati d ON r.IdRilevazione = d.Rilevazione
JOIN Gruppo c ON g.IdGruppo = c.IdGruppo -- Corrispondente gruppo di controllo
GROUP BY g.IdGruppo, g.TipoGruppo, g.NumeroReplica, g.NomeComune,
         c.NumeroReplica, c.NomeComune,
         p.NumeroReplica, p.Specie, o.NomeOrto;