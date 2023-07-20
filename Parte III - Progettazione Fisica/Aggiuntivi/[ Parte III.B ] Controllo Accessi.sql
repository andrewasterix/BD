/*
Parte III.B - Controllo Accessi

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';

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