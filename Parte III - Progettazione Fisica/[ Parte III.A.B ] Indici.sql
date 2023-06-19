/*
Parte III.A.B - Indici per le Interrogazioni

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/

-- A. Interrogazione 1 - JOIN
CREATE CLUSTER INDEX idx_Classe_Docente ON Classe USING btree(Docente);
CREATE CLUSTER INDEX idx_Scuola_Cod_Meccanografico ON Scuola USING btree(Cod_Meccanografico);
CREATE CLUSTER INDEX idx_Scuola_Finanziamento ON Scuola USING btree(Finanziamento);

-- B. Interrogazione 2 - Condizione Complessa
CREATE CLUSTER INDEX idx_Rilevazione_DataOraRilevazione ON Rilevazione USING btree(DataOraRilevazione);
CREATE CLUSTER INDEX idx_Dati_Rilevazione ON Dati USING btree(Rilevazione);
CREATE CLUSTER INDEX idx_Dati_Temperatura_Umidita ON Dati USING btree(Temperatura, Umidita);

-- C. Interrogazione 3 - Funzione Generica
CREATE CLUSTER INDEX idx_Classe_Scuola ON Classe USING btree(Scuola);
CREATE CLUSTER INDEX idx_Pianta_Classe ON Pianta USING btree(Classe);
CREATE CLUSTER INDEX idx_Scuola_NomeScuola ON Scuola USING btree(NomeScuola);
CREATE CLUSTER INDEX idx_Pianta_Specie ON Pianta USING btree(Specie);