
# Progetto di Base Dati 2023 - "Orti Scolastici" - 12 CFU

## Componenti del Gruppo

- Andrea Franceschetti - 4357070
- William Chen -
- Alessio De Vincenzi - 4878315

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
    