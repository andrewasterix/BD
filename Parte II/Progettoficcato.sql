DROP SCHEMA IF EXISTS "OrtiScolastici" CASCADE;
CREATE SCHEMA IF NOT EXISTS "OrtiScolastici";
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';

DROP TABLE IF EXISTS Rilevazioni;
DROP TABLE IF EXISTS Sensore;
DROP TABLE IF EXISTS Dati;
DROP TABLE IF EXISTS Orto CASCADE;
DROP TABLE IF EXISTS Piante;
DROP TABLE IF EXISTS Gruppo;
DROP TABLE IF EXISTS Specie CASCADE;
DROP TABLE IF EXISTS Classe;
DROP TABLE IF EXISTS Persona;
DROP TABLE IF EXISTS Scuola CASCADE;
DROP TABLE IF EXISTS Ruolo;
DROP TABLE IF EXISTS Progetto CASCADE;

CREATE TABLE IF NOT EXISTS Progetto (
    id_progetto BIGINT NOT NULL,
    nome_progetto TEXT NOT NULL,
    finanziamento TEXT NOT NULL,    
	PRIMARY KEY (id_progetto)
);

CREATE TABLE IF NOT EXISTS Ruolo (
    Tipo_ruolo TEXT NOT NULL CHECK (Tipo_ruolo IN ('Docente', 'Referente', 'Rilevatore Esterno', 'Studente')),
	PRIMARY KEY (Tipo_ruolo)
);

CREATE TABLE IF NOT EXISTS Scuola (
    codice_meccanografico VARCHAR(10) NOT NULL,
    nome_scuola TEXT NOT NULL,
    provincia CHAR(2) NOT NULL,
    comune TEXT NOT NULL,
    ciclo_istruzione TEXT NOT NULL CHECK (ciclo_istruzione IN ('PRIMO', 'SECONDO')),
    collabora TEXT NOT NULL CHECK (collabora IN ('Si', 'No')),
    progetto BIGINT REFERENCES Progetto (id_progetto),
	PRIMARY KEY (codice_meccanografico),
    UNIQUE (codice_meccanografico)
);

CREATE TABLE IF NOT EXISTS Persona (
    email TEXT NOT NULL,
    nome TEXT NOT NULL,
    cognome TEXT NOT NULL,
    telefono BIGINT,
    scuola VARCHAR(10) REFERENCES Scuola (codice_meccanografico),
    ruolo TEXT REFERENCES Ruolo (Tipo_ruolo),
	PRIMARY KEY (email)
);

CREATE TABLE IF NOT EXISTS Classe (
    nome_classe VARCHAR(5) NOT NULL,
    ordine INT NOT NULL,
    tipo_scuola TEXT NOT NULL,
    docente TEXT NOT NULL REFERENCES Persona (email),
    scuola VARCHAR(10) REFERENCES Scuola (codice_meccanografico),
	PRIMARY KEY (nome_classe, scuola)
);

CREATE TABLE IF NOT EXISTS Specie (
    nome_scientifico TEXT NOT NULL,
    substrato TEXT NOT NULL CHECK (substrato IN ('Terriccio rinvaso', 'Suolo pre-esistente')),
	PRIMARY KEY (nome_scientifico)
);

CREATE TABLE IF NOT EXISTS Gruppo (
    id_gruppo BIGINT NOT NULL,
    tipo_gruppo TEXT NOT NULL CHECK (tipo_gruppo IN ('Controllo', 'Stress ambientale')),
    PRIMARY KEY (id_gruppo)
);

CREATE TABLE IF NOT EXISTS Orto (
    nome_orto TEXT NOT NULL,
    superficie FLOAT NOT NULL,
    latitudine FLOAT NOT NULL,
    longitudine FLOAT NOT NULL,
    condizione_ambientale TEXT NOT NULL CHECK (condizione_ambientale IN ('Pulito', 'Inquinato')),
    collocazione TEXT NOT NULL CHECK (collocazione IN ('Vaso', 'Terra')),
    scuola VARCHAR(10) REFERENCES Scuola (codice_meccanografico),
    specie TEXT REFERENCES Specie (nome_scientifico),
    PRIMARY KEY (nome_orto, latitudine, longitudine)
);

CREATE TABLE IF NOT EXISTS Piante (
    id_pianta BIGINT NOT NULL,
    nome_comune TEXT NOT NULL,
    data_messa_a_dimora DATE NOT NULL,
    sole BOOLEAN NOT NULL,
    ombra BOOLEAN NULL,
    mezz_ombra BOOLEAN NOT NULL,
    scopo TEXT NOT NULL CHECK (scopo IN ('Biomonitoraggio', 'Fitobotanica')),
    gruppo BIGINT REFERENCES Gruppo (id_gruppo),
    orto_nome_orto TEXT NOT NULL,
    orto_latitudine FLOAT NOT NULL,
    orto_longitudine FLOAT NOT NULL,
    FOREIGN KEY (orto_nome_orto, orto_latitudine, orto_longitudine) REFERENCES Orto (nome_orto, latitudine, longitudine),
    specie TEXT REFERENCES Specie (nome_scientifico), 
    PRIMARY KEY (id_pianta)
);

CREATE TABLE IF NOT EXISTS Rilevazioni (
    id_rilevazione BIGINT,
    data_ora_inserimento TIMESTAMP NOT NULL,
    data_ora_rilevazione TIMESTAMP NOT NULL,
    responsabile TEXT REFERENCES Persona (email),
    pianta BIGINT REFERENCES Piante (id_pianta),	
    PRIMARY KEY (id_rilevazione),
	
    CONSTRAINT data_ora_rilevazione_a_antecedente_a_data_ora_inserimento
        CHECK (data_ora_rilevazione > data_ora_inserimento),
    UNIQUE (data_ora_inserimento, data_ora_rilevazione)
);

CREATE TABLE IF NOT EXISTS Dati(
    id_dato BIGINT NOT NULL,
    lunghezza_foglia FLOAT NOT NULL,
    altezza_pianta FLOAT NOT NULL,
    num_fiori INT NOT NULL,
    num_frutti INT NOT NULL,
    num_foglie_danneggiate INT NOT NULL,
    percent_superficie_foglie_danneggiate FLOAT NOT NULL,
     temperatura FLOAT NOT NULL,
    umidita FLOAT NOT NULL,
    ph INT NOT NULL,
    rilevazione BIGINT REFERENCES Rilevazioni (id_rilevazione),    
    PRIMARY KEY (id_dato)
);

CREATE TABLE IF NOT EXISTS Sensore (
    id_sensore BIGINT,
    tipo TEXT NOT NULL CHECK (tipo IN ('arduino', 'sensore')),
    acquisizione TEXT NOT NULL CHECK (acquisizione IN ('BD', 'App')),
    PRIMARY KEY (id_sensore)
);



--Progetto
INSERT INTO Progetto VALUES (12345,'Progetto 1','Finanziato');
INSERT INTO Progetto VALUES (12346,'Progetto 2','Non finanziato');
INSERT INTO Progetto VALUES (12347,'Progetto 3','Finanziato');
INSERT INTO Progetto VALUES (12348,'Progetto 4','Non finanziato');


--Ruolo
INSERT INTO Ruolo VALUES ('Docente');
INSERT INTO Ruolo VALUES ('Referente');
INSERT INTO Ruolo VALUES ('Rilevatore Esterno');
INSERT INTO Ruolo VALUES ('Studente');


--Scuola 
INSERT INTO Scuola VALUES ('ALUS017004','I.I.S CIAMPINI','IM','AIROLE','SECONDO','Si',12345);
INSERT INTO Scuola VALUES ('ALYS017805','S.P. FASTI','GE','ARENZANO','PRIMO','No',12346);
INSERT INTO Scuola VALUES ('ALQS027406','S.P. MONTALE','GE','CASARZA LIGURE','PRIMO','Si',12347);
INSERT INTO Scuola VALUES ('ALUS017507','I.I.S ESTI','SP','LA SPEZIA','SECONDO','No',12348);


--Persona
INSERT INTO Persona VALUES ('Nicola584@gmail.com','Nicola','Bianchi',3333333333,'ALUS017004','Docente');
INSERT INTO Persona VALUES ('Laura659@gmail.com','Laura','Rossi',4444444444,'ALYS017805','Referente');
INSERT INTO Persona VALUES ('Ugo456@gmail.com','Ugo','Verdi',5555555555,'ALQS027406','Studente');
INSERT INTO Persona VALUES ('Siria7854@.gmail.com','Siria','Neri',6666666666,'ALUS017507','Rilevatore Esterno');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Persona VALUES ('Gigi84@gmail.com','Gigi','Giallo',7777777777,'ALUS017004','Docente');
INSERT INTO Persona VALUES ('Fiona79@gmail.com','Fiona','Arncio',8888888888,'ALYS017805','Referente');
INSERT INTO Persona VALUES ('Susan46@gmail.com','Susan','Black',9999999999,'ALQS027406','Studente');
INSERT INTO Persona VALUES ('Rebby654@.gmail.com','Rebecca','',2222222222,'ALUS017507','Rilevatore Esterno');


--Classe
INSERT INTO Classe VALUES ('1A',2,'Scientifico','Nicola584@gmail.com','ALUS017004');
INSERT INTO Classe VALUES ('3C',1,'Elementare','Gigi84@gmail.com','ALYS017805');
INSERT INTO Classe VALUES ('1B',1,'Elementare','Gigi84@gmail.com','ALQS027406');
INSERT INTO Classe VALUES ('2A',2,'Classico','Nicola584@gmail.com','ALUS017507');

--Specie
INSERT INTO Specie VALUES ('Acer campestre','Terriccio rinvaso'); --acero
INSERT INTO Specie VALUES ('Prunus avium','Suolo pre-esistente');  --cigliegio
INSERT INTO Specie VALUES ('Acacia','Terriccio rinvaso'); --acacia
INSERT INTO Specie VALUES ('Betula','Suolo pre-esistente'); --betulla


--Gruppo
INSERT INTO Gruppo VALUES (0001,'Controllo');
INSERT INTO Gruppo VALUES (0002,'Stress ambientale');
INSERT INTO Gruppo VALUES (0003,'Controllo');
INSERT INTO Gruppo VALUES (0004,'Stress ambientale');


--Orto
INSERT INTO Orto VALUES ('Orto 1', 10, 44.40726, 8.93386, 'Pulito', 'Vaso', 'ALUS017004', 'Acer campestre');
INSERT INTO Orto VALUES ('Orto 2', 20, 44.40726, 8.93386, 'Inquinato', 'Terra', 'ALYS017805', 'Prunus avium');
INSERT INTO Orto VALUES ('Orto 3', 30, 44.40726, 8.93386, 'Pulito', 'Vaso', 'ALQS027406', 'Acacia');
INSERT INTO Orto VALUES ('Orto 4', 40, 44.40726, 8.93386, 'Inquinato', 'Terra', 'ALUS017507', 'Betula');


--Piante
INSERT INTO Piante VALUES (1,'Acero', '2022-09-10', TRUE, FALSE, FALSE, 'Biomonitoraggio', 0001, 'Orto 1', 44.40726, 8.93386, 'Acer campestre');
INSERT INTO Piante VALUES (2,'Cigliegio', '2022-05-02', FALSE, FALSE, TRUE, 'Fitobotanica', 0002, 'Orto 2', 44.40726, 8.93386, 'Prunus avium');
INSERT INTO Piante VALUES (3,'Acacia', '2022-04-06', FALSE, TRUE, FALSE, 'Biomonitoraggio', 0003, 'Orto 3', 44.40726, 8.93386, 'Acacia');
INSERT INTO Piante VALUES (4,'Betulla', '2022-02-07', TRUE, FALSE, FALSE, 'Fitobotanica', 0004, 'Orto 4', 44.40726, 8.93386, 'Betula');


--Rilevazioni
INSERT INTO Rilevazioni VALUES (01,'2021-09-10 10:30:00','2021-09-10 10:45:00','Siria7854@.gmail.com',1);
INSERT INTO Rilevazioni VALUES (02,'2021-05-02 12:30:00','2021-05-02 12:45:00','Ugo456@gmail.com',2);
INSERT INTO Rilevazioni VALUES (03,'2021-04-06 14:30:00','2021-04-06 14:45:00','Fiona79@gmail.com',3);
INSERT INTO Rilevazioni VALUES (04,'2021-02-07 16:30:00','2021-02-07 16:45:00','Laura659@gmail.com',4);


--Dati
INSERT INTO Dati VALUES (1, 10.5, 20.5, 5, 10, 2, 0.5, 20.5, 30.5, 7, 01);
INSERT INTO Dati VALUES (2, 11.5, 21.5, 6, 11, 3, 0.6, 21.5, 31.5, 8, 02);
INSERT INTO Dati VALUES (3, 12.5, 22.5, 7, 12, 4, 0.7, 22.5, 32.5, 9, 03);
INSERT INTO Dati VALUES (4, 13.5, 23.5, 8, 13, 5, 0.8, 23.5, 33.5, 10, 04);


--Sensore
INSERT INTO Sensore VALUES (10,'arduino','BD');
INSERT INTO Sensore VALUES (20,'sensore','App');
INSERT INTO Sensore VALUES (30,'arduino','BD');
INSERT INTO Sensore VALUES (40,'sensore','App');




