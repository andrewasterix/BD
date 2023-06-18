/*
Parte II.E.A - Test - Trigger

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

-- Inserimenti nella tabella Pianta
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (7, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (8, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (9, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (10, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (11, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (12, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (13, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (14, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (15, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (7, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (8, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (9, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (10, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (11, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (12, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (13, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (14, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (15, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1);

-- Inserimenti nella tabella Gruppo
-- Questa Query andrà a buon fine, poiché il gruppo può contenere al massimo 20 repliche
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 8, 'RosaCanina'),
    (1, 'Controllo', 9, 'RosaCanina'),
	(1, 'Controllo', 10, 'RosaCanina'),
    (1, 'Controllo', 11, 'RosaCanina'),
    (1, 'Controllo', 12, 'RosaCanina'),
	(1, 'Controllo', 13, 'RosaCanina'),
    (1, 'Controllo', 14, 'RosaCanina'),
    (1, 'Controllo', 15, 'RosaCanina');

-- Questa Query genererà un errore, poiché il gruppo può contenere al massimo 20 repliche
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES
    (1, 'Controllo', 7, 'Lavanda'),
    (1, 'Controllo', 8, 'Lavanda'),
    (1, 'Controllo', 9, 'Lavanda'),
	(1, 'Controllo', 10, 'Lavanda'),
    (1, 'Controllo', 11, 'Lavanda'),
    (1, 'Controllo', 12, 'Lavanda'),
	(1, 'Controllo', 13, 'Lavanda'),
    (1, 'Controllo', 14, 'Lavanda'),
    (1, 'Controllo', 15, 'Lavanda');