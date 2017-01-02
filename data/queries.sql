/*Query che estrae gli insegnanti(Codice fiscale,Nome e Cognome) per i quali almeno un allievo ha partecipato ad un saggio tenuto nella sala (A,1,C)*/
SELECT P.CodiceFiscale,P.Nome,P.Cognome
FROM Persone AS P JOIN Insegnanti AS I ON (P.CodiceFiscale=I.CodiceFiscale)
WHERE EXISTS (SELECT * FROM AllieviAlSaggio AS A_S JOIN Saggi AS S 
		ON (A_S.Saggio=S.DataOraInizio)
		WHERE S.Insegnante=I.CodiceFiscale AND S.Edificio='A' AND S.Piano=1 AND S.Sala='C');


/*Query che estrae i Codice fiscale,Nome e Cognome degli allievi che hanno tutti gli insegnanti di età superiore ai 50 anni*/
/*######################################################*/
SELECT P.CodiceFiscale,P.Nome,P.Cognome 
FROM Persone AS P JOIN Allievi AS A ON (P.CodiceFiscale=A.CodiceFiscale) 
WHERE NOT EXISTS (SELECT * FROM Insegna AS I1 JOIN Insegnanti AS I2 ON (I1.Insegnante=I2.CodiceFiscale)
		  WHERE (I1.Allievo = P.CodiceFiscale AND I2.Eta <= 50)				
		 );
/*######################################################*/

/*Query che estrae UNO degli allievi con partecipazione ai saggi massima*/
/*Crea una view di appoggio*/
/*#####################################################*/
DROP VIEW IF EXISTS NumeroSaggiPerAllievo;
CREATE VIEW NumeroSaggiPerAllievo AS (SELECT A.Allievo,COUNT(*) AS NumeroSaggi
				      FROM AllieviAlSaggio AS A
				      GROUP BY A.Allievo);
SELECT N.Allievo,P.Nome,P.Cognome 
FROM NumeroSaggiPerAllievo AS N JOIN Persone AS P ON (N.Allievo=P.CodiceFiscale)
WHERE NumeroSaggi >= ALL(SELECT NumeroSaggi FROM NumeroSaggiPerAllievo)
LIMIT 1; 
/*##########################################################*/

/*Query che estrae DataOraInizio e Edificio,Piano e Sala di 2 saggi qualsiasi a cui hanno partecipato
più allievi*/
/*Crea una view di appoggio*/
/*#########################################*/
DROP VIEW IF EXISTS NumeroAllieviPerSaggio;
CREATE VIEW NumeroAllieviPerSaggio AS (SELECT S.DataOraInizio,S.Edificio,S.Piano,S.Sala,COUNT(*) AS NumeroAllievi
						FROM Saggi AS S JOIN AllieviAlSaggio AS S1 ON (S.DataOraInizio=S1.Saggio)
						WHERE (S1.Allievo IS NOT NULL)
						GROUP BY S.DataOraInizio 
				      );
SELECT DataOraInizio,Edificio,Piano,Sala,NumeroAllievi
FROM NumeroAllieviPerSaggio
WHERE NumeroAllievi >= ALL (SELECT NumeroAllievi FROM NumeroAllieviPerSaggio)
LIMIT 2;
/*##########################################*/

/*Query che estrae Nome e NumeroCopie degli strumenti dei quali sono presenti almeno 5 copie*/
/*####################################*/
DROP VIEW IF EXISTS NumeroCopiePerStrumento;
CREATE VIEW NumeroCopiePerStrumento AS
  (SELECT Nome,COUNT(*) AS NumeroCopie
   FROM Strumenti AS S,CopieStrumentiScuola AS C
   WHERE (S.Nome = C.Strumento)
   GROUP BY Nome
);

SELECT Nome,NumeroCopie 
FROM  NumeroCopiePerStrumento
WHERE (NumeroCopie > 4);
/*####################################*/

/*Query che estrae l'aula (tutte le aule) che ha più pianoforti*/
/*VIEW di appoggio*/
DROP VIEW IF EXISTS NumPianofortiPerInterno;
CREATE VIEW NumPianofortiPerInterno AS	
SELECT I.Edificio,I.Piano,I.CodAula,COUNT(*) AS NumeroPianoforti
FROM CopieStrumentiScuola AS C JOIN Interni AS I ON (C.Edificio=I.Edificio AND C.Piano=I.Piano AND C.Aula=I.CodAula)
WHERE C.Strumento='pianoforte'
GROUP BY I.Edificio,I.Piano,I.CodAula;

SELECT * FROM NumPianofortiPerInterno AS N
WHERE NumeroPianoforti >= ALL (SELECT NumeroPianoforti FROM NumPianofortiPerInterno);
