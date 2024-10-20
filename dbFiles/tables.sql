CREATE TABLE ATTORE(
	COD_ATTORE SERIAL PRIMARY KEY,
	NOME VARCHAR(255) NOT NULL,
	COGNOME VARCHAR(255) NOT NULL,
	DATA_DI_NASCITA DATE NOT NULL,
	NAZIONALITA VARCHAR(255)
);

CREATE TABLE REGISTA(
	COD_REGISTA SERIAL PRIMARY KEY,
	NOME VARCHAR(255) NOT NULL,
	COGNOME VARCHAR(255) NOT NULL,
	DATA_DI_NASCITA DATE NOT NULL,
	NAZIONALITA VARCHAR(255)
);

CREATE TABLE GIORNALISTA(
	COD_GIORNALISTA SERIAL PRIMARY KEY,
	NOME VARCHAR(255) NOT NULL,
	COGNOME VARCHAR(255) NOT NULL,
	DATA_DI_NASCITA DATE NOT NULL,
	NAZIONALITA VARCHAR(255)
);

CREATE TABLE PRODUZIONE(
	COD_PROD SERIAL PRIMARY KEY,
	MINUTAGGIO INT CHECK(MINUTAGGIO > 0) NOT NULL,
	COD_REGISTA SERIAL,
	GENERE VARCHAR(255),
	
	FOREIGN KEY (COD_REGISTA) REFERENCES REGISTA(COD_REGISTA)
);

CREATE TABLE OPERA_AUDIOVISIVA(
	COD_OPERA SERIAL PRIMARY KEY,
	TITOLO VARCHAR(255) NOT NULL,
	NUM_VOTI_OE INT DEFAULT 0,
	VALUTAZIONE_MEDIA REAL DEFAULT 0.0
);

CREATE TABLE FILM(
	COD_PROD SERIAL PRIMARY KEY,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_PROD) REFERENCES PRODUZIONE(COD_PROD)
);

CREATE TABLE SERIE_TV(
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA)
);

CREATE TABLE STAGIONE(
	COD_OPERA SERIAL,
	NUM INT,
	
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (COD_OPERA, NUM)
);

CREATE TABLE EPISODIO(
	COD_PROD SERIAL PRIMARY KEY,
	TITOLO VARCHAR(255) NOT NULL,
	COD_OPERA SERIAL,
	NUM_STAGIONE INT,
	NUM_EPISODIO INT NOT NULL,
	
	FOREIGN KEY (COD_OPERA, NUM_STAGIONE) REFERENCES STAGIONE(COD_OPERA, NUM)
);

CREATE TABLE CAST_PROD(
	COD_PROD SERIAL,
	COD_ATTORE SERIAL,
	
	FOREIGN KEY (COD_PROD) REFERENCES PRODUZIONE(COD_PROD),
	FOREIGN KEY (COD_ATTORE) REFERENCES ATTORE(COD_ATTORE),
	PRIMARY KEY (COD_PROD, COD_ATTORE)
);

CREATE TABLE EDIZIONE_VENEZIA(
	ANNATA_VENEZIA INT PRIMARY KEY
);

CREATE TABLE EDIZIONE_OE(
	ANNATA_OE INT PRIMARY KEY
);

CREATE TABLE COMPOSTA_DA_ATTORE(
	ANNATA_VENEZIA INT,
	COD_ATTORE SERIAL,
	
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_ATTORE) REFERENCES ATTORE(COD_ATTORE),
	PRIMARY KEY (ANNATA_VENEZIA, COD_ATTORE)
);

CREATE TABLE COMPOSTA_DA_REGISTA(
	ANNATA_VENEZIA INT,
	COD_REGISTA SERIAL,
	
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_REGISTA) REFERENCES REGISTA(COD_REGISTA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_REGISTA)
);

CREATE TABLE COMPOSTA_DA_GIORNALISTA(
	ANNATA_VENEZIA INT,
	COD_GIORNALISTA SERIAL,
	
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_GIORNALISTA) REFERENCES GIORNALISTA(COD_GIORNALISTA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_GIORNALISTA)
);

CREATE TABLE NOMINATA_IN_OE(
	ANNATA_OE INT,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (ANNATA_OE) REFERENCES EDIZIONE_OE(ANNATA_OE),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_OE, COD_OPERA)
);

CREATE TABLE NOMINATA_IN_VENEZIA(
	ANNATA_VENEZIA INT,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_OPERA)
);

CREATE TABLE SPETTATORE(
	COD_SPETTATORE SERIAL PRIMARY KEY,
	NOME VARCHAR(255) NOT NULL,
	COGNOME VARCHAR(255) NOT NULL,
	DATA_DI_NASCITA DATE NOT NULL
);

CREATE TABLE SEGUE(
	COD_SPETTATORE_SEGUE SERIAL,
	COD_SPETTATORE_SEGUITO SERIAL,
	
	FOREIGN KEY (COD_SPETTATORE_SEGUE) REFERENCES SPETTATORE(COD_SPETTATORE),
	FOREIGN KEY (COD_SPETTATORE_SEGUITO) REFERENCES SPETTATORE(COD_SPETTATORE),
	PRIMARY KEY (COD_SPETTATORE_SEGUE, COD_SPETTATORE_SEGUITO)
);

CREATE TABLE GESTORE(
	COD_GESTORE SERIAL PRIMARY KEY,
	NOME VARCHAR(255) NOT NULL,
	COGNOME VARCHAR(255) NOT NULL,
	DATA_DI_NASCITA DATE NOT NULL
);

CREATE TABLE RECENSIONE(
	COD_SPETTATORE SERIAL NOT NULL,
	COD_OPERA SERIAL NOT NULL,
	TESTO TEXT,
	VALUTAZIONE INT NOT NULL CHECK (VALUTAZIONE < 6 AND VALUTAZIONE > 0),
	TIMESTAMP_CONT TIMESTAMP NOT NULL,
	
	FOREIGN KEY (COD_SPETTATORE) REFERENCES SPETTATORE(COD_SPETTATORE)  ON DELETE CASCADE,
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA)  ON DELETE CASCADE,
	PRIMARY KEY (COD_SPETTATORE, COD_OPERA)
);

CREATE TABLE COMMENTO(
	COD_COMMENTO SERIAL,
	COD_SPETTATORE SERIAL,
	COD_OPERA SERIAL,
	TESTO TEXT,
	TIMESTAMP_CONT TIMESTAMP NOT NULL,
	COD_SPETTATORE_SCRIVE SERIAL,
	
	FOREIGN KEY (COD_SPETTATORE_SCRIVE) REFERENCES SPETTATORE(COD_SPETTATORE),
	FOREIGN KEY (COD_OPERA, COD_SPETTATORE) REFERENCES RECENSIONE(COD_OPERA, COD_SPETTATORE),
	PRIMARY KEY (COD_SPETTATORE, COD_OPERA, COD_COMMENTO, COD_SPETTATORE_SCRIVE)	
);

CREATE TABLE VOTA_SPETTATORE(
	ANNATA_OE INT,
	COD_SPETTATORE SERIAL,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_SPETTATORE) REFERENCES SPETTATORE(COD_SPETTATORE),
	FOREIGN KEY (ANNATA_OE) REFERENCES EDIZIONE_OE(ANNATA_OE),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_OE, COD_SPETTATORE)
);

CREATE TABLE VOTA_ATTORE(
	ANNATA_VENEZIA INT,
	COD_ATTORE SERIAL,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_ATTORE) REFERENCES ATTORE(COD_ATTORE),
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_ATTORE)
);

CREATE TABLE VOTA_REGISTA(
	ANNATA_VENEZIA INT,
	COD_REGISTA SERIAL,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_REGISTA) REFERENCES REGISTA(COD_REGISTA),
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_REGISTA)
);

CREATE TABLE VOTA_GIORNALISTA(
	ANNATA_VENEZIA INT,
	COD_GIORNALISTA SERIAL,
	COD_OPERA SERIAL,
	
	FOREIGN KEY (COD_GIORNALISTA) REFERENCES GIORNALISTA(COD_GIORNALISTA),
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	PRIMARY KEY (ANNATA_VENEZIA, COD_GIORNALISTA)
);

CREATE TABLE PROIEZIONE(
	COD_PROD SERIAL,
	DATA_PROIEZIONE DATE,
	ORA TIME,
	
	FOREIGN KEY (COD_PROD) REFERENCES PRODUZIONE(COD_PROD),
	PRIMARY KEY (COD_PROD, DATA_PROIEZIONE, ORA)
);

CREATE TABLE ISCRIZIONE(
	COD_PROD SERIAL,
	DATA_PROIEZIONE DATE,
	ORA TIME,
	COD_SPETTATORE SERIAL,
	
	FOREIGN KEY (COD_PROD, DATA_PROIEZIONE, ORA) REFERENCES PROIEZIONE(COD_PROD, DATA_PROIEZIONE, ORA),
	FOREIGN KEY (COD_SPETTATORE) REFERENCES SPETTATORE(COD_SPETTATORE),
	PRIMARY KEY (COD_PROD, DATA_PROIEZIONE, ORA, COD_SPETTATORE)
);

CREATE TABLE PREMIO_OE(
	COD_OPERA SERIAL,
	ANNATA_OE INT,
	
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	FOREIGN KEY (ANNATA_OE) REFERENCES EDIZIONE_OE(ANNATA_OE),
	PRIMARY KEY (COD_OPERA, ANNATA_OE)
);

CREATE TABLE PREMIO_VENEZIA(
	COD_OPERA SERIAL,
	ANNATA_VENEZIA INT,
	
	FOREIGN KEY (COD_OPERA) REFERENCES OPERA_AUDIOVISIVA(COD_OPERA),
	FOREIGN KEY (ANNATA_VENEZIA) REFERENCES EDIZIONE_VENEZIA(ANNATA_VENEZIA),
	PRIMARY KEY (COD_OPERA, ANNATA_VENEZIA)
);