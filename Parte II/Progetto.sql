-- Active: 1684932917946@@127.0.0.1@5432@postgres
DROP SCHEMA IF EXISTS "OrtiScolastici" CASCADE;
CREATE SCHEMA IF NOT EXISTS "OrtiScolastici";
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';

DROP TABLE IF EXISTS Rilevazioni;
DROP TABLE IF EXISTS Sensore;
DROP TABLE IF EXISTS Parametri;
DROP TABLE IF EXISTS Danni;
DROP TABLE IF EXISTS Fruttificazione;
DROP TABLE IF EXISTS Biomassa;
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

CREATE TABLE IF NOT EXISTS Scuola (
    codice_meccanografico VARCHAR(10) NOT NULL,
    nome_scuola TEXT NOT NULL,
    provincia CHAR(2) NOT NULL,
    comune TEXT NOT NULL,
    ciclo_istruzione TEXT NOT NULL CHECK (ciclo_istruzione IN ('Primo', 'Secondo')),
    collabora BOOLEAN NOT NULL,
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
    PRIMARY KEY (email)
);

CREATE TABLE IF NOT EXISTS Ruolo (
    Tipo_ruolo TEXT NOT NULL CHECK (Tipo_ruolo IN ('Docente', 'Referente', 'Rilevatore Esterno', 'Studente')),
	email TEXT NOT NULL REFERENCES Persona (email),
    PRIMARY KEY (Tipo_ruolo)
);

CREATE TABLE IF NOT EXISTS Classe (
    nome_classe VARCHAR(5) NOT NULL,
    ordine TEXT NOT NULL,
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
    id_rilevazione BIGINT NOT NULL,
    data_ora_inserimento TIMESTAMP NOT NULL,
    data_ora_rilevazione TIMESTAMP NOT NULL,
    responsabile TEXT REFERENCES Persona (email),
    pianta BIGINT REFERENCES Piante (id_pianta),	
    PRIMARY KEY (id_rilevazione),
	
    CONSTRAINT data_ora_rilevazione_a_antecedente_a_data_ora_inserimento
        CHECK (data_ora_rilevazione > data_ora_inserimento),
    UNIQUE (data_ora_inserimento, data_ora_rilevazione)
);

CREATE TABLE IF NOT EXISTS Responsabile (
    id_responsabile BIGINT NOT NULL,
    responsabile_inserimento TEXT NULL,
    responsavile_rilevazione TEXT NULL,

    CONSTRAINT IF
    PRIMARY KEY (id_responsabile)
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
    tipo CHAR NOT NULL CHECK (tipo IN ('arduino', 'sensore')),
    acquisizione TEXT NOT NULL CHECK (acquisizione IN ('BD', 'App')),
    PRIMARY KEY (id_sensore)
);