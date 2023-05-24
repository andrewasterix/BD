create schema "OrtiScolastici";
set search_path to "OrtiScolastici";
set datestyle to "MDY";


CREATE TABLE Progetto(
    id_progetto BIGINT NOT NULL,
    nome_progetto TEXT NOT NULL,
    finanziamento TEXT NOT NULL,
    referente REFERENCES Persona(email),
    scuola REFERENCES Scuola(codice_mecanografico),
    PRIMARY KEY (id_progetto),
);

CREATE TABLE Scuola (
    codice_mecanografico CHAR (25) NOT NULL, 	
    nome_scuola CHAR(25) NOT NULL,
	provincia TEXT (2) NOT NULL,
	comune TEXT (25) NOT NULL,
    ciclo_istruzione TEXT (25) NOT NULL CHECK (ciclo_istruzione IN ('Primo','Secondo')),
    collabora BOOLEAN NOT NULL,
    progetto REFERENCES Progetto(id_progetto),
    possiede REFERENCES Orto(nome_orto),
    utilizza REFERENCES Orto(nome_orto),

	PRIMARY KEY (codice_mecanografico),
	UNIQUE (codice_mecanografico)
);


CREATE TABLE Persona(
    email TEXT,
    nome TEXT,
    cognome TEXT,
    telefono BIGINT,
    scuola REFERENCES Scuola(codice_mecanografico),
    ruolo REFERENCES Ruolo(Tipo_ruolo),

	PRIMARY KEY (email)
);

CREATE TABLE Ruolo(
    Tipo_ruolo TEXT NOT NULL CHECK (Tipo_ruolo IN ('Docente','Referente','Rilevatore Esterno')),
)

CREATE TABLE Classe( 
    nome_classe char(10) NOT NULL,
    docente TEXT NOT NULL REFERENCES Persona(email),
	ordine TEXT NOT NULL,
    tipo_scuola TEXT NOT NULL,
    scuola REFERENCES Scuola(codice_mecanografico),
    
	PRIMARY KEY (nome_classe)
);

CREATE TABLE Gruppo(
    id_gruppo BIGINT NOT NULL,
    tipo_gruppo TEXT NOT NULL CHECK (tipo_gruppo IN ('Controllo','Stress ambientale')),
    contenuta REFERENCES Pianta(id_pianta),
    
    PRIMARY KEY (id_gruppo)
);


CREATE TABLE Orto(
    nome_orto TEXT NOT NULL,
    superficie DOUBLE NOT NULL,
    latitudine BIGINT NOT NULL,    /*coodinate GPS*/
    longitudine BIGINT NOT NULL,  /*coodinate GPS*/
    condizione_ambientale TEXT NOT NULL CHECK (condizione_ambientale IN ('Pulito','Inquinato')),
	collocazione TEXT NOT NULL CHECK  (collocazione IN ('Vaso','Terra')),
    scuola REFERENCES Scuola(codice_mecanografico),
    specie REFERENCES Specie(nome_scientifico),

    PRIMARY KEY (nome_orto,latitudine,longitudine)
);

CREATE TABLE Specie(
 nome_scientifico TEXT NOT NULL,
 substrato TEXT NOT NULL CHECK (substrato IN ('Terriccio rinvaso','Suolo pre-esistente')),
 
 PRIMARY KEY (nome_scientifico)

);

CREATE TABLE Piante(
	id_pianta BIGINT NOT NULL,
    nome_comune TEXT NOT NULL,
    data_messa_a_dimora date NOT NULL,
    sole TEXT NOT NULL,
    ombra TEXT NOT NULL,
    mezz_ombra TEXT NOT NULL,  
	scopo TEXT NOT NULL CHECK  (scopo IN ('Biomonitoraggio','Fitobotanica')),
    gruppo REFERENCES Gruppo(id_gruppo),
    orto REFERENCES Orto(nome_orto),
    specie REFERENCES Specie(nome_scientifico),

	
    PRIMARY KEY(id_pianta)
);

CREATE TABLE Rilevazioni(
	id_rilevazione BIGINT,
    data_ora_inserimento TIMESTAMP NOT NULL,
	data_ora_rilevazione TIMESTAMP NOT NULL,
    responsabile TEXT REFERENCES Persona(email),
    fruttificazione /* entità con tuttii dati del' excel*/
    danni /* entità con tuttii dati del' excel*/
    biomassa /* entità con tuttii dati del' excel*/
    temperatura int NOT NULL,
    umidita DOUBLE NOT NULL,
    ph int NOT NULL,

    responsabile REFERENCES Persona(email),
   
	PRIMARY KEY(id_rilevazione),
	
	CONSTRAINT data_ora_rilevazione_a_antecedente_a_data_ora_inserimento
	CHECK (data_ora_rilevazione > data_ora_inserimento),
	
	UNIQUE (data_ora_inserimento,data_ora_rilevazione)
	
);

CREATE TABLE Sensore(
	id_sensore BIGINT,
	tipo CHAR NOT NULL CHECK (tipo IN ('arduino','sensore')),
	acquisizione TEXT NOT NULL CHECK (acquisizione IN ('BD','App')),
    rilevazione REFERENCES Rilevazione(id_rilevazione),
    
    PRIMARY KEY(id_sensore)
	
	
);






--Scuola
INSERT INTO Scuola VALUES ('ALIS017004','I.I.S CIAMPINI','IMPERIA','SUPERIORE','Rifiutato'); 
INSERT INTO Scuola VALUES ('ALIS017005','I.I.S FASTI','GENOVA','SUPERIORE','Beneficia');
INSERT INTO Scuola VALUES ('ALIS017006','I.I.S MONTALE','GENOVA','SUPERIORE','Beneficia');  
INSERT INTO Scuola VALUES ('ALIS017007','I.I.S ESTI','LA SPEZIA','SUPERIORE','Rifiutato');


--Persona
INSERT INTO Persona VALUES ('Nicola584@gmail.com','Nicola','Bianchi',3333333333,'Docente');
INSERT INTO Persona VALUES ('Laura659@gmail.com','Laura','Rossi',4444444444,'Docente');
INSERT INTO Persona VALUES ('Ugo456@gmail.com','Ugo','Verdi',5555555555,'Docente');
INSERT INTO Persona VALUES ('Siria7854@.gmail.com','Siria','Neri',6666666666,'Docente');


--Classe
INSERT INTO Classe VALUES ('1A','Nicola584@gmail.com,','Superiore','Liceo');
INSERT INTO Classe VALUES ('2A','Laura659@gmail.com,','Superiore','Liceo');
INSERT INTO Classe VALUES ('3A','Siria7854@.gmail.com','Superiore','Liceo');
INSERT INTO Classe VALUES ('4A','Ugo456@gmail.com','Superiore','Liceo');

--Orto

INSERT INTO Orto VALUES ('Orto1','100mq',44.40726,8.93386,'OK','Vaso');
INSERT INTO Orto VALUES ('Orto2','100mq',44.40726,8.93386,'OK','Terra');
INSERT INTO Orto VALUES ('Orto3','100mq',44.40726,8.93386,'OK','Vaso');
INSERT INTO Orto VALUES ('Orto4','100mq',44.40726,8.93386,'OK','Terra');

--Piante
INSERT INTO Piante VALUES ('1','2023-10-01','1A','Salvia','Sole',3,'Orto1','Biomonitoraggio');
INSERT INTO Piante VALUES ('2','2023-05-08','2A','Basilico','Sole',1,'Orto2','Fotobotanica');
INSERT INTO Piante VALUES ('3','2023-07-04','3A','Rosmarino','Sole',2,'Orto3','FotoBotanica');
INSERT INTO Piante VALUES ('4','2023-09-05','4A','Acacia','Sole',2,'Orto4','Biomonitoraggio');

--Rilevazioni
INSERT INTO Rilevazioni VALUES (1,'2021-05-08 10:00:00','2021-05-08 10:10:00','Ugo456@gmail.com');
INSERT INTO Rilevazioni VALUES (2,'2021-07-04 09:00:00','2021-07-04 09:10:00','Laura659@gmail.com');
INSERT INTO Rilevazioni VALUES (3,'2021-09-05 08:00:00','2021-09-05 08:10:00','Siria7854@.gmail.com');
INSERT INTO Rilevazioni VALUES (4,'2021-10-01 07:00:00','2021-10-01 07:10:00','Nicola584@gmail.com');

--Sensore
INSERT INTO Sensore VALUES (1,'arduino','BD');
INSERT INTO Sensore VALUES (2,'sensore','App');
INSERT INTO Sensore VALUES (3,'arduino','BD');
INSERT INTO Sensore VALUES (4,'sensore','App');

--Info_Ambientali

INSERT INTO Info_Ambientali VALUES ('HWID1',7,25,50,'arduino',1,'BD');
INSERT INTO Info_Ambientali VALUES ('HWID2',7,25,50,'sensore',2,'App');
INSERT INTO Info_Ambientali VALUES ('HWID3',7,25,50,'arduino',3,'BD');
INSERT INTO Info_Ambientali VALUES ('HWID4',7,25,50,'sensore',4,'App');





