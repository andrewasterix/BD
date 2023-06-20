# Progetto di Base Dati 2023 - "Orti Scolastici" - 12 CFU

## Componenti del Gruppo

- **Andrea Franceschetti** - 4357070
- **William Chen** - 4827847
- **Alessio De Vincenzi**s - 4878315

## Progettazione Fisica

Per verificare il corretto funzionamento delle interrogazioni a pieno carico, si è deciso di creare un database di test con un numero di tuple molto alto, in modo da poter valutare le prestazioni delle interrogazioni a pieno carico.

Al fine di fare ciò abbiamo creato uno Notebook in Python che genera un elevato numero di dati in modo dinamico e casuale, inserendoli direttamente nel database.

Lo script, creando valori di dati in modo altamente casuale nel momento della creazione del database, permette di ottenere un database di test diverso ad ogni esecuzione.

**Nota:** Lo script è stato creato per essere eseguito su un database vuoto, quindi se si vuole eseguire nuovamente lo script, è necessario eliminare il database e ricrearlo con il file SQL '[ Parte II.A.A ] BaseDati.sql'.

### Interrogazioni a pieno carico

#### Interrogazione 1 - JOIN

Questa query restituisce il nome del docente, la sezione della classe e il nome dell'orto per tutte le scuole che hanno il finanziamento abilitato.

```sql
SELECT P.Nome, C.Sezione, O.NomeOrto
FROM Persona P
JOIN Classe C ON P.Email = C.Docente
JOIN Scuola S ON C.Scuola = S.Cod_Meccanografico
JOIN Orto O ON O.Scuola = S.Cod_Meccanografico
WHERE S.Finanziamento IS NOT NULL
GROUP BY P.Nome, C.Sezione, O.NomeOrto
ORDER BY O.NomeOrto;
```

#### Interrogazione 2 - Condizione Complessa

Questa query restituisce l'ID della rilevazione, la temperatura e l'umidità dai dati per tutte le rilevazioni in cui la temperatura è superiore a 25 e l'umidità è superiore a 80, oppure per tutte le rilevazioni effettuate a partire dal 1º gennaio 2023.

```sql
SELECT R.IdRilevazione, D.Temperatura, D.Umidita
FROM Rilevazione R
JOIN Dati D ON R.IdRilevazione = D.Rilevazione
WHERE (D.Temperatura > 25 AND D.Umidita > 80) OR R.DataOraRilevazione >= '2023-01-01';
```

#### Interrogazione 3 - Funzione Generica

Questa query restituisce il nome della scuola e il numero di piante coltivate in ciascuna scuola, considerando solo le scuole che hanno più di 10 piante coltivate.

```sql
SELECT S.NomeScuola, COUNT(*) AS NumeroPiante
FROM Scuola S
JOIN Classe C ON S.Cod_Meccanografico = C.Scuola
JOIN Pianta P ON C.IdClasse = P.Classe
GROUP BY S.NomeScuola
HAVING COUNT(*) > 10;
```

### Indici per le interrogazioni a pieno carico

L'idea che abbiamo avuto è di realizzare indici clusterizzati di tipo B-Tree i quali organizzano fisicamente i dati sulla base delle colonne specificate, migliorando le prestazioni delle operazioni di lettura che coinvolgono tali colonne.

Tuttavia, abbiamo tenuto presente che l'utilizzo di indici clusterizzati può comportare una penalità sulle operazioni di inserimento, aggiornamento e cancellazione, poiché i dati devono essere riorganizzati per mantenere l'ordine clusterizzato.

#### Indice 1 - JOIN

Questo indice è stato creato per velocizzare la query di JOIN.

```sql
CREATE INDEX idx_Classe_Docente ON Classe USING btree(Docente);
CLUSTER Classe USING idx_Classe_Docente;

CREATE INDEX idx_Scuola_Cod_Meccanografico ON Scuola USING btree(Cod_Meccanografico);
CLUSTER Scuola USING idx_Scuola_Cod_Meccanografico;

CREATE INDEX idx_Scuola_Finanziamento ON Scuola USING btree(Finanziamento);
CLUSTER Scuola USING idx_Scuola_Finanziamento;
```

La creazione di indici clusterizzati sulla colonna "Docente" nella tabella "Classe" e sulle colonne "Cod_Meccanografico" e "Finanziamento" nella tabella "Scuola", ci permette di accedere direttamente ai dati di nostro interesse, accelerando conseguentemente i le operazioni di JOIN tra le tabelle.

#### Indice 2 - Condizione Complessa

Questo indice è stato creato per velocizzare la query di Condizione Complessa.

```sql
CREATE INDEX idx_Rilevazione_DataOraRilevazione ON Rilevazione USING btree(DataOraRilevazione);
CLUSTER Rilevazione USING idx_Rilevazione_DataOraRilevazione;

CREATE INDEX idx_Dati_Rilevazione ON Dati USING btree(Rilevazione);
CLUSTER Dati USING idx_Dati_Rilevazione;

CREATE INDEX idx_Dati_Temperatura_Umidita ON Dati USING btree(Temperatura, Umidita);
CLUSTER Dati USING idx_Dati_Temperatura_Umidita;
```

L'indice clusterizzato sulla colonna "DataOraRilevazione" nella tabella "Rilevazione" organizza fisicamente le righe di dati in base ai valori di questa colonna.
Gli indici clusterizzati sulla colonna "Rilevazione" nella tabella "Dati" e sulle colonne "Temperatura" e "Umidita" nella tabella "Dati" hanno lo stesso effetto, organizzando fisicamente le righe di dati in base ai valori di queste colonne.

#### Indice 3 - Funzione Generica

Questo indice è stato creato per velocizzare la query di Funzione Generica.

```sql
CREATE INDEX idx_Classe_Scuola ON Classe USING btree(Scuola);
CLUSTER Classe USING idx_Classe_Scuola;

CREATE INDEX idx_Pianta_Classe ON Pianta USING btree(Classe);
CLUSTER Pianta USING idx_Pianta_Classe;

CREATE INDEX idx_Scuola_NomeScuola ON Scuola USING btree(NomeScuola);
CLUSTER Scuola USING idx_Scuola_NomeScuola;

CREATE INDEX idx_Pianta_Specie ON Pianta USING btree(Specie);
CLUSTER Pianta USING idx_Pianta_Specie;
```

Gli indici clusterizzati sulla colonna "Scuola" nella tabella "Classe", sulla colonna "Classe" nella tabella "Pianta", sulla colonna "NomeScuola" nella tabella "Scuola" e sulla colonna "Specie" nella tabella "Pianta" organizzano fisicamente le righe di dati in base ai valori di queste colonne, migliorando le prestazioni delle query che coinvolgono tali colonne.

### Tabella riassuntivo del carico di lavoro

Dati ottenuti tramite la seguente query:

**Nota:** La query estrae i valori richiesti per tutte le tabelle del database

```sql
SELECT
  t.relname AS Tabella,
  t.n_tup_ins AS Numero_Tuple_Inserite,
  pg_size_pretty(pg_relation_size(t.relid)) AS Dimensione_Blocchi,
  pg_size_pretty(pg_total_relation_size(t.relid)) AS Dimensione_Totale
FROM
  pg_stat_user_tables t
  JOIN pg_class c ON t.relname = c.relname
WHERE
  c.relkind = 'r' -- Considera solo le tabelle
ORDER BY
  t.relname;
```

<table>
<tr><td>Tabella</td><td>Numero Tuple</td><td>Dimensione Blocchi Singolo</td><td>Dimensione Totale</td>
<tr style="text-align: center;"><td>Classe</td><td>19</td><td>8192 byte</td><td>24 kb</td>
<tr style="text-align: center;"><td>Scuola</td><td>10</td><td>8192 byte</td><td>32 kb</td>
<tr style="text-align: center;"><td>Pianta</td><td>100</td><td>16 kb</td><td>56 kb</td>
<tr style="text-align: center;"><td>Rilevazione</td><td>100</td><td>8192 byte</td><td>24 kb</td>
<tr style="text-align: center;"><td>Dati</td><td>100</td><td>8192 byte</td><td>24 kb</td>
</table>

### Piani di esecuzione delle interrogazioni a pieno carico scelti dal Sistema

#### Interrogazione 1 - JOIN

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Prima Interrogazione](Aggiuntivi\Senza_Indici\1\Analisi.jpg "Analisi Prima Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Senza_Indici\1\Grafico.jpg "Grafico Prima Interrogazione")

#### Interrogazione 2 - Condizione Complessa

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Seconda Interrogazione](Aggiuntivi\Senza_Indici\2\Analisi.jpg "Analisi Seconda Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Senza_Indici\2\Grafico.jpg "Grafico Seconda Interrogazione")

#### Interrogazione 3 - Funzione Generica

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Terza Interrogazione](Aggiuntivi\Senza_Indici\2\Analisi.jpg "Analisi Terza Interrogazione")
- Grafico
  ![Grafico Terza Interrogazione](Aggiuntivi\Senza_Indici\2\Grafico.jpg "Grafico Terza Interrogazione")

## Controllo degli Accessi

### Gerarchia dei Ruoli

Il successivo elenco mostra la gerarchia dei ruoli in ordine decrescente di privilegi:

1. **Amministratore** - Ruolo che ha tutti i privilegi (Gestore globale del Progetto).
2. **Referente** - Ruolo che ha i privilegi di gestione dei dati di una Scuola.
3. **Insegnante** - Ruolo che ha i privilegi di gestione dei dati di una Classe.
4. **Studente** - Ruolo che ha i privilegi di gestione dati di una Classe ma minori di **Insegnante**.

### Tabella Privilegi

<table>
<tr><td>#</td><td>Amministratore</td><td>Referente</td><td>Insegnante</td><td>Studente</td>
<tr><td>Persona</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Scuola</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Classe</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Studente</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Specie</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td>
<tr><td>Orto</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Pianta</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Esposizione</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Gruppo</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Sensore</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td>
<tr><td>Rilevazione</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE</td>
<tr><td>Dati</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE</td>
<tr><td>Responsabile</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
</table>

**Nota:** ALL = SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER.

## Politica dei Privilegi

Si è deciso di applicare la filosofia del minimo privilegio, ovvero assegnare ad ogni ruolo solo i privilegi necessari per svolgere il proprio lavoro.

1. **Amministratore** - Ha accesso a tutti i dati del database e può eseguire tutte le operazioni.
2. **Referente** - Ha accesso ai dati della Scuola di cui è Referente e può eseguire tutte le operazioni su di essi.
   - Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Scuola di cui è Referente.
   - Scritture: Cancellazione -> Solo su dati che riguardano le Piante e le Rilevazioni fatte dalla Scuola di cui è Referente.
   - Letture: Visualizzazione -> Su tutti i dati che riguardano la Scuola di cui è Referente.
   - Non può eseguire operazioni su dati di altre Scuole.
3. **Insegnante** - Ha accesso ai dati della Classe di cui è Insegnante e può eseguire tutte le operazioni su di essi.
   - Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Classe di cui è Insegnante.
   - Scritture: Cancellazione -> Solo su dati che riguardano le Piante e le Rilevazioni fatte dalla Classe di cui è Insegnante.
   - Letture: Visualizzazione -> Su tutti i dati che riguardano la Classe di cui è Insegnante.
   - Può eseguire operazioni su dati di altre Classi della stessa Scuola ammesso che ne sia un Insegnante.
4. **Studente** - Ha accesso ai dati della Classe di cui è Studente e può eseguire tutte le operazioni su di essi.
   - Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Classe di cui è Studente.
   - Scritture: Cancellazione -> Solo su dati che riguardano le Rilevazioni fatte dalla Classe di cui è Studente.
   - Letture: Visualizzazione -> Su tutti i dati che riguardano la Classe di cui è Studente.
   - Non può eseguire operazioni su dati di altre Classi.
