# Basi di Dati 2023 - 12 CFU - "Orti Scolastici"

## **Progettazione Fisica**

<div style="text-align: justify;">
<p> Al fine di verificare il corretto funzionamento delle interrogazioni a pieno carico, si è deciso di creare un database di test con un elevato numero di tuple, in modo da valutare le prestazioni delle interrogazioni in situazioni di carico massimo. </p>
<p> Per fare ciò, abbiamo creato un Notebook in Python che genera un elevato numero di dati in modo casua- le, inserendoli direttamente nel database, questo ci permette di ottenere un database di test diverso ad ogni esecuzione.</p>
<p> Inoltre genera il file <b>[ Parte III.A ] PopolamentoLarge.sql</b> dove vengono inserite le query che sono state appena eseguite sul database.</p>
<p> <b>Nota<sup>1</sup>:</b> Lo script è stato creato per essere eseguito su un database vuoto, quindi se si vuole eseguirlo nuovamente, è necessario eliminare il database e ricrearlo <b>[ Parte II.A.A ] BaseDati.sql</b>.</p>
<p> <b>Nota<sup>2</sup>:</b> In allegato è presente il file <b>[ Parte III.A ] PopolamentoLarge.sql</b> generato durante una nostra esecuzione di test.</p></div>

### **Interrogazioni a pieno carico**

#### Interrogazione 1 - JOIN
<div style="text-align: justify;">
<p>Questa query restituisce il nome del docente, la sezione della classe e il nome dell'orto per tutte le scuole che hanno il finanziamento abilitato.</p>
</div>

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
<div style="text-align: justify;">
<p>Questa query restituisce l'ID della rilevazione, la temperatura e l'umidità dai dati per tutte le rilevazioni in cui la temperatura è superiore a 25 e l'umidità è superiore a 80, oppure per tutte le rilevazioni effettuate a partire dal 1º gennaio 2023.</p></div>

<div style="page-break-after: always;"></div>

```sql
SELECT R.IdRilevazione, D.Temperatura, D.Umidita
FROM Rilevazione R
JOIN Dati D ON R.IdRilevazione = D.Rilevazione
WHERE (D.Temperatura > 25 AND D.Umidita > 80) OR R.DataOraRilevazione >= '2023-01-01';
```

#### Interrogazione 3 - Funzione Generica

<div style="text-alogn: justify;">
<p>Questa query restituisce il nome della scuola e il numero di piante coltivate in ciascuna scuola, considerando solo le scuole che hanno più di 10 piante coltivate.</p></div>

```sql
SELECT S.NomeScuola, COUNT(*) AS NumeroPiante
FROM Scuola S
JOIN Classe C ON S.Cod_Meccanografico = C.Scuola
JOIN Pianta P ON C.IdClasse = P.Classe
GROUP BY S.NomeScuola
HAVING COUNT(*) > 10;
```

### **Indici per le interrogazioni a pieno carico**
<div style="text-align: justify">
<p>L'idea che abbiamo avuto è di realizzare indici clusterizzati di tipo B-Tree i quali organizzano fisicamente i dati sulla base delle colonne specificate, migliorando le prestazioni delle operazioni di lettura che coinvolgono tali colonne.</p>
<p>Tuttavia, abbiamo tenuto presente che l'utilizzo di indici clusterizzati può comportare una penalità sulle operazioni di inserimento, aggiornamento e cancellazione, poiché i dati devono essere riorganizzati per mantenere l'ordine clusterizzato.</p></div>

#### Indice 1 - Indice creato per la query di JOIN.

```sql
CREATE INDEX idx_Classe_Docente ON Classe USING btree(Docente);
CLUSTER Classe USING idx_Classe_Docente;

CREATE INDEX idx_Scuola_Cod_Meccanografico ON Scuola USING btree(Cod_Meccanografico);
CLUSTER Scuola USING idx_Scuola_Cod_Meccanografico;

CREATE INDEX idx_Scuola_Finanziamento ON Scuola USING btree(Finanziamento);
CLUSTER Scuola USING idx_Scuola_Finanziamento;
```
<div style="text-align: justify;">
<p>La creazione di indici clusterizzati sulla colonna "Docente" nella tabella "Classe" e sulle colonne "Cod_Meccanografico" e "Finanziamento" nella tabella "Scuola", ci permette di accedere direttamente ai dati di nostro interesse, accelerando conseguentemente i le operazioni di JOIN tra le tabelle.</p></div>

#### Indice 2 - Indice creato per la query di Condizione Complessa.

```sql
CREATE INDEX idx_Rilevazione_DataOraRilevazione ON Rilevazione USING btree(DataOraRilevazione);
CLUSTER Rilevazione USING idx_Rilevazione_DataOraRilevazione;

CREATE INDEX idx_Dati_Rilevazione ON Dati USING btree(Rilevazione);
CLUSTER Dati USING idx_Dati_Rilevazione;

CREATE INDEX idx_Dati_Temperatura_Umidita ON Dati USING btree(Temperatura, Umidita);
CLUSTER Dati USING idx_Dati_Temperatura_Umidita;
```
<div style="text-align: justify;">
<p>L'indice clusterizzato sulla colonna "DataOraRilevazione" nella tabella "Rilevazione" organizza fisicamente le righe di dati in base ai valori di questa colonna.
Gli indici clusterizzati sulla colonna "Rilevazione" nella tabella "Dati" e sulle colonne "Temperatura" e "Umidita" nella tabella "Dati" hanno lo stesso effetto, organizzando fisicamente le righe di dati in base ai valori di queste colonne.</p></div>

#### Indice 3 - Funzione Generica

<div style="text-align: justify;">
<p>Questo indice è stato creato per velocizzare la query di Funzione Generica.</p></div>

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

<div style="text-align: justify;">
<p>Gli indici clusterizzati sulla colonna "Scuola" nella tabella "Classe", sulla colonna "Classe" nella tabella "Pianta", sulla colonna "NomeScuola" nella tabella "Scuola" e sulla colonna "Specie" nella tabella "Pianta" organizzano fisicamente le righe di dati in base ai valori di queste colonne, migliorando le prestazioni delle query che coinvolgono tali colonne.</p></div>
<div style="page-break-after: always;"></div>

### **Tabella riassuntivo del carico di lavoro**

<div style="text-align: justify;">
<p>Dati ottenuti tramite la seguente query:

**Nota:** La query estrae i valori richiesti per tutte le tabelle del database
</p></div>

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
<div style="width: 100%; margin: left 45%">
<table style="width: 100%; margin: left 45%; position: relative">
<thead><tr><th>Tabella</th><th>Numero Tuple</th><th>Dimensione Blocchi Singolo</th><th>Dimensione Totale</th></thead>
<tbody>
<tr style="text-align: center;"><td>Classe</td><td>19</td><td>8192 byte</td><td>24 kb</td>
<tr style="text-align: center;"><td>Scuola</td><td>10</td><td>8192 byte</td><td>32 kb</td>
<tr style="text-align: center;"><td>Pianta</td><td>100</td><td>16 kb</td><td>56 kb</td>
<tr style="text-align: center;"><td>Rilevazione</td><td>100</td><td>8192 byte</td><td>24 kb</td>
<tr style="text-align: center;"><td>Dati</td><td>100</td><td>8192 byte</td><td>24 kb</td>
</tbody>
</table>
</div>
<div style="page-break-after: always;"></div>


### **Piani di esecuzione delle interrogazioni a pieno carico scelti dal Sistema**

#### Interrogazione 1 - JOIN

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Prima Interrogazione](Aggiuntivi\Senza_Indici\1\Analisi.jpg "Analisi Prima Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Senza_Indici\1\Grafico.jpg "Grafico Prima Interrogazione")

#### Piano esecuzione dopo l'indice

- Analisi
  ![Analisi Prima Interrogazione](Aggiuntivi\Con_Indici\1\Analisi.jpg "Analisi Prima Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Con_Indici\1\Grafico.jpg "Grafico Prima Interrogazione")

#### Conclusioni

<div style="text-align: justify;">
<p>Con l'introduzione degli indici clusterizzati, il piano di esecuzione fisico cambia di poco, ma le prestazioni peggiorano leggermente. Infatti, il tempo di esecuzione della query è di 0.3 ms senza indici e di 0.4 ms con indici.</p>
<p>Questo perchè essendo una query di JOIN, il sistema deve comunque eseguire un'operazione di JOIN tra le tabelle, quindi l'indice clusterizzato non ha un impatto significativo sulle prestazioni.</p>
<p>Il piano di esecuzione fisico per eseguire il JOIN sceglie di eseguire un'operazione di Hash Join tra le tabelle "Classe" e "Persona", utilizzando l'indice clusterizzato sulla colonna "Docente" nella tabella "Classe" e l'indice clusterizzato sulla colonna "Email" nella tabella "Persona".</p>
<p>Dopo aver eseguito l'operazione di Hash Join, il sistema esegue un'operazione di Hash Join tra le tabelle "Scuola" e "Classe", utilizzando l'indice clusterizzato sulla colonna "Cod_Meccanografico" nella tabella "Scuola" e l'indice clusterizzato sulla colonna "Scuola" nella tabella "Classe".</p><p>Infine, il sistema esegue un'operazione di Hash Join tra le tabelle "Orto" e "Scuola", utilizzando l'indice clusterizzato sulla colonna "Cod_Meccanografico" nella tabella "Scuola" e l'indice clusterizzato sulla colonna "Scuola" nella tabella "Orto".</p></div>

#### Interrogazione 2 - Condizione Complessa

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Seconda Interrogazione](Aggiuntivi\Senza_Indici\2\Analisi.jpg "Analisi Seconda Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Senza_Indici\2\Grafico.jpg "Grafico Seconda Interrogazione")

#### Piano esecuzione dopo l'indice

- Analisi
  ![Analisi Seconda Interrogazione](Aggiuntivi\Con_Indici\2\Analisi.jpg "Analisi Seconda Interrogazione")
- Grafico
  ![Grafico Prima Interrogazione](Aggiuntivi\Con_Indici\2\Grafico.jpg "Grafico Seconda Interrogazione")
<div style="page-break-after: always;"></div>

#### Conclusioni

<div style="text-align: justify;">
<p>Con l'introduzione degli indici clusterizzati, il piano di esecuzione fisico non cambia e le prestazioni rimangono le stesse. Infatti, il tempo di esecuzione della query è di 0.1 ms sia senza indici che con indici.</p>
<p>Questo perchè essendo una query di JOIN, il sistema deve comunque eseguire un'operazione di JOIN tra le tabelle, quindi l'indice clusterizzato non ha un impatto significativo sulle prestazioni.</p>
<p>Il piano di esecuzione fisico per eseguire il JOIN sceglie di eseguire un'operazione di Hash Join tra le tabelle "Rilevazione" e "Dati", utilizzando l'indice clusterizzato sulla colonna "Rilevazione" nella tabella "Dati".</p></div>

#### Interrogazione 3 - Funzione Generica

##### Piano esecuzione prima dell'indice

- Analisi
  ![Analisi Terza Interrogazione](Aggiuntivi\Senza_Indici\3\Analisi.jpg "Analisi Terza Interrogazione")
- Grafico
  ![Grafico Terza Interrogazione](Aggiuntivi\Senza_Indici\3\Grafico.jpg "Grafico Terza Interrogazione")
<div style="page-break-after: always;"></div>

#### Piano esecuzione dopo l'indice

- Analisi
  ![Analisi Terza Interrogazione](Aggiuntivi\Con_Indici\3\Analisi.jpg "Analisi Terza Interrogazione")
- Grafico
  ![Grafico Terza Interrogazione](Aggiuntivi\Con_Indici\3\Grafico.jpg "Grafico Terza Interrogazione")

#### Conclusioni

<div style="text-align: justify;">
<p>Con l'introduzione degli indici clusterizzati, il piano di esecuzione fisico cambia di poco, ma le prestazioni peggiorano leggermente. Infatti, il tempo di esecuzione della query è di 0.2 ms senza indici e di 0.1 ms con indici.</p>
<p>Questo perchè essendo una query di JOIN, il sistema deve comunque eseguire un'operazione di JOIN tra le tabelle, quindi l'indice clusterizzato non ha un impatto significativo sulle prestazioni.</p>
<p>Il piano di esecuzione fisico per eseguire il JOIN sceglie di eseguire un'operazione di Hash Join tra le tabelle "Classe" e "Scuola", utilizzando l'indice clusterizzato sulla colonna "Scuola" nella tabella "Classe" e l'indice clusterizzato sulla colonna "Cod_Meccanografico" nella tabella "Scuola".</p>
<p>Dopo aver eseguito l'operazione di Hash Join, il sistema esegue un'operazione di Hash Join tra le tabelle "Pianta" e "Classe", utilizzando l'indice clusterizzato sulla colonna "Classe" nella tabella "Pianta" e l'indice clusterizzato sulla colonna "IdClasse" nella tabella "Classe".</p>
<p>Infine, il sistema esegue un'operazione di Hash Join tra le tabelle "Pianta" e "Specie", utilizzando l'indice clusterizzato sulla colonna "Specie" nella tabella "Pianta" e l'indice clusterizzato sulla colonna "NomeSpecie" nella tabella "Specie".</p></div>
<div style="page-break-after: always;"></div>

## **Progettazione Fisica - Sicurezza**

### Controllo degli Accessi Gerarchia dei Ruoli
<div style="text-align: justify;">
<p>Il successivo elenco mostra la gerarchia dei ruoli in ordine decrescente di privilegi:</p>

1. **Amministratore** - Ruolo che ha tutti i privilegi (Admin - Gestore globale del Progetto).
2. **Referente** - Ruolo che ha i privilegi di gestione dei dati di una Scuola.
3. **Insegnante** - Ruolo che ha i privilegi di gestione dei dati di una Classe.
4. **Studente** - Ruolo che ha i privilegi di gestione dati di una Classe ma minori di **Insegnante**.
</div>

### **Tabella Privilegi**

<div style="width: 100%; font-size: 11px;">
<table style="width: 100%; margin: left 45%; position: relative">
<thead><tr><th>#</th><th>Admin</th><th>Referente</th><th>Insegnante</th><th>Studente</th></thead>
<tbody>
<tr><td>Persona</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Scuola</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Classe</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Studente</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Specie</td><td>ALL</td><td>SELECT, INSERT, UPDATE</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td>
<tr><td>Orto</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td><td>SELECT</td>
<tr><td>Pianta</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Esposizione</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Gruppo</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT</td>
<tr><td>Sensore</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE</td><td>SELECT</td>
<tr><td>Rilevazione</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE</td>
<tr><td>Dati</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT, UPDATE</td>
<tr><td>Responsabile</td><td>ALL</td><td>SELECT, INSERT, UPDATE, DELETE</td><td>SELECT, INSERT</td><td>SELECT</td>
</tbody>
</table>
</div>

**Nota:** ALL = SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER.

## Politica dei Privilegi
<div style="text-align: justify">
<p>Si è deciso di applicare la filosofia del minimo privilegio, ovvero assegnare ad ogni ruolo solo i privilegi necessari per svolgere il proprio lavoro.</p>
<p>

<ol type="1" style="text-align: left;">
  <li><b>Amministratore:</b> Ha accesso a tutti i dati del database e può eseguire tutte le operazioni.
  </li>
  <div style="page-break-after: always;"></div>
  <li><b>Referente:</b> Ha accesso ai dati della Scuola di cui è Referente e può eseguire tutte le operazioni su di essi.
    <ul>
      <li>Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Scuola di cui è Referente.</li>
      <li>Scritture: Cancellazione -> Solo su dati che riguardano le Piante e le Rilevazioni fatte dalla Scuola di cui è Referente.</li>
      <li>Letture: Visualizzazione -> Su tutti i dati che riguardano la Scuola di cui è Referente.</li>
      <li>Non può eseguire operazioni su dati di altre Scuole.</li>
    </ul>
  <li><b>Insegnante:</b> Ha accesso ai dati della Classe di cui è Insegnante e può eseguire tutte le operazioni su di essi.
    <ul>
      <li>Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Classe di cui è Insegnante.</li>
      <li>Scritture: Cancellazione -> Solo su dati che riguardano le Piante e le Rilevazioni fatte dalla Classe di cui è Insegnante.</li>
      <li>Letture: Visualizzazione -> Su tutti i dati che riguardano la Classe di cui è Insegnante.</li>
      <li>Può eseguire operazioni su dati di altre Classi della stessa Scuola ammesso che ne sia un Insegnante.</li>
    </ul>
  </li>
  <li><b>Studente:</b> Ha accesso ai dati della Classe di cui è Studente e può eseguire tutte le operazioni su di essi.
    <ul>
      <li>Scritture: Inserimento, Modifica -> Su tutti i dati che riguardano la Classe di cui è Studente.</li>
      <li>Scritture: Cancellazione -> Nessuno.</li>
      <li>Letture: Visualizzazione -> Su tutti i dati che riguardano la Classe di cui è Studente.</li>
      <li>Non può eseguire operazioni su dati di altre Classi.</li>
  </ul>
  </li>
</ol>
</div>