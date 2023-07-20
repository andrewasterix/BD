/*
Parte III - Progetto Base di Dati

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/

-- CREAZIONE DELLO SCHEMA DELLA BASE DATI

DROP SCHEMA IF EXISTS "OrtiScolastici" CASCADE;
CREATE SCHEMA IF NOT EXISTS "OrtiScolastici";
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

DROP TABLE IF EXISTS "Progetto", "Scuola", "Persona", "Ruolo", "Classe" CASCADE;
DROP TABLE IF EXISTS "Specie", "Orto", "Pianta", "Esposizione", "Gruppo", "Sensore", "Dati", "Rilevazione", "Responsabile" CASCADE;

-- Tabella Persona
CREATE TABLE IF NOT EXISTS Persona (
    Email VARCHAR(100) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Cognome VARCHAR(100) NOT NULL,
    Telefono Numeric(10) NULL,
    RilevatoreEsterno BOOLEAN NULL DEFAULT FALSE
);

-- Tabella Scuola
CREATE TABLE IF NOT EXISTS Scuola (
    Cod_Meccanografico VARCHAR(10) PRIMARY KEY,
    NomeScuola VARCHAR(100) NOT NULL,
    CicloIstruzione INTEGER NOT NULL CHECK(CicloIstruzione >= 1 AND CicloIstruzione <= 2),
    Comune VARCHAR(100) NOT NULL,
    Provincia VARCHAR(100) NOT NULL,
    Collabora BOOLEAN NOT NULL DEFAULT FALSE,

    Finanziamento VARCHAR(100) NULL,

    Dirigente VARCHAR(100) NOT NULL,
    FOREIGN KEY (Dirigente) REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    
    Referente VARCHAR(100) NULL,
    FOREIGN KEY (Referente) REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabella Classe
CREATE TABLE IF NOT EXISTS Classe (
    IdClasse BIGINT PRIMARY KEY,
    Sezione VARCHAR(5) NOT NULL,
    Scuola VARCHAR(10) NOT NULL,
    FOREIGN KEY (Scuola) REFERENCES Scuola(Cod_Meccanografico) ON DELETE CASCADE ON UPDATE CASCADE,
    Ordine INTEGER NOT NULL CHECK(Ordine >= 1 AND Ordine <= 2),
    TipoScuola VARCHAR(100) NOT NULL,

    Docente VARCHAR(100) NOT NULL,
    FOREIGN KEY (Docente) REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabella Specie
CREATE TABLE IF NOT EXISTS Specie (
    NomeScientifico VARCHAR(100) NOT NULL PRIMARY KEY,
    Substrato VARCHAR(100) NOT NULL CHECK(Substrato IN ('TerriccioRinvaso', 'SuoloPreEsistente'))
);

-- Tabella Orto
CREATE TABLE IF NOT EXISTS Orto (
    IdOrto BIGINT,
    NomeOrto VARCHAR(100) NOT NULL,
    Latitudine FLOAT NOT NULL,
    Longitudine FLOAT NOT NULL,
    Superficie FLOAT NOT NULL,
    Posizione VARCHAR(100) NOT NULL CHECK(Posizione IN ('Vaso', 'Terra')),
    CondizioneAmbientale VARCHAR(10) NOT NULL CHECK(CondizioneAmbientale IN ('Pulito', 'Inquinato')),

    Specie VARCHAR(100) NOT NULL,
    FOREIGN KEY (Specie) REFERENCES Specie(NomeScientifico) ON DELETE CASCADE ON UPDATE CASCADE,

    Scuola VARCHAR(10) NOT NULL,
    FOREIGN KEY (Scuola) REFERENCES Scuola(Cod_Meccanografico) ON DELETE CASCADE ON UPDATE CASCADE,

    PRIMARY KEY (IdOrto, Specie)
);

-- Tabella Pianta
CREATE TABLE IF NOT EXISTS Pianta (
    NumeroReplica BIGINT NOT NULL,
    NomeComune VARCHAR(100) NOT NULL,
    Scopo VARCHAR(100) NOT NULL CHECK(Scopo IN ('Fitobotanica', 'Biomonitoraggio')),
    DataMessaDimora DATE NOT NULL,

    Specie VARCHAR(100) NOT NULL,
    FOREIGN KEY (Specie) REFERENCES Specie(NomeScientifico) ON DELETE CASCADE ON UPDATE CASCADE,

    Classe BIGINT NOT NULL,
    FOREIGN KEY (Classe) REFERENCES Classe(IdClasse) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (NumeroReplica, NomeComune)
);

-- Tabella Esposizione
CREATE TABLE IF NOT EXISTS Esposizione (
    NumeroReplica BIGINT NOT NULL,
    NomeComune VARCHAR(100) NOT NULL,
    FOREIGN KEY (NumeroReplica, NomeComune) REFERENCES Pianta(NumeroReplica, NomeComune) ON DELETE CASCADE ON UPDATE CASCADE,

    TipoEsposizione VARCHAR(100) NOT NULL CHECK(TipoEsposizione IN ('Sole', 'Mezzombra', 'Ombra')),
    PRIMARY KEY (NumeroReplica, NomeComune, TipoEsposizione)
);

-- Tabella Gruppo
CREATE TABLE IF NOT EXISTS Gruppo (
    IdGruppo BIGINT,
    TipoGruppo VARCHAR(100) NOT NULL CHECK(TipoGruppo IN ('Controllo', 'Monitoraggio')),

    NumeroReplica BIGINT NOT NULL,
    NomeComune VARCHAR(100) NOT NULL,
    FOREIGN KEY (NumeroReplica, NomeComune) REFERENCES Pianta(NumeroReplica, NomeComune) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(IdGruppo, NumeroReplica, NomeComune)
);

-- Tabella Sensore
CREATE TABLE IF NOT EXISTS Sensore (
    IdSensore BIGINT PRIMARY KEY,
    TipoSensore VARCHAR(100) NOT NULL CHECK(TipoSensore IN ('Arduino', 'Sensore')),
    TipoAcquisizione VARCHAR(100) NOT NULL CHECK(TipoAcquisizione IN ('Arduino', 'App'))
);

-- Tabella Rilevazione
CREATE TABLE IF NOT EXISTS Rilevazione (
    IdRilevazione BIGINT PRIMARY KEY,
    DataOraRilevazione TIMESTAMP NOT NULL,
    DataOraInserimento TIMESTAMP NOT NULL,

    NumeroReplica BIGINT NOT NULL,
    NomeComune VARCHAR(100) NOT NULL,
    FOREIGN KEY (NumeroReplica, NomeComune) REFERENCES Pianta(NumeroReplica, NomeComune) ON DELETE CASCADE ON UPDATE CASCADE,

    Sensore BIGINT NOT NULL,
    FOREIGN KEY (Sensore) REFERENCES Sensore(IdSensore) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabella Dati
CREATE TABLE IF NOT EXISTS Dati (
    Rilevazione BIGINT PRIMARY KEY,
    FOREIGN KEY (Rilevazione) REFERENCES Rilevazione(IdRilevazione) ON DELETE CASCADE ON UPDATE CASCADE,
    -- Parametri Suolo
    Temperatura FLOAT NOT NULL,
    Umidita FLOAT NOT NULL,
    Ph FLOAT NOT NULL,
    -- Parametri Danni
    FoglieDanneggiate INT NULL,
    SuperficieFoglieDanneggiate FLOAT NULL,
    -- Parametri Fioritura & Fruttificazione
    Fiori INT NULL,
    Frutti INT NULL,
    -- Parametri Biomassa & Struttura
    AltezzaPianta FLOAT NOT NULL,
    LunghezzaRadice FLOAT NOT NULL
);

-- Tabella Responsabile
CREATE TABLE IF NOT EXISTS Responsabile (
    Rilevazione BIGINT NOT NULL PRIMARY KEY,
    FOREIGN KEY (Rilevazione) REFERENCES Rilevazione(IdRilevazione) ON DELETE CASCADE ON UPDATE CASCADE,
    InserimentoPersona VARCHAR(100) NULL REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    RilevatorePersona VARCHAR(100) NULL REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE,

    InserimentoClasse BIGINT NULL,
    FOREIGN KEY (InserimentoClasse) REFERENCES Classe(IdClasse) ON DELETE CASCADE ON UPDATE CASCADE,
    RilevatoreClasse BIGINT NULL,
    FOREIGN KEY (RilevatoreClasse) REFERENCES Classe(IdClasse) ON DELETE CASCADE ON UPDATE CASCADE
);

-- POPOLAMENTO LARGE

INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('carusogiacinto@example.com', 'Michela', 'Iannucci', '6470959059', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('zaccardonino@example.org', 'Gastone', 'Iannotti', '6732926210', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('giannapriuli@example.org', 'Puccio', 'Onio', '8811056082', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('yagazzi@example.net', 'Elisa', 'Monaco', '1040960959', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('fredo13@example.net', 'Guarino', 'Badoglio', '6305871450', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('coluccio09@example.net', 'Lazzaro', 'Rosselli', '3277415668', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('lara39@example.org', 'Coluccio', 'Giannelli', '4215216879', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('luchino02@example.com', 'Antonina', 'Biagiotti', '3616496683', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('mariarosiello@example.com', 'Jacopo', 'Schicchi', '4358809383', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('rmontessori@example.org', 'Giulio', 'Garzoni', '8598416377', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('giacomopizziol@example.net', 'Filippo', 'Boccherini', '9591595760', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('qtrupiano@example.com', 'Vincenza', 'Bellini', '325356674', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('enrico21@example.com', 'Michelangelo', 'Soprano', '5310086612', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('silvia65@example.net', 'Lolita', 'Zanzi', '2178076410', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('vincentiomoretti@example.com', 'Gabriella', 'Giannuzzi', '3562548094', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('corradobertoni@example.com', 'Toni', 'Iacobucci', '6022337048', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('massimo73@example.com', 'Concetta', 'Gabbana', '966023634', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('veronica27@example.com', 'Francesco', 'Alonzi', '986548414', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('vincentiosegni@example.com', 'Costanzo', 'Gagliano', '3929633636', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('cristina84@example.net', 'Luciana', 'Bettoni', '5103698826', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('bartolipompeo@example.net', 'Teresa', 'Ossola', '1966513357', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('comissocirillo@example.com', 'Antonello', 'Fabrizi', '5521389558', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('emilio69@example.org', 'Ninetta', 'Soranzo', '9206832037', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('danilocerutti@example.com', 'Armando', 'Varano', '6122496468', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('flavioluzi@example.net', 'Imelda', 'Polizzi', '3636344783', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('germanagentileschi@example.net', 'Rodolfo', 'Folliero', '3624004256', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('vecelliolina@example.org', 'Calogero', 'Ludovisi', '3562445867', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('maffeigaspare@example.com', 'Amleto', 'Anguillara', '3399668406', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('amico70@example.com', 'Franco', 'Orengo', '8499991131', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('edoardoserao@example.org', 'Renata', 'Marrone', '4811343750', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('corradopetrucci@example.org', 'Carla', 'Farina', '8404134816', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('calogeroargentero@example.org', 'Camillo', 'Broggini', '5423317258', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('upedersoli@example.com', 'Fiorino', 'Nibali', '9835169455', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('mariaantonetti@example.com', 'Gelsomina', 'Gargallo', '7148706994', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('giolittimicheletto@example.com', 'Gemma', 'Vivaldi', '3273885236', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('nicolabruno@example.com', 'Maria', 'Desio', '8309091028', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('martapacomio@example.net', 'Nina', 'Tropea', '7671252840', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('alessio81@example.net', 'Vittoria', 'Mimun', '6980605253', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('antonelloaltera@example.com', 'Damiano', 'Vecellio', '6208994343', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('opetrucelli@example.net', 'Paolo', 'Miniati', '5933492807', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('upaolucci@example.com', 'Santino', 'Gozzano', '8951032428', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('claudia73@example.org', 'Livio', 'Guarato', '3977658401', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('laurettalettiere@example.org', 'Gustavo', 'Florio', '5869083688', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('segrealberico@example.net', 'Umberto', 'Boiardo', '2426391994', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('andreottitonino@example.org', 'Bruno', 'Donatoni', '3572046168', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('onistoramona@example.net', 'Lucio', 'Spinola', '3356975539', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('giuliomoretti@example.org', 'Sebastiano', 'Niggli', '1456171102', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('qfarina@example.com', 'Raffaellino', 'Gritti', '2093304648', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('baldassarepinamonte@example.net', 'Raffaello', 'Boitani', '2949242491', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('niscoromniantonietta@example.com', 'Giacinto', 'Dandolo', '5884924392', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('norbiatomariana@example.net', 'Laura', 'Villadicani', '7282860392', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('cpizzo@example.org', 'Serena', 'Balbi', '6965843118', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('galtarossaannibale@example.org', 'Angelina', 'Ritacca', '3689949160', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('esegni@example.org', 'Giorgia', 'Luzi', '5610232713', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('ipalmisano@example.org', 'Marta', 'Marzorati', '8707421825', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('geronimo25@example.net', 'Antonina', 'Mortati', '5407229410', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('pellegriniruggero@example.com', 'Lucrezia', 'Porzio', '1288340275', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('rizzoantonella@example.com', 'Rossana', 'Vergassola', '3532870883', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('pedersoligianluigi@example.com', 'Milo', 'Fieramosca', '9642790588', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('toldogiulio@example.net', 'Stefano', 'Vitturi', '6603739122', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('gaitogermana@example.net', 'Ermes', 'Oliboni', '1734701321', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('brugnaroliberto@example.com', 'Sergius', 'Bianchi', '683072827', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('edibiasi@example.org', 'Gianpietro', 'Platini', '2239388849', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('pomponio39@example.net', 'Laura', 'Pausini', '9243369718', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('carolinaluria@example.com', 'Guarino', 'Falcone', '1517206387', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('jcristoforetti@example.org', 'Ruggiero', 'Gregorio', '1444922883', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('matteo49@example.com', 'Nicol�', 'Peruzzi', '3716219984', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('mpininfarina@example.com', 'Marina', 'Bodoni', '8902666223', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('ferrarisubaldo@example.com', 'Niccol�', 'Marangoni', '8315818790', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('vattimoarsenio@example.org', 'Santino', 'Micca', '9664191943', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('bernardosperi@example.net', 'Temistocle', 'Ruberto', '2817554985', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('cappelliennio@example.com', 'Gianfranco', 'Pistoletto', '1449666814', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('lodovicoboiardo@example.net', 'Pompeo', 'Cicala', '6390834286', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('abatantuonogiuliana@example.org', 'Rodolfo', 'Cuomo', '7753213244', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('sonia28@example.net', 'Oreste', 'Malpighi', '8218116717', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('fabriziofilippini@example.org', 'Alfredo', 'Strangio', '3984002545', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('egioberti@example.org', 'Ronaldo', 'Brancaccio', '1235169008', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('baccio81@example.org', 'Alfio', 'Folliero', '5388057762', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('bajardiisa@example.net', 'Delfino', 'Zeffirelli', '8399886505', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('blasitorquato@example.org', 'Matteo', 'Zacchia', '4575382150', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('platiniflora@example.net', 'Armando', 'Olivetti', '6338930220', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('stradivarinatalia@example.net', 'Mercedes', 'Argan', '767518326', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('solepirandello@example.net', 'Nina', 'Quasimodo', '1850423098', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('rgatto@example.org', 'Ramona', 'Pavarotti', '4344681195', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('fredo23@example.org', 'Beppe', 'Terragni', '82530374', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('lgentileschi@example.org', 'Leonardo', 'Sabbatini', '8741511086', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('ballagianluigi@example.com', 'Adamo', 'Trevisan', '9213617078', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('michelangelogaiatto@example.net', 'Mauro', 'Navone', '489236741', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('pisaronicipriano@example.net', 'Lara', 'Cantimori', '6552516607', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('santemimun@example.net', 'Dino', 'Panatta', '2078633996', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('dbocca@example.com', 'Coriolano', 'Stradivari', '4611496294', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('manuel96@example.com', 'Berenice', 'Torricelli', '3608633579', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('ycianciolo@example.org', 'Tonino', 'Tuzzolino', '5159578196', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('piergiorgio14@example.com', 'Tiziano', 'Moretti', '1316833609', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('gianni28@example.org', 'Pierluigi', 'Persico', '2779081814', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('carlo75@example.net', 'Santino', 'Leblanc', '3458969677', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('livio36@example.org', 'Patrizio', 'Chinnici', '6104118315', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('pietro77@example.com', 'Gioacchino', 'Quasimodo', '3613529922', True);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('anita10@example.net', 'Baldassare', 'Vespucci', '4300468759', False);
INSERT INTO Persona (Email, Nome, Cognome, Telefono, RilevatoreEsterno) VALUES ('zcheda@example.com', 'Ruggero', 'Lombroso', '1755368403', False);
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('9973387207', 'Pace-Scarpetta e figli', 2, 'Lonate Ceppino', 'Sassari', True, 'consequuntur', 'santemimun@example.net', 'santemimun@example.net');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('6736514978', 'Ceri Group', 1, 'Castellammare Di Stabia', 'Catania', True, 'quibusdam', 'toldogiulio@example.net', 'toldogiulio@example.net');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('7840277742', 'Gramsci Group', 2, 'Deiva Marina', 'Reggio Emilia', True, 'pariatur', 'carolinaluria@example.com', 'carolinaluria@example.com');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('32374066', 'Bova-Castelli SPA', 2, 'Saint Denis', 'Vercelli', True, 'vel', 'blasitorquato@example.org', 'blasitorquato@example.org');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('7137667498', 'Sforza, Rismondo e Detti e figli', 1, 'Fiumara', 'Pesaro e Urbino', False, 'voluptatem', 'upaolucci@example.com', 'upaolucci@example.com');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('7842129378', 'Marangoni s.r.l.', 1, 'Colleatterrato Alto', 'Taranto', True, 'accusamus', 'vecelliolina@example.org', 'vecelliolina@example.org');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('7078800104', 'Albertini, Vanvitelli e Guidotti s.r.l.', 1, 'Villasanta', 'Caltanissetta', False, 'nam', 'mpininfarina@example.com', 'mpininfarina@example.com');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('3351290093', 'Ferrabosco s.r.l.', 2, 'Frattaminore', 'Enna', False, 'ipsa', 'vincentiosegni@example.com', 'vincentiosegni@example.com');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('8274908900', 'Vecoli, Morandi e Finotto e figli', 2, 'Borgagne', 'Ravenna', False, 'nulla', 'coluccio09@example.net', 'coluccio09@example.net');
INSERT INTO Scuola (Cod_Meccanografico, NomeScuola, CicloIstruzione, Comune, Provincia, Collabora, Finanziamento, Dirigente, Referente) VALUES ('1427210992', 'Ricci-Mercadante Group', 1, 'Moglio', 'Cremona', False, 'sapiente', 'cpizzo@example.org', 'cpizzo@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('5273566922', 'o', '9973387207', 2, 'inventore', 'martapacomio@example.net');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('4945605917', 'Y', '9973387207', 2, 'dolorem', 'luchino02@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('6900148646', 'g', '7840277742', 2, 'reiciendis', 'anita10@example.net');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('5074440098', 'i', '7840277742', 1, 'tempora', 'bartolipompeo@example.net');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('7457333766', 'S', '7137667498', 1, 'quas', 'piergiorgio14@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('1241371775', 'R', '7137667498', 2, 'beatae', 'amico70@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('3780356817', 'D', '7078800104', 2, 'optio', 'rmontessori@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('3078562893', 'h', '7078800104', 1, 'quos', 'martapacomio@example.net');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('6002562545', 'Q', '8274908900', 2, 'illum', 'maffeigaspare@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('9369114805', 'y', '8274908900', 1, 'quasi', 'manuel96@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('7875855536', 'h', '1427210992', 1, 'ratione', 'danilocerutti@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('6511426933', 'm', '1427210992', 2, 'voluptate', 'esegni@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('8997139989', 'V', '1427210992', 2, 'suscipit', 'andreottitonino@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('1532292613', 'J', '1427210992', 1, 'error', 'egioberti@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('8782075526', 'r', '1427210992', 2, 'illum', 'danilocerutti@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('9041357177', 'c', '1427210992', 1, 'quas', 'giacomopizziol@example.net');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('1983052604', 'D', '1427210992', 1, 'eligendi', 'fredo23@example.org');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('1739922803', 'C', '1427210992', 2, 'similique', 'zcheda@example.com');
INSERT INTO Classe (IdClasse, Sezione, Scuola, Ordine, TipoScuola, Docente) VALUES ('1729300239', 'n', '1427210992', 1, 'voluptas', 'andreottitonino@example.org');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('iusto', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('explicabo', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('in', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('porro', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('veniam', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('incidunt', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('eveniet', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('a', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('autem', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('vitae', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('beatae', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('placeat', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('necessitatibus', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('maiores', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('quam', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('rem', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('ad', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('libero', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('reprehenderit', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('voluptatum', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('accusantium', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('sed', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('ipsa', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('voluptates', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('saepe', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('officiis', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('fugiat', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('consequuntur', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('facere', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('laboriosam', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('illo', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('repellendus', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('quae', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('repudiandae', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('corrupti', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('odio', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('ea', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('voluptate', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('velit', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('assumenda', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('deleniti', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('unde', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('aliquam', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('soluta', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('molestiae', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('officia', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('consectetur', 'SuoloPreEsistente');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('ullam', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('dolores', 'TerriccioRinvaso');
INSERT INTO Specie (NomeScientifico, Substrato) VALUES ('minima', 'TerriccioRinvaso');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('1781806085', 'cupiditate', '-29.092037', '46.911480', '35.509582406759975', 'Vaso', 'Inquinato', 'fugiat', '6736514978');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9564487507', 'illo', '-16.6502605', '-116.899687', '37.66288934938153', 'Vaso', 'Inquinato', 'molestiae', '7842129378');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('5612573869', 'impedit', '-88.255034', '-84.397638', '63.22492751934654', 'Vaso', 'Inquinato', 'veniam', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('7731133327', 'magnam', '-4.304725', '146.474121', '60.668771835357106', 'Vaso', 'Inquinato', 'ullam', '32374066');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9577956194', 'magni', '-44.789762', '-135.208400', '97.64992520399753', 'Terra', 'Pulito', 'odio', '7137667498');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('6014150702', 'iste', '36.1512895', '-177.100518', '48.376845280560076', 'Terra', 'Pulito', 'reprehenderit', '6736514978');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('6052760964', 'eveniet', '88.335953', '-32.271491', '86.32704477583461', 'Vaso', 'Inquinato', 'minima', '8274908900');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('5813120234', 'repudiandae', '64.3218415', '171.804324', '12.449603535019632', 'Vaso', 'Inquinato', 'corrupti', '1427210992');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('5960627891', 'iusto', '32.1639485', '-14.572108', '10.253984926413434', 'Terra', 'Inquinato', 'rem', '3351290093');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9838184327', 'in', '65.076606', '173.891969', '76.1059719487681', 'Vaso', 'Inquinato', 'reprehenderit', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('8200942476', 'blanditiis', '-23.3933325', '-125.263019', '45.31317840576396', 'Vaso', 'Pulito', 'rem', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('2365125225', 'pariatur', '-31.909458', '80.288765', '24.302976820027123', 'Vaso', 'Inquinato', 'minima', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('8230346608', 'doloribus', '-6.858513', '99.779014', '29.48288558811039', 'Vaso', 'Pulito', 'necessitatibus', '7137667498');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9448327045', 'eaque', '29.357237', '-119.056401', '95.3252058722387', 'Terra', 'Inquinato', 'deleniti', '7137667498');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('7764665518', 'blanditiis', '-89.8239665', '-142.413518', '17.694528181863067', 'Vaso', 'Inquinato', 'voluptate', '7137667498');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('5958202933', 'soluta', '-63.0819965', '70.070774', '19.062218657296494', 'Vaso', 'Inquinato', 'odio', '3351290093');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('6528005576', 'architecto', '64.0192875', '141.278714', '33.20073014283615', 'Terra', 'Pulito', 'quae', '3351290093');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('2448342546', 'laboriosam', '73.5486365', '-119.500488', '55.650448252771874', 'Terra', 'Pulito', 'officia', '7842129378');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('1664294718', 'praesentium', '75.3530405', '-167.777127', '99.57470105411727', 'Vaso', 'Pulito', 'necessitatibus', '8274908900');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('1320725542', 'adipisci', '40.022136', '177.778339', '59.306630030557024', 'Vaso', 'Inquinato', 'quam', '6736514978');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('667418899', 'nam', '34.184460', '73.586931', '8.00223891907923', 'Terra', 'Inquinato', 'ullam', '9973387207');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('1046659705', 'blanditiis', '68.1964475', '-11.848336', '3.850964882720735', 'Terra', 'Pulito', 'reprehenderit', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('4134400828', 'nihil', '77.721013', '145.703940', '82.8926892705917', 'Vaso', 'Inquinato', 'in', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('1529994371', 'vero', '-26.822911', '-76.467980', '58.91389266395113', 'Vaso', 'Pulito', 'ullam', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('6680725246', 'commodi', '74.6374255', '61.956616', '10.471112567638185', 'Terra', 'Inquinato', 'accusantium', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9568845166', 'repellendus', '-31.4020395', '-49.906242', '26.984352094790236', 'Vaso', 'Pulito', 'beatae', '8274908900');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('604765450', 'perspiciatis', '73.3198365', '-118.174895', '31.200759969264393', 'Vaso', 'Inquinato', 'unde', '9973387207');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('5480954304', 'facilis', '-48.825657', '86.910143', '78.97767031137873', 'Terra', 'Pulito', 'autem', '7840277742');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('9264764708', 'ipsum', '-26.3485225', '3.751699', '82.536639998842', 'Vaso', 'Inquinato', 'quam', '9973387207');
INSERT INTO Orto (IdOrto, NomeOrto, Latitudine, Longitudine, Superficie, Posizione, CondizioneAmbientale, Specie, Scuola) VALUES ('6483676145', 'ipsa', '87.9594685', '116.015644', '76.5735038082669', 'Vaso', 'Inquinato', 'soluta', '1427210992');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1211224251', 'harum', 'Biomonitoraggio', '2004-03-24', 'facere', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1899262588', 'atque', 'Fitobotanica', '2015-12-31', 'facere', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3988843802', 'occaecati', 'Fitobotanica', '2009-03-25', 'repudiandae', '8782075526');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7868023009', 'fuga', 'Biomonitoraggio', '1993-08-16', 'libero', '9369114805');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7924711984', 'placeat', 'Fitobotanica', '2010-02-20', 'ad', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2377739686', 'alias', 'Biomonitoraggio', '2017-05-02', 'libero', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8648713075', 'sint', 'Fitobotanica', '2018-04-01', 'ullam', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8820080114', 'occaecati', 'Biomonitoraggio', '2012-04-21', 'minima', '9369114805');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9839021475', 'fuga', 'Biomonitoraggio', '2022-04-02', 'vitae', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5917166963', 'fugit', 'Biomonitoraggio', '2020-12-27', 'voluptates', '5273566922');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4477214218', 'accusantium', 'Fitobotanica', '2022-04-26', 'repudiandae', '9369114805');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4393631951', 'fugiat', 'Fitobotanica', '2003-05-11', 'dolores', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4045647087', 'sed', 'Biomonitoraggio', '1973-10-31', 'ea', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4591214155', 'molestias', 'Biomonitoraggio', '2011-01-11', 'illo', '1983052604');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3814295402', 'odio', 'Fitobotanica', '2010-01-07', 'officiis', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1138461532', 'odit', 'Biomonitoraggio', '1986-06-24', 'consectetur', '8782075526');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2490743947', 'nobis', 'Biomonitoraggio', '1982-02-17', 'beatae', '5273566922');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9209822061', 'enim', 'Biomonitoraggio', '2021-04-17', 'consequuntur', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2012489317', 'laboriosam', 'Fitobotanica', '1992-12-30', 'rem', '1739922803');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4727603148', 'soluta', 'Fitobotanica', '1989-05-15', 'odio', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8273883865', 'iusto', 'Fitobotanica', '1971-11-28', 'necessitatibus', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('964829666', 'dolorem', 'Biomonitoraggio', '2003-02-18', 'assumenda', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5582952932', 'voluptatibus', 'Biomonitoraggio', '1989-04-24', 'facere', '9041357177');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1657308634', 'vero', 'Fitobotanica', '1972-09-05', 'in', '8782075526');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9602709266', 'consequuntur', 'Fitobotanica', '1996-12-10', 'quam', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('485033355', 'accusamus', 'Fitobotanica', '2018-02-02', 'ad', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7815495791', 'pariatur', 'Biomonitoraggio', '2011-10-13', 'voluptates', '8782075526');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9387766532', 'esse', 'Biomonitoraggio', '1979-02-07', 'dolores', '1729300239');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6145397785', 'tenetur', 'Fitobotanica', '2008-02-09', 'vitae', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1822536236', 'nesciunt', 'Fitobotanica', '1976-04-25', 'repudiandae', '1241371775');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1140875029', 'reprehenderit', 'Biomonitoraggio', '1977-09-02', 'ipsa', '1241371775');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9906091612', 'fugiat', 'Fitobotanica', '2000-01-18', 'quam', '7875855536');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('738957259', 'suscipit', 'Fitobotanica', '1974-09-29', 'saepe', '8782075526');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1609613015', 'laudantium', 'Biomonitoraggio', '2010-08-08', 'aliquam', '1983052604');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8862982251', 'aliquam', 'Biomonitoraggio', '1996-07-09', 'ea', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5985688773', 'quam', 'Biomonitoraggio', '1993-01-03', 'odio', '1241371775');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6210321188', 'culpa', 'Fitobotanica', '1996-12-19', 'velit', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1564159057', 'dolorem', 'Fitobotanica', '1981-06-22', 'eveniet', '9369114805');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4360766907', 'nostrum', 'Biomonitoraggio', '2002-08-24', 'iusto', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2252275430', 'labore', 'Fitobotanica', '1984-03-04', 'velit', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1082073776', 'fugit', 'Biomonitoraggio', '1996-09-25', 'libero', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5439683258', 'veritatis', 'Fitobotanica', '2009-03-23', 'quae', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4409400610', 'assumenda', 'Biomonitoraggio', '1987-08-27', 'repellendus', '1739922803');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1967478587', 'explicabo', 'Biomonitoraggio', '1974-04-08', 'autem', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5249447283', 'distinctio', 'Fitobotanica', '1977-09-21', 'saepe', '9041357177');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9679255196', 'natus', 'Biomonitoraggio', '1982-05-29', 'accusantium', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5002642629', 'numquam', 'Biomonitoraggio', '1975-05-31', 'repellendus', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2278907045', 'sit', 'Biomonitoraggio', '2017-03-23', 'voluptates', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9168982553', 'repellendus', 'Fitobotanica', '1996-06-24', 'reprehenderit', '7875855536');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4736366319', 'sapiente', 'Biomonitoraggio', '1984-11-08', 'maiores', '7875855536');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('775475023', 'dolorum', 'Fitobotanica', '1990-08-19', 'dolores', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5905275578', 'earum', 'Biomonitoraggio', '2009-03-15', 'consectetur', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('471343835', 'debitis', 'Fitobotanica', '1996-02-16', 'maiores', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6724687033', 'vel', 'Biomonitoraggio', '2011-12-23', 'quae', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3752420758', 'deleniti', 'Fitobotanica', '1983-05-30', 'libero', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6570983203', 'soluta', 'Biomonitoraggio', '2017-07-12', 'consequuntur', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1348967937', 'odit', 'Biomonitoraggio', '1984-02-29', 'deleniti', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2932757107', 'consequuntur', 'Fitobotanica', '1979-04-07', 'saepe', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6241381121', 'odio', 'Fitobotanica', '2000-09-11', 'voluptatum', '9041357177');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3127706681', 'totam', 'Biomonitoraggio', '1990-11-26', 'beatae', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2263393853', 'ducimus', 'Biomonitoraggio', '1986-11-04', 'soluta', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7312889190', 'repudiandae', 'Fitobotanica', '1971-12-26', 'quae', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9107478942', 'aut', 'Fitobotanica', '1995-05-13', 'deleniti', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7482059811', 'nobis', 'Fitobotanica', '1993-10-06', 'unde', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2098797184', 'nobis', 'Biomonitoraggio', '2002-04-12', 'maiores', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1539875051', 'cum', 'Biomonitoraggio', '1993-05-25', 'in', '1983052604');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1952778255', 'quis', 'Biomonitoraggio', '2019-10-27', 'quam', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7990075707', 'dolor', 'Biomonitoraggio', '2023-02-25', 'saepe', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4415671898', 'fuga', 'Biomonitoraggio', '1992-02-15', 'ad', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8258007319', 'sunt', 'Fitobotanica', '1990-12-25', 'laboriosam', '7875855536');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7352262116', 'repudiandae', 'Biomonitoraggio', '1991-05-21', 'repudiandae', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('443327309', 'vero', 'Fitobotanica', '2017-02-09', 'voluptates', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1309848026', 'consequuntur', 'Biomonitoraggio', '1977-06-17', 'ea', '7875855536');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2971158128', 'vel', 'Fitobotanica', '2014-08-09', 'illo', '8997139989');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5593918413', 'sapiente', 'Biomonitoraggio', '1986-01-11', 'iusto', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8010655700', 'esse', 'Fitobotanica', '2003-08-30', 'repellendus', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4650798289', 'exercitationem', 'Biomonitoraggio', '1983-09-10', 'soluta', '3780356817');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('2464083524', 'veniam', 'Fitobotanica', '1991-09-16', 'unde', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7410739616', 'saepe', 'Fitobotanica', '2002-06-19', 'minima', '1241371775');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1465276735', 'perspiciatis', 'Fitobotanica', '2008-09-29', 'quam', '1739922803');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8936153571', 'cum', 'Fitobotanica', '2006-04-29', 'rem', '1241371775');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3683108197', 'consequuntur', 'Biomonitoraggio', '2010-03-11', 'eveniet', '7457333766');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7885422266', 'sed', 'Fitobotanica', '1982-01-07', 'explicabo', '3078562893');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4589643217', 'quasi', 'Biomonitoraggio', '2020-06-22', 'quae', '1739922803');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8498100589', 'nam', 'Biomonitoraggio', '2019-08-10', 'explicabo', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('148450884', 'incidunt', 'Fitobotanica', '1975-11-23', 'repellendus', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1252729957', 'nihil', 'Biomonitoraggio', '2021-07-10', 'accusantium', '1983052604');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4218014385', 'minima', 'Fitobotanica', '1998-10-22', 'eveniet', '9369114805');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('826645016', 'ratione', 'Fitobotanica', '2014-08-01', 'quae', '5074440098');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('4587110805', 'odit', 'Biomonitoraggio', '1974-11-21', 'illo', '3780356817');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('430555039', 'laudantium', 'Fitobotanica', '1996-04-12', 'quae', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5706417250', 'labore', 'Biomonitoraggio', '2006-11-09', 'saepe', '1532292613');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('9250479946', 'placeat', 'Fitobotanica', '1983-11-21', 'ullam', '6900148646');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('7138297837', 'unde', 'Biomonitoraggio', '2007-04-06', 'explicabo', '8997139989');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('1942890727', 'suscipit', 'Fitobotanica', '2020-07-25', 'porro', '4945605917');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('5783269948', 'exercitationem', 'Fitobotanica', '1994-05-27', 'accusantium', '6511426933');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8604671090', 'debitis', 'Biomonitoraggio', '1993-03-28', 'in', '8997139989');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('8335728026', 'tenetur', 'Biomonitoraggio', '1990-04-30', 'autem', '3780356817');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('3217065390', 'saepe', 'Fitobotanica', '1993-09-10', 'iusto', '6002562545');
INSERT INTO Pianta (NumeroReplica, NomeComune, Scopo, DataMessaDimora, Specie, Classe) VALUES ('6622805263', 'repellendus', 'Biomonitoraggio', '2018-06-11', 'libero', '1241371775');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1211224251', 'harum', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1899262588', 'atque', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3988843802', 'occaecati', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7868023009', 'fuga', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7924711984', 'placeat', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2377739686', 'alias', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8648713075', 'sint', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8820080114', 'occaecati', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9839021475', 'fuga', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5917166963', 'fugit', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4477214218', 'accusantium', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4393631951', 'fugiat', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4045647087', 'sed', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4591214155', 'molestias', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3814295402', 'odio', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1138461532', 'odit', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2490743947', 'nobis', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9209822061', 'enim', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2012489317', 'laboriosam', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4727603148', 'soluta', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8273883865', 'iusto', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('964829666', 'dolorem', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5582952932', 'voluptatibus', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1657308634', 'vero', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9602709266', 'consequuntur', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('485033355', 'accusamus', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7815495791', 'pariatur', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9387766532', 'esse', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6145397785', 'tenetur', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1822536236', 'nesciunt', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1140875029', 'reprehenderit', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9906091612', 'fugiat', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('738957259', 'suscipit', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1609613015', 'laudantium', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8862982251', 'aliquam', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5985688773', 'quam', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6210321188', 'culpa', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1564159057', 'dolorem', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4360766907', 'nostrum', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2252275430', 'labore', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1082073776', 'fugit', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5439683258', 'veritatis', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4409400610', 'assumenda', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1967478587', 'explicabo', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5249447283', 'distinctio', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9679255196', 'natus', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5002642629', 'numquam', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2278907045', 'sit', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9168982553', 'repellendus', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4736366319', 'sapiente', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('775475023', 'dolorum', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5905275578', 'earum', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('471343835', 'debitis', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6724687033', 'vel', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3752420758', 'deleniti', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6570983203', 'soluta', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1348967937', 'odit', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2932757107', 'consequuntur', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6241381121', 'odio', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3127706681', 'totam', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2263393853', 'ducimus', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7312889190', 'repudiandae', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9107478942', 'aut', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7482059811', 'nobis', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2098797184', 'nobis', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1539875051', 'cum', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1952778255', 'quis', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7990075707', 'dolor', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4415671898', 'fuga', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8258007319', 'sunt', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7352262116', 'repudiandae', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('443327309', 'vero', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1309848026', 'consequuntur', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2971158128', 'vel', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5593918413', 'sapiente', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8010655700', 'esse', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4650798289', 'exercitationem', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('2464083524', 'veniam', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7410739616', 'saepe', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1465276735', 'perspiciatis', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8936153571', 'cum', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3683108197', 'consequuntur', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7885422266', 'sed', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4589643217', 'quasi', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8498100589', 'nam', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('148450884', 'incidunt', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1252729957', 'nihil', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4218014385', 'minima', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('826645016', 'ratione', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('4587110805', 'odit', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('430555039', 'laudantium', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5706417250', 'labore', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('9250479946', 'placeat', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('7138297837', 'unde', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('1942890727', 'suscipit', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('5783269948', 'exercitationem', 'Mezzombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8604671090', 'debitis', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('8335728026', 'tenetur', 'Ombra');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('3217065390', 'saepe', 'Sole');
INSERT INTO Esposizione (NumeroReplica, NomeComune, TipoEsposizione) VALUES ('6622805263', 'repellendus', 'Sole');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (64, 'Monitoraggio', '1211224251', 'harum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (88, 'Controllo', '1899262588', 'atque');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (73, 'Controllo', '3988843802', 'occaecati');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (34, 'Controllo', '7868023009', 'fuga');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (9, 'Monitoraggio', '7924711984', 'placeat');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (57, 'Controllo', '2377739686', 'alias');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (12, 'Monitoraggio', '8648713075', 'sint');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (62, 'Monitoraggio', '8820080114', 'occaecati');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (96, 'Monitoraggio', '9839021475', 'fuga');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (21, 'Monitoraggio', '5917166963', 'fugit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (83, 'Monitoraggio', '4477214218', 'accusantium');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (56, 'Monitoraggio', '4393631951', 'fugiat');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (36, 'Controllo', '4045647087', 'sed');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (77, 'Controllo', '4591214155', 'molestias');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (99, 'Controllo', '3814295402', 'odio');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (57, 'Controllo', '1138461532', 'odit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (72, 'Controllo', '2490743947', 'nobis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (76, 'Controllo', '9209822061', 'enim');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (32, 'Controllo', '2012489317', 'laboriosam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (84, 'Monitoraggio', '4727603148', 'soluta');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (27, 'Controllo', '8273883865', 'iusto');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (11, 'Controllo', '964829666', 'dolorem');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (78, 'Monitoraggio', '5582952932', 'voluptatibus');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (83, 'Monitoraggio', '1657308634', 'vero');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (35, 'Monitoraggio', '9602709266', 'consequuntur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (2, 'Controllo', '485033355', 'accusamus');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (57, 'Controllo', '7815495791', 'pariatur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (99, 'Monitoraggio', '9387766532', 'esse');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (57, 'Monitoraggio', '6145397785', 'tenetur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (43, 'Monitoraggio', '1822536236', 'nesciunt');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (38, 'Controllo', '1140875029', 'reprehenderit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (46, 'Monitoraggio', '9906091612', 'fugiat');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (73, 'Controllo', '738957259', 'suscipit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (15, 'Monitoraggio', '1609613015', 'laudantium');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (28, 'Controllo', '8862982251', 'aliquam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (32, 'Controllo', '5985688773', 'quam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (20, 'Controllo', '6210321188', 'culpa');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (70, 'Controllo', '1564159057', 'dolorem');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (89, 'Controllo', '4360766907', 'nostrum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (28, 'Controllo', '2252275430', 'labore');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (80, 'Controllo', '1082073776', 'fugit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (76, 'Controllo', '5439683258', 'veritatis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (60, 'Monitoraggio', '4409400610', 'assumenda');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (1, 'Monitoraggio', '1967478587', 'explicabo');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (41, 'Monitoraggio', '5249447283', 'distinctio');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (23, 'Controllo', '9679255196', 'natus');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (91, 'Controllo', '5002642629', 'numquam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (5, 'Monitoraggio', '2278907045', 'sit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (21, 'Monitoraggio', '9168982553', 'repellendus');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (22, 'Controllo', '4736366319', 'sapiente');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (34, 'Monitoraggio', '775475023', 'dolorum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (38, 'Controllo', '5905275578', 'earum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (56, 'Controllo', '471343835', 'debitis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (19, 'Monitoraggio', '6724687033', 'vel');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (80, 'Monitoraggio', '3752420758', 'deleniti');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (33, 'Controllo', '6570983203', 'soluta');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (26, 'Monitoraggio', '1348967937', 'odit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (95, 'Monitoraggio', '2932757107', 'consequuntur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (82, 'Monitoraggio', '6241381121', 'odio');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (78, 'Monitoraggio', '3127706681', 'totam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (26, 'Monitoraggio', '2263393853', 'ducimus');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (9, 'Monitoraggio', '7312889190', 'repudiandae');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (60, 'Monitoraggio', '9107478942', 'aut');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (47, 'Controllo', '7482059811', 'nobis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (96, 'Controllo', '2098797184', 'nobis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (49, 'Monitoraggio', '1539875051', 'cum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (21, 'Controllo', '1952778255', 'quis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (63, 'Monitoraggio', '7990075707', 'dolor');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (26, 'Monitoraggio', '4415671898', 'fuga');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (94, 'Monitoraggio', '8258007319', 'sunt');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (83, 'Controllo', '7352262116', 'repudiandae');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (8, 'Monitoraggio', '443327309', 'vero');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (82, 'Controllo', '1309848026', 'consequuntur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (68, 'Monitoraggio', '2971158128', 'vel');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (92, 'Controllo', '5593918413', 'sapiente');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (72, 'Monitoraggio', '8010655700', 'esse');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (68, 'Controllo', '4650798289', 'exercitationem');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (6, 'Monitoraggio', '2464083524', 'veniam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (42, 'Monitoraggio', '7410739616', 'saepe');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (53, 'Controllo', '1465276735', 'perspiciatis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (36, 'Monitoraggio', '8936153571', 'cum');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (78, 'Monitoraggio', '3683108197', 'consequuntur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (64, 'Controllo', '7885422266', 'sed');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (51, 'Controllo', '4589643217', 'quasi');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (68, 'Controllo', '8498100589', 'nam');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (8, 'Monitoraggio', '148450884', 'incidunt');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (35, 'Monitoraggio', '1252729957', 'nihil');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (93, 'Monitoraggio', '4218014385', 'minima');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (28, 'Controllo', '826645016', 'ratione');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (12, 'Monitoraggio', '4587110805', 'odit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (27, 'Controllo', '430555039', 'laudantium');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (99, 'Monitoraggio', '5706417250', 'labore');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (56, 'Controllo', '9250479946', 'placeat');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (96, 'Monitoraggio', '7138297837', 'unde');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (41, 'Monitoraggio', '1942890727', 'suscipit');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (74, 'Monitoraggio', '5783269948', 'exercitationem');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (58, 'Monitoraggio', '8604671090', 'debitis');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (65, 'Monitoraggio', '8335728026', 'tenetur');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (30, 'Monitoraggio', '3217065390', 'saepe');
INSERT INTO Gruppo (IdGruppo, TipoGruppo, NumeroReplica, NomeComune) VALUES (44, 'Monitoraggio', '6622805263', 'repellendus');
INSERT INTO Sensore (IdSensore, TipoSensore, TipoAcquisizione) VALUES (1, 'Arduino', 'App');
INSERT INTO Sensore (IdSensore, TipoSensore, TipoAcquisizione) VALUES (2, 'Arduino', 'App');
INSERT INTO Sensore (IdSensore, TipoSensore, TipoAcquisizione) VALUES (3, 'Sensore', 'App');
INSERT INTO Sensore (IdSensore, TipoSensore, TipoAcquisizione) VALUES (4, 'Sensore', 'App');
INSERT INTO Sensore (IdSensore, TipoSensore, TipoAcquisizione) VALUES (5, 'Arduino', 'App');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (1, '1211224251', 'harum', '2023-03-25 23:35:14', '2023-06-15 16:01:09', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (2, '1899262588', 'atque', '2021-10-12 22:24:21', '2022-10-11 04:57:58', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (3, '3988843802', 'occaecati', '2023-05-05 04:56:23', '2023-05-05 12:59:09', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (4, '7868023009', 'fuga', '2020-07-07 05:39:54', '2020-10-11 05:24:52', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (5, '7924711984', 'placeat', '2022-08-14 17:28:22', '2023-07-06 15:20:02', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (6, '2377739686', 'alias', '2020-10-22 13:07:50', '2022-11-28 13:38:29', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (7, '8648713075', 'sint', '2020-09-05 22:52:28', '2023-07-05 16:21:59', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (8, '8820080114', 'occaecati', '2020-09-11 02:10:24', '2021-09-29 22:51:20', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (9, '9839021475', 'fuga', '2022-02-14 01:34:12', '2022-04-14 17:40:00', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (10, '5917166963', 'fugit', '2021-07-22 00:09:46', '2023-02-17 19:11:00', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (11, '4477214218', 'accusantium', '2022-08-19 09:04:15', '2023-07-05 18:49:35', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (12, '4393631951', 'fugiat', '2023-04-01 14:49:03', '2023-07-09 11:05:07', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (13, '4045647087', 'sed', '2021-04-29 04:37:45', '2022-05-23 19:53:04', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (14, '4591214155', 'molestias', '2022-03-19 02:04:59', '2023-06-28 06:48:36', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (15, '3814295402', 'odio', '2022-04-09 01:37:57', '2022-05-23 20:48:47', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (16, '1138461532', 'odit', '2021-09-16 02:09:38', '2021-11-12 11:14:37', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (17, '2490743947', 'nobis', '2021-08-06 11:42:29', '2022-08-07 23:12:22', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (18, '9209822061', 'enim', '2021-09-14 13:46:04', '2022-04-02 01:07:49', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (19, '2012489317', 'laboriosam', '2022-04-16 23:34:15', '2023-06-29 10:45:25', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (20, '4727603148', 'soluta', '2020-06-02 06:58:30', '2023-03-11 09:39:01', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (21, '8273883865', 'iusto', '2023-04-01 01:37:04', '2023-04-28 21:01:38', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (22, '964829666', 'dolorem', '2020-12-05 17:27:32', '2021-12-04 03:26:05', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (23, '5582952932', 'voluptatibus', '2021-10-24 14:38:18', '2022-10-28 10:28:46', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (24, '1657308634', 'vero', '2020-07-06 05:16:24', '2021-01-28 04:31:10', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (25, '9602709266', 'consequuntur', '2022-07-31 08:28:32', '2022-08-01 17:39:49', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (26, '485033355', 'accusamus', '2021-08-24 21:59:12', '2022-03-14 14:20:34', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (27, '7815495791', 'pariatur', '2022-04-02 08:36:01', '2022-05-19 17:05:35', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (28, '9387766532', 'esse', '2021-07-09 21:50:46', '2022-11-11 20:37:05', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (29, '6145397785', 'tenetur', '2021-01-17 07:16:19', '2022-03-18 10:33:37', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (30, '1822536236', 'nesciunt', '2021-03-26 04:01:18', '2021-07-12 15:07:00', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (31, '1140875029', 'reprehenderit', '2021-12-11 15:38:10', '2023-05-04 15:01:40', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (32, '9906091612', 'fugiat', '2022-09-27 13:44:09', '2023-02-17 08:29:37', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (33, '738957259', 'suscipit', '2022-03-15 04:18:49', '2023-04-12 15:30:31', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (34, '1609613015', 'laudantium', '2021-04-05 10:33:11', '2022-09-15 17:17:51', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (35, '8862982251', 'aliquam', '2020-08-28 09:40:31', '2021-09-05 19:28:53', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (36, '5985688773', 'quam', '2022-02-25 08:40:17', '2022-06-25 21:52:37', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (37, '6210321188', 'culpa', '2022-06-22 06:15:07', '2022-11-30 07:16:27', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (38, '1564159057', 'dolorem', '2021-06-02 09:24:33', '2023-02-18 11:43:53', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (39, '4360766907', 'nostrum', '2021-06-01 02:00:56', '2022-06-14 08:44:53', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (40, '2252275430', 'labore', '2022-04-18 06:36:59', '2023-01-21 11:21:18', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (41, '1082073776', 'fugit', '2021-01-19 07:29:15', '2023-04-26 20:45:55', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (42, '5439683258', 'veritatis', '2021-04-06 05:51:17', '2021-11-11 02:53:32', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (43, '4409400610', 'assumenda', '2021-02-19 18:11:45', '2022-03-21 06:03:03', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (44, '1967478587', 'explicabo', '2021-05-25 09:32:16', '2021-10-09 12:13:43', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (45, '5249447283', 'distinctio', '2021-06-15 01:44:56', '2022-08-24 13:26:03', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (46, '9679255196', 'natus', '2022-01-28 14:05:53', '2023-06-16 09:36:58', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (47, '5002642629', 'numquam', '2020-02-12 14:42:07', '2021-12-22 21:26:43', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (48, '2278907045', 'sit', '2020-12-27 00:25:44', '2023-05-31 15:20:13', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (49, '9168982553', 'repellendus', '2023-02-20 15:33:50', '2023-04-30 12:36:34', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (50, '4736366319', 'sapiente', '2021-09-15 05:32:30', '2022-06-02 20:00:29', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (51, '775475023', 'dolorum', '2023-03-24 14:50:50', '2023-07-05 01:51:33', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (52, '5905275578', 'earum', '2021-08-30 19:22:04', '2022-06-24 00:37:20', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (53, '471343835', 'debitis', '2023-06-09 00:56:56', '2023-06-14 19:19:51', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (54, '6724687033', 'vel', '2021-10-23 23:15:39', '2023-07-10 04:27:30', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (55, '3752420758', 'deleniti', '2022-12-22 11:19:57', '2023-01-31 06:13:21', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (56, '6570983203', 'soluta', '2022-08-24 17:13:10', '2023-01-02 03:15:47', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (57, '1348967937', 'odit', '2021-04-18 21:14:05', '2021-10-20 16:24:19', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (58, '2932757107', 'consequuntur', '2021-04-18 17:23:51', '2021-06-11 05:39:44', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (59, '6241381121', 'odio', '2020-06-13 21:56:55', '2023-06-02 11:24:01', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (60, '3127706681', 'totam', '2020-05-28 14:12:46', '2021-07-17 18:48:56', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (61, '2263393853', 'ducimus', '2020-11-22 14:47:07', '2023-04-07 07:20:50', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (62, '7312889190', 'repudiandae', '2023-02-22 19:48:41', '2023-02-24 17:03:35', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (63, '9107478942', 'aut', '2022-08-19 13:32:21', '2022-09-28 13:14:45', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (64, '7482059811', 'nobis', '2021-10-12 11:17:20', '2021-12-04 03:52:33', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (65, '2098797184', 'nobis', '2021-04-15 09:50:09', '2022-05-20 04:27:39', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (66, '1539875051', 'cum', '2022-06-17 02:47:54', '2023-03-02 03:32:20', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (67, '1952778255', 'quis', '2020-05-18 23:57:59', '2020-08-21 06:42:46', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (68, '7990075707', 'dolor', '2022-02-11 17:04:33', '2023-03-07 07:07:33', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (69, '4415671898', 'fuga', '2022-12-28 13:15:44', '2023-04-02 02:56:26', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (70, '8258007319', 'sunt', '2023-03-14 05:50:04', '2023-05-03 15:10:46', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (71, '7352262116', 'repudiandae', '2020-04-17 06:01:58', '2021-09-04 03:01:57', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (72, '443327309', 'vero', '2021-02-05 03:35:18', '2022-09-22 01:20:17', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (73, '1309848026', 'consequuntur', '2020-10-12 06:00:58', '2021-08-02 04:12:53', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (74, '2971158128', 'vel', '2023-03-25 19:14:36', '2023-07-05 11:32:46', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (75, '5593918413', 'sapiente', '2022-03-16 19:27:09', '2023-05-12 13:37:01', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (76, '8010655700', 'esse', '2022-06-14 00:42:28', '2022-07-01 10:47:00', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (77, '4650798289', 'exercitationem', '2022-05-07 17:02:51', '2023-01-13 16:16:42', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (78, '2464083524', 'veniam', '2022-03-31 20:44:53', '2023-06-04 03:12:23', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (79, '7410739616', 'saepe', '2020-10-10 19:08:55', '2023-04-05 21:05:01', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (80, '1465276735', 'perspiciatis', '2022-07-05 18:16:28', '2022-08-05 16:28:18', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (81, '8936153571', 'cum', '2021-01-30 02:24:31', '2022-03-19 21:31:07', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (82, '3683108197', 'consequuntur', '2021-03-14 02:35:04', '2023-03-29 00:39:58', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (83, '7885422266', 'sed', '2022-03-15 09:07:25', '2022-07-10 04:52:26', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (84, '4589643217', 'quasi', '2022-12-16 06:08:37', '2023-05-11 20:55:58', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (85, '8498100589', 'nam', '2023-02-06 15:06:59', '2023-05-15 22:00:59', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (86, '148450884', 'incidunt', '2021-03-29 14:09:53', '2022-06-20 04:36:15', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (87, '1252729957', 'nihil', '2020-12-01 07:20:53', '2021-07-10 02:26:35', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (88, '4218014385', 'minima', '2023-04-09 16:05:38', '2023-04-21 06:11:23', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (89, '826645016', 'ratione', '2022-01-14 02:39:54', '2022-08-13 19:25:11', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (90, '4587110805', 'odit', '2021-10-03 23:36:33', '2022-03-17 15:30:12', '2');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (91, '430555039', 'laudantium', '2020-09-03 03:48:28', '2021-03-05 10:43:13', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (92, '5706417250', 'labore', '2021-07-17 18:40:46', '2023-04-25 16:06:15', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (93, '9250479946', 'placeat', '2021-05-16 02:15:39', '2022-07-31 14:10:13', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (94, '7138297837', 'unde', '2021-11-11 15:16:32', '2022-10-24 21:58:54', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (95, '1942890727', 'suscipit', '2021-05-05 20:12:10', '2023-01-20 05:53:01', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (96, '5783269948', 'exercitationem', '2022-01-13 17:46:40', '2022-10-24 05:28:01', '3');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (97, '8604671090', 'debitis', '2021-10-07 00:21:45', '2023-02-02 01:53:45', '4');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (98, '8335728026', 'tenetur', '2021-08-22 07:05:43', '2022-07-31 01:53:34', '5');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (99, '3217065390', 'saepe', '2021-02-21 07:14:57', '2022-08-13 16:35:42', '1');
INSERT INTO Rilevazione (IdRilevazione, NumeroReplica, NomeComune, DataOraRilevazione, DataOraInserimento, Sensore) VALUES (100, '6622805263', 'repellendus', '2020-01-17 15:43:54', '2021-02-17 22:39:47', '5');
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('1', 19.03721423175101, 35.91344826381545, 6.00542984685665, 3, 57.43428858916181, 3, 29, 179.53495121033654, 99.35192637311205);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('2', 10.742059791589881, 59.48030660487413, 5.636110696985144, 4, 55.41589228144607, 0, 45, 58.552203669366435, 185.56310477210897);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('3', 11.488259054241038, 69.42543424685753, 7.48085470446906, 6, 58.19707495639206, 2, 17, 186.0098454165645, 192.57519313218876);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('4', 26.708901016460416, 34.99484963994088, 6.133765526378406, 8, 26.9818840729969, 11, 1, 139.18468033006062, 94.29485696473476);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('5', 14.446719099415919, 47.702110177426654, 5.576975271850328, 9, 79.79086517628144, 2, 6, 95.18399051847382, 89.62038677586362);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('6', 11.420234201940026, 50.24497040426476, 5.222883735442137, 10, 93.93088635569504, 1, 46, 49.791488132784636, 188.09017630447502);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('7', 15.277450402918353, 49.18301046783762, 5.570806720898711, 1, 10.972010832050094, 8, 17, 116.80495413139604, 56.00169486222529);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('8', 29.63607631569821, 77.0112335039509, 6.632892209579935, 1, 27.021895428026454, 10, 9, 110.20500665288223, 40.04661002639053);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('9', 29.05939780504896, 57.23071967413056, 5.334535422780454, 6, 47.54821887315512, 13, 46, 124.75853865380006, 52.97738073842775);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('10', 14.590391062818295, 74.24087207352454, 5.198605817969433, 10, 72.03248531382451, 5, 26, 147.18176911984517, 31.988143161224816);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('11', 16.16118381797083, 50.408245901677674, 6.426913816168841, 10, 0.20603995987446, 3, 29, 182.50662156760876, 13.964542687660597);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('12', 16.532291426335398, 76.9902476776181, 7.970431388754282, 4, 61.351139737556004, 20, 7, 181.38880735827712, 126.82008452198954);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('13', 15.973798248472821, 43.70906920319925, 5.565328780604671, 10, 34.36136575951583, 8, 39, 10.98753395750669, 135.06413468915343);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('14', 15.663471798021423, 50.29290312497456, 7.591781845214873, 1, 24.13839444395476, 18, 32, 146.06740738938123, 113.23260962310869);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('15', 22.263059447447727, 35.03934523057499, 6.7481299699872554, 4, 4.759606516294824, 12, 36, 56.58824100268301, 99.45586361175069);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('16', 23.92678697070334, 33.648619699706536, 6.274737192222213, 0, 48.28094084584684, 12, 11, 21.911050577907467, 77.15007890897327);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('17', 18.4868966214241, 48.06385947616093, 6.104581116635318, 0, 81.98668658835098, 9, 28, 24.17633016140023, 86.85912610120909);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('18', 15.6577195508996, 38.33733110323153, 6.967959360962874, 3, 75.68723817689047, 18, 50, 188.83689440585587, 78.03178296833867);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('19', 25.925808935356986, 62.43183584023113, 7.281842245760503, 10, 81.78426022021203, 4, 43, 39.279727299810936, 174.60067263751517);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('20', 16.21621962209012, 64.18399456174859, 5.09080844589297, 5, 79.08522882549013, 7, 37, 15.699730279156295, 105.85849021422885);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('21', 23.883314827751065, 40.197045126880234, 7.148055467620615, 3, 11.7854390898675, 11, 36, 175.76794265723956, 73.72076408723791);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('22', 15.801608726879952, 51.820233758925205, 7.048316140735867, 6, 51.83936557941982, 8, 5, 107.48673120616354, 22.60249953510257);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('23', 26.03530156321376, 33.137020360731626, 5.723892579557232, 5, 90.60287983968173, 13, 43, 36.02619006323788, 197.15807872571403);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('24', 28.396358930550953, 45.25166237836607, 7.116681685353398, 3, 23.594937168567355, 5, 48, 42.40432008537414, 16.499281004658016);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('25', 11.19792284486519, 54.69991249977385, 6.791565741388231, 3, 28.36763363608795, 5, 47, 141.60895089223334, 90.9976525134097);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('26', 17.775620697914917, 66.33969621146392, 6.088001448626997, 10, 74.0403164158018, 5, 7, 120.93884889553028, 190.7682154604387);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('27', 26.398429576883775, 35.149967631381095, 5.7612945846194945, 9, 18.788167898073993, 15, 48, 26.318757223952343, 39.591950453834365);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('28', 29.973446782014324, 47.17345744945932, 5.042034268972566, 0, 14.473653685787335, 18, 18, 63.19681332599751, 190.09498038146464);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('29', 29.44280108177411, 60.117570036979686, 6.697110174214009, 2, 56.73890384561645, 2, 33, 105.92842096869306, 90.06371059328276);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('30', 23.560406108113725, 64.99873884088403, 6.954354273565182, 3, 98.32273851327618, 20, 12, 36.85518509896062, 173.36701420550872);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('31', 26.458222493082907, 62.9984774787922, 7.740723760099398, 9, 49.658040767969695, 18, 41, 38.98878600500586, 87.33427213813117);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('32', 23.457094416446292, 41.99818351619957, 6.7688346163022155, 1, 32.78571014554469, 3, 42, 61.5965478467823, 86.5460065264009);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('33', 18.168167942562373, 64.06506061842893, 7.506628901446263, 2, 42.99165121042125, 3, 22, 100.11744208574015, 56.3880731210242);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('34', 18.35238666173197, 67.65085725477243, 5.6857294568985095, 7, 66.85525682883699, 14, 27, 66.59911658076308, 31.326862767713862);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('35', 20.38095250518533, 51.50239812244915, 7.230054202350697, 2, 44.05749331258553, 10, 21, 132.93621583292764, 76.55699269226812);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('36', 28.8181228169238, 72.47430895840182, 7.349901784281926, 0, 15.13078477023414, 15, 4, 147.9626508544574, 91.96752806568801);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('37', 16.109605928247234, 43.830046792582735, 6.733165670099317, 0, 63.14956562891659, 16, 49, 159.5614427534265, 136.22279219150928);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('38', 28.258729405990756, 67.35252770999934, 5.78182086208534, 5, 23.505637132245806, 0, 45, 54.91514664855579, 24.521937087087696);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('39', 16.323277086046936, 50.42792593658372, 5.488406659127983, 4, 43.03865558845437, 15, 12, 191.71826897664855, 140.4689427404818);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('40', 22.010297530021887, 44.91267348803096, 6.325717363550624, 7, 9.100158959675452, 4, 11, 97.713838925431, 115.90219320640335);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('41', 16.742844820806184, 47.95796411962267, 5.3092097316352955, 2, 96.5974041053292, 9, 29, 161.15465505078438, 74.9584092708952);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('42', 10.975152778326136, 71.20224334201887, 6.916287678989937, 2, 54.99600129763914, 9, 26, 82.64901227175989, 87.41462939406827);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('43', 10.797664379057002, 78.5616870870819, 5.84343038691885, 8, 25.128708958640587, 20, 2, 99.15059581169697, 75.31040139950207);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('44', 15.325752680455114, 39.62062367446539, 7.037117530651001, 6, 12.568128874367124, 0, 39, 146.09513284693296, 86.47650141047988);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('45', 16.502849702225163, 52.59884187499186, 7.008298450797213, 4, 21.959705401559017, 19, 14, 116.74419025468583, 79.73451113014131);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('46', 10.060999256561258, 56.35361708899729, 6.95368239956032, 2, 36.63000848958755, 20, 10, 77.60652850690727, 17.003324982055577);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('47', 11.057417369932491, 58.09397551940555, 7.668379510330901, 3, 2.862044942818487, 18, 37, 172.74067651979223, 36.33923517746673);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('48', 10.333754917094177, 73.35018233028879, 5.377109213303166, 4, 38.564750805731286, 2, 45, 67.11374481530196, 170.79378919906367);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('49', 20.712190853736267, 61.14777048746754, 5.897973906005537, 1, 99.3107878269457, 20, 9, 153.48342649790297, 83.64832684471702);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('50', 22.669446134173924, 55.976857867248654, 7.847476911718429, 3, 69.86760692992537, 20, 37, 162.91738947245258, 71.905908098234);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('51', 20.318761868594265, 56.534028284105034, 6.5984547325533836, 7, 79.46524250055899, 7, 16, 48.670736607973716, 120.23087753133817);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('52', 14.998721980098097, 65.31869745596796, 6.362794823541935, 2, 41.892777869663725, 18, 42, 179.00435859225405, 179.7547105706206);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('53', 24.261335821104957, 51.60607629579472, 5.191652753692519, 1, 24.599464104860413, 1, 42, 126.42435900313197, 195.1965279873456);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('54', 26.385570790902428, 51.56327707365871, 6.5953438446852655, 9, 76.31921186346601, 12, 26, 143.2731038131198, 93.11987482030308);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('55', 16.938764358813465, 36.3133958710375, 7.476008458057555, 4, 39.098792939019035, 9, 9, 190.20658458274963, 110.5964864927775);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('56', 19.017805031968294, 45.92301450616976, 6.119732146184336, 10, 17.244128169342222, 11, 47, 43.704526930212864, 171.4069493374989);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('57', 15.130806085125759, 54.78114157761695, 6.669638482861977, 4, 81.07262268730878, 18, 32, 122.1453229489971, 167.5760790209378);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('58', 27.98888307370647, 76.67046084000353, 6.823907915116335, 7, 5.893244895732808, 8, 41, 143.5941087188213, 27.720102700866406);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('59', 23.066830269874636, 34.435952319132525, 6.8984992050278064, 0, 82.40430027629444, 9, 13, 135.6166090104411, 191.19682256849174);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('60', 14.417340905047872, 44.387416703298, 5.394107769848358, 9, 65.58041191448604, 3, 20, 44.89301185210045, 17.39377780559436);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('61', 24.022605667549282, 36.145170930988705, 7.8358031644615735, 1, 1.3773588865792608, 13, 6, 191.09349616995132, 158.02023915221864);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('62', 13.907737773316395, 53.00905409247384, 5.354724435204278, 0, 3.5835533138938613, 2, 26, 94.84936912856863, 37.596429018794495);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('63', 14.402795746399978, 58.33779752228219, 5.282289764117788, 7, 5.278966904083493, 1, 35, 125.45087801975964, 161.82056678366325);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('64', 11.349806481803297, 36.289610228633954, 6.4625234699130205, 6, 6.6889847150777175, 10, 40, 152.95926378847082, 29.846714903312893);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('65', 10.56156050381578, 33.31294590994041, 6.492631322091327, 5, 60.904426648225574, 5, 35, 62.77470480909807, 33.62952157259764);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('66', 24.736014749310655, 53.12499979840515, 7.416650320195533, 2, 6.16574664495233, 2, 20, 17.722536356906577, 40.00507554908626);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('67', 15.221542874665959, 57.81518607396539, 5.775974241642327, 6, 98.7317561232891, 16, 48, 29.22200277071959, 64.91017870022604);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('68', 24.94023887480263, 55.367161848487136, 5.933569169089089, 5, 52.124119888536335, 1, 9, 97.70213330656259, 12.149550338786781);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('69', 24.636517767434945, 48.04542242363369, 5.648584934555977, 2, 56.17219317274914, 3, 15, 71.93671319539773, 66.78880474711399);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('70', 26.72061354115388, 72.41208478033056, 6.300655118739439, 3, 34.777626081723824, 17, 15, 170.20280813523152, 67.7075133642274);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('71', 28.690089756018736, 60.13995371227962, 6.201437774322958, 8, 46.082684622297364, 3, 12, 156.01098871824897, 57.133568019628264);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('72', 21.63313273499468, 76.95920771939166, 7.997745307375306, 1, 65.66834583042234, 18, 49, 102.16360649636428, 183.52287149145582);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('73', 14.53217651714775, 39.647571142978194, 6.8138902520672175, 9, 82.18637213314662, 4, 26, 103.80238697762292, 145.00255612965054);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('74', 11.563570385049758, 76.40118447994757, 7.436622504646365, 7, 9.273172354716742, 15, 25, 181.57848075705257, 122.27222614270298);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('75', 16.11235184351987, 67.40220201434418, 7.932303276436016, 10, 78.6397119763044, 10, 18, 140.99154515738792, 150.87834650220756);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('76', 16.85634073804859, 76.76720565933121, 7.471118809624998, 0, 33.248491852116736, 7, 34, 177.88143023112275, 51.48742393120339);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('77', 25.230604931532806, 51.530860444005995, 7.864165626706308, 1, 52.49681833058184, 12, 11, 147.91172681232777, 172.15101939499064);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('78', 18.319843585004477, 37.60375803868504, 7.767108946748136, 8, 23.568448581068267, 1, 45, 28.117557881824347, 120.59057716014458);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('79', 17.94861221097829, 56.843497947941856, 5.023197341664366, 8, 6.325617109637194, 20, 8, 116.35167603549249, 75.25204232375954);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('80', 27.5249473899293, 38.84237026303437, 7.408954048287385, 9, 12.650973051509196, 19, 6, 87.52076938804916, 110.71661247389846);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('81', 14.852411900976016, 39.16264629027945, 5.178891119476943, 10, 88.06058281324172, 15, 38, 123.34972370484728, 108.7441405833007);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('82', 22.39070648947035, 68.33074438213026, 5.166980477366671, 8, 0.5028653838382913, 20, 12, 30.079783696770097, 62.02274969443449);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('83', 23.813564767569574, 67.6856254696041, 5.511260725221689, 6, 38.177159176951115, 11, 25, 185.48025099402176, 63.701916555958206);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('84', 15.347276282701223, 44.17194332167279, 6.095053943973097, 4, 95.38682446231603, 10, 34, 126.10942545114223, 148.91969359621723);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('85', 20.654636390326925, 45.9872283993749, 5.481612584078721, 8, 16.915785584050813, 15, 36, 183.0937307726988, 82.5481786575725);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('86', 15.73705451030525, 79.01806190990013, 7.309928097368042, 5, 17.194243389686616, 7, 12, 98.83235150674233, 112.05010709460444);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('87', 12.712669142434795, 75.65414820715407, 6.234157692178387, 3, 41.88104760557753, 13, 0, 54.321950057365406, 186.2673034246647);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('88', 29.660352296758173, 42.16557027202377, 6.296553542493952, 10, 79.44768491067242, 16, 15, 72.17189032435465, 123.97694186416828);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('89', 28.827318718576073, 54.129082840974945, 6.234944992748876, 0, 19.522180202079078, 4, 16, 23.606594837658474, 165.76967408723854);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('90', 24.233584073993253, 66.88136601971576, 6.633165774840551, 2, 98.20707211245393, 6, 43, 158.1470244181369, 103.39456327535247);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('91', 17.15390377629211, 54.54056045702258, 5.707310770999972, 2, 73.8278434958831, 16, 7, 163.01356225545067, 50.892733442262006);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('92', 11.60553066913186, 47.73029217597799, 7.291039329594067, 3, 61.335332072867764, 8, 21, 166.79497779035734, 147.76986935576912);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('93', 16.452407366232173, 61.87459205875602, 6.47331108413047, 5, 16.496385614678555, 20, 34, 165.45282089496666, 42.36045343768094);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('94', 17.999324389773182, 61.36933742166396, 7.0424442789981, 3, 73.83872303895366, 5, 33, 107.77583965411948, 51.17955107241401);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('95', 22.085271861175944, 32.50274611633591, 6.9952299505477775, 7, 82.0856519922444, 16, 5, 89.56444653617156, 133.89322254421447);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('96', 28.725350009325844, 48.14693301038067, 5.457372497158579, 10, 8.809498723147103, 16, 12, 70.40394322405619, 46.46670693323419);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('97', 20.827764222492206, 39.5100250030603, 5.825597209242455, 1, 9.393778798437813, 12, 8, 108.97970397824643, 184.1772034997513);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('98', 18.1564316661361, 64.72991550727349, 5.034631203657406, 10, 6.974357432477363, 19, 41, 42.01319573580164, 162.12014170600435);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('99', 27.353885172968162, 34.12325815280914, 6.457624700978737, 8, 82.16158708568949, 20, 13, 141.39311830891643, 176.6918721251078);
INSERT INTO Dati (Rilevazione, Temperatura, Umidita, Ph, FoglieDanneggiate, SuperficieFoglieDanneggiate, Fiori, Frutti, AltezzaPianta, LunghezzaRadice) VALUES ('100', 24.614826393142536, 43.35934187048413, 5.308752290979016, 1, 68.46951287408879, 13, 31, 157.70912908189007, 132.86331174317377);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('1', 'emilio69@example.org', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('2', 'ipalmisano@example.org', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('3', NULL, 'vincentiomoretti@example.com', '7875855536', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('4', 'bartolipompeo@example.net', NULL, NULL, '1729300239');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('5', NULL, NULL, 7457333766, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('6', NULL, 'abatantuonogiuliana@example.org', '1729300239', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('7', NULL, NULL, 1739922803, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('8', NULL, 'bernardosperi@example.net', '4945605917', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('9', NULL, 'qtrupiano@example.com', '9369114805', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('10', NULL, 'massimo73@example.com', '4945605917', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('11', 'santemimun@example.net', NULL, NULL, '1983052604');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('12', 'solepirandello@example.net', NULL, NULL, '8997139989');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('13', NULL, NULL, 9041357177, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('14', NULL, NULL, 8782075526, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('15', 'mariaantonetti@example.com', NULL, NULL, '6511426933');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('16', NULL, 'coluccio09@example.net', '1532292613', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('17', NULL, 'amico70@example.com', '9041357177', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('18', NULL, 'mpininfarina@example.com', '6511426933', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('19', 'ballagianluigi@example.com', NULL, NULL, '1532292613');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('20', NULL, 'mariarosiello@example.com', '4945605917', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('21', NULL, 'platiniflora@example.net', '3780356817', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('22', 'fredo13@example.net', NULL, NULL, '1532292613');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('23', NULL, NULL, 6002562545, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('24', NULL, NULL, 1241371775, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('25', 'anita10@example.net', NULL, NULL, '8997139989');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('26', NULL, 'flavioluzi@example.net', '1241371775', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('27', NULL, 'cristina84@example.net', '1532292613', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('28', 'antonelloaltera@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('29', NULL, NULL, 7875855536, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('30', 'laurettalettiere@example.org', NULL, NULL, '4945605917');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('31', NULL, NULL, 1983052604, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('32', 'norbiatomariana@example.net', NULL, NULL, '5273566922');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('33', 'abatantuonogiuliana@example.org', NULL, NULL, '4945605917');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('34', NULL, 'giacomopizziol@example.net', '6900148646', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('35', 'gaitogermana@example.net', NULL, NULL, '9369114805');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('36', 'upaolucci@example.com', NULL, NULL, '6900148646');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('37', 'santemimun@example.net', NULL, NULL, '3780356817');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('38', 'brugnaroliberto@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('39', NULL, 'antonelloaltera@example.com', '6002562545', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('40', NULL, 'martapacomio@example.net', '9041357177', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('41', 'fredo13@example.net', NULL, NULL, '6900148646');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('42', NULL, 'corradopetrucci@example.org', '5074440098', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('43', NULL, 'fredo23@example.org', '5273566922', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('44', 'jcristoforetti@example.org', NULL, NULL, '8782075526');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('45', NULL, NULL, 9369114805, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('46', 'veronica27@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('47', NULL, NULL, 1739922803, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('48', NULL, 'amico70@example.com', '1241371775', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('49', 'giuliomoretti@example.org', NULL, NULL, '1532292613');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('50', NULL, 'norbiatomariana@example.net', '1729300239', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('51', NULL, NULL, 3078562893, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('52', 'esegni@example.org', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('53', NULL, NULL, 5273566922, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('54', 'carolinaluria@example.com', NULL, NULL, '6511426933');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('55', NULL, 'cristina84@example.net', '8782075526', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('56', 'lodovicoboiardo@example.net', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('57', 'esegni@example.org', NULL, NULL, '5074440098');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('58', NULL, 'veronica27@example.com', '5074440098', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('59', 'toldogiulio@example.net', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('60', NULL, 'bajardiisa@example.net', '5273566922', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('61', 'dbocca@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('62', NULL, 'emilio69@example.org', '6002562545', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('63', NULL, NULL, 1532292613, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('64', 'jcristoforetti@example.org', NULL, NULL, '1241371775');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('65', 'claudia73@example.org', NULL, NULL, '1983052604');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('66', 'upaolucci@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('67', NULL, 'emilio69@example.org', '8782075526', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('68', 'rizzoantonella@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('69', 'ycianciolo@example.org', NULL, NULL, '3078562893');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('70', NULL, NULL, 1983052604, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('71', NULL, 'rizzoantonella@example.com', '6002562545', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('72', NULL, NULL, 3780356817, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('73', NULL, 'gianni28@example.org', '1241371775', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('74', 'calogeroargentero@example.org', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('75', 'manuel96@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('76', 'enrico21@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('77', 'carolinaluria@example.com', NULL, NULL, '9369114805');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('78', 'sonia28@example.net', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('79', 'livio36@example.org', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('80', NULL, 'mpininfarina@example.com', '1241371775', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('81', 'giolittimicheletto@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('82', 'upedersoli@example.com', NULL, NULL, '9369114805');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('83', NULL, NULL, 6900148646, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('84', 'mariaantonetti@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('85', NULL, 'zcheda@example.com', '4945605917', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('86', NULL, 'egioberti@example.org', '6002562545', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('87', 'brugnaroliberto@example.com', NULL, NULL, '3078562893');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('88', NULL, NULL, 6002562545, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('89', 'pietro77@example.com', NULL, NULL, '6002562545');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('90', NULL, NULL, 1532292613, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('91', 'bernardosperi@example.net', NULL, NULL, '8782075526');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('92', NULL, 'dbocca@example.com', '1241371775', NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('93', NULL, NULL, 5074440098, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('94', 'galtarossaannibale@example.org', NULL, NULL, '4945605917');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('95', 'gaitogermana@example.net', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('96', 'lgentileschi@example.org', NULL, NULL, '3078562893');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('97', NULL, NULL, 1532292613, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('98', 'bartolipompeo@example.net', NULL, NULL, '1739922803');
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('99', 'ballagianluigi@example.com', NULL, NULL, NULL);
INSERT INTO Responsabile (Rilevazione, InserimentoPersona, RilevatorePersona, InserimentoClasse, RilevatoreClasse) VALUES ('100', 'calogeroargentero@example.org', NULL, NULL, '1729300239');

-- INTERROGAZIONI

/*
    A. Interrogazione 1 - JOIN
        - Questa query restituisce il nome del docente, la sezione della classe 
            e il nome dell'orto per tutte le scuole che hanno il finanziamento abilitato.
*/
SELECT P.Nome, C.Sezione, O.NomeOrto
FROM Persona P
JOIN Classe C ON P.Email = C.Docente
JOIN Scuola S ON C.Scuola = S.Cod_Meccanografico
JOIN Orto O ON O.Scuola = S.Cod_Meccanografico
WHERE S.Finanziamento IS NOT NULL
GROUP BY P.Nome, C.Sezione, O.NomeOrto
ORDER BY O.NomeOrto;

/*
    B. Interrogazione 2 - Condizione Complessa
        - Questa query restituisce l'ID della rilevazione, la temperatura e l'umidità dai dati 
            per tutte le rilevazioni in cui la temperatura è superiore a 25 e l'umidità è superiore a 80, 
                oppure per tutte le rilevazioni effettuate a partire dal 1º gennaio 2023.
*/
SELECT R.IdRilevazione, D.Temperatura, D.Umidita
FROM Rilevazione R
JOIN Dati D ON R.IdRilevazione = D.Rilevazione
WHERE (D.Temperatura > 25 AND D.Umidita > 80) OR R.DataOraRilevazione >= '2023-01-01';

/*
    C. Interrogazione 3 - Funzione Generica
        - Questa query restituisce il nome della scuola e il numero di piante coltivate in ciascuna scuola, 
            considerando solo le scuole che hanno più di 10 piante coltivate.
*/
SELECT S.NomeScuola, COUNT(*) AS NumeroPiante
FROM Scuola S
JOIN Classe C ON S.Cod_Meccanografico = C.Scuola
JOIN Pianta P ON C.IdClasse = P.Classe
GROUP BY S.NomeScuola
HAVING COUNT(*) > 10;

-- INDICI RELATIVI ALLE QUERY PRECEDENTI

-- A. Interrogazione 1 - JOIN
CREATE INDEX idx_Classe_Docente ON Classe USING btree(Docente);
CLUSTER Classe USING idx_Classe_Docente;

CREATE INDEX idx_Scuola_Cod_Meccanografico ON Scuola USING btree(Cod_Meccanografico);
CLUSTER Scuola USING idx_Scuola_Cod_Meccanografico;

CREATE INDEX idx_Scuola_Finanziamento ON Scuola USING btree(Finanziamento);
CLUSTER Scuola USING idx_Scuola_Finanziamento;

-- B. Interrogazione 2 - Condizione Complessa
CREATE INDEX idx_Rilevazione_DataOraRilevazione ON Rilevazione USING btree(DataOraRilevazione);
CLUSTER Rilevazione USING idx_Rilevazione_DataOraRilevazione;

CREATE INDEX idx_Dati_Rilevazione ON Dati USING btree(Rilevazione);
CLUSTER Dati USING idx_Dati_Rilevazione;

CREATE INDEX idx_Dati_Temperatura_Umidita ON Dati USING btree(Temperatura, Umidita);
CLUSTER Dati USING idx_Dati_Temperatura_Umidita;

-- C. Interrogazione 3 - Funzione Generica
CREATE INDEX idx_Classe_Scuola ON Classe USING btree(Scuola);
CLUSTER Classe USING idx_Classe_Scuola;

CREATE INDEX idx_Pianta_Classe ON Pianta USING btree(Classe);
CLUSTER Pianta USING idx_Pianta_Classe;

CREATE INDEX idx_Scuola_NomeScuola ON Scuola USING btree(NomeScuola);
CLUSTER Scuola USING idx_Scuola_NomeScuola;

CREATE INDEX idx_Pianta_Specie ON Pianta USING btree(Specie);
CLUSTER Pianta USING idx_Pianta_Specie;

-- GESTIONE DEGLI ACCESSI

-- Elimina i ruoli prima di ricrearli
DROP ROLE IF EXISTS Amministratore;
DROP ROLE IF EXISTS Referente;
DROP ROLE IF EXISTS Insegnante;
DROP ROLE IF EXISTS Studente;

-- Creazione Ruoli
CREATE ROLE Amministratore;
GRANT USAGE ON SCHEMA "OrtiScolastici" TO Amministratore WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA "OrtiScolastici" TO Amministratore WITH GRANT OPTION;
CREATE ROLE Referente;
GRANT USAGE ON SCHEMA "OrtiScolastici" TO Referente;
CREATE ROLE Insegnante;
GRANT USAGE ON SCHEMA "OrtiScolastici" TO Insegnante;
CREATE ROLE Studente;
GRANT USAGE ON SCHEMA "OrtiScolastici" TO Studente;

-- Assegnazione dei privilegi per la tabella Persona
GRANT ALL ON Persona TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Persona TO Referente;
GRANT SELECT ON Persona TO Insegnante, Studente;

-- Assegnazione dei privilegi per la tabella Scuola
GRANT ALL ON Scuola TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Scuola TO Referente;
GRANT SELECT ON Scuola TO Insegnante, Studente;

-- Assegnazione dei privilegi per la tabella Classe
GRANT ALL ON Classe TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Classe TO Referente;
GRANT SELECT ON Classe TO Insegnante, Studente;

-- Assegnazione dei privilegi per la tabella Specie
GRANT ALL ON Specie TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Specie TO Referente, Insegnante;
GRANT SELECT ON Specie TO Studente;

-- Assegnazione dei privilegi per la tabella Orto
GRANT ALL ON Orto TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Orto TO Referente;
GRANT SELECT ON Orto TO Insegnante, Studente;

-- Assegnazione dei privilegi per la tabella Pianta
GRANT ALL ON Pianta TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pianta TO Referente;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pianta TO Insegnante;
GRANT SELECT ON Pianta TO Studente;

-- Assegnazione dei privilegi per la tabella Esposizione
GRANT ALL ON Esposizione TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Esposizione TO Referente, Insegnante;
GRANT SELECT ON Esposizione TO Studente;

-- Assegnazione dei privilegi per la tabella Gruppo
GRANT ALL ON Gruppo TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Gruppo TO Referente, Insegnante;
GRANT SELECT ON Gruppo TO Studente;

-- Assegnazione dei privilegi per la tabella Sensore
GRANT ALL ON Sensore TO Amministratore;
GRANT SELECT, INSERT, UPDATE ON Sensore TO Referente, Insegnante;
GRANT SELECT ON Sensore TO Studente;

-- Assegnazione dei privilegi per la tabella Rilevazione
GRANT ALL ON Rilevazione TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Rilevazione TO Referente, Insegnante;
GRANT SELECT, INSERT, UPDATE ON Rilevazione TO Studente;

-- Assegnazione dei privilegi per la tabella Dati
GRANT ALL ON Dati TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dati TO Referente, Insegnante;
GRANT SELECT, INSERT, UPDATE ON Dati TO Studente;

-- Assegnazione dei privilegi per la tabella Responsabile
GRANT ALL ON Responsabile TO Amministratore;
GRANT SELECT, INSERT, UPDATE, DELETE ON Responsabile TO Referente, Insegnante;
GRANT SELECT ON Responsabile TO Studente;

-- Elimina gli utenti prima di crearli
DROP USER IF EXISTS amministratore_user;
DROP USER IF EXISTS referente_user;
DROP USER IF EXISTS insegnante_user;
DROP USER IF EXISTS studente_user_one;
DROP USER IF EXISTS studente_user_two;

-- Creazione degli utenti e assegnazione di password (NB: le password, non richieste da specifiche, sono tutte uguali per comodità)
CREATE USER amministratore_user WITH PASSWORD 'password';
CREATE USER referente_user WITH PASSWORD 'password';
CREATE USER insegnante_user WITH PASSWORD 'password';
CREATE USER studente_user_one WITH PASSWORD 'password';
CREATE USER studente_user_two WITH PASSWORD 'password';

-- Assegnazione dei ruoli agli utenti
GRANT Amministratore TO amministratore_user;
GRANT Referente TO referente_user;
GRANT Insegnante TO insegnante_user;
GRANT Studente TO studente_user_one, studente_user_two;