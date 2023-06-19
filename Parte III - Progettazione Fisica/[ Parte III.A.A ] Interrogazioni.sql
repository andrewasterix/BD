/*
Parte III.A.A - Interrogazioni

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';
SET datestyle TO 'MDY';
SET timezone TO 'GMT';

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