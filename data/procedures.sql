DROP PROCEDURE IF EXISTS InserisciAllievo;
DROP PROCEDURE IF EXISTS InserisciInsegnante;
DROP PROCEDURE IF EXISTS EliminaAllievo;
DROP PROCEDURE IF EXISTS InserisciSaggio;
DROP PROCEDURE IF EXISTS PrenotaLezione;

SET NAMES 'utf8';

/*NB: molti controlli sono stati implementati in PHP*/
/*Procedure per l'inserimento di un allievo
  Riceve i dati di un allievo (propri della tabella 'Allievi' e i suoi(max 3) insegnanti
  ==> aggiunge un'ennupla alla tabella 'Allievi', un'ennupla alla tabella 'Persone' e ennuple (max 3) alla tabella 'Insegna' 
*/
DELIMITER //
CREATE PROCEDURE InserisciAllievo 
	(
		
		IN p_CodiceFiscale CHAR(16),		
		IN p_Nome VARCHAR(20),
		IN p_Cognome VARCHAR(20),
		IN p_NumeroTelefono NUMERIC(10),
		IN p_Citta   VARCHAR(20),
		IN p_Eta	INT,
		IN p_Insegnante1 CHAR(16),      /*la procedure deve ricevere codici fiscale di insegnanti che esistono ===>*/
		IN p_Insegnante2 CHAR(16),	
		IN p_Insegnante3 CHAR(16)
	)
BEGIN
		INSERT INTO Persone(
			CodiceFiscale,
			Nome,
			Cognome,
			NumeroTelefono
		)
		VALUES (
			p_CodiceFiscale,
			p_Nome,
			p_Cognome,
			p_NumeroTelefono
		);
	        INSERT INTO Allievi
		   (
			CodiceFiscale,
			Citta,
			Eta
		   ) 
		   VALUES 
		   (
			p_CodiceFiscale,
			p_Citta,
			p_Eta
	           );
/*aggiunge alla tabella Insegna solo se l'insegnante passato esiste*/
	       IF p_Insegnante1 <> 'NULL' && p_Insegnante1 <> '' THEN
			INSERT INTO Insegna(Insegnante,Allievo)
                                VALUES(p_Insegnante1,p_CodiceFiscale);			
	       END IF;
	       IF p_Insegnante2 <> 'NULL' && p_Insegnante2 <> ''  THEN
			INSERT INTO Insegna(Insegnante,Allievo)
                                VALUES(p_Insegnante2,p_CodiceFiscale);			
	       END IF;       
	       IF p_Insegnante3 <> 'NULL' && p_Insegnante3 <> '' THEN
			INSERT INTO Insegna(Insegnante,Allievo)
                                VALUES(p_Insegnante3,p_CodiceFiscale);			
	       END IF;
END 
//

DELIMITER //
/*Procedure per inserire un nuovo insegnante*/
CREATE PROCEDURE InserisciInsegnante(
			IN p_CodiceFiscale CHAR(16),
			IN p_Password	   VARCHAR(20),
			IN p_Nome	   VARCHAR(20),
			IN p_Cognome	   VARCHAR(20),
			IN p_NumeroTelefono NUMERIC(10),
			IN p_Conservatorio VARCHAR(40),
			IN p_Eta	   INT,
			IN p_Strumento	   VARCHAR(20)	
		)
BEGIN
	DECLARE ExistsInstr VARCHAR(20);
	SELECT Nome FROM Strumenti WHERE (Nome=p_Strumento) INTO ExistsInstr;
	IF ExistsInstr IS NOT NULL THEN
		INSERT INTO Persone(
			CodiceFiscale,
			Nome,
			Cognome,
			NumeroTelefono
		)
		VALUES(
			p_CodiceFiscale,
			p_Nome,
			p_Cognome,
			p_NumeroTelefono
		);
                INSERT INTO Insegnanti
                   (
                        CodiceFiscale,
                        Password,
                        Conservatorio,
			Eta,
			Strumento
                   )
                   VALUES
                   (
                        p_CodiceFiscale,
			p_Password,
                        p_Conservatorio,
                        p_Eta,
			p_Strumento
                   );
	END IF;
END //

DELIMITER //

/*Questa procedura riceve come parametri il CodiceFiscale dell'insegnante che sta 
cancellando un proprio allievo(che ha fatto il login nell'area privata), e il codice fiscale dell'allievo che si vuole eliminare*/
/*Dopo il DELETE sulla tabella 'Insegna', bisogna eliminare tutte le Lezioni e i Saggi in cui
sono coinvolti sia l'Insegnante sia l'Allievo,*/
CREATE PROCEDURE EliminaAllievo(
	           p_CodiceInsegnante CHAR(16),
		   p_CodiceAllievo    CHAR(16)
		)
BEGIN	
	    DELETE FROM Insegna WHERE (Insegnante=p_CodiceInsegnante AND Allievo=p_CodiceAllievo);
	    DELETE FROM Lezioni WHERE (Insegnante=p_CodiceInsegnante AND Allievo=p_CodiceAllievo);
	    /*selezionare i saggi dell insegnante con p_CodiceInsegnante*/
/*	    DELETE FROM AllieviAlSaggio WHERE (Allievo=p_CodiceAllievo AND
						Saggio IN (SELECT DataOraInizio FROM Saggi
							  WHERE Insegnante=p_CodiceInsegnante));*/
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InserisciSaggio(
				p_Insegnante CHAR(16),
				p_DataOra DATETIME,
				p_Edificio CHAR,
				p_Piano    SMALLINT,
				p_Sala	   CHAR,
				p_Allievo1 CHAR(16),
				p_Allievo2 CHAR(16),
				p_Allievo3 CHAR(16),
				p_Allievo4 CHAR(16)
			)
BEGIN
		INSERT INTO Saggi(Insegnante,DataOraInizio,Edificio,Piano,Sala)
			VALUES (p_Insegnante,p_DataOra,p_Edificio,p_Piano,p_Sala);
 
		/*insert on AllieviAlSaggio only if Allievo is not null*/	
		IF p_Allievo1 <> 'NULL' && p_Allievo1 <> '' THEN 
			INSERT INTO AllieviAlSaggio(Allievo,Saggio)
                                VALUES(p_Allievo1,p_DataOra);			
		END IF;
		IF p_Allievo2 <> 'NULL' && p_Allievo2 <> '' THEN
                        INSERT INTO AllieviAlSaggio(Allievo,Saggio)
                                VALUES(p_Allievo2,p_DataOra);
                END IF;
		IF p_Allievo3 <> 'NULL' && p_Allievo3 <> '' THEN
                        INSERT INTO AllieviAlSaggio(Allievo,Saggio)
                                VALUES(p_Allievo3,p_DataOra);
                END IF;
		IF p_Allievo4 <> 'NULL' && p_Allievo4 <> '' THEN
                        INSERT INTO AllieviAlSaggio(Allievo,Saggio)
                                VALUES(p_Allievo4,p_DataOra);
                END IF;      
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE PrenotaLezione(
			p_Insegnante 	CHAR(16),
			p_Allievo  	CHAR(16), 
			p_OraInizio 	TIME,
			p_OraFine   	TIME,
			p_Edificio  	CHAR,
			p_Piano		SMALLINT,
			p_Aula		CHAR,
			p_Segr_Pren	CHAR(16)
		)
BEGIN
		INSERT INTO 
		    Lezioni(IdLezione,Insegnante,Allievo,OraInizio,OraFine,Edificio,Piano,
				Aula,Segr_Pren)
		VALUES (NULL,p_Insegnante,p_Allievo,p_OraInizio,                 /*null perche'' AUTO_INCREMENT*/
				p_OraFine,p_Edificio,p_Piano,p_Aula,p_Segr_Pren);
END //
DELIMITER ;
