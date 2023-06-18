/*
Parte II.A.A - Base di Dati

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
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
    Collabora BOOLEAN NOT NULL,

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

-- Associazione Studente
CREATE TABLE IF NOT EXISTS Studente (
    Classe BIGINT NOT NULL,
    FOREIGN KEY (Classe) REFERENCES Classe(IdClasse) ON DELETE CASCADE ON UPDATE CASCADE,
    Alunno VARCHAR(100) NOT NULL,
    FOREIGN KEY (Alunno) REFERENCES Persona(Email) ON DELETE CASCADE ON UPDATE CASCADE,

    PRIMARY KEY (Classe, Alunno)
);

-- Tabella Specie
CREATE TABLE IF NOT EXISTS Specie (
    NomeScientifico VARCHAR(100) NOT NULL PRIMARY KEY,
    Substrato VARCHAR(100) NOT NULL
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