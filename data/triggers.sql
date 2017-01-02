DROP TRIGGER IF EXISTS UpdateNumInstr;
DROP TRIGGER IF EXISTS AnnullaSaggio;
DROP TRIGGER IF EXISTS MaxLessonsForTeacher;

/*Trigger che quando viene aggiunta una copia di uno strumento
a)incrementa di 1 il numero di strumento presenti nella aula in cui è stato inserita la nuova copia
b)incrementa di 1 la quantita di quello strumenti (nella tabella Strumenti)
;*/
DELIMITER //
CREATE TRIGGER UpdateNumInstr
AFTER INSERT ON CopieStrumentiScuola
FOR EACH ROW
BEGIN
	/*controllare che il numero di strumenti nell Interno non sia già massimo*/
	DECLARE numStr_beforeInsert INT;
	DECLARE max_strumenti INT;
	SELECT NumStrumenti FROM Interni 
	WHERE (Edificio = NEW.Edificio AND Piano=NEW.Piano AND CodAula=NEW.Aula) INTO numStr_beforeInsert;
	/*aggiorna il numero di strumenti solo se numStr_beforeInsert < MassimoStrumenti*/
	SELECT MassimoStrumenti FROM Interni
        WHERE (Edificio = NEW.Edificio AND Piano=NEW.Piano AND CodAula=NEW.Aula) INTO max_Strumenti;
	
	IF numStr_beforeInsert < max_Strumenti THEN
		UPDATE Interni
		SET NumStrumenti = NumStrumenti + 1
		WHERE (Edificio = NEW.Edificio AND Piano=NEW.Piano AND CodAula=NEW.Aula);
	END IF;	
	/*aggiorna il numero di strumenti di quel tipo*/
	UPDATE Strumenti
	SET Quantita = Quantita + 1
	WHERE (Nome = NEW.Strumento);
END //
DELIMITER ;

/*Trigger che elimina un saggio quando il numero di allievi che a esso partecipano diventa 0*/
DELIMITER //
CREATE TRIGGER AnnullaSaggio
AFTER DELETE ON AllieviAlSaggio
FOR EACH ROW
BEGIN
       	DECLARE zeroPupilConcertDate DATETIME;       /*variabile che memorizza il codice del saggio con zero allievi*/
	SELECT DataOraInizio INTO zeroPupilConcertDate
        FROM NumeroAllieviPerSaggio 
	WHERE NumeroAllievi = 0;

 	DELETE FROM Saggi 
	WHERE DataOraInizio = zeroPupilConcertDate;	
END //
DELIMITER ;

/*Trigger che controlla che un insegnante non superi mai le 4 lezioni al giorno*/
/*se ciò accade, generare un error*/
DELIMITER //
CREATE TRIGGER MaxLessonsForTeacher
BEFORE INSERT ON Lezioni
FOR EACH ROW
BEGIN
	DECLARE numLessons INT;
	SELECT COUNT(*)
	FROM Lezioni
	WHERE Insegnante=NEW.Insegnante
	INTO numLessons;
	IF numLessons > 3  THEN
	/*RAISE AN ERROR*/	
		UPDATE Lezioni SET attr = 'error';
	END IF; 
END //
DELIMITER ;
