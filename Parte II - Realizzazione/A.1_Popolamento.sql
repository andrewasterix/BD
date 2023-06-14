SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';

-- Inserimento Persone come Rilevatore Esterno
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno)
VALUES ('mirko.alessandrini@esterno.example.com', 'Mirko', 'Alessandrini', NULL, TRUE),
    ('cesare.conte@esterno.example.com', 'Cesare', 'Conte', NULL, TRUE),
    ('beatrice.gazzo@esterno.example.com', 'Beatrice', 'Gazzo', NULL, TRUE),
    ('francesco.firenza@esterno.example.com', 'Francesco', 'Firenza', NULL, TRUE), 
    ('sascha.bucci@esterno.example.com', 'Sascha', 'Bucci', NULL, TRUE),
    ('lorenzo.ostuni@esterno.example.com', 'Lorenzo', 'Ostuni', NULL, TRUE);

-- Inserimento Persone divise per Scuole
INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Primaria Giovanni Pascoli
VALUES ('mario.rossi@example.com', 'Mario', 'Rossi', 1234567890), -- Dirigente 
    ('giulia.bianchi@example.com', 'Giulia', 'Bianchi', NULL), -- Docente
    ('andrea.verdi@example.com', 'Andrea', 'Verdi', 9876543210); -- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('mario.acquilino@studenti.example.com', 'Mario', 'Acquilino', NULL), -- Studente 1 5A
    ('giulia.agosti@studenti.example.com', 'Giulia', 'Agosti', NULL), -- Studente 2 5A
    ('andrea.apostu@studenti.example.com', 'Andrea', 'Apostu', NULL), -- Studente 3 5A
    ('luca.araghi@studenti.example.com', 'Luca', 'Araghi', NULL), -- Studente 4 5A
    ('silvia.baghino@studenti.example.com', 'Silvia', 'Baghino', NULL); -- Studente 5 5A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('francesca.bardi@studenti.example.com', 'Francesca', 'Bardi', NULL), -- Studente 1 5B
    ('luca.baretto@studenti.example.com', 'Luca', 'Barretto', NULL), -- Studente 2 5B
    ('sara.barragan@studenti.example.com', 'Sara', 'Barragan', NULL), -- Studente 3 5B
    ('giorgio.barrara@studenti.example.com', 'Giorgio', 'Barrara', NULL), -- Studente 4 5B
    ('elena.bernardini@studenti.example.com', 'Elena', 'Bernardini', NULL); -- Studente 5 5B

INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Secondaria di Primo Grado Leonardo da Vinci
VALUES ('giorgio.bianchi@example.com', 'Giorgio', 'Bianchi', NULL), -- Dirigente
    ('elena.verdi@example.com', 'Elena', 'Verdi', NULL), -- Docente
    ('matteo.ferrari@example.com', 'Matteo', 'Ferrari', 4567890123); -- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('matteo.borracino@studenti.example.com', 'Matteo', 'Borracino', NULL), -- Studente 1 1A
    ('anna.bosso@studenti.example.com', 'Anna', 'Bosso', NULL), -- Studente 2 1A
    ('valentina.bouras@studenti.example.com', 'Valentina', 'Bouras', NULL), -- Studente 3 1A
    ('giovanni.bronzetti@studenti.example.com', 'Giovanni', 'Bronzetti', NULL), -- Studente 4 1A
    ('giulia.bruzzone@studenti.example.com', 'Giulia', 'Bruzzone', NULL); -- Studente 5 1A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('mario.bulgari@studenti.example.com', 'Mario', 'Bulgari', NULL), -- Studente 1 1B
    ('maria.cani@studenti.example.com', 'Maria', 'Cani', NULL), -- Studente 2 1B
    ('laura.carena@studenti.example.com', 'Laura', 'Carena', NULL), -- Studente 3 1B
    ('paolo.casagrande@studenti.example.com', 'Paolo', 'Casagrande', NULL), -- Studente 4 1B
    ('giuseppe.catania@studenti.example.com', 'Giuseppe', 'Catania', NULL); -- Studente 5 1B

INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Secondaria di Secondo Grado Galileo Galilei
VALUES ('giulia.verdi@example.com', 'Giulia', 'Verdi', 6666666666), -- Dirigente
    ('mario.bianchi@example.com', 'Mario', 'Bianchi', 7777777777), -- Docente
    ('maria.bianchi@example.com', 'Maria', 'Bianchi', NULL); -- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('marco.cavalca@studenti.example.com', 'Marco', 'Cavalca', NULL), -- Studente 1 2A
    ('claudia.cavalli@studenti.example.com', 'Claudia', 'Cavalli', NULL), -- Studente 2 2A
    ('giorgia.cavicchia@studenti.example.com', 'Giorgia', 'Cavicchia', NULL), -- Studente 3 2A
    ('gabriele.caviglia@studenti.example.com', 'Gabriele', 'Caviglia', NULL), -- Studente 4 2A
    ('luca.caviglia@studenti.example.com', 'Luca', 'Caviglia', NULL); -- Studente 5 2A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('elena.celotto@studenti.example.com', 'Elena', 'Celotto', NULL), -- Studente 1 2B
    ('michele.centoze@studenti.example.com', 'Michele', 'Centoze', NULL), -- Studente 2 2B
    ('anna.chen@studenti.example.com', 'Anna', 'Chen', NULL), -- Studente 3 2B
    ('gabriele.chen@studenti.example.com', 'Gabriele', 'Chen', NULL), -- Studente 4 2B
    ('valentina.chicco@studenti.example.com', 'Valentina', 'Chicco', NULL); -- Studente 5 2B
INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Primaria Giuseppe Verdi
VALUES ('laura.rossi@example.com', 'Laura', 'Rossi', 8888888888), -- Dirigente
    ('paolo.verdi@example.com', 'Paolo', 'Verdi', 9999999999), -- Docente
    ('giuseppe.bianchi@example.com', 'Giuseppe', 'Bianchi', 1111111111); -- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('simone.chicco@studenti.example.com', 'Simone', 'Chicco', NULL), -- Studente 1 4A
    ('francesco.chiola@studenti.example.com', 'Francesco', 'Chiola', NULL), -- Studente 2 4A
    ('laura.ciarlo@studenti.example.com', 'Laura', 'Ciarlo', NULL), -- Studente 3 4A
    ('matteo.civati@studenti.example.com', 'Matteo', 'Civati', NULL), -- Studente 4 4A
    ('elisa.corbo@studenti.example.com', 'Elisa', 'Corbo', NULL); -- Studente 5 4A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES('gabriele.alessandro@studenti.example.com', 'Gabriele', 'Alessandro', NULL), -- Studente 1 4B
    ('giulia.devincenzi@studenti.example.com', 'Giulia', 'De Vincenzi', NULL), -- Studente 2 4B
    ('paola.delvigo@studenti.example.com', 'Paola', 'Del Vigo', NULL), -- Studente 3 4B
    ('luca.derqui@studenti.example.com', 'Luca', 'Derqui', NULL), -- Studente 4 4B
    ('silvia.dicriscio@studenti.example.com', 'Silvia', 'Di Criscio', NULL); -- Studente 5 4B
INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Secondaria di Primo Grado Alessandro Volta
VALUES ('francesca.rossi@example.com', 'Francesca', 'Rossi', NULL), -- Dirigente 
    ('luca.ferrari@example.com', 'Luca', 'Ferrari', 2345678901), -- Docente
    ('sara.rossi@example.com', 'Sara', 'Rossi', NULL); -- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('francesco.disabatino@studenti.example.com', 'Francesco', 'Di Sabatino', NULL), -- Studente 1 3A
    ('marco.dufour@studenti.example.com', 'Marco', 'Dufour', NULL), -- Studente 2 3A
    ('elisa.durante@studenti.example.com', 'Elisa', 'Durante', NULL), -- Studente 3 3A
    ('michele.elezi@studenti.example.com', 'Michele', 'Elezi', NULL), -- Studente 4 3A
    ('claudia.emuze@studenti.example.com', 'Claudia', 'Emuze', NULL); -- Studente 5 3A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('simone.etna@studenti.example.com', 'Simone', 'Etna', NULL), -- Studente 1 3B
    ('giorgia.fabbri@studenti.example.com', 'Giorgia', 'Fabbri', NULL), -- Studente 2 3B
    ('paola.falcone@studenti.example.com', 'Paola', 'Falcone', NULL), -- Studente 3 3B
    ('gabriele.fancellu@studenti.example.com', 'Gabriele', 'Fancellu', NULL), -- Studente 4 3B
    ('giulia.fasce@studenti.example.com', 'Giulia', 'Fasce', NULL); -- Studente 5 3B
	
INSERT INTO Persona (Email, Nome, Cognome, Telefono) -- Scuola Secondaria di Secondo Grado Giuseppe Garibaldi
VALUES ('anna.verdi@example.com', 'Anna', 'Verdi', 1234567890), -- Dirigente
    ('valentina.rossi@example.com', 'Valentina', 'Rossi', NULL), -- Docente
    ('giovanni.rossi@example.com', 'Giovanni', 'Rossi', 9876543210);-- Docente
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('giulia.fazio@studenti.example.com', 'Giulia', 'Fazio', NULL), -- Studente 1 1A
    ('andrea.fazio@studenti.example.com', 'Andrea', 'Fazio', NULL), -- Studente 2 1A
    ('elisa.fazzeri@studenti.example.com', 'Elisa', 'Fazzeri', NULL), -- Studente 3 1A
    ('simone.ferrari@studenti.example.com', 'Simone', 'Ferrari', NULL), -- Studente 4 1A
    ('giorgia.fontana@studenti.example.com', 'Giorgia', 'Fontana', NULL); -- Studente 5 1A
INSERT INTO Persona (Email, Nome, Cognome, Telefono)
VALUES ('paola.giampietro@studenti.example.com', 'Paola', 'Giampietro', NULL), -- Studente 1 1B
    ('gabriele.giusto@studenti.example.com', 'Gabriele', 'Giusto', NULL), -- Studente 2 1B
    ('giulia.guan@studenti.example.com', 'Giulia', 'Guan', NULL), -- Studente 3 1B
    ('andrea.guiso@studenti.example.com', 'Andrea', 'Guiso', NULL), -- Studente 4 1B
    ('elisa.lamperti@studenti.example.com', 'Elisa', 'Lamperti', NULL); -- Studente 5 1B

-- Inserimento dati nella tabella Scuola
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Dirigente, Finanziamento, Referente)
VALUES ('ABCD12345A', 'Scuola Primaria Giovanni Pascoli', 1, 'Roma', 'RM', TRUE, 'mario.rossi@example.com', 'Contributo regionale', 'mario.rossi@example.com'),
    ('EFGH67890B', 'Scuola Secondaria di Primo Grado Leonardo da Vinci', 2, 'Milano', 'MI', FALSE, 'giorgio.bianchi@example.com', NULL, NULL),
    ('MNOP23456D', 'Scuola Secondaria di Secondo Grado Galileo Galilei', 2, 'Torino', 'TO', TRUE, 'giulia.verdi@example.com', NULL, NULL),
    ('QRST56789E', 'Scuola Primaria Giuseppe Verdi', 1, 'Firenze', 'FI', FALSE, 'laura.rossi@example.com', NULL, NULL),
    ('UVWX34567F', 'Scuola Secondaria di Primo Grado Alessandro Volta', 2, 'Bologna', 'BO', TRUE, 'francesca.rossi@example.com', 'Europa 2020', 'francesca.rossi@example.com'),
    ('CDEF90123H', 'Scuola Secondaria di Secondo Grado Giuseppe Garibaldi', 2, 'Genova', 'GE', FALSE, 'anna.verdi@example.com', 'Ministero Istruzione', 'anna.verdi@example.com');

-- Inserimento dati nella tabella Classe
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente)
VALUES (1, '5A', 'ABCD12345A', 1, 'Scuola Primaria', 'giulia.bianchi@example.com'),
    (2, '5B', 'ABCD12345A', 1, 'Scuola Primaria', 'andrea.verdi@example.com'),
    (3, '1A', 'EFGH67890B', 2, 'Scuola Secondaria di Primo Grado', 'luca.ferrari@example.com'),
    (4, '1B', 'EFGH67890B', 2, 'Scuola Secondaria di Primo Grado', 'sara.rossi@example.com'),
    (5, '2A', 'MNOP23456D', 2, 'Liceo Scientifico', 'elena.verdi@example.com'),
    (6, '2B', 'MNOP23456D', 2, 'Liceo Scientifico', 'matteo.ferrari@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente)
VALUES (7, '4A', 'QRST56789E', 2, 'Scuola Primaria', 'paolo.verdi@example.com'),
    (8, '4B', 'QRST56789E', 2, 'Scuola Primaria', 'giuseppe.bianchi@example.com'),
    (9, '3A', 'UVWX34567F', 2, 'Scuola Secondaria di Primo Grado', 'luca.ferrari@example.com'),
    (10, '3B', 'UVWX34567F', 2, 'Scuola Secondaria di Primo Grado', 'sara.rossi@example.com'),
    (11, '1A', 'CDEF90123H', 2, 'Istituto Agrario', 'valentina.rossi@example.com'),
    (12, '1B', 'CDEF90123H', 2, 'Istituto Agrario', 'giovanni.rossi@example.com');

-- Inserimento dati nella tabella Studente
INSERT INTO Studente (Classe, Alunno) -- 5A ABCD12345A
VALUES ( 1, 'mario.acquilino@studenti.example.com'),
    ( 1, 'giulia.agosti@studenti.example.com'), 
    ( 1, 'andrea.apostu@studenti.example.com'), 
    ( 1, 'luca.araghi@studenti.example.com'), 
    ( 1, 'silvia.baghino@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 5B ABCD12345A
VALUES ( 2, 'francesca.bardi@studenti.example.com'), 
    ( 2, 'luca.baretto@studenti.example.com'), 
    ( 2, 'sara.barragan@studenti.example.com'),
    ( 2, 'giorgio.barrara@studenti.example.com'),
    ( 2, 'elena.bernardini@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 1A EFGH67890B
VALUES ( 3, 'matteo.borracino@studenti.example.com'),
    ( 3, 'anna.bosso@studenti.example.com'),
    ( 3, 'valentina.bouras@studenti.example.com'),
    ( 3, 'giovanni.bronzetti@studenti.example.com'),
    ( 3, 'giulia.bruzzone@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 1B EFGH67890B
VALUES ( 4, 'mario.bulgari@studenti.example.com'),
    ( 4, 'maria.cani@studenti.example.com'),
    ( 4, 'laura.carena@studenti.example.com'),
    ( 4, 'paolo.casagrande@studenti.example.com'),
    ( 4, 'giuseppe.catania@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 2A MNOP23456D
VALUES ( 5, 'marco.cavalca@studenti.example.com'),
    ( 5, 'claudia.cavalli@studenti.example.com'),
    ( 5, 'giorgia.cavicchia@studenti.example.com'),
    ( 5, 'gabriele.caviglia@studenti.example.com'),
    ( 5, 'luca.caviglia@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 2B MNOP23456D
VALUES ( 6, 'elena.celotto@studenti.example.com'),
    ( 6, 'michele.centoze@studenti.example.com'),
    ( 6, 'anna.chen@studenti.example.com'),
    ( 6, 'gabriele.chen@studenti.example.com'),
    ( 6, 'valentina.chicco@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 4A QRST56789E   
VALUES ( 7, 'simone.chicco@studenti.example.com'),
    ( 7, 'francesco.chiola@studenti.example.com'),
    ( 7, 'laura.ciarlo@studenti.example.com'),
    ( 7, 'matteo.civati@studenti.example.com'),
    ( 7, 'elisa.corbo@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 4B QRST56789E
VALUES ( 8, 'gabriele.alessandro@studenti.example.com'),
    ( 8, 'giulia.devincenzi@studenti.example.com'),
    ( 8, 'paola.delvigo@studenti.example.com'),
    ( 8, 'luca.derqui@studenti.example.com'),
    ( 8, 'silvia.dicriscio@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 3A UVWX34567F
VALUES ( 9, 'francesco.disabatino@studenti.example.com'),
    ( 9, 'marco.dufour@studenti.example.com'),
    ( 9, 'elisa.durante@studenti.example.com'),
    ( 9, 'michele.elezi@studenti.example.com'),
    ( 9, 'claudia.emuze@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 3B UVWX34567F
VALUES (10, 'simone.etna@studenti.example.com'),
    (10, 'giorgia.fabbri@studenti.example.com'),
    (10, 'paola.falcone@studenti.example.com'),
    (10, 'gabriele.fancellu@studenti.example.com'),
    (10, 'giulia.fasce@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 1A CDEF90123H
VALUES (11, 'giulia.fazio@studenti.example.com'),
    (11, 'andrea.fazio@studenti.example.com'),
    (11, 'elisa.fazzeri@studenti.example.com'),
    (11, 'simone.ferrari@studenti.example.com'),
    (11, 'giorgia.fontana@studenti.example.com');
INSERT INTO Studente (Classe, Alunno) -- 1B CDEF90123H
VALUES (12, 'paola.giampietro@studenti.example.com'),
    (12, 'gabriele.giusto@studenti.example.com'),
    (12, 'giulia.guan@studenti.example.com'),
    (12, 'andrea.guiso@studenti.example.com'),
    (12, 'elisa.lamperti@studenti.example.com');


-- Inserimento dati nella tabella Specie
INSERT INTO Specie (NomeScientifico, Substrato)
VALUES ('Rosa canina', 'TerriccioRinvaso'),
	('Lavandula angustifolia', 'TerriccioRinvaso'),
	('Olea europaea', 'SuoloPreEsistente'),
	('Ficus carica', 'SuoloPreEsistente'),
	('Salvia officinalis', 'TerriccioRinvaso'),
	('Melissa officinalis', 'TerriccioRinvaso'),
	('Lycopersicon esculentum', 'SuoloPreEsistente'),
	('Citrus limon', 'SuoloPreEsistente'),
    ('Mentha piperita', 'TerriccioRinvaso'),
	('Rosmarinus officinalis', 'TerriccioRinvaso'),
	('Prunus avium', 'SuoloPreEsistente'),
	('Cucumis sativus', 'SuoloPreEsistente');

-- Inserimento dati nella tabella Orto
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola)
VALUES (1, 'Orto Roma Centro',41.9028, 12.4964, 75.2, 'Vaso' , 'Pulito', 'Rosa canina','ABCD12345A'),
    (1, 'Orto Roma Centro',41.9028, 12.4964, 75.2, 'Vaso' , 'Pulito', 'Lavandula angustifolia','ABCD12345A'),
    (2, 'Orto Milano Centro',45.4642, 9.1900, 180.0, 'Terra' , 'Inquinato', 'Olea europaea', 'EFGH67890B'),
    (2, 'Orto Milano Centro',45.4642, 9.1900, 180.0, 'Terra' , 'Inquinato', 'Ficus carica', 'EFGH67890B'),
    (3, 'Orto Torino Centro',45.0705, 7.6868, 60.0, 'Vaso' , 'Pulito', 'Salvia officinalis', 'MNOP23456D'),
    (3, 'Orto Torino Centro',45.0705, 7.6868, 60.0, 'Vaso' , 'Pulito', 'Melissa officinalis', 'MNOP23456D'),
    (4, 'Orto Firenze Centro',43.7696, 11.2558, 150.0, 'Terra', 'Inquinato', 'Lycopersicon esculentum', 'QRST56789E'),
    (4, 'Orto Firenze Centro',43.7696, 11.2558, 150.0, 'Terra', 'Inquinato', 'Citrus limon', 'QRST56789E'),
    (5, 'Orto Bologna Centro',44.4949, 11.3426, 50.0, 'Vaso' , 'Pulito', 'Mentha piperita', 'UVWX34567F'),
    (5, 'Orto Bologna Centro',44.4949, 11.3426, 50.0, 'Vaso' , 'Pulito', 'Rosmarinus officinalis', 'UVWX34567F'),
    (6, 'Orto Genova Centro',44.4056, 8.9463, 100.0, 'Terra' , 'Inquinato', 'Prunus avium', 'CDEF90123H'),
    (6, 'Orto Genova Centro',44.4056, 8.9463, 100.0, 'Terra' , 'Inquinato', 'Cucumis sativus', 'CDEF90123H');

-- Inserimento dati nella tabella Pianta
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (2, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (3, 'RosaCanina', 'Fitobotanica', '2023-01-15', 'Rosa canina', 1),
    (4, 'RosaCanina', 'Fitobotanica', '2023-01-16', 'Rosa canina', 2),
    (5, 'RosaCanina', 'Fitobotanica', '2023-01-16', 'Rosa canina', 2),
    (6, 'RosaCanina', 'Fitobotanica', '2023-01-16', 'Rosa canina', 2),
    (1, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (2, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (3, 'Lavanda', 'Fitobotanica', '2023-05-05', 'Lavandula angustifolia', 1),
    (4, 'Lavanda', 'Fitobotanica', '2023-05-04', 'Lavandula angustifolia', 2),
    (5, 'Lavanda', 'Fitobotanica', '2023-05-04', 'Lavandula angustifolia', 2),
    (6, 'Lavanda', 'Fitobotanica', '2023-05-04', 'Lavandula angustifolia', 2);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'Olivo', 'Biomonitoraggio', '2023-02-28', 'Olea europaea', 3),
    (2, 'Olivo', 'Biomonitoraggio', '2023-02-28', 'Olea europaea', 3),
    (3, 'Olivo', 'Biomonitoraggio', '2023-02-28', 'Olea europaea', 3),
    (4, 'Olivo', 'Biomonitoraggio', '2023-02-27', 'Olea europaea', 4),
    (5, 'Olivo', 'Biomonitoraggio', '2023-02-27', 'Olea europaea', 4),
    (6, 'Olivo', 'Biomonitoraggio', '2023-02-27', 'Olea europaea', 4),
    (1, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 3),
    (2, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 3),
    (3, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 3),
    (4, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 4),
    (5, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 4),
    (6, 'Fico', 'Biomonitoraggio', '2023-02-26', 'Ficus carica', 4);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'Salvia', 'Fitobotanica', '2023-01-15', 'Salvia officinalis', 5),
    (2, 'Salvia', 'Fitobotanica', '2023-01-15', 'Salvia officinalis', 5),
    (3, 'Salvia', 'Fitobotanica', '2023-01-15', 'Salvia officinalis', 5),
    (4, 'Salvia', 'Fitobotanica', '2023-01-16', 'Salvia officinalis', 6),
    (5, 'Salvia', 'Fitobotanica', '2023-01-16', 'Salvia officinalis', 6),
    (6, 'Salvia', 'Fitobotanica', '2023-01-16', 'Salvia officinalis', 6),
    (1, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 5),
    (2, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 5),
    (3, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 5),
    (4, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 6),
    (5, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 6),
    (6, 'Melissa', 'Fitobotanica', '2023-05-05', 'Melissa officinalis', 6);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 7),
    (2, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 7),
    (3, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 7),
    (4, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 8),
    (5, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 8),
    (6, 'Pomodoro', 'Biomonitoraggio', '2023-04-22', 'Lycopersicon esculentum', 8),
    (1, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 7),
    (2, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 7),
    (3, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 7),
    (4, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 8),
    (5, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 8),
    (6, 'Limone', 'Biomonitoraggio', '2023-05-22', 'Citrus limon', 8);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 9),
    (2, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 9),
    (3, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 9),
    (4, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 10),
    (5, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 10),
    (6, 'Menta', 'Fitobotanica', '2023-01-30', 'Mentha piperita', 10),
    (1, 'Rosmarino', 'Fitobotanica', '2023-05-14', 'Rosmarinus officinalis', 9),
    (2, 'Rosmarino', 'Fitobotanica', '2023-05-14', 'Rosmarinus officinalis', 9),
    (3, 'Rosmarino', 'Fitobotanica', '2023-05-14', 'Rosmarinus officinalis', 9),
    (4, 'Rosmarino', 'Fitobotanica', '2023-05-17', 'Rosmarinus officinalis', 10),
    (5, 'Rosmarino', 'Fitobotanica', '2023-05-17', 'Rosmarinus officinalis', 10),
    (6, 'Rosmarino', 'Fitobotanica', '2023-05-17', 'Rosmarinus officinalis', 10);
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe)
VALUES (1, 'Ciliegio', 'Biomonitoraggio', '2023-03-01', 'Prunus avium', 11),
    (2, 'Ciliegio', 'Biomonitoraggio', '2023-03-01', 'Prunus avium', 11),
    (3, 'Ciliegio', 'Biomonitoraggio', '2023-03-01', 'Prunus avium', 11),
    (4, 'Ciliegio', 'Biomonitoraggio', '2023-03-10', 'Prunus avium', 12),
    (5, 'Ciliegio', 'Biomonitoraggio', '2023-03-10', 'Prunus avium', 12),
    (6, 'Ciliegio', 'Biomonitoraggio', '2023-03-10', 'Prunus avium', 12),
    (1, 'Cetriolo', 'Biomonitoraggio', '2023-06-06', 'Cucumis sativus', 11),
    (2, 'Cetriolo', 'Biomonitoraggio', '2023-06-06', 'Cucumis sativus', 11),
    (3, 'Cetriolo', 'Biomonitoraggio', '2023-06-06', 'Cucumis sativus', 11),
    (4, 'Cetriolo', 'Biomonitoraggio', '2023-06-05', 'Cucumis sativus', 12),
    (5, 'Cetriolo', 'Biomonitoraggio', '2023-06-05', 'Cucumis sativus', 12),
    (6, 'Cetriolo', 'Biomonitoraggio', '2023-06-05', 'Cucumis sativus', 12);

-- Inserimento dati nella tabella Esposizione
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'RosaCanina', 'Mezzombra'),
    (2, 'RosaCanina', 'Mezzombra'),
    (3, 'RosaCanina', 'Mezzombra'),
    (4, 'RosaCanina', 'Mezzombra'),
    (5, 'RosaCanina', 'Mezzombra'),
    (6, 'RosaCanina', 'Mezzombra'),
    (1, 'Lavanda', 'Sole'),
    (2, 'Lavanda', 'Sole'),
    (3, 'Lavanda', 'Sole'),
    (4, 'Lavanda', 'Sole'),
    (5, 'Lavanda', 'Sole'),
    (6, 'Lavanda', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'Olivo', 'Sole'),
    (2, 'Olivo', 'Sole'),
    (3, 'Olivo', 'Sole'),
    (4, 'Olivo', 'Sole'),
    (5, 'Olivo', 'Sole'),
    (6, 'Olivo', 'Sole'),
    (1, 'Fico', 'Sole'),
    (2, 'Fico', 'Sole'),
    (3, 'Fico', 'Sole'),
    (4, 'Fico', 'Sole'),
    (5, 'Fico', 'Sole'),
    (6, 'Fico', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'Salvia', 'Ombra'),
    (2, 'Salvia', 'Ombra'),
    (3, 'Salvia', 'Ombra'),
    (4, 'Salvia', 'Ombra'),
    (5, 'Salvia', 'Ombra'),
    (6, 'Salvia', 'Ombra'),
    (1, 'Melissa', 'Mezzombra'),
    (2, 'Melissa', 'Mezzombra'),
    (3, 'Melissa', 'Mezzombra'),
    (4, 'Melissa', 'Mezzombra'),
    (5, 'Melissa', 'Mezzombra'),
    (6, 'Melissa', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'Pomodoro', 'Sole'),
    (2, 'Pomodoro', 'Sole'),
    (3, 'Pomodoro', 'Sole'),
    (4, 'Pomodoro', 'Sole'),
    (5, 'Pomodoro', 'Sole'),
    (6, 'Pomodoro', 'Sole'),
    (1, 'Limone', 'Sole'),
    (2, 'Limone', 'Sole'),
    (3, 'Limone', 'Sole'),
    (4, 'Limone', 'Sole'),
    (5, 'Limone', 'Sole'),
    (6, 'Limone', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'Menta', 'Ombra'),
    (2, 'Menta', 'Ombra'),
    (3, 'Menta', 'Ombra'),
    (4, 'Menta', 'Ombra'),
    (5, 'Menta', 'Ombra'),
    (6, 'Menta', 'Ombra'),
    (1, 'Rosmarino', 'Mezzombra'),
    (2, 'Rosmarino', 'Mezzombra'),
    (3, 'Rosmarino', 'Mezzombra'),
    (4, 'Rosmarino', 'Mezzombra'),
    (5, 'Rosmarino', 'Mezzombra'),
    (6, 'Rosmarino', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione)
VALUES (1, 'Ciliegio', 'Sole'),
    (2, 'Ciliegio', 'Sole'),
    (3, 'Ciliegio', 'Sole'),
    (4, 'Ciliegio', 'Sole'),
    (5, 'Ciliegio', 'Sole'),
    (6, 'Ciliegio', 'Sole'),
    (1, 'Cetriolo', 'Sole'),
    (2, 'Cetriolo', 'Sole'),
    (3, 'Cetriolo', 'Sole'),
    (4, 'Cetriolo', 'Sole'),
    (5, 'Cetriolo', 'Sole'),
    (6, 'Cetriolo', 'Sole');

-- Inserimento dati nella tabella Gruppo
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'RosaCanina'),
    (1, 'Controllo', 2, 'RosaCanina'),
    (1, 'Controllo', 3, 'RosaCanina'),
    (2, 'Monitoraggio', 4, 'RosaCanina'),
    (2, 'Monitoraggio', 5, 'RosaCanina'),
    (2, 'Monitoraggio', 6, 'RosaCanina'),
    (1, 'Controllo', 1, 'Lavanda'),
    (1, 'Controllo', 2, 'Lavanda'),
    (1, 'Controllo', 3, 'Lavanda'),
    (2, 'Monitoraggio', 4, 'Lavanda'),
    (2, 'Monitoraggio', 5, 'Lavanda'),
    (2, 'Monitoraggio', 6, 'Lavanda');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'Olivo'),
    (1, 'Controllo', 2, 'Olivo'),
    (1, 'Controllo', 3, 'Olivo'),
    (2, 'Monitoraggio', 4, 'Olivo'),
    (2, 'Monitoraggio', 5, 'Olivo'),
    (2, 'Monitoraggio', 6, 'Olivo'),
    (1, 'Controllo', 1, 'Fico'),
    (1, 'Controllo', 2, 'Fico'),
    (1, 'Controllo', 3, 'Fico'),
    (2, 'Monitoraggio', 4, 'Fico'),
    (2, 'Monitoraggio', 5, 'Fico'),
    (2, 'Monitoraggio', 6, 'Fico');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'Salvia'),
    (1, 'Controllo', 2, 'Salvia'),
    (1, 'Controllo', 3, 'Salvia'),
    (2, 'Monitoraggio', 4, 'Salvia'),
    (2, 'Monitoraggio', 5, 'Salvia'),
    (2, 'Monitoraggio', 6, 'Salvia'),
    (1, 'Controllo', 1, 'Melissa'),
    (1, 'Controllo', 2, 'Melissa'),
    (1, 'Controllo', 3, 'Melissa'),
    (2, 'Monitoraggio', 4, 'Melissa'),
    (2, 'Monitoraggio', 5, 'Melissa'),
    (2, 'Monitoraggio', 6, 'Melissa');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'Pomodoro'),
    (1, 'Controllo', 2, 'Pomodoro'),
    (1, 'Controllo', 3, 'Pomodoro'),
    (2, 'Monitoraggio', 4, 'Pomodoro'),
    (2, 'Monitoraggio', 5, 'Pomodoro'),
    (2, 'Monitoraggio', 6, 'Pomodoro'),
    (1, 'Controllo', 1, 'Limone'),
    (1, 'Controllo', 2, 'Limone'),
    (1, 'Controllo', 3, 'Limone'),
    (2, 'Monitoraggio', 4, 'Limone'),
    (2, 'Monitoraggio', 5, 'Limone'),
    (2, 'Monitoraggio', 6, 'Limone');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'Menta'),
    (1, 'Controllo', 2, 'Menta'),
    (1, 'Controllo', 3, 'Menta'),
    (2, 'Monitoraggio', 4, 'Menta'),
    (2, 'Monitoraggio', 5, 'Menta'),
    (2, 'Monitoraggio', 6, 'Menta'),
    (1, 'Controllo', 1, 'Rosmarino'),
    (1, 'Controllo', 2, 'Rosmarino'),
    (1, 'Controllo', 3, 'Rosmarino'),
    (2, 'Monitoraggio', 4, 'Rosmarino'),
    (2, 'Monitoraggio', 5, 'Rosmarino'),
    (2, 'Monitoraggio', 6, 'Rosmarino');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune)
VALUES (1, 'Controllo', 1, 'Ciliegio'),
    (1, 'Controllo', 2, 'Ciliegio'),
    (1, 'Controllo', 3, 'Ciliegio'),
    (2, 'Monitoraggio', 4, 'Ciliegio'),
    (2, 'Monitoraggio', 5, 'Ciliegio'),
    (2, 'Monitoraggio', 6, 'Ciliegio'),
    (1, 'Controllo', 1, 'Cetriolo'),
    (1, 'Controllo', 2, 'Cetriolo'),
    (1, 'Controllo', 3, 'Cetriolo'),
    (2, 'Monitoraggio', 4, 'Cetriolo'),
    (2, 'Monitoraggio', 5, 'Cetriolo'),
    (2, 'Monitoraggio', 6, 'Cetriolo');

-- Insetimento dati nella tabella Sensore
INSERT INTO Sensore (idSensore, TipoSensore, TipoAcquisizione)
VALUES (1, 'Arduino', 'Arduino'),
		(2, 'Sensore', 'App'),
		(3, 'Arduino', 'App'),
		(4, 'Sensore', 'Arduino'),
		(5, 'Arduino', 'App'),
		(6, 'Arduino', 'Arduino'),
		(7, 'Arduino', 'Arduino'),
		(8, 'Sensore', 'App'),
		(9, 'Arduino', 'App'),
		(10, 'Sensore', 'Arduino'),
		(11, 'Arduino', 'App'),
		(12, 'Arduino', 'Arduino'),
		(13, 'Arduino', 'Arduino'),
		(14, 'Sensore', 'App'),
		(15, 'Arduino', 'App'),
		(16, 'Sensore', 'Arduino'),
		(17, 'Arduino', 'App'),
		(18, 'Arduino', 'Arduino'),
		(19, 'Arduino', 'Arduino'),
		(20, 'Sensore', 'App'),
		(21, 'Arduino', 'App');

-- Inserimento dati nella tabella Rilevazione
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (1, '2023-09-01 12:34:56', '2023-09-01 12:39:56', 1, 'RosaCanina', 7),
    (2, '2023-09-02 10:20:30', '2023-09-02 10:25:30', 2, 'RosaCanina', 20),
    (3, '2023-09-03 08:12:45', '2023-09-03 08:17:45', 3, 'RosaCanina', 13),
    (4, '2023-10-04 16:30:15', '2023-10-04 16:35:15', 4, 'RosaCanina', 2),
    (5, '2023-10-05 09:45:30', '2023-10-05 09:50:30', 5, 'RosaCanina', 10),
    (6, '2023-10-06 14:25:10', '2023-10-06 14:30:10', 6, 'RosaCanina', 5),
    (7, '2023-09-07 11:15:25', '2023-09-07 11:20:25', 1, 'Lavanda', 18),
    (8, '2023-09-08 13:40:50', '2023-09-08 13:45:50', 2, 'Lavanda', 6),
    (9, '2023-09-09 17:55:40', '2023-09-09 18:00:40', 3, 'Lavanda', 4),
    (10, '2023-10-10 20:10:55', '2023-10-10 20:15:55', 4, 'Lavanda', 17),
    (11, '2023-10-11 15:30:20', '2023-10-11 15:35:20', 5, 'Lavanda', 9),
    (12, '2023-10-12 18:45:35', '2023-10-12 18:50:35', 6, 'Lavanda', 12);
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (13, '2023-10-01 12:34:56', '2023-10-01 12:39:56', 1, 'Olivo', 14),
    (14, '2023-10-02 10:20:30', '2023-10-02 10:25:30', 2, 'Olivo', 8),
    (15, '2023-10-03 08:12:45', '2023-10-03 08:17:45', 3, 'Olivo', 3),
    (16, '2023-11-04 16:30:15', '2023-11-04 16:35:15', 4, 'Olivo', 1),
    (17, '2023-11-05 09:45:30', '2023-11-05 09:50:30', 5, 'Olivo', 16),
    (18, '2023-11-06 14:25:10', '2023-11-06 14:30:10', 6, 'Olivo', 11),
    (19, '2023-10-07 11:15:25', '2023-10-07 11:20:25', 1, 'Fico', 19),
    (20, '2023-10-08 13:40:50', '2023-10-08 13:45:50', 2, 'Fico', 15),
    (21, '2023-10-09 17:55:40', '2023-10-09 18:00:40', 3, 'Fico', 21),
    (22, '2023-11-10 20:10:55', '2023-11-10 20:15:55', 4, 'Fico', 6),
    (23, '2023-11-11 15:30:20', '2023-11-11 15:35:20', 5, 'Fico', 19),
    (24, '2023-11-12 18:45:35', '2023-11-12 18:50:35', 6, 'Fico', 7);
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (25, '2023-11-01 12:34:56', '2023-11-01 12:39:56', 1, 'Salvia', 3),
    (26, '2023-11-02 10:20:30', '2023-11-02 10:25:30', 2, 'Salvia', 14),
    (27, '2023-11-03 08:12:45', '2023-11-03 08:17:45', 3, 'Salvia', 2),
    (28, '2023-12-04 16:30:15', '2023-11-04 16:35:15', 4, 'Salvia', 10),
    (29, '2023-12-05 09:45:30', '2023-12-05 09:50:30', 5, 'Salvia', 12),
    (30, '2023-12-06 14:25:10', '2023-12-06 14:30:10', 6, 'Salvia', 16),
    (31, '2023-11-07 11:15:25', '2023-12-07 11:20:25', 1, 'Melissa', 9),
    (32, '2023-11-08 13:40:50', '2023-11-08 13:45:50', 2, 'Melissa', 5),
    (33, '2023-11-09 17:55:40', '2023-11-09 18:00:40', 3, 'Melissa', 1),
    (34, '2023-12-10 20:10:55', '2023-12-10 20:15:55', 4, 'Melissa', 18),
    (35, '2023-12-11 15:30:20', '2023-12-11 15:35:20', 5, 'Melissa', 20),
    (36, '2023-12-12 18:45:35', '2023-12-12 18:50:35', 6, 'Melissa', 11);
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (37, '2023-09-01 12:34:56', '2023-09-01 12:39:56', 1, 'Pomodoro', 8),
    (38, '2023-09-02 10:20:30', '2023-09-02 10:25:30', 2, 'Pomodoro', 4),
    (39, '2023-09-03 08:12:45', '2023-09-03 08:17:45', 3, 'Pomodoro', 17),
    (40, '2023-10-04 16:30:15', '2023-10-04 16:35:15', 4, 'Pomodoro', 15),
    (41, '2023-10-05 09:45:30', '2023-10-05 09:50:30', 5, 'Pomodoro', 13),
    (42, '2023-10-06 14:25:10', '2023-10-06 14:30:10', 6, 'Pomodoro', 21),
    (43, '2023-09-07 11:15:25', '2023-09-07 11:20:25', 1, 'Limone', 6),
    (44, '2023-09-08 13:40:50', '2023-09-08 13:45:50', 2, 'Limone', 19),
    (45, '2023-09-09 17:55:40', '2023-09-09 18:00:40', 3, 'Limone', 7),
    (46, '2023-10-10 20:10:55', '2023-10-10 20:15:55', 4, 'Limone', 3),
    (47, '2023-10-11 15:30:20', '2023-10-11 15:35:20', 5, 'Limone', 12),
    (48, '2023-10-12 18:45:35', '2023-10-12 18:50:35', 6, 'Limone', 9);
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (49, '2023-10-01 12:34:56', '2023-10-01 12:39:56', 1, 'Menta', 2),
    (50, '2023-10-02 10:20:30', '2023-10-02 10:25:30', 2, 'Menta', 7),
    (51, '2023-10-03 08:12:45', '2023-10-03 08:17:45', 3, 'Menta', 15),
    (52, '2023-11-04 16:30:15', '2023-11-04 16:35:15', 4, 'Menta', 8),
    (53, '2023-11-05 09:45:30', '2023-11-05 09:50:30', 5, 'Menta', 14),
    (54, '2023-11-06 14:25:10', '2023-11-06 14:30:10', 6, 'Menta', 16),
    (55, '2023-10-07 11:15:25', '2023-10-07 11:20:25', 1, 'Rosmarino', 11),
    (56, '2023-10-08 13:40:50', '2023-10-08 13:45:50', 2, 'Rosmarino', 1),
    (57, '2023-10-09 17:55:40', '2023-10-09 18:00:40', 3, 'Rosmarino', 4),
    (58, '2023-11-10 20:10:55', '2023-11-10 20:15:55', 4, 'Rosmarino', 18),
    (59, '2023-11-11 15:30:20', '2023-11-11 15:35:20', 5, 'Rosmarino', 20),
    (60, '2023-11-12 18:45:35', '2023-11-12 18:50:35', 6, 'Rosmarino', 10);
INSERT INTO Rilevazione (IdRilevazione, DataOraRilevazione, DataOraInserimento, NumeroReplica, NomeComune, Sensore)
VALUES (61, '2023-11-01 12:34:56', '2023-11-01 12:39:56', 1, 'Ciliegio',17),
    (62, '2023-11-02 10:20:30', '2023-11-02 10:25:30', 2, 'Ciliegio', 5),
    (63, '2023-11-03 08:12:45', '2023-11-03 08:17:45', 3, 'Ciliegio', 13),
    (64, '2023-12-04 16:30:15', '2023-12-04 16:35:15', 4, 'Ciliegio', 21),
    (65, '2023-12-05 09:45:30', '2023-12-05 09:50:30', 5, 'Ciliegio', 6),
    (66, '2023-12-06 14:25:10', '2023-12-06 14:30:10', 6, 'Ciliegio', 3),
    (67, '2023-11-07 11:15:25', '2023-11-07 11:20:25', 1, 'Cetriolo', 14),
    (68, '2023-11-08 13:40:50', '2023-11-08 13:45:50', 2, 'Cetriolo', 9),
    (69, '2023-11-09 17:55:40', '2023-11-09 18:00:40', 3, 'Cetriolo', 12),
    (70, '2023-12-10 20:10:55', '2023-12-10 20:15:55', 4, 'Cetriolo', 20),
    (71, '2023-12-11 15:30:20', '2023-12-11 15:35:20', 5, 'Cetriolo', 3),
    (72, '2023-12-12 18:45:35', '2023-12-12 18:50:35', 6, 'Cetriolo', 7);

-- Inserimento dati nella tabella Dati
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (1, 17.5, 12.8, 6.9, NULL, NULL, 3, 9, 23.4, 0.0),
    (2, 18.2, 11.5, 7.2, 5, 32.0, NULL, 14, 0.0, 10.2), 
    (3, 15.9, 13.2, 6.6, NULL, NULL, 2, 7, 18.7, 0.0),
    (4, 19.4, 14.7, 6.8, 8, 45.0, NULL, 21, 0.0, 13.5),
    (5, 16.8, 12.1, 7.1, NULL, NULL, 4, 11, 20.1, 0.0),
    (6, 17.6, 13.8, 6.7, 3, 18.0, NULL, 8, 0.0, 9.8),
    (7, 18.9, 12.5, 6.9, NULL, NULL, 1, 5, 22.3, 0.0),
    (8, 16.2, 14.3, 7.0, 6, 39.0, NULL, 17, 0.0, 11.9),
    (9, 18.1, 13.5, 6.5, NULL, NULL, 3, 10, 19.8, 0.0),
    (10, 15.7, 11.9, 7.3, 4, 25.0, NULL, 13, 0.0, 10.7),
    (11, 17.3, 12.6, 6.8, NULL, NULL, 2, 6, 21.2, 0.0),
    (12, 19.2, 14.9, 6.7, 7, 42.0, NULL, 20, 0.0, 12.3);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (13, 16.6, 12.3, 7.2, NULL, NULL, 4, 8, 18.5, 0.0),
    (14, 17.8, 13.6, 6.9, 2, 15.0, NULL, 11, 0.0, 9.5),
    (15, 19.7, 12.9, 6.6, NULL, NULL, 1, 4, 23.0, 0.0),
    (16, 16.4, 14.5, 7.1, 5, 30.0, NULL, 16, 0.0, 11.1),
    (17, 18.3, 13.1, 6.8, NULL, NULL, 3, 7, 20.6, 0.0),
    (18, 15.8, 11.7, 7.0, 3, 20.0, NULL, 12, 0.0, 10.0),
    (19, 17.4, 12.4, 6.7, NULL, NULL, 2, 5, 22.0, 0.0),
    (20, 19.1, 14.6, 6.9, 6, 36.0, NULL, 19, 0.0, 12.1),
    (21, 16.9, 12.0, 7.2, NULL, NULL, 4, 10, 18.2, 0.0),
    (22, 17.7, 13.7, 6.5, 4, 22.0, NULL, 15, 0.0, 9.3),
    (23, 18.8, 12.3, 7.3, NULL, NULL, 1, 3, 21.8, 0.0),
    (24, 16.1, 14.2, 6.8, 7, 41.0, NULL, 18, 0.0, 11.7);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (25, 17.9, 13.3, 6.6, NULL, NULL, 3, 6, 19.5, 0.0),
    (26, 19.6, 11.8, 7.1, 5, 28.0, NULL, 13, 0.0, 10.5),
    (27, 16.7, 12.5, 6.9, NULL, NULL, 2, 4, 21.5, 0.0),
    (28, 18.4, 14.8, 6.7, 8, 44.0, NULL, 20, 0.0, 12.6),
    (29, 15.6, 12.2, 7.2, NULL, NULL, 4, 9, 18.4, 0.0),
    (30, 17.5, 13.9, 6.8, 3, 17.0, NULL, 14, 0.0, 9.7),
    (31, 18.7, 12.6, 7.0, NULL, NULL, 1, 6, 22.1, 0.0),
    (32, 16.3, 14.4, 6.9, 6, 38.0, NULL, 17, 0.0, 11.3),
    (33, 18.2, 13.4, 6.4, NULL, NULL, 3, 8, 19.7, 0.0),
    (34, 15.9, 11.6, 7.3, 4, 24.0, NULL, 15, 0.0, 10.3),
    (35, 17.3, 12.7, 6.8, NULL, NULL, 2, 7, 20.9, 0.0),
    (36, 19.3, 14.9, 6.7, 7, 43.0, NULL, 19, 0.0, 12.5);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (37, 16.5, 12.4, 7.1, NULL, NULL, 4, 10, 18.6, 0.0),
    (38, 17.8, 13.5, 6.9, 2, 14.0, NULL, 11, 0.0, 9.9),
    (39, 19.9, 12.8, 6.6, NULL, NULL, 1, 5, 22.8, 0.0),
    (40, 16.2, 14.6, 7.0, 5, 29.0, NULL, 16, 0.0, 11.0),
    (41, 18.1, 13.2, 6.8, NULL, NULL, 3, 7, 20.3, 0.0),
    (42, 15.7, 11.9, 7.1, 3, 19.0, NULL, 12, 0.0, 10.1),
    (43, 17.4, 12.3, 6.7, NULL, NULL, 2, 5, 21.7, 0.0),
    (44, 19.2, 14.7, 6.6, 6, 40.0, NULL, 18, 0.0, 12.2),
    (45, 16.8, 12.1, 7.1, NULL, NULL, 4, 11, 20.1, 0.0),
    (46, 17.6, 13.8, 6.7, 3, 18.0, NULL, 8, 0.0, 9.8),
    (47, 18.9, 12.5, 6.9, NULL, NULL, 1, 5, 22.3, 0.0),
    (48, 16.2, 14.3, 7.0, 6, 39.0, NULL, 17, 0.0, 11.9);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (49, 18.1, 13.5, 6.5, NULL, NULL, 3, 10, 19.8, 0.0),
    (50, 15.7, 11.9, 7.3, 4, 25.0, NULL, 13, 0.0, 10.7),
    (51, 17.3, 12.6, 6.8, NULL, NULL, 2, 6, 21.2, 0.0),
    (52, 19.2, 14.9, 6.7, 7, 42.0, NULL, 20, 0.0, 12.3),
    (53, 16.6, 12.3, 7.2, NULL, NULL, 4, 8, 18.5, 0.0),
    (54, 17.8, 13.6, 6.9, 2, 15.0, NULL, 11, 0.0, 9.5),
    (55, 19.7, 12.9, 6.6, NULL, NULL, 1, 4, 23.0, 0.0),
    (56, 16.4, 14.5, 7.1, 5, 30.0, NULL, 16, 0.0, 11.1),
    (57, 18.3, 13.1, 6.8, NULL, NULL, 3, 7, 20.6, 0.0),
    (58, 15.8, 11.7, 7.0, 3, 20.0, NULL, 12, 0.0, 10.0),
    (59, 17.4, 12.4, 6.7, NULL, NULL, 2, 5, 22.0, 0.0),
    (60, 19.1, 14.6, 6.9, 6, 36.0, NULL, 19, 0.0, 12.1);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice)
VALUES (61, 16.9, 12.0, 7.2, NULL, NULL, 4, 10, 18.2, 0.0),
    (62, 17.7, 13.7, 6.5, 4, 22.0, NULL, 15, 0.0, 9.3),
    (63, 18.8, 12.3, 7.3, NULL, NULL, 1, 3, 21.8, 0.0),
    (64, 16.1, 14.2, 6.8, 7, 41.0, NULL, 18, 0.0, 11.7),
    (65, 17.9, 13.3, 6.6, NULL, NULL, 3, 6, 19.5, 0.0),
    (66, 19.6, 11.8, 7.1, 5, 28.0, NULL, 13, 0.0, 10.5),
    (67, 16.7, 12.5, 6.9, NULL, NULL, 2, 4, 21.5, 0.0),
    (68, 18.4, 14.8, 6.7, 8, 44.0, NULL, 20, 0.0, 12.6),
    (69, 15.6, 12.2, 7.2, NULL, NULL, 4, 9, 18.4, 0.0),
    (70, 17.5, 13.9, 6.8, 3, 17.0, NULL, 14, 0.0, 9.7),
    (71, 18.7, 12.6, 7.0, NULL, NULL, 1, 6, 22.1, 0.0),
    (72, 16.3, 14.4, 6.9, 6, 38.0, NULL, 17, 0.0, 11.3);

-- Inserimento dati nella tabella Responsabile
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES (1, 'mirko.alessandrini@esterno.example.com', NULL, NULL, 1),
    (2, 'mirko.alessandrini@esterno.example.com', NULL, NULL, 1),
    (3, NULL, 'giulia.bianchi@example.com', 1, NULL),
    (4, NULL, NULL, 2, NULL),
    (5, 'andrea.verdi@example.com', NULL, NULL, 2),
    (6, 'andrea.verdi@example.com', NULL, NULL, NULL),
    (7, NULL, 'mirko.alessandrini@esterno.example.com', 1, NULL),
    (8, 'mirko.alessandrini@esterno.example.com', NULL, NULL, 1),
    (9, 'andrea.verdi@example.com', NULL, NULL, NULL),
    (10, NULL, NULL, 2, NULL),
    (11, 'giulia.bianchi@example.com', NULL, NULL, NULL),
    (12, 'giulia.bianchi@example.com', NULL, NULL, 2);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES(13, 'cesare.conte@esterno.example.com', NULL, NULL, NULL),
    (14, 'cesare.conte@esterno.example.com', NULL, NULL, 3),
    (15, NULL, 'elena.verdi@example.com', 3, NULL),
    (16, NULL, NULL, 4, NULL),
    (17, 'matteo.ferrari@example.com', NULL, NULL, 4),
    (18, 'matteo.ferrari@example.com', NULL, NULL, NULL),
    (19, NULL, 'cesare.conte@esterno.example.com', 3, NULL),
    (20, 'cesare.conte@esterno.example.com', NULL, NULL, 3),
    (21, 'matteo.ferrari@example.com', NULL, NULL, NULL),
    (22, NULL, NULL, 4, NULL),
    (23, 'elena.verdi@example.com', NULL, NULL, 4),
    (24, 'elena.verdi@example.com', NULL, NULL, 4);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES (25, 'beatrice.gazzo@esterno.example.com', NULL, NULL, NULL),
    (26, 'beatrice.gazzo@esterno.example.com', NULL, NULL, 5),
    (27, NULL, 'mario.bianchi@example.com', 5, NULL),
    (28, NULL, NULL, 6, NULL),
    (29, 'maria.bianchi@example.com', NULL, NULL, 6),
    (30, 'maria.bianchi@example.com', NULL, NULL, 5),
    (31, NULL, 'beatrice.gazzo@esterno.example.com', 5, NULL),
    (32, 'beatrice.gazzo@esterno.example.com', NULL, NULL, 5),
    (33, 'maria.bianchi@example.com', NULL, NULL, NULL),
    (34, NULL, NULL, 6, NULL),
    (35, 'mario.bianchi@example.com', NULL, NULL, NULL),
    (36, 'mario.bianchi@example.com', NULL, NULL, 6);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES (37, 'francesco.firenza@esterno.example.com', NULL, NULL, NULL),
    (38, 'francesco.firenza@esterno.example.com', NULL, NULL, 7),
    (39, NULL, 'paolo.verdi@example.com', 7, NULL),
    (40, NULL, NULL, 8, NULL),
    (41, 'giuseppe.bianchi@example.com', NULL, NULL, 8),
    (42, 'giuseppe.bianchi@example.com', NULL, NULL, NULL),
    (43, NULL, 'francesco.firenza@esterno.example.com', 7, NULL),
    (44, 'francesco.firenza@esterno.example.com', NULL, NULL, 7),
    (45, 'giuseppe.bianchi@example.com', NULL, NULL, NULL),
    (46, NULL, NULL, 8, NULL),
    (47, 'paolo.verdi@example.com', NULL, NULL, 8),
    (48, 'paolo.verdi@example.com', NULL, NULL, 8);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES (49, 'sascha.bucci@esterno.example.com', NULL, NULL, 9),
    (50, 'sascha.bucci@esterno.example.com', NULL, NULL, 9),
    (51, NULL, 'luca.ferrari@example.com', 9, NULL),
    (52, NULL, NULL, 10, NULL),
    (53, 'sara.rossi@example.com', NULL, NULL, 10),
    (54, 'sara.rossi@example.com', NULL, NULL, NULL),
    (55, NULL, 'sascha.bucci@esterno.example.com', 9, NULL),
    (56, 'sascha.bucci@esterno.example.com', NULL, NULL, 9),
    (57, 'sara.rossi@example.com', NULL, NULL, NULL),
    (58, NULL, NULL, 10, NULL),
    (59, 'luca.ferrari@example.com', NULL, NULL, NULL),
    (60, 'luca.ferrari@example.com', NULL, NULL, 10);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse)
VALUES (61, 'lorenzo.ostuni@esterno.example.com', NULL, NULL, 11),
    (62, 'lorenzo.ostuni@esterno.example.com', NULL, NULL, 11),
    (63, NULL, 'valentina.rossi@example.com', 11, NULL),
    (64, NULL, NULL, 12, NULL),
    (65, 'giovanni.rossi@example.com', NULL, NULL, 12),
    (66, 'giovanni.rossi@example.com', NULL, NULL, NULL),
    (67, NULL, 'lorenzo.ostuni@esterno.example.com', 11, NULL),
    (68, 'lorenzo.ostuni@esterno.example.com', NULL, NULL, 11),
    (69, 'giovanni.rossi@example.com', NULL, NULL, NULL),
    (70, NULL, NULL, 12, NULL),
    (71, 'valentina.rossi@example.com', NULL, NULL, NULL),
    (72, 'valentina.rossi@example.com', NULL, NULL, 12);
