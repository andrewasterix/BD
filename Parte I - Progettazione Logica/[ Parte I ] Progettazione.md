# Progetto di Base Dati 2023 - "Orti Scolastici" - 12 CFU

## Componenti del Gruppo

- Andrea Franceschetti - 4357070
- William Chen -
- Alessio De Vincenzi - 4878315

## Parte 1 - Requisiti e Progettazione Concettuale

### 1 - Descrizione del dominio applicativo

### 1.1 - Leggenda

<ul>
  <li> <font color="#539165">Verde </font> - Entità </li>
  <li> <font color="#F7C04A">Giallo </font> - Attributo </li>
  <li> <font color="#6495ED">Blu </font> - Attibuti composti </li>
  <li> <font color="#FF00FF">Viola </font> - Relazione </li>
  <li> <font color="#FF7F50">Arancione </font> - Vincoli </li>
  <li> <font color="#DE3163">Rosso </font> - Note di disambiguazione </li>
</ul>

### 1.2 - Descrizione del dominio applicativo

<div style="text-align: justify;">
<p>Si vuole realizzare una base di dati a supporto dell’iniziativa di citizen science rivolta alle scuole “Dalla botanica ai big data” <font color="#DE3163">(che rappresenta l'intero scherma ER)</font>.</p>
<p>L’iniziativa mira a costruire una rete di supporto per le scuole che partecipano a <font color="#539165">progetti</font> <font color="#DE3163">(gli attributi verrano specificati sucessivamente)</font> relativi agli orti scolastici. Per ogni <font color="#539165">scuola</font> si vogliono memorizzare il <font color="#F7C04A">nome dell’istituto scolastico</font>, il <font color="#F7C04A">codice meccanografico</font>, la <font color="#F7C04A">provincia</font>, il <font color="#F7C04A">ciclo di istruzione</font> (primo o secondo ciclo di istruzione) e se l’istituto beneficia o meno di un <font color="#F7C04A">finanziamento</font> <font color="#DE3163">(attributo dell'entità Progetti)</font> per <font color="#FF00FF">partecipare </font>all’iniziativa <font color="#DE3163">(relazione tra Scuola e Progetto)</font>, in tal caso ne memorizziamo il <font color="#F7C04A">tipo</font> <font color="#DE3163">(attributo dell'entità Progetti)</font>.</p>
<p>Per ogni scuola c’è almeno una <font color="#539165">persona</font> di <font color="#FF00FF">riferimento</font> <font color="#DE3163">(relazione tra Progetto e Persona)</font> per l’iniziativa, ma <font color="#FF7F50">possono essercene diverse</font><font color="#DE3163"> (molteplicità sulla relazione precedente)</font>. Per ogni persona coinvolta vogliamo memorizzare <font color="#F7C04A">nome</font>, <font color="#F7C04A">cognome</font>, <font color="#F7C04A">indirizzo di email</font>, <font color="#FF7F50">opzionalmente</font> <font color="#DE3163">(molteplicità sull'attributo)</font> un contatto <font color="#F7C04A">telefonico</font> e il <font color="#F7C04A">ruolo</font> <font color="#FF7F50">(dirigente, animatore digitale, docente, ...)</font>. Nel caso la scuola sia titolare di finanziamento per partecipare all’iniziativa (es. finanziamento per progetto PON EduGreen) si vuole memorizzare se la persona sia il <font color="#FF00FF">referente</font> <font color="#DE3163">(relazione tra Pesona e Progetto)</font> e un <font color="#FF00FF">partecipante</font> <font color="#DE3163"> (relazione tra Persona e Scuola)</font> al progetto da cui deriva il finanziamento. All’interno della scuola, possono esserci più <font color="#539165">classi</font> partecipanti all’iniziativa. Per ognuna di esse si vuole memorizzare la <font color="#F7C04A">classe (es. 4E)</font> <font color="#DE3163">(indicato come Nome)</font>, <font color="#F7C04A">l’ordine</font> (es. primaria, secondaria di primo grado) o il <font color="#F7C04A">tipo di scuola</font> (es. liceo scienze applicate, agrario) e il <font color="#FF00FF">docente di riferimento per la partecipazione</font> <font color="#DE3163">(relazione tra Persona e Classe)</font> di tale classe.</p>
<p>Ogni scuola <font color="#FF00FF">ha</font> <font color="#DE3163">(relazione tra Scuola e Orto)</font> <font color="#FF7F50">uno o più</font> <font color="#DE3163">(molteplicità sulla relazione precedente)</font> <font color="#539165">orti</font>, identificati da un <font color="#F7C04A">nome</font> che identifica l’orto all’interno della scuola. Ogni orto può essere <font color="#F7C04A">in pieno campo o in vaso</font> <font color="#DE3163">(indicati come attributo 'Collocazione')</font>, ed è caratterizzato da <font color="#F7C04A">coordinate GPS</font> e una <font color="#F7C04A">superficie</font> in mq. Si vuole inoltre memorizzare se le <font color="#F7C04A">condizioni ambientali</font> dell’orto lo rendono adatto a fare da controllo per altri istituti (cioè se si trova in un contesto ambientale "pulito" e l’istituto è disposto a <font color="#F7C04A">collaborare</font> <font color="#DE3163">(attributo di Scuola indicato come 'Collabora')</font> con altri).</p>
<p>Le piante vengono piantate con scopi di biomonitoraggio o fitobonifica. Con biomonitoraggio si intende il monitoraggio dell'inquinamento mediante organismi viventi. Le principali tecniche di biomonitoraggio consistono nell'uso di organismi bioaccumulatori per fornire informazioni sulla situazione ambientale. Fornisce stime sugli effetti combinati di più inquinanti sugli esseri viventi, ha costi di gestione limitati e consente di coprire vaste zone e territori diversificati, consentendo una adeguata mappatura del territorio. Con fitobonifica si intende l’utilizzo delle piante per disinquinare aria, acqua, sedimenti e suoli.</p>
<p>Si considerano un certo numero di <font color="#539165">specie</font> per i diversi <font color="#F7C04A">scopi</font> e per ogni specie <font color="#FF00FF">vengono utilizzate</font> <font color="#DE3163">(relazione tra Specie e Pianta)</font> un certo numero di <font color="#539165">repliche</font> <font color="#DE3163">(indicata come entità 'Pianta')</font> (cioè esemplari veri e propri delle piante). In particolare, in caso di biomonitoraggio le repliche del <font color="#539165">gruppo</font> di <font color="#F7C04A">controllo</font> <font color="#DE3163">(indicato come attributo  'Tipo')</font> (“nel pulito”) <font color="#FF7F50">dovranno essere lo stesso numero di quelle del gruppo per cui vogliamo monitorare lo stress ambientale</font>. Le repliche di controllo potranno essere dislocate in un orto a disposizione dello stesso istituto o in un orto messo a disposizione da altro istituto e andrà mantenuto il collegamento tra gruppo per cui si monitora lo stress ambientale e il corrispondente gruppo di controllo. In particolare, <font color="#FF00FF">ogni scuola dovrebbe concentrarsi</font> <font color="#DE3163">(relazione tra Orto e Specie)</font> su <font color="#FF7F50">tre specie</font> <font color="#DE3163">(indicato come molteplicità sulla relazione precedente)</font> e ogni gruppo <font color="#FF00FF">dovrebbe contenere</font> <font color="#DE3163">(relazione tra Gruppo e Pianta)</font> <font color="#FF7F50">20 repliche</font>.</p>
<p>Per ogni specifica <font color="#539165">pianta</font> <font color="#DE3163">(stessa entità di relazione, indicata come 'Pianta')</font> messa a dimora, verrà memorizzata la <font color="#F7C04A">specie</font> <font color="#DE3163">(indicato dalla relazione tra Specie e Pianta)</font>, il <font color="#F7C04A">numero di replica</font> <font color="#DE3163">(indicato come ID)</font>, il <font color="#F7C04A">gruppo</font> <font color="#DE3163">(indicato dalla relazione tra Gruppo e Pianta)</font>, <font color="#F7C04A">l’orto</font> <font color="#DE3163">(indicato dalla relazione tra Orto e Pianta)</font>, <font color="#F7C04A">l’esposizione specifica</font>, la <font color="#F7C04A">data di messa a dimora</font> e la <font color="#F7C04A">classe</font> <font color="#DE3163">(indicato dalla relazione tra Classe e Pianta)</font> che l’ha messa a dimora.</p>
<p>Le <font color="#539165">rilevazioni</font> (osservazioni) <font color="#FF00FF">vengono effettuate</font> <font color="#DE3163">(relazione tra Pianta e Rilevazione)</font> sulle specifiche piante (repliche) e le informazioni acquisite memorizzate con <font color="#F7C04A">data e ora della rilevazione</font>, <font color="#F7C04A">data e ora dell’inserimento</font>, <font color="#F7C04A">responsabile della rilevazione</font> <font color="#DE3163">(indicato dalla relazione tra Rilevazione e Perosna)</font> (può essere un individuo o una classe) e responsabile dell’inserimento (se diverso da quello della rilevazione e anche in questo caso può essere un individuo o una classe).</p>
<p>Le <font color="#6495ED">informazioni ambientali relative a pH, umidità e temperatura</font> vengono acquisite mediante <font color="#539165">sensori o schede Arduino</font> <font color="#DE3163">(indicati come unica entità 'Sensore')</font>, si vogliono memorizzare <font color="#F7C04A">numero</font> e <font color="#F7C04A">tipo</font> di sensori presenti in ogni orto (e le repliche associate a quel sensore). Le informazioni possono essere rilevate tramite app e inserite nella base di dati oppure essere trasmesse direttamente da schede Arduino alla base di dati. Si vuole tenere traccia della <font color="#F7C04A">modalità di acquisizione</font> delle informazioni.</p></div>

## 2 - Progettazione Concettuale

### 2.1 - Diagramma ER

![Modello ER - Non Ristrutturato](DiagrammaNonRistrutturato.jpg "Modello ER non ristrutturato")

### 2.2 - Domini e Entità

| #  | ENTITA'     | DESCRIZIONE                               | ATTRIBUTI             | DESCRIZIONE                                                                             | DOMINIO                                                |
| :- | :---------- | :---------------------------------------- | :-------------------- | :-------------------------------------------------------------------------------------- | :----------------------------------------------------- |
| 1  | Progetto    | A cui la scuola partecipa                 | ID                    | Chiave primaria;<br />Identificativo                                                    | BIGINT                                                 |
|    |             |                                           | Finanziamento         | Tipo di finanziamento se la Scuola ne beneficia                                         | TEXT                                                   |
|    |             |                                           | Nome                  | Indica il nome                                                                          | TEXT                                                   |
| 2  | Scuola      | Indentifica la scuola                     | cod_Meccanografico    | Chiave primaria;<br />Identifica il codice meccanografico della scuola                  | VARCHAR(10)                                            |
|    |             |                                           | Nome                  | Indica il nome della scuola                                                             | TEXT                                                   |
|    |             |                                           | Ciclo_Istruzione      | La scuola è del primo ciclo d’istruzione o il secondo                                 | Primo, Secondo                                         |
|    |             |                                           | Collabora             | La scuola collabora con altre (True) o no (False)                                       | BOOLEAN                                                |
|    |             |                                           | Provincia             | Sigla della provincia di appartenza                                                     | CHAR(2)                                                |
|    |             |                                           | Comune                | Comune dov'è la scuola                                                                 | TEXT                                                   |
| 3  | Classe      | Indica le classi che aderiscono           | Sezione               | Chiave primaria;<br />Nome della classe es. 4E,4ART,4E-I                                | VARCHAR(5)                                             |
|    |             |                                           | Ordine                | Ordine della classe (primo, secondo); Opzionale                                         | 1, 2                                                   |
|    |             |                                           | Tipo                  | Scientifico, Classico, Agrario, ...                                                     | TEXT                                                   |
| 4  | Persona     | Coloro che partecipano                    | Email                 | Chiave primaria;<br /> Email della persona.                                             | TEXT                                                   |
|    |             |                                           | Nome                  | Nome della persona                                                                      | TEXT                                                   |
|    |             |                                           | Cognome               | Cognome della persona                                                                   | TEXT                                                   |
|    |             |                                           | Ruolo                 | Ruolo della persona                                                                     | Dirigente, Docente, Referente, Rilevatore Esterno      |
|    |             |                                           | Telefono              | Numero di telefono; Opzionale                                                           | NUMERIC(10)                                            |
| 5  | Orto        | Orti delle scuole partecipanti            | Nome                  | Chiave primaria;<br />Nome dell'orto                                                    | TEXT                                                   |
|    |             |                                           | Coordinate_GPS        | Chiave primaria;<br />Coordinate GPS dell'orto (Latitudine, Longitudine)                | FLOAT, FLOAT                                           |
|    |             |                                           | Condizione_Ambientale | Condizioni ambientali dell'orto (Pulito, Inquinato)                                     | Pulito, Inquinato                                      |
|    |             |                                           | Collocazione          | L'orto è in terra o in vaso.                                                           | Vaso, Terra                                            |
|    |             |                                           | Superficie_mq         | Superficie in metri quadrati                                                            | FLOAT                                                  |
| 6  | Specie      | Specie della pianta coltivata             | Nome_Scientifico      | Chiave primaria;<br />Nome della famiglia della pianta                                  | TEXT                                                   |
|    |             |                                           | Substrato             | Tipo di terra in cui è coltivata la specie, terriccio da rinvaso o suolo pre-esistente | Terriccio_Rinvaso, Suolo_Pre-Esistente                 |
| 7  | Pianta      | Piante che vengono coltivate              | Nome_Comune           | Nome comune della pianta                                                                | TEXT                                                   |
|    |             |                                           | Scopo                 | Chiave Primaria;<br />Scopo della specie, Fitobonifica o Biomonitoraggio.               | Fitobonifica, Biomonitoraggio                          |
|    |             |                                           | Data_Messa_A_Dimora   | Data in cui è stata piantata una replica                                               | DATE                                                   |
|    |             |                                           | Esposizione           | Esposizione della replica                                                               | Sole, Mezz’ombra, Ombra                               |
|    |             |                                           | Numero_Replica        | Chiave Primaria;<br />Identificativo della replica della pianta                         | BIGINT                                                 |
| 8  | Gruppo      | Gruppo di piante per un determinato scopo | ID                    | Chiave primaria;<br />Identificatore del gruppo                                         | BIGINT                                                 |
|    |             |                                           | Tipo                  | Il gruppo è Pulito o Inquinato                                                         | Controllo, Stress_Ambientale                           |
| 9  | Rilevazione | Elenco dei dati registrati dai sensori    | ID                    | Chiave primaria;<br />Identificatore della rilevazione                                  | BIGINT                                                 |
|    |             |                                           | DataOra_Rilevazione   | Data e Ora in cui viene eseguita la rilevazione                                         | TIMESTAMP                                              |
|    |             |                                           | DataOra_Inserimento   | Data e Ora in cui viene eseguito l'inserimento nella base di dati                       | TIMESTAMP                                              |
|    |             |                                           | Parametri del suolo   | Attributo composto;<br />Informazioni riguardanti il suolo                              | Temperatura, PH, Umidità                              |
|    |             |                                           | Altre Informazioni    | Attributo composto;<br />Altre informazioni riguardanti le piante                       | Danni, Fioritura, Biomassa, Dtruttura, Fruttificazione |
| 10 | Rilevatore  | Responsabile della rilevazione            | ID_Rilevazione        | Chiave primaria;<br />ID della rilevazione di riferimento                               | BIGINT                                                 |
| 11 | Sensore     | Sensori per le rilevazioni                | ID                    | Chiave primaria;<br />Identificatore univoco                                            | BIGINT                                                 |
|    |             |                                           | Tipo                  | Tipo del sensore: SchedaArduino o Sensore                                               | SchedaArduino, Sensore                                 |
|    |             |                                           | Acquisizione          | Tipo di acquisizione delle informazioni                                                 | Arduino, App                                           |

### 2.3 - Associazioni

| #  | ASSOCIAZIONE  | DESCRIZIONE                                                 | ENTITA'                 | MOLTEPLICITA' |
| :- | :------------ | :---------------------------------------------------------- | :---------------------- | :-----------: |
| 1  | Rappresentata | La classe è rappresentata da un docente                    | Classe, Persona         |   1:1 - 0:1   |
| 2  | Coltiva       | La classe coltiva delle piante                              | Classe, Pianta          |   1:N - 1:1   |
| 3  | Afferisce     | La classe fa parte di una scuola                            | Classe, Scuola          |   1:1 - 1:N   |
| 4  | Appartiene    | Persone lavorano e/o appartengono alla scuola               | Persona, Scuola         |   0:1 - 1:N   |
| 5  | Iscritta      | La scuola è iscritta a uno o più progetti                 | Scuola, Progetto        |   1:N - 1:N   |
| 6  | Utilizza      | La scuola utilizza un orto di un’altra scuola              | Scuola, Orto            |   1:N - 0:N   |
| 7  | Possiede      | La scuola possiede un orto                                  | Scuola, Orto            |   1:N - 1,1   |
| 8  | Partecipa     | Una persona partecipa al progetto, con un determinato ruolo | Persona, Progetto       |   0:N - 1:N   |
| 9  | Responsabile  | Una persona è responsabile della rilevazione               | Persona, Rilevazione    |   0:N - 1:2   |
| 10 | Contiene      | Nell’orto sono contenute diverse specie di piante          | Orto, Specie            |   1:3 - 1:N   |
| 11 | Ospitate      | Nell’orto sono messe a dimora delle piante                 | Orto, Pianta            |   1:N - 1:1   |
| 12 | Include       | Una specie include diversi piante                           | Specie, Pianta          |   1:N - 1:1   |
| 13 | Contenuta     | Le piante sono contenute in al massimo 2 diversi gruppi     | Pianta, Gruppo          |  1:1 - 1:20  |
| 14 | Effettuata    | Sulle piante/repliche sono effettuate delle rilevazioni     | Pianta, Rilevazione     |   1:N - 1:N   |
| 15 | Rilevata      | I sensiori fanno le rilevazioni dei dati                    | Sensore, Rilevazione    |   1:N - 1:N   |
| 16 | Identificato  | La persona fa Rileva o Inserisce i dati                     | Persona, Responsabile   |   0:N - 0:2   |
| 17 | Esegue        | Rilevatore esegue la rilevazione                            | Rilevatore, Rilevazione |   1:1 - 1:2   |

### 2.4 - Vincoli

| # | ENTITÀ     | VINCOLO                                                                                                                                             | TIPO SQL  |
| :- | :---------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| 1 | Progetto    | Se la scuola riceve un finanziamento per un progetto, si memorizzerà una Persona con ruolo "Referente"                                             | [TRIGGER] |
| 2 | Orto        | Se l'orto della scuola ha come Condizione Ambientale "Pulito", allora può essere adatto per fare da controllo per orti di altre scuole             | [CHECK]   |
| 3 | Scuola      | Se la scuola utilizza un orto con Condizione Ambientale "Pulito", allora può essere collaborare con altre scuole                                   | [CHECK]   |
| 4 | Pianta      | Se lo Scopo è "Biomonitoraggio" allora il Numero di Repliche del Gruppo di Controllo devono essere uguali a quelle del Gruppo di Monitoraggio      | [CHECK]   |
| 5 | Rilevamento | Se il responsabile dell'Inserimento è diverso da quello della Rilevazione allora dobbiamo inserire due Persone o Classi per la stessa rilevazione. | [TRIGGER] |

### 2.5 - Generalizzazioni

Esite una generalizzazione per l'entità Responsabile, che può essere Responsabile di Rilevazione o Responsabile di Inserimento.

## 3 - Progettazione Logica

### 3.1 - Schema Relazionale Ristrutturato

![Modello ER - Ristrutturato](DiagrammaRistrutturato.jpg "Modello ER ristrutturato")

### 3.2 - Modifiche ad Entità, Associazioni e Vincoli

Nella Ristrutturazione del modello ER sono state apportate le seguenti modifiche:

- L'attributo multiplo "Ruolo" dell'entità Persona è stato sostituito con l'entità Ruolo, in modo da evitare la ripetizione di valori, ed è stato aggiunto l'attributo "Tipo" per descrivere meglio il tipo ruolo.
- Gli atributi multipli "Parametri del suolo" e "Altre Informazioni" sono stati sostituiti dall'entità "Dati" e nuovi attributi più espicativi:

  - ID
  - Temperatura
  - PH
  - Umidità
  - N_Foglie_Danneggiate
  - %_Superficie_Foglie_Danneggiate
  - N_Frutti
  - N_Fiori
  - Altezza_Pianta
  - Lunghezza_Radice
- L'attributo multiplo "Esposizione" dell'entità Pianta è stato sostituito con entità singola con attributo composto Nome_Comune, Numero_Replica (derivato da Pianta, ed è chiave) e l'attributo Tipo (Sole, Mezzombra, Ombra).

### 3.3 - Modifiche ai Vincoli

Non sto state effettuate modifiche ai vincoli precedenti.

### 3.4 - Modifiche alle generalizzazioni

La generalizzazione per l'entità Responsabile è stata riorganizzata aggiungendo due attibruti alla stessa entità.

### 3.5 - Schema Logico

<ol type="1" style="text-align: left;">
  <li> Progetto (<u>ID</u>, Finanziamento<sub>O</sub>, Nome) </li>
  <li> Persona (<u>Email</u>, Nome, Cognome, Telefono<sub>O</sub>, RilevatoreEsterno<sub>O</sub>)</li>  
  <li> Scuola (<u>cod_Meccanografico</u>, Nome, Ciclo_istruzione, Comune, Provincia, Collabora<sub>O</sub>, Dirigente<sup>Persona</sup>) </li>
  <li> Aderisce (<u>Scuola</u><sup>Scuola</sup>, <u>Progetto</u><sup>Progetto</sup>, Referente<sup>Persona</sup>)</li>
  <br>
  <li> Classe (<u>ID</u>, <i>Sezione</i>, <i>Scuola</i><sup><i>Scuola</i></sup>, Ordine, TipoScuola, Docente<sup>Persona</sup>)</li>
  <li> Studente (<u>Alunno</u><sup>Persona</sup>, Classe<sup>Classe</sup>)</li>
  <br>
  <li> Specie (<u>Nome_Scientifico</u>, Substrato)</li>
  <li> Orto (<u>Nome</u>, <u>Latitudine</u>, <u>Longitudine</u>, Superficie_mq, Posizione, CondizioneAmbientale, Scuola<sup>Scuola</sup>, Specie<sup>Specie</sup>)</li>
  <li> Pianta (<u>NumeroReplica</u>, <u>NomeComune</u>, DataMessaADimora, Scopo, Specie<sup>Specie</sup>, Classe<sup>Classe</sup>)</li>
  <li> Gruppo (<u>ID</u>, Tipo, Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>)</li>
  <li> Esposizione (Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>, Tipo)</li>
  <br>
  <li> Rilevazione (<u>ID</u>, DataOra_Inserimento, DataOra_Rilevazione, Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>)</li>
  <li> Sensore (<u>ID</u>, Tipo, Acquisizione, ID_Rilevazione<sup>Rilevazione</sup>)</li>
  <li> Dati (<u>ID</u><sup>Rilevazione</sup>, Temperatura, PH, Umidità, N_Foglie_Danneggiate, %_Superficie_Foglie_Danneggiate, N_Frutti<sub>O</sub>, N_Fiori, Altezza_Pianta, Lunghezza_Radice)</li>
  <li> Responsabile (<u>ID</u><sup>Rilevazione</sup>, Inserimento<sub>O</sub><sup>Persona</sup>, Rilevatore<sup>Persona</sup>, Inserimento<sub>O</sub><sup>Classe</sup>, Rilevatore<sup>Classe</sup>)</li>
</ol>

### 3.6 - Verifica della correttezza e della qualità dello schema logico e del modello ER ristrutturato

<div style="text-align: left;">
<b>Progetto (<u>ID</u>, Finanziamento<sub>O </sub>, Nome)</b><br>
ID -> Finanziamento, Nome;<br>
La relazione è <b>BCNF</b> dato che la chiave è unica e compare a sinistra.<br>
<br>
<b>Scuola (<u>cod_Meccanografico</u>, NomeScuola, Ciclo_istruzione, Collabora<sub>O</sub>, Provincia, Comune, Progetto<sup>Progetto</sup>)</b><br>
cod_Meccanografico -> NomeScuola, Ciclo_istruzione; <br>
... <br>
cod_Meccanografico -> NomeScuola, Ciclo_istruzione, Collabora<sub>O</sub>, Provincia, Comune, Progetto<sup>Progetto</sup>;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Persona (<u>Email</u>, Telefono<sub>O</sub>, Nome, Cognome)</b><br>
Email -> Nome, Cognome, Telefono;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Ruolo (<u>Email</u><sup>Persona</sup>,Tipo)</b><br>
Email -> Tipo;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Classe (<u>Sezione</u>, <u>cod_Meccanografico</u><sup>Scuola</sup>, Ordine, TipoScuola, Docente<sup>Persona</sup>)</b><br>
Sezione, cod_Meccanografico -> Ordine, TipoScuola;<br>
...<br>
Sezione, cod_Meccanografico -> Ordine, TipoScuola, Docente<sup>Persona</sup>;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Specie (<u>Nome_Scientifico</u>, Substrato)</b><br>
Nome_Scientifico -> Substrato;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Orto (<u>Nome</u>, <u>Coordinate_GPS</u>, Superficie_mq, Posizione, Condinzione_Ambientale, Scuola<sup>Scuola</sup>, Specie<sup>Specie</sup>)</b><br>
Nome, Coordinate_GPS -> Superficie_mq, Posizione;<br>
...<br>
Nome, Coordinate_GPS -> Superficie_mq, Posizione, Condinzione_Ambientale, Scuola<sup>Scuola</sup>, Specie<sup>Specie</sup>;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Pianta (<u>Numero_Replica</u>, <u>Nome_Comune</u>, Data_Messa_A_Dimora, Scopo, Specie<sup>Specie</sup>, Classe<sup>Classe</sup>, Scuola<sup>Classe</sup>)</b><br>
Numero_Replica, Nome_Comune -> Data_Messa_A_Dimora, Scopo, Specie, Classe, Scuola;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Gruppo (<u>ID</u>, Tipo, Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>)</b><br>
ID -> Tipo, Pianta, NumeroReplica;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Esposizione (Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>, Tipo)</b><br>
Pianta, NumeroReplica -> Tipo;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Rilevazione (<u>ID</u>, DataOra_Inserimento, DataOra_Rilevazione, Pianta<sup>Pianta</sup>, NumeroReplica<sup>Pianta</sup>)</b><br>
ID -> DataOra_Inserimento, DataOra_Rilevazione;<br>
...<br>
ID -> DataOra_Inserimento, DataOra_Rilevazione, Pianta, NumeroReplica;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Sensore (<u>ID</u>, Tipo, Acquisizione, ID_Rilevazione<sup>Rilevazione</sup>)</b><br>
ID -> Tipo, Acquisizione, ID_Rilevazione;<br>
La relazione è <b>BCNF</b>, l'unica chiave possibile è chiave primaria della Relazione.<br>
<br>
<b>Dati (<u>ID</u><sup>Rilevazione</sup>, Temperatura, PH, Umidità, N_Foglie_Danneggiate, %_Superficie_Foglie_Danneggiate, N_Frutti<sub>O</sub>, N_Fiori, Altezza_Pianta, Lunghezza_Radice)</b><br>
ID -> Temperatura, PH, Umidità;<br>
...<br>
ID -> Temperatura, PH, Umidità, N_Foglie_Danneggiate, %_Superficie_Foglie_Danneggiate, N_Frutti, N_Fiori, Altezza_Pianta, Lunghezza_Radice;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Responsabile (<u>ID</u><sup>Rilevazione</sup>, Inserimento<sub>O</sub><sup>Persona</sup>, Rilevatore<sup>Persona</sup>)</b><br>
ID -> Inserimento, Rilevatore;<br>
La relazione è <b>BCNF</b>, dato che la chiave compare a sinistra.<br>
<br>
<b>Tutte le relazioni sono in forma normale di Boyce-Codd, e tutte sono in terza forma normale.</b>
</div>
