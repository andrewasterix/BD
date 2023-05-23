# Progetto di Base Dati 2023 - "Orti Scolastici" - 12 CFU

## Parte 1 - Requisiti e Progettazione Concettuale

## 1 - Descrizione del dominio applicativo

### 1.1 - Leggenda
- <font color="green">Verde</font> - Entità
- <font color="yellow">Giallo</font> - Attributo
- <font color="blue">Blu</font> - Attibuti composti
- <font color="purple">Viola</font> - Relazione
- <font color="orange">Arancione</font> - Vincoli
- <font color="red">Rosso</font> - Note di disambiguazione 

### 1.2 - Descrizione del dominio applicativo
<div style="text-align: justify;">

<p>Si vuole realizzare una base di dati a supporto dell’iniziativa di citizen science rivolta alle scuole “Dalla botanica ai big data” <font color="red">(che rappresenta l'intero scherma ER)</font>.</p>
<p>L’iniziativa mira a costruire una rete di supporto per le scuole che partecipano a <font color="green">progetti</font> <font color="red">(gli attributi verrano specificati sucessivamente)</font> relativi agli orti scolastici. Per ogni <font color="green">scuola</font> si vogliono memorizzare il <font color="yellow">nome dell’istituto scolastico</font>, il <font color="yellow">codice meccanografico</font>, la <font color="yellow">provincia</font>, il <font color="yellow">ciclo di istruzione</font> (primo o secondo ciclo di istruzione) e se l’istituto beneficia o meno di un <font color="yellow">finanziamento</font> <font color="red">(attributo dell'entità Progetti)</font> per <font color="purple">partecipare </font>all’iniziativa <font color="red">(relazione tra Scuola e Progetto)</font>, in tal caso ne memorizziamo il <font color="yellow">tipo</font> <font color="red">(attributo dell'entità Progetti)</font>.</p>
<p>Per ogni scuola c’è almeno una <font color="green">persona</font> di <font color="purple">riferimento</font> <font color="red">(relazione tra Progetto e Persona)</font> per l’iniziativa, ma <font color="orange">possono essercene diverse</font><font color="red"> (molteplicità sulla relazione precedente)</font>. Per ogni persona coinvolta vogliamo memorizzare <font color="yellow">nome</font>, <font color="yellow">cognome</font>, <font color="yellow">indirizzo di email</font>, <font color="orange">opzionalmente</font> <font color="red">(molteplicità sull'attributo)</font> un contatto <font color="yellow">telefonico</font> e il <font color="yellow">ruolo</font> <font color="orange">(dirigente, animatore digitale, docente, ...)</font>. Nel caso la scuola sia titolare di finanziamento per partecipare all’iniziativa (es. finanziamento per progetto PON EduGreen) si vuole memorizzare se la persona sia il <font color="purple">referente</font> <font color="red">(relazione tra Pesona e Progetto)</font> e un <font color="purple">partecipante</font> <font color="red"> (relazione tra Persona e Scuola)</font> al progetto da cui deriva il finanziamento. All’interno della scuola, possono esserci più <font color="green">classi</font> partecipanti all’iniziativa. Per ognuna di esse si vuole memorizzare la <font color="yellow">classe (es. 4E)</font> <font color="red">(indicato come Nome)</font>, <font color="yellow">l’ordine</font> (es. primaria, secondaria di primo grado) o il <font color="yellow">tipo di scuola</font> (es. liceo scienze applicate, agrario) e il <font color="purple">docente di riferimento per la partecipazione</font><font color="red">(relazione tra Persona e Classe)</font> di tale classe.</p>
<p>Ogni scuola <font color="purple">ha</font> <font color="red">(relazione tra Scuola e Orto)</font> <font color="orange">uno o più</font> <font color="red">(molteplicità sulla relazione precedente)</font> <font color="green">orti</font>, identificati da un <font color="yellow">nome</font> che identifica l’orto all’interno della scuola. Ogni orto può essere <font color="yellow">in pieno campo o in vaso</font> <font color="red">(indicati come attributo 'Collocazione')</font>, ed è caratterizzato da <font color="yellow">coordinate GPS</font> e una <font color="yellow">superficie</font> in mq. Si vuole inoltre memorizzare se le <font color="yellow">condizioni ambientali</font> dell’orto lo rendono adatto a fare da controllo per altri istituti (cioè se si trova in un contesto ambientale "pulito" e l’istituto è disposto a <font color="yellow">collaborare</font> <font color="red">(attributo di Scuola indicato come 'Collabora')</font> con altri).</p>
<p>Le piante vengono piantate con scopi di biomonitoraggio o fitobonifica. Con biomonitoraggio si intende il monitoraggio dell'inquinamento mediante organismi viventi. Le principali tecniche di biomonitoraggio consistono nell'uso di organismi bioaccumulatori per fornire informazioni sulla situazione ambientale. Fornisce stime sugli effetti combinati di più inquinanti sugli esseri viventi, ha costi di gestione limitati e consente di coprire vaste zone e territori diversificati, consentendo una adeguata mappatura del territorio. Con fitobonifica si intende l’utilizzo delle piante per disinquinare aria, acqua, sedimenti e suoli.</p>
<p>Si considerano un certo numero di <font color="green">specie</font> per i diversi <font color="yellow">scopi</font> e per ogni specie <font color="purple">vengono utilizzate</font> <font color="red">(relazione tra Specie e Pianta)</font> un certo numero di <font color="green">repliche</font> <font color="red">(indicata come entità 'Replica/Pianta')</font> (cioè esemplari veri e propri delle piante). In particolare, in caso di biomonitoraggio le repliche del <font color="green">gruppo</font> di <font color="yellow">controllo</font> <font color="red">(indicato come attributo  'Tipo')</font> (“nel pulito”) <font color="orange">dovranno essere lo stesso numero di quelle del gruppo per cui vogliamo monitorare lo stress ambientale</font>. Le repliche di controllo potranno essere dislocate in un orto a disposizione dello stesso istituto o in un orto messo a disposizione da altro istituto e andrà mantenuto il collegamento tra gruppo per cui si monitora lo stress ambientale e il corrispondente gruppo di controllo. In particolare, <font color="purple">ogni scuola dovrebbe concentrarsi</font> <font color="red">(relazione tra Orto e Specie)</font> su <font color="orange">tre specie</font> <font color="red">(indicato come molteplicità sulla relazione precedente)</font> e ogni gruppo <font color="purple">dovrebbe contenere</font> <font color="red">(relazione tra Gruppo e Replica/Pianta)</font> <font color="orange">20 repliche</font>.</p>
<p>Per ogni specifica <font color="green">pianta</font> <font color="red">(stessa entità di relazione, indicata come 'Replica/Pianta')</font> messa a dimora, verrà memorizzata la <font color="yellow">specie</font> <font color="red">(indicato dalla relazione tra Specie e Pianta)</font>, il <font color="yellow">numero di replica</font> <font color="red">(indicato come ID)</font>, il <font color="yellow">gruppo</font> <font color="red">(indicato dalla relazione tra Gruppo e Pianta)</font>, <font color="yellow">l’orto</font> <font color="red">(indicato dalla relazione tra Orto e Pianta)</font>, <font color="yellow">l’esposizione specifica</font>, la <font color="yellow">data di messa a dimora</font> e la <font color="yellow">classe</font> <font color="red">(indicato dalla relazione tra Classe e Pianta)</font> che l’ha messa a dimora.</p>
<p>Le <font color="green">rilevazioni</font> (osservazioni) <font color="purple">vengono effettuate</font> <font color="red">(relazione tra Pianta e Rilevazione)</font> sulle specifiche piante (repliche) e le informazioni acquisite memorizzate con <font color="yellow">data e ora della rilevazione</font>, <font color="yellow">data e ora dell’inserimento</font>, <font color="yellow">responsabile della rilevazione</font> <font color="red">(indicato dalla relazione tra Rilevazione e Perosna)</font> (può essere un individuo o una classe) e responsabile dell’inserimento (se diverso da quello della rilevazione e anche in questo caso può essere un individuo o una classe).</p>
<p>Le <font color="blue">informazioni ambientali relative a pH, umidità e temperatura</font> vengono acquisite mediante <font color="green">sensori o schede Arduino</font> <font color="red">(indicati come unica entità 'Sensore')</font>, si vogliono memorizzare <font color="yellow">numero</font> e <font color="yellow">tipo</font> di sensori presenti in ogni orto (e le repliche associate a quel sensore). Le informazioni possono essere rilevate tramite app e inserite nella base di dati oppure essere trasmesse direttamente da schede Arduino alla base di dati. Si vuole tenere traccia della <font color="yellow">modalità di acquisizione</font> delle informazioni.</p></div>

## 2 - Progettazione Concettuale

### 2.1 - Diagramma ER
![Modello ER - Non Ristrutturato](DiagrammaNonRistrutturato.svg "Modello ER non ristrutturato")

### 2.2 - Domini e Entità

| ENTITA' | DESCRIZIONE | ATTRIBUTI | DESCRIZIONE | DOMINIO |
|:---|:---|:---|:---|:---|
| Progetto | A cui la scuola partecipa | ID | Chiave primaria;<br> Identificativo | BIGINT
| |        | Finanziamento | Tipo di finanziamento se la Scuola ne beneficia |	TEXT
| |        | Nome | Indica il nome |	TEXT
| Scuola   | Indentifica la scuola | cod_Meccanografico | Chiave primaria; <br>Identifica il codice meccanografico della scuola | VARCHAR(10) |
| |        | Nome | Indica il nome della scuola | TEXT |
| |        | Ciclo_Istruzione | La scuola è del primo ciclo d’istruzione o il secondo | 1,2 |
| |        | Collabora | La scuola collabora con altre (True) o no (False) | BOOLEAN |
| |        | Provincia | Sigla della provincia di appartenza | CHAR(2) |
| |        | Comune | Comune dov’è la scuola | TEXT |
| Classe   | Indica le classi che aderiscono | Sezione | Chiave primaria<br> Nome della classe | CHAR(2) |
| |        | Ordine | Ordine della classe (primo, secondo); Opzionale | 1, 2|
| |        | Tipo   | Scientifico, Classico, Agrario, ... | TEXT |
| Persona  | Coloro che partecipano | Email | Chiave primaria;<br> Email della persona. | TEXT |
| |        | Nome   | Nome della persona | TEXT |
| |        | Cognome | Cognome della persona | TEXT |
| |        | Ruolo | Ruolo della persona | Dirigente, Docente, Finanziatore, Rilevatore Esterno |
| |        | Telefono | Numero di telefono; Opzionale | NUMERIC(10) |
| Orto     | Orti delle scuole partecipanti | Nome | Chiave primaria;<br> Nome dell'orto | TEXT |
| |        | Coordinate_GPS | Chiave primaria;<br>Coordinate GPS dell’orto (Latitudine, Longitudine) | DOUBLE, DOUBLE |
| |        | Condizione_Ambientale | Condizioni ambientali dell’orto (Pulito, Inquinato) | Pulito, Inquinato |
| |        | Collocazione | L'orto è in terra o in vaso. | Vaso, Terra |
| |        | Superficie_mq | Superficie in metri quadrati | DOUBLE |
| Specie   | Specie della pianta coltivata | Nome_Scientifico | Chiave primaria;<br> Nome della famiglia della pianta | TEXT |
| |        | Substrato | Tipo di terra in cui è coltivata la specie, terriccio da rinvaso o suolo pre-esistente | Terriccio_Rinvaso, Suolo_Pre-Esistente |
| Replica / Pianta   | Piante che vengono coltivate | Nome_Comune | Nome comune della pianta | TEXT |
| |        | Scopo | Scopo della specie, Fitobonifica o Biomonitoraggio. | Fitobonifica, Biomonitoraggio |
| |        | Data_Messa_A_Dimora | Data in cui è stata piantata una replica | DATE |
| |        | Esposizione | Esposizione della replica | Sole, Mezz’ombra, Ombra |
| |        | ID | Chiave Primaria; <br>Identificativo della replica della pianta | BIGINT |
| Gruppo   | Gruppo di piante per un determinato scopo | ID | Chiave primaria;<br> Identificatore del gruppo | BIGINT |
| |        | Tipo | Il gruppo è Pulito o Inquinato | Pulito, Inquinato |
| Rilevazione | Elenco dei dati registrati dai sensori sulle piante | ID | Chiave primaria;<br> Identificatore della rilevazione | BIGINT |
| |        | DataOra_Rilevazione | Data e Ora in cui viene eseguita la rilevazione | TIMESTAMP |
| |        | DataOra_Inserimento | Data e Ora in cui viene eseguito l’inserimento nella base di dati | TIMESTAMP |
| |        | Parametri del suolo | Attributo composto;<br> Informazioni riguardanti il suolo | Temperatura, PH, Umidità |
| |        | Altre Informazioni | Attributo composto;<br> Altre informazioni riguardanti le piante | Danni, Fioritura, Biomassa, Dtruttura, Fruttificazione |
| Sensore  | Sensori per le rilevazioni | ID | Chiave primaria;<br> Identificatore univoco | BIGINT              |
| |        | Tipo | Tipo del sensore: SchedaArduino o Sensore| SchedaArduino, Sensore |
| |        | Acquisizione  | Tipo di acquisizione delle informazioni | Arduino, App |

### 2.3 - Associazioni

| ASSOCIAZIONE | DESCRIZIONE |
|:---|:---|
| Rappresentata | La classe è rappresentata da un docente |
| Coltiva | La classe coltiva delle piante |
| Afferisce | La classe fa parte di una scuola |
| Appartiene | Persone lavorano e/o appartengono alla scuola |
| Iscritta | La scuola è iscritta a uno o più progetti |
| Utilizza | La scuola utilizza un orto di un’altra scuola |
| Possiede | La scuola possiede un orto |
| Partecipa | Una persona partecipa al progetto, con un determinato ruolo |
| Responsabile | Una persona è responsabile della rilevazione |
| Contiene | Nell’orto sono contenute diverse specie di piante |
| Ospitate | Nell’orto sono messe a dimora delle piante |
| Include | Una specie include diversi piante |
| Contenuta | Le piante sono contenute in al massimo 2 diversi gruppi |
| Effettuata | Sulle piante/repliche sono effettuate delle rilevazioni |
| Rilevata | I sensiori fanno le rilevazioni dei dati |

### 2.4 - Vincoli

| ENTITÀ | VINCOLO | TIPO SQL |
|:---|:---|:---|
| Progetto | Se la scuola riceve un finanziamento per un progetto, si memorizzerà una Persona con ruolo "Referente" | [TRIGGER] |
| Orto | Se l'orto della scuola ha come Condizione Ambientale "Pulito", allora può essere adatto per fare da controllo per orti di altre scuole | [CHECK] |
| Scuola | Se la scuola utilizza un orto con Condizione Ambientale "Pulito", allora può essere collaborare con altre scuole | [CHECK] |
| Replica \ Pianta | Se lo Scopo è "Biomonitoraggio" allora il Numero di Repliche del Gruppo di Controllo devono essere uguali a quelle del Gruppo di Monitoraggio | [CHECK] |
| Rilevamento | Se il responsabile dell'Inserimento è diverso da quello della Rilevazione allora dobbiamo inserire due Persone o Classi per la stessa rilevazione. | [TRIGGER] |

### 2.5 - Generalizzazioni

Non sono presenti generalizzazioni.

## 3 - Progettazione Logica

### 3.1 - Schema Relazionale Ristrutturato

![Modello ER - Ristrutturato](DiagrammaRistrutturato.svg "Modello ER ristrutturato")

### 3.2 - Modifiche ad Entità, Associazioni e Vincoli

Nella Ristrutturazione del modello ER sono state apportate le seguenti modifiche:
- L'attributo multiplo "Ruolo" dell'entità Persona è stato sostituito con l'entità Ruolo, in modo da evitare la ripetizione di valori, ed è stato aggiunto l'attributo "Tipo" per descrivere meglio il tipo ruolo.
- L'attributo multiplo "Parametri del suolo" dell'entità Rilevazione è stato sostituito con attributi singoli direttamente sull'entità:
    - Temperatura
    - PH
    - Umidità
- L'attributo multiplo "Altre" dell'entità Rilevazione è stato sostituito con attributi singoli direttamente sull'entità:
    - Danni
    - Fioritura
    - Biomassa
    - Distruttura
    - Fruttificazione
- L'attributo multiplo "Esposizione" dell'entità Replica/Pianta è stato sostituito con attributi singoli direttamente sull'entità:
    - Sole
    - Mezz'ombra
    - Ombra

### 3.3 - Modifiche ai Vincoli

//TODO - Verificare possibili cambiamenti ai vincoli

### 3.4 - Modifiche alle generalizzazioni

Non erano presenti generalizzazioni nello scheam concettuale, quindi non sono state apportate conseguenti modifiche.

### 3.5 - Schema Logico

- Classe(<u>Sezione</u>, <u>cod_Meccanografico</u><sup>cod_Meccanografico</sup>, Ordine, TipoScuola)
- Scuola(<u>cod_Meccanografico</u>, NomeScuola, Ciclo_istruzione, Collabora<sub>o</sub>, Provincia, Comune)
- Progetto(<u>ID</u>, Finanziamento<sub>o</sub>, Nome)
- Persona(<u>Email</u>, Telefono<sub>o</sub>, Nome, Cognome)
- Ruolo(Tipo)
- Orto(<u>Nome</U>, <u>Coordinate_GPS</u>, Superficie_mq, Posizione, Condinzione_Ambientale)
- Specie(<u>Nome_Scientifico</U>, Substrato)
- Pianta(<u>ID</u>, Nome_Comune, Data_Messa_A_Dimora, Scopo, Sole<sub>o</sub>, Mezz’ombra<sub>o</sub>, Ombra<sub>o</sub>)
- Gruppo(<u>ID</u>, Tipo)
- Rilevazione(<u>ID</u>, DataOra_Inserimento, DataOra_Rilevazione, Temperatura, Umidità, Ph, Danni, Fioritura, Biomassa, Struttura, Fruttificazione)
- Sensore(<u>ID</u>, Tipo, Acquisizione)


### 3.6 - Verifica della correttezza e della qualità dello schema logico e del modello ER ristrutturato