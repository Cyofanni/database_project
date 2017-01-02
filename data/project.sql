DROP SCHEMA IF EXISTS `gmazzocc-PR`;     /*obbligatorio usare apici inversi a causa del '-'*/
CREATE SCHEMA `gmazzocc-PR`; USE `gmazzocc-PR`;

SET NAMES 'utf8';

/*Contiene i dati di base che hanno Insegnanti, Allievi e Segretari*/
CREATE TABLE Persone (
	CodiceFiscale CHAR(16),
	Nome	      VARCHAR(20) NOT NULL,
	Cognome	      VARCHAR(20) NOT NULL,
	NumeroTelefono NUMERIC(10),
	PRIMARY KEY(CodiceFiscale)
)ENGINE=InnoDB;

/*Si assume che la scuola sia composta da più edifici*/
CREATE TABLE Interni(
	Edificio CHAR,
	Piano	 SMALLINT,
	CodAula	 CHAR,
	Tipologia ENUM('aula','sala concerti'), 
	NumStrumenti INT,	/*numero di copie presenti nell'interno*/
	MassimoStrumenti SMALLINT,	/*campo per memorizzare il massimo numero di strumenti che l'Interno può ospitare*/	
	PRIMARY KEY (Edificio,Piano,CodAula)
)ENGINE=InnoDB;

/*Un tecnico si occupa di un unico tipo di strumenti: e.g. tecnico del pianoforte,tecnico dell'arpa*/
/*DISTINGUERE TRA STRUMENTI COME CONCETTO E 'ESEMPLARE' DI STRUMENTO*/
CREATE TABLE Strumenti(
	Nome 	VARCHAR(20) PRIMARY KEY,
	Tipologia ENUM('portatile','fisso'),
	Quantita INT,          /*e.g. 'quanti pianoforti ci sono nella scuola'*/
	Tecnico CHAR(16),			/*UNIQUE perche' un tecnico non puo' occuparsi di piu' strumenti (era 1:1 nell'ER)*/
	NumTelTecnico NUMERIC(10)		
)ENGINE=InnoDB;

/*Tabella per memorizzare gli esemplari di strumenti presenti nella scuola*/
/*Una copia di uno strumento può trovarsi al più in un interno*/
/*In un interno possono trovarsi più copie di strumenti*/
CREATE TABLE CopieStrumentiScuola(
	IdCopia   CHAR(10),	/*codice identificativo di uno strumento*/	
	Strumento VARCHAR(20),   
	Edificio  CHAR,       /*in che edificio si trova questa copia*/
	Piano 	  SMALLINT,	/*in che piano si trova questa copia*/
	Aula	  CHAR,		/*in che aula si trova questa copia*/
	PRIMARY KEY (IdCopia),
	FOREIGN KEY (Strumento) REFERENCES Strumenti(Nome) ON DELETE CASCADE,   /*quando viene eliminato uno strumento dalla scuola ==> tutti le copie devono essere 											eliminate*/
	/*Edificio,Piano,Aula sono FOREIGN KEYS su Interni*/
	FOREIGN KEY(Edificio,Piano,Aula) REFERENCES Interni(Edificio,Piano,CodAula) ON DELETE SET NULL
)ENGINE=InnoDB;

/*I segretari possono modificare il database*/
CREATE TABLE Segretari(
	CodiceFiscale CHAR(16),
	Password VARCHAR(20),
	PRIMARY KEY (CodiceFiscale),
	FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale) ON DELETE CASCADE
)ENGINE=InnoDB;

/*gli insegnanti e gli allievi possono solo visualizzare i dati*/
CREATE TABLE Insegnanti(
	CodiceFiscale CHAR(16),
	Password      VARCHAR(20),
	Conservatorio VARCHAR(40),    /*nome del conservatorio di provenienza dell'insegnante*/
	Eta INT,
	Strumento VARCHAR(20),
	PRIMARY KEY (CodiceFiscale),
	FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY (Strumento) REFERENCES Strumenti(Nome) ON DELETE SET NULL
)ENGINE=InnoDB;

CREATE TABLE Allievi(
	CodiceFiscale CHAR(16),
	Citta VARCHAR(20),       /*città di nascita*/
	Eta INT,
	PRIMARY KEY (CodiceFiscale),
	FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE Insegna(
 	Insegnante CHAR(16),
	Allievo    CHAR(16),
	PRIMARY KEY (Insegnante, Allievo),
	FOREIGN KEY (Insegnante) REFERENCES Insegnanti(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY (Allievo) REFERENCES Allievi(CodiceFiscale) ON DELETE CASCADE
)ENGINE=InnoDB;



/*Un allievo può effettuare più lezioni nello stesso giorno;
  Un insegnante può effettuare più lezioni nello stesso giorno;
  (Insegnante DataOraInizio) UNIQUE;
  (Allievi    DataOraInizio) UNIQUE;
*/
CREATE TABLE Lezioni(
	IdLezione  INT AUTO_INCREMENT,
	Insegnante CHAR(16),
	Allievo    CHAR(16),
 	OraInizio  TIME,     
	OraFine    TIME, 	
	Edificio   CHAR,
	Piano	   SMALLINT,
	Aula       CHAR,	
	Segr_Pren  CHAR(16),	 /*segretario che ha prenotato la lezione*/	
	PRIMARY KEY (IdLezione),
	FOREIGN KEY (Insegnante) REFERENCES Insegnanti(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY (Allievo) REFERENCES Allievi(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY (Segr_Pren) REFERENCES Segretari(CodiceFiscale) ON DELETE SET NULL,
	FOREIGN KEY(Edificio,Piano,Aula) REFERENCES Interni(Edificio,Piano,CodAula) ON DELETE CASCADE
)ENGINE=InnoDB;

/*Un insegnante on un allievo possono partecipare a più saggi*/
/*Ad un saggio partecipano più allievi*/
CREATE TABLE Saggi(
	Insegnante CHAR(16),
	DataOraInizio DATETIME,	/*Chiave perché un saggio al giorno quindi sempre diversa in ogni tupla*/
	Edificio CHAR,
	Piano	 SMALLINT,
	Sala 	 CHAR,
	PRIMARY KEY (DataOraInizio),
	FOREIGN KEY (Insegnante) REFERENCES Insegnanti(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY(Edificio,Piano,Sala) REFERENCES Interni(Edificio,Piano,CodAula) ON DELETE CASCADE
)ENGINE=InnoDB;



CREATE TABLE AllieviAlSaggio(
	Allievo	CHAR(16),
	Saggio DATETIME,
	PRIMARY KEY(Allievo,Saggio),
	FOREIGN KEY (Allievo) REFERENCES Allievi(CodiceFiscale) ON DELETE CASCADE,
	FOREIGN KEY (Saggio) REFERENCES Saggi(DataOraInizio) ON DELETE CASCADE
)ENGINE=InnoDB;

