-- 1.1 - Visualizza proiezioni giornaliere
SELECT OPERA_TITOLO, OPERA_PRODUZIONE_VIEW.TITOLO_EPISODIO, MINUTAGGIO, DATA_PROIEZIONE, ORA
	FROM PROIEZIONE JOIN OPERA_PRODUZIONE_VIEW ON PROIEZIONE.COD_PROD = OPERA_PRODUZIONE_VIEW.COD_PROD
	WHERE DATA_PROIEZIONE = '2024-09-07';

-- 1.2 - Iscrizione a proiezione
INSERT INTO ISCRIZIONE(COD_PROD, DATA_PROIEZIONE, ORA, COD_SPETTATORE)
VALUES(101, '2024-09-08', '23:31', 2);

-- 1.3 - Visualizza proprie iscrizioni
SELECT OPERA_TITOLO, OPERA_PRODUZIONE_VIEW.TITOLO_EPISODIO, MINUTAGGIO, DATA_PROIEZIONE, ORA
FROM ISCRIZIONE
	JOIN OPERA_PRODUZIONE_VIEW ON ISCRIZIONE.COD_PROD = OPERA_PRODUZIONE_VIEW.COD_PROD
	WHERE COD_SPETTATORE=9001

-- 1.4 - Visualizza informazioni opera
CREATE INDEX IDX_TITOLO on OPERA_AUDIOVISIVA using HASH (TITOLO);

SELECT * 
FROM INFO_OPERA_VIEW
	WHERE OPERA_TITOLO = 'Planet 51'
	ORDER BY COD_OPERA; 

-- 1.5 - Visualizza tutte le opere 
SELECT (TITOLO) FROM OPERA_AUDIOVISIVA;

-- 1.6.1 - Visualizza opere nominate in edizione O.E.
SELECT TITOLO
FROM NOMINATA_IN_OE
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
	WHERE ANNATA_OE=2024;

-- 1.6.2 - Visualizza opere nominate in edizione Venezia
SELECT TITOLO
FROM NOMINATA_IN_VENEZIA
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_VENEZIA.COD_OPERA
	WHERE ANNATA_VENEZIA=2024;

-- 1.7 - Vota in edizione O.E.
INSERT INTO VOTA_SPETTATORE(ANNATA_OE, COD_SPETTATORE, COD_OPERA)
VALUES(2024, 2, 101);

------------

-- 1.8 - Scrivi recensione
INSERT INTO RECENSIONE(COD_SPETTATORE, COD_OPERA, TESTO, VALUTAZIONE, TIMESTAMP_CONT)
VALUES(2, 101, 'Fantastic!', 5, '2024-06-05 12:50:22.302057');

------------------

-- 1.9 - Visualizza recensioni opera
CREATE INDEX IDX_COD_OP_REC ON RECENSIONE USING HASH (COD_OPERA);

SELECT *
FROM RECENSIONE
WHERE COD_OPERA=4
ORDER BY TIMESTAMP_CONT;

-- 1.10 -  Visualiza commenti recensione
SELECT *
FROM COMMENTO
WHERE COD_OPERA=4 AND COD_SPETTATORE = 9001
ORDER BY TIMESTAMP_CONT;

-- 1.11 - Commenta recensione
INSERT INTO COMMENTO(COD_SPETTATORE, COD_OPERA, TESTO, TIMESTAMP_CONT)
VALUES (9001, 50, 'I agree with you', '2024-06-07 12:55:22.302057');

-- 1.12 - Segui utente
INSERT INTO SEGUE(COD_SPETTATORE_SEGUE, COD_SPETTATORE_SEGUITO)
VALUES (2, 3);

-- 1.13 - Visualizza commenti e recensioni di Seguiti 
CREATE INDEX IDX_SPET_SCRIVE ON COMMENTO USING HASH (COD_SPETTATORE_SCRIVE)

(SELECT COD_COMMENTO, COD_SPETTATORE, COD_OPERA, TESTO, NULL AS VALUTAZIONE, COD_SPETTATORE_SCRIVE, TIMESTAMP_CONT
FROM COMMENTO
	WHERE COMMENTO.COD_SPETTATORE_SCRIVE IN (SELECT COD_SPETTATORE_SEGUITO FROM SEGUE
												WHERE COD_SPETTATORE_SEGUE = 9001)
	   
UNION 
	   
SELECT NULL AS COD_COMMENTO, COD_SPETTATORE, COD_OPERA , TESTO, VALUTAZIONE, NULL AS COD_SPETTATORE_SCRIVE, TIMESTAMP_CONT
FROM RECENSIONE
	WHERE RECENSIONE.COD_SPETTATORE IN (SELECT COD_SPETTATORE_SEGUITO FROM SEGUE
												WHERE COD_SPETTATORE_SEGUE = 9001)
) ORDER BY TIMESTAMP_CONT
	   

-- 1.14 - Visualizza propri commenti e recensioni 
CREATE INDEX IDX_SPET_SCRIVE ON COMMENTO USING HASH (COD_SPETTATORE_SCRIVE)
	   
(SELECT COD_COMMENTO, COD_SPETTATORE, COD_OPERA, TESTO, NULL AS VALUTAZIONE, TIMESTAMP_CONT, COD_SPETTATORE_SCRIVE
FROM COMMENTO
	WHERE COMMENTO.COD_SPETTATORE_SCRIVE = 9001
	   
UNION 
	   
SELECT NULL AS COD_COMMENTO, COD_SPETTATORE, COD_OPERA , TESTO, VALUTAZIONE, TIMESTAMP_CONT, NULL AS COD_SPETTATORE_SCRIVE
FROM RECENSIONE
	WHERE RECENSIONE.COD_SPETTATORE = 9001
)	ORDER BY TIMESTAMP_CONT

---------
	   
-- 2.1 - Visualizza recensioni opera
CREATE INDEX IDX_COD_OP_REC ON RECENSIONE USING HASH (COD_OPERA)
DROP INDEX IDX_COD_OP_REC
	   
SELECT *
FROM RECENSIONE 
WHERE COD_OPERA = 3
ORDER BY TIMESTAMP_CONT;

-- 2.2 - Visualizza commenti recensione
SELECT *
FROM COMMENTO
WHERE COD_OPERA=3 AND COD_SPETTATORE=9001
ORDER BY TIMESTAMP_CONT;

-- 2.3 - Visualizza recensioni di ogni opera
CREATE INDEX IDX_TIMESTAMP_REC ON RECENSIONE USING BTREE (TIMESTAMP_CONT);
CLUSTER RECENSIONE USING IDX_TIMESTAMP_REC;
	   
SELECT *
FROM RECENSIONE 
	   ORDER BY TIMESTAMP_CONT; 

-- 2.4 -  Visualizza commenti di ogni recensione
CREATE INDEX IDX_TIMESTAMP_COM ON COMMENTO USING BTREE (TIMESTAMP_CONT);
CLUSTER COMMENTO USING IDX_TIMESTAMP_COM;
	   
SELECT *
FROM COMMENTO
	   ORDER BY TIMESTAMP_CONT;

-- 2.5 - Visualizza tutti commenti e recensioni
(SELECT COD_COMMENTO, COD_SPETTATORE, COD_OPERA, TESTO, NULL AS VALUTAZIONE, TIMESTAMP_CONT, COD_SPETTATORE_SCRIVE
FROM COMMENTO
	
	   
UNION 
	   
SELECT NULL AS COD_COMMENTO, COD_SPETTATORE, COD_OPERA , TESTO, VALUTAZIONE, TIMESTAMP_CONT, NULL AS COD_SPETTATORE_SCRIVE
FROM RECENSIONE

) ORDER BY TIMESTAMP_CONT;

	   
-- 2.6 - Visualizza commenti e recensioni di un utente 
CREATE INDEX IDX_SPET_SCRIVE ON COMMENTO USING HASH (COD_SPETTATORE_SCRIVE)
	   
(SELECT COD_COMMENTO, COD_SPETTATORE, COD_OPERA, TESTO, NULL AS VALUTAZIONE, TIMESTAMP_CONT, COD_SPETTATORE_SCRIVE
FROM COMMENTO
	WHERE COMMENTO.COD_SPETTATORE_SCRIVE = 9001

UNION 
	   
SELECT NULL AS COD_COMMENTO, COD_SPETTATORE, COD_OPERA, TESTO, VALUTAZIONE, TIMESTAMP_CONT, NULL AS COD_SPETTATORE_SCRIVE
FROM RECENSIONE
	WHERE RECENSIONE.COD_SPETTATORE = 9001) ORDER BY TIMESTAMP_CONT;
	  
	   
-- 2.7 - Rimuovi commento
DELETE FROM COMMENTO
WHERE COD_COMMENTO = 1 AND COD_SPETTATORE = 2 AND COD_OPERA = 2; 

-- 2.8 - Rimuovi recensione
DELETE FROM RECENSIONE
WHERE COD_OPERA=50 AND COD_SPETTATORE=9001;

-- 2.9.1 - Visualizza opere nominate in edizione O.E. 
SELECT TITOLO
FROM NOMINATA_IN_OE
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
	WHERE ANNATA_OE=2024;

-- 2.9.2 - Visualizza opere nominate in edizione O.E. 
SELECT TITOLO
FROM NOMINATA_IN_VENEZIA
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_VENEZIA.COD_OPERA
	WHERE ANNATA_VENEZIA=2024;
   
-- 2.10.1 - Visualizza classifica edizione O.E
SELECT COD_OPERA, COUNT(*) AS VOTI_RICEVUTI FROM VOTI_GIURATO_VIEW
	   WHERE ANNATA_VENEZIA = 2024
	   GROUP BY COD_OPERA
	   ORDER BY VOTI_RICEVUTI DESC;

-- 2.10.2 - Visualizza classifica edizione Venezia
SELECT OPERA_AUDIOVISIVA.COD_OPERA, NUM_VOTI_OE, ANNATA_OE FROM OPERA_AUDIOVISIVA
	   JOIN NOMINATA_IN_OE ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
	   WHERE ANNATA_OE = 2024
	   ORDER BY NUM_VOTI_OE DESC;

-- 2.11.1 - Assegna premio O.E.
INSERT INTO PREMIO_OE (COD_OPERA, ANNATA_OE)
SELECT OPERA_AUDIOVISIVA.COD_OPERA, 2024 FROM OPERA_AUDIOVISIVA
		   		JOIN NOMINATA_IN_OE ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
		   		WHERE ANNATA_OE = 2024 
		   			AND NUM_VOTI_OE >= ALL (
						SELECT NUM_VOTI_OE FROM OPERA_AUDIOVISIVA 
						JOIN NOMINATA_IN_OE 
							ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
						);
	   
-- 2.11.2 Assegna premio Venezia	   
INSERT INTO PREMIO_VENEZIA (COD_OPERA, ANNATA_VENEZIA)
SELECT COD_OPERA, 2024 FROM (
		   SELECT COD_OPERA, COUNT(*) AS VOTI_RICEVUTI FROM VOTI_GIURATO_VIEW
			   WHERE ANNATA_VENEZIA = 2024
			   GROUP BY COD_OPERA
			   ORDER BY VOTI_RICEVUTI DESC LIMIT 1
		   );
	   
-- 2.12.1 Nomina giurato attore
INSERT INTO COMPOSTA_DA_ATTORE (ANNATA_VENEZIA, COD_ATTORE)
	   VALUES (2024, 4);
	   
-- 2.12.2 Nomina giurato regista
INSERT INTO COMPOSTA_DA_REGISTA (ANNATA_VENEZIA, COD_REGISTA)
	   VALUES (2024, 7);

-- 2.12.3 Nomina giurato giornalista
INSERT INTO COMPOSTA_DA_GIORNALISTA (ANNATA_VENEZIA, COD_GIORNALISTA)
	   VALUES (2024, 8);
	   
-- 3.1 Visualizza proiezioni giornaliere
SELECT OPERA_TITOLO, OPERA_PRODUZIONE_VIEW.TITOLO_EPISODIO, MINUTAGGIO, DATA_PROIEZIONE, ORA
FROM PROIEZIONE JOIN OPERA_PRODUZIONE_VIEW ON PROIEZIONE.COD_PROD = OPERA_PRODUZIONE_VIEW.COD_PROD
WHERE DATA_PROIEZIONE='2024-09-07';

-- 3.2 Visualizza informazioni opera
SELECT * 
FROM INFO_OPERA_VIEW
	WHERE OPERA_TITOLO = 'Planet 51'
	ORDER BY COD_OPERA; 

-- 3.3 - Visualizza tutte le opere
SELECT (TITOLO)
FROM OPERA_AUDIOVISIVA;

-- 3.4.1 - Visualizza opere nominate in edizione O.E. 
SELECT TITOLO
FROM NOMINATA_IN_OE
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_OE.COD_OPERA
	WHERE ANNATA_OE=2024;

-- 3.4.2 Visualizza opere nominate in edizione Venezia 
SELECT TITOLO
FROM NOMINATA_IN_VENEZIA
	JOIN OPERA_AUDIOVISIVA ON OPERA_AUDIOVISIVA.COD_OPERA = NOMINATA_IN_VENEZIA.COD_OPERA
	WHERE ANNATA_VENEZIA=2024;

-- 3.5.1 - Attore vota in edizione Venezia
INSERT INTO VOTA_ATTORE (ANNATA_VENEZIA, COD_ATTORE, COD_OPERA)
	   VALUES (2024, 2, 2);
	   
-- 3.5.2 - Regista vota in edizione Venezia
INSERT INTO VOTA_REGISTA (ANNATA_VENEZIA, COD_REGISTA, COD_OPERA)
	   VALUES (2024, 2, 2);
	   
-- 3.5.3 - Giornalista vota in edizione Venezia
INSERT INTO VOTA_GIORNALISTA (ANNATA_VENEZIA, COD_GIORNALISTA, COD_OPERA)
	   VALUES (2024, 2, 2);
	   
-------------------