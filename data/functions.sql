DROP FUNCTION IF EXISTS EtaMediaClasse;

DELIMITER //
/*FUNCTION che ritorna l'età media degli allievi di un insegnante(di cui viene passato il CodiceFiscale)*/
CREATE FUNCTION EtaMediaClasse (p_CodFisc CHAR(16)) RETURNS DECIMAL(3,1)
BEGIN
	DECLARE etaMedia DECIMAL(3,1);
	SELECT AVG(Eta) 
	FROM Insegna JOIN Allievi ON (Allievo = CodiceFiscale) 
	WHERE (Insegnante = p_CodFisc)
	GROUP BY Insegnante
	INTO etaMedia;

 	RETURN etaMedia;
END //
DELIMITER ;



