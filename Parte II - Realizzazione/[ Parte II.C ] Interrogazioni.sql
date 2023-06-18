/*
Parte II.C - Interrogazioni

Andrea Franceschetti - 4357070
William Chen - 4827847
Alessio De Vincenzi - 4878315
*/
SET search_path TO 'OrtiScolastici';

SET datestyle TO 'MDY';

-- A. Determinare le scuole che, pur avendo un finanziamento per il progetto, non hanno inserito rilevazioni in questo anno scolastico;

-- [TESTATA E FUNZIONANTE]

SELECT S.Cod_Meccanografico
FROM Scuola S
WHERE
    S.Finanziamento IS NOT NULL
    AND S.Referente IS NOT NULL
    AND S.Cod_Meccanografico != (
        SELECT C.Scuola
        FROM CLASSE C
            JOIN Responsabile R ON C.IdClasse = R.InserimentoClasse
            JOIN Rilevazione RI ON R.Rilevazione = RI.IdRilevazione
        WHERE
            RI.DataOraInserimento BETWEEN '2023-01-01 00:00:00' AND '2023-01-12 23:59:59'
    );

-- B. Determinare le specie utilizzate in tutti i comuni in cui ci sono scuole aderenti al progetto;

-- [TESTATA E FUNZIONANTE]

SELECT DISTINCT o.Specie
FROM Orto o
    JOIN Scuola s ON o.Scuola = s.Cod_Meccanografico
WHERE s.Comune IN (
        SELECT
            DISTINCT s.Comune
        FROM Scuola s
            JOIN Orto o ON s.Cod_Meccanografico = o.Scuola
    );

-- C. Determinare per ogni scuola l’individuo/la classe della scuola che ha effettuato più rilevazioni;

-- [TESTATA E FUNZIONANTE]

(
    SELECT
        S.Cod_Meccanografico AS SCUOLA,
        MAX(RilevazioniTotali) AS RILEVAZIONI_TOTALI
    FROM Classe C
        JOIN Scuola AS S ON C.Scuola = S.Cod_Meccanografico
        LEFT JOIN (
            SELECT
                S1.Cod_Meccanografico,
                R1.RilevatoreClasse,
                COUNT(*) AS RilevazioniTotali
            FROM Scuola S1
                JOIN Classe C1 ON S1.Cod_Meccanografico = C1.Scuola
                JOIN Responsabile R1 ON C1.IdClasse = R1.RilevatoreClasse
            GROUP BY
                S1.Cod_Meccanografico,
                R1.RilevatoreClasse
        ) AS R ON C.idClasse = R.RilevatoreClasse
    GROUP BY
        S.Cod_Meccanografico
)
UNION (
    SELECT
        S.Cod_Meccanografico AS SCUOLA,
        MAX(RilevazioniTotali) AS RILEVAZIONI_TOTALI
    FROM Classe C
        JOIN Scuola AS S ON C.Scuola = S.Cod_Meccanografico
        LEFT JOIN (
            SELECT
                S1.Cod_Meccanografico,
                R1.RilevatorePersona,
                COUNT(*) AS RilevazioniTotali
            FROM Scuola S1
                JOIN Classe C1 ON S1.Cod_Meccanografico = C1.Scuola
                JOIN Responsabile R1 ON C1.Docente = R1.RilevatorePersona
            GROUP BY
                S1.Cod_Meccanografico,
                R1.RilevatorePersona
        ) AS R ON C.Docente = R.RilevatorePersona
    GROUP BY
        S.Cod_Meccanografico
)
ORDER BY
    RILEVAZIONI_TOTALI DESC;