INSERT INTO Segretari(CodiceFiscale,Password)
	VALUES ('mzqgrg94m08a703p','stk2CaAFylb7Y');

INSERT INTO Strumenti(Nome,Tipologia,Quantita,Tecnico,NumTelTecnico)
             VALUES('pianoforte','fisso',15,'1234uiop2345vcxz',3391623821);
INSERT INTO Strumenti(Nome,Tipologia,Quantita,Tecnico,NumTelTecnico)
	     VALUES('violino','portatile',NULL,'qwersdfg78905432',3471294271);
INSERT INTO Strumenti(Nome,Tipologia,Quantita,Tecnico,NumTelTecnico)
	     VALUES('arpa','fisso',4,'1243jkhq9iwe2431',3386888304);
INSERT INTO Interni(Edificio,Piano,CodAula,Tipologia,NumStrumenti,MassimoStrumenti) values ('A',2,'B','aula',2,5);
INSERT INTO Interni(Edificio,Piano,CodAula,Tipologia,NumStrumenti,MassimoStrumenti) values ('A',1,'C','sala concerti',2,5);
INSERT INTO Interni(Edificio,Piano,CodAula,Tipologia,NumStrumenti,MassimoStrumenti) values ('A',2,'Z','aula',2,5);

CALL InserisciInsegnante('mzzgnn94m08a703j','stT3ToAP6D9e6','Giovanni','Mazzocchin',3391695802,'Arrigo Pedrollo',59,'pianoforte');
CALL InserisciInsegnante('MLVSTT52B71A794R','stP.evcWQHG6k','Matteo','Salvietta',3427977254,'Giuseppe Verdi',48,'violino');
CALL InserisciInsegnante('MCRNNN93S09C710W','st.slH6bVzPZk','Antonino','Macri',3335798295,'Dall''abaco ',61,'pianoforte');
CALL InserisciInsegnante('FSLFNC94S07G693X','stk2CaAFylb7Y','Francesco','Fasolato',3463245621,'Benedetto Marcello',51,'arpa');

CALL InserisciAllievo('RSSMRA92A01H501Y','Mario','Rossi',3382214428,'Roma',26,'MLVSTT52B71A794R','mzzgnn94m08a703j','FSLFNC94S07G693X');
CALL InserisciAllievo('zccgcm93d04g693a','Giacomo','Zecchin',3338514214,'Piove di sacco',22,'MCRNNN93S09C710W','mzzgnn94m08a703j','FSLFNC94S07G693X');
CALL InserisciAllievo('zkcgcm93d04g692a','Paolo','Zecchin',3338514214,'Piove di sacco',31,'MCRNNN93S09C710W','mzzgnn94m08a703j','FSLFNC94S07G693X');
CALL InserisciAllievo('zccgcq93d04g691a','Giacomo','Verdi',3338514214,'Piove di sacco',29,'MCRNNN93S09C710W','mzzgnn94m08a703j','FSLFNC94S07G693X');

CALL InserisciSaggio('mzzgnn94m08a703j','2015-01-01 21:00:01','A,','1','C','RSSMRA92A01H501Y','zccgcm93d04g693a','zkcgcm93d04g692a','zccgcq93d04g691a');
CALL InserisciSaggio('mzzgnn94m08a703j','2015-02-01 20:00:01','A,','1','C','RSSMRA92A01H501Y',NULL,NULL,NULL);

CALL PrenotaLezione('FSLFNC94S07G693X','zkcgcm93d04g692a','13:00','14:00','A','2','B','mzqgrg94m08a703p');

INSERT INTO CopieStrumentiScuola(IdCopia,Strumento,Edificio,Piano,Aula) values ('1234567891','pianoforte','A',2,'B');
