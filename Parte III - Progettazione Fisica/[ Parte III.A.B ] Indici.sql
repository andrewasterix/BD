/*
Parte III.A.B - Indici per le Interrogazioni

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/

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