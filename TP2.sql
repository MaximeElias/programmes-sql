-- TP2.sql
-- Jean-François Condotta
-- 14/09/2022
\echo
\echo '***************************************************************************'
\echo '***************************************************************************'
\echo '* TP 2 - Fonctions PL/pgSQL - BUT2 Informatique - Jean-François Condotta  *'
\echo '***************************************************************************'
\echo '***************************************************************************'
\echo
\echo 'Complétez ce fichier aux endroits marqués Travail à réaliser.'
\echo 'À chaque ajout, relancez ce script et vérifiez que l''affichage produit est correct.'
\echo 'Vous pouvez également comparer la trace des affichages avec le fichier trace fourni.'
\echo
\echo 'Bon TP !!!'
\echo
\echo '***************************************************************************'

SET client_min_messages TO info;
-- Pour s'arrêter lorsqu'il y a une première erreur
\set ON_ERROR_STOP on

-- Affichage de la valeur null avec la chaîne de caractères 'NULL'
\pset null 'NULL'
\echo
\echo 'Suppression et création du schéma BD_ENCHERES ...'
-- Suppression et création du schéma
DROP SCHEMA IF EXISTS BD_ENCHERES CASCADE;
CREATE SCHEMA BD_ENCHERES;
SET search_path TO BD_ENCHERES;

\echo 'Création de la table PERSONNE ...'

-----------------------------------------------------------------------------------


CREATE TABLE PERSONNE (
	id_personne SERIAL PRIMARY KEY,
	nom VARCHAR(100) NOT NULL,
	prenom VARCHAR(100) NOT NULL,
	date_naissance DATE NOT NULL,
	email VARCHAR(100) NOT NULL,
	CHECK(LENGTH(nom)>0),
	CHECK(LENGTH(prenom)>0),
	CHECK(LENGTH(email)>0),
	UNIQUE(email)
);
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Insertion d''enregistrements dans la table PERSONNE ...'

-- Insertion de quelques personnes ...
INSERT INTO PERSONNE VALUES
(1,'Devos','Evelyne','2000-10-01','devos31@yahoo.fr'),
(2,'Panahi','Lou','1998-12-10','lou_panahi@gmail.com'),
(3,'Buzek','Elsa','1999-12-10','zaza62@yahoo.fr'),
(4,'Amalric','Jeanne','2002-03-04','jeanne.amalric@free.fr'),
(5,'Pheonix','Arthur','2002-01-01','art_phoenix@wanadoo.com'),
(6,'Peuplier','Jordan','2001-02-20','j_peuplier@hotmail.com'),
(7,'Maison','Marion','2001-05-12','marion45@orange.fr'),
(8,'Biolay','Amélie','1995-06-14','biolay_amelie@gmail.com'),
(9,'Mandoski','Jules','1985-03-22','mandoski@laposte.fr'),
(10,'Glycine','Lucas','1995-09-23','lucas.glycine_62@gmail.com')
;

-- Mise à jour de la série associée à PERSONNE.id_personne
SELECT setval(pg_get_serial_sequence('personne', 'id_personne'),MAX(id_personne))
FROM PERSONNE;

\echo 'Contenu de la table PERSONNE ...'

-- Affichage du contenu de la table PERSONNE
SELECT * FROM PERSONNE;

\echo 'Création de la table ARTICLE ...'

-----------------------------------------------------------------------------------


CREATE TABLE ARTICLE (
	id_article SERIAL PRIMARY KEY,
	designation VARCHAR(100) NOT NULL,
	prix_article NUMERIC(12,2) NOT NULL,
	id_vendeur INTEGER NOT NULL,
	date_depot DATE DEFAULT CURRENT_DATE NOT NULL,
	etat VARCHAR(10) DEFAULT 'En vente' NOT NULL,
	id_acheteur INTEGER,
	prix_achat	NUMERIC(12,2),
	CHECK(LENGTH(designation)>0),
	CHECK(etat IN ('En vente','Vendu','Non vendu')),
	FOREIGN KEY (id_vendeur) REFERENCES PERSONNE(id_personne),
	FOREIGN KEY (id_acheteur) REFERENCES PERSONNE(id_personne),
	CHECK (prix_article>0.0),
	CHECK (prix_achat>=prix_article)
);
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Insertion d''enregistrements dans la table ARTICLE ...'

-- Insertion de quelques articles ...
INSERT INTO ARTICLE VALUES
(1,'Bonnet bleu',0.5,1,'2020-06-20','Vendu',5,2.75),
(2,'Trottinette Adule MW34',50,2,'2020-06-25','Vendu',6,60.0),
(3,'Vélo Voyageur Y300 XL',100,1,'2020-10-02','Vendu',4,107),
(4,'Lot de 50 billes',2.5,1,'2020-12-12','Non vendu',null,null),
(5,'Ordinateur Pell 564',350,4,'2021-03-04','Vendu',5,425.5),
(6,'Ordinateur Pochiba 400',345,4,'2021-06-20','Non vendu',null,null),
(7,'VTT Mountain 450 Taille S',75.5,1,'2021-10-15','Vendu',7,97.8),
(8,'Cerf-volant CVT8',4.75,6,'2022-01-18','En vente',null,null),
(9,'Truelle',2.5,8,'2022-05-05','En vente',null,null),
(10,'Pioche',4.25,8,'2022-07-15','En vente',null,null)
;

-- Mise à jour de la série associée à ARTICLE.id_article
SELECT setval(pg_get_serial_sequence('article', 'id_article'),MAX(id_article))
FROM ARTICLE;


\echo 'Contenu de la table ARTICLE ...'

-- Affichage du contenu de la table ARTICLE
SELECT * FROM ARTICLE;

\echo 'Création de la table OFFRE ...'

-----------------------------------------------------------------------------------


CREATE TABLE OFFRE (
	id_offre SERIAL PRIMARY KEY,
	id_article INTEGER NOT NULL,
	id_encherisseur INTEGER NOT NULL,
	date_offre DATE DEFAULT CURRENT_DATE NOT NULL,
	montant_offre NUMERIC(12,2) NOT NULL,
	FOREIGN KEY (id_encherisseur) REFERENCES PERSONNE(id_personne),
	FOREIGN KEY (id_article) REFERENCES ARTICLE(id_article),
	CHECK (montant_offre>0.0)
);
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Insertion d''enregistrements dans la table OFFRE ...'

-- Insertion de quelques offres ...
INSERT INTO OFFRE VALUES
(1,8,2,'2022-01-19',2.5),
(4,8,5,'2022-01-25',3.75),
(7,8,2,'2022-07-04',5.0),
(8,10,3,'2022-07-17',5.2),
(9,10,4,'2022-07-18',8),
(10,10,5,'2022-07-20',10),
(11,8,5,'2022-08-15',6.5),
(12,8,6,'2022-08-15',8.2),
(13,8,2,'2022-08-17',9),
(14,10,1,'2022-07-18',12)
;

-- Mise à jour de la série associée à OFFRE.id_offre
SELECT setval(pg_get_serial_sequence('offre', 'id_offre'),MAX(id_offre))
FROM OFFRE;

\echo 'Contenu de la table OFFRE ...'

-- Affichage du contenu de la table OFFRE
SELECT * FROM OFFRE;

\echo '***************************************************************************'
\echo 'Travail à réaliser 1'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_articles_vendus_personne ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_articles_vendus_personne(
	id_personne INTEGER
) 
RETURNS INTEGER AS
$$
DECLARE
	nb integer;
BEGIN
	SELECT COUNT(*) INTO nb FROM ARTICLE WHERE id_vendeur = id_personne AND etat = 'Vendu';
	RETURN nb;
END
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 1'
\echo '***************************************************************************'

\echo 'Le nombre d''articles vendus par la personne identifiée par 1 ...'

SELECT nb_articles_vendus_personne(1);

\echo 'Le nombre d''articles vendus par la personne identifiée par 8 ...'

SELECT nb_articles_vendus_personne(8);

\echo 'Le nombre d''articles vendus par la personne identifiée par 20 (elle n''existe pas) ...'

SELECT nb_articles_vendus_personne(20);

\echo '***************************************************************************'
\echo 'Travail à réaliser 2'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_articles_vendus_personne_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_articles_vendus_personne_2(
	id_personne INTEGER
) 
RETURNS INTEGER AS
$$
DECLARE
	nb integer;
BEGIN
	SELECT COUNT(*) INTO nb FROM PERSONNE WHERE nb_articles_vendus_personne_2.id_personne = PERSONNE.id_personne;
	IF nb = 0 THEN
		RAISE WARNING 'Identifiant de personne inconnu !';
		RETURN NULL;
	END IF;
	SELECT COUNT(*) INTO nb FROM ARTICLE WHERE id_vendeur = id_personne AND etat = 'Vendu';
	RETURN nb;
END
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 2'
\echo '***************************************************************************'

\echo 'Le nombre d''articles vendus par la personne identifiée par 1 ...'

SELECT nb_articles_vendus_personne_2(1);

\echo 'Le nombre d''articles vendus par la personne identifiée par 8 ...'

SELECT nb_articles_vendus_personne_2(8);

\echo 'Le nombre d''articles vendus par la personne identifiée par 20 (elle n''existe pas) ...'

SELECT nb_articles_vendus_personne_2(20);

\echo '***************************************************************************'
\echo 'Travail à réaliser 3'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_articles_vendus_personne_3 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_articles_vendus_personne_3(
	id_personne INTEGER
) 
RETURNS INTEGER AS
$$
DECLARE
	nb integer;
BEGIN
	PERFORM * FROM PERSONNE WHERE nb_articles_vendus_personne_3.id_personne = PERSONNE.id_personne;
	IF NOT FOUND THEN
		RAISE WARNING 'Identifiant de personne inconnu !';
		RETURN NULL;
	END IF;
	SELECT nb_articles_vendus_personne(id_personne) INTO nb;
	RETURN nb;
END
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 3'
\echo '***************************************************************************'

\echo 'Le nombre d''articles vendus par la personne identifiée par 1 ...'

SELECT nb_articles_vendus_personne_3(1);

\echo 'Le nombre d''articles vendus par la personne identifiée par 8 ...'

SELECT nb_articles_vendus_personne_3(8);

\echo 'Le nombre d''articles vendus par la personne identifiée par 20 (elle n''existe pas) ...'

SELECT nb_articles_vendus_personne_3(20);

\echo '***************************************************************************'
\echo 'Travail à réaliser 4'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_articles_personne ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_articles_personne(
	IN id_personne INTEGER, 
	OUT nb_vendus INTEGER, 
	OUT nb_non_vendus INTEGER, 
	OUT nb_en_vente INTEGER
) 
AS
$$
DECLARE
	nb integer;
BEGIN
	PERFORM * FROM PERSONNE WHERE nb_articles_personne.id_personne = PERSONNE.id_personne;
	IF NOT FOUND THEN
		RETURN;
	END IF;
	SELECT nb_articles_vendus_personne(id_personne) INTO nb_vendus;
	SELECT COUNT(*) INTO nb_non_vendus FROM ARTICLE WHERE id_vendeur = id_personne AND etat = 'Non vendu';
	SELECT COUNT(*) INTO nb_en_vente FROM ARTICLE WHERE id_vendeur = id_personne AND etat = 'En vente';
END
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 4'
\echo '***************************************************************************'

\echo 'Le nombre d''articles vendus/non vendus/en vente par la personne identifiée par 1 ...'


SELECT (nb_articles_personne(1)).nb_vendus,(nb_articles_personne(1)).nb_non_vendus,(nb_articles_personne(1)).nb_en_vente;

\echo 'Le nombre d''articles vendus/non vendus/en vente par la personne identifiée par 8 ...'

SELECT * FROM nb_articles_personne(8);

\echo 'Le nombre d''articles vendus/non vendus/en vente par la personne identifiée par 20 (elle n''existe pas) ...'

SELECT (nb_articles_personne(20)).*;


\echo '***************************************************************************'
\echo 'Travail à réaliser 5'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_articles_personnes ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_articles_personnes(
    OUT id_personne INTEGER, 
    OUT prenom VARCHAR, 
    OUT nom VARCHAR, 
    OUT nb_vendus INTEGER, 
    OUT nb_non_vendus INTEGER, 
    OUT nb_en_vente INTEGER
) 
RETURNS SETOF RECORD AS
$$
BEGIN
    FOR id_personne, prenom, nom IN
        SELECT PERSONNE.id_personne, PERSONNE.prenom, PERSONNE.nom
        FROM PERSONNE
    LOOP
        SELECT (nb_articles_personne(id_personne)).* 
        INTO nb_vendus, nb_non_vendus, nb_en_vente;
        RETURN NEXT;
    END LOOP;
END
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 5'
\echo '***************************************************************************'

\echo 'Le nombre d''articles vendus/non vendus/en vente des différentes personnes ...'

SELECT * FROM nb_articles_personnes();

\echo '***************************************************************************'
\echo 'Travail à réaliser 6'
\echo '***************************************************************************'
\echo 'Création de la procedure creation_table_vendeur ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE creation_table_vendeur()
AS
$$
BEGIN
    DROP TABLE IF EXISTS VENDEUR CASCADE;
    
    CREATE TABLE VENDEUR (
        id_personne INTEGER PRIMARY KEY,
        nom VARCHAR(255),
        prenom VARCHAR(255),
        nb_vendus INTEGER,
        nb_non_vendus INTEGER,
        nb_en_vente INTEGER
    );
END;
$$
LANGUAGE plpgsql;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 6'
\echo '***************************************************************************'

\echo 'Création de la table VENDEUR et affichage de son contenu (vide) ...'

CALL creation_table_vendeur();

SELECT * FROM VENDEUR;

\echo 'Création de la table VENDEUR et affichage de son contenu (vide) ...'

CALL creation_table_vendeur();

SELECT * FROM VENDEUR;

\echo '***************************************************************************'
\echo 'Travail à réaliser 7'
\echo '***************************************************************************'
\echo 'Création de la procédure mise_a_jour_vendeur ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE mise_a_jour_vendeur()
AS
$$
BEGIN
    DELETE FROM VENDEUR;

    INSERT INTO VENDEUR (id_personne, prenom, nom, nb_vendus, nb_non_vendus, nb_en_vente)
    SELECT id_personne, prenom, nom, nb_vendus, nb_non_vendus, nb_en_vente
    FROM nb_articles_personnes();
END;
$$
LANGUAGE plpgsql;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 7'
\echo '***************************************************************************'

\echo 'Une première mise à jour de la table VENDEUR et l''affichage de son contenu ...'

CALL mise_a_jour_vendeur();

SELECT * FROM VENDEUR;

\echo 'Une seconde mise à jour de la table VENDEUR et l''affichage de son contenu ...'

CALL mise_a_jour_vendeur();

SELECT * FROM VENDEUR;

\echo '***************************************************************************'
\echo 'Travail à réaliser 8'
\echo '***************************************************************************'
\echo 'Création de la procédure est_acheteur ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION est_acheteur(
    IN id INTEGER
)
RETURNS BOOLEAN AS
$$
DECLARE
    exists_acheteur BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM ARTICLE WHERE id_acheteur = id)
    INTO exists_acheteur;

    RETURN exists_acheteur;
END;
$$
LANGUAGE plpgsql;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 8'
\echo '***************************************************************************'

\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Est-ce que 1 est un identifiant d''un acheteur ?'
SELECT est_acheteur(1);

\echo 'Est-ce que 4 est un identifiant d''un acheteur ?'
SELECT est_acheteur(4);

\echo 'Est-ce que 100 est un identifiant d''un acheteur ?'
SELECT est_acheteur(100);


\echo '***************************************************************************'
\echo 'Travail à réaliser 9'
\echo '***************************************************************************'
\echo 'Création de la procédure nouvelle_offre ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la fonction ou procédure




-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 9'
\echo '***************************************************************************'

\echo 'Contenu de la table PERSONNE ...'
SELECT * FROM PERSONNE;

\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\echo 'Insertion du don id_article=0, id_encherisseur=5, montant_offre=1000.50 (article inexistant) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(0,5,1000.5);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=1, id_encherisseur=5, montant_offre=1000.50 (article déjà vendu) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(1,5,1000.5);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=8, id_encherisseur=0, montant_offre=1000.50 (enchérisseur inexistant) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(8,0,1000.5);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=8, id_encherisseur=6, montant_offre=1000.50 (enchérisseur est le vendeur) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(8,6,1000.5);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=8, id_encherisseur=1, montant_offre=3 (montant strictement inférieur au prix de l''article) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(8,1,3.0);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=8, id_encherisseur=1, montant_offre=7 (offre moins bonne qu''une existante) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(8,1,7.0);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Insertion du don id_article=8, id_encherisseur=1, montant_offre=70 ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL nouvelle_offre(8,1,70);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 10'
\echo '***************************************************************************'
\echo 'Création de la procédure cloturer_vente ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la fonction ou procédure




-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 10'
\echo '***************************************************************************'


\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\echo 'Fin de la vente de l''article 0 (qui n''existe pas) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL cloturer_vente(0);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;
\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\echo 'Fin de la vente de l''article 1 (qui n''est plus en vente) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL cloturer_vente(1);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\echo 'Fin de la vente de l''article 9 (qui n''a pas d''offre associée) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL cloturer_vente(9);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\echo 'Fin de la vente de l''article 10 (qui a plusieurs offres d''associées) ...'
DO LANGUAGE plpgsql
$$
BEGIN
CALL cloturer_vente(10);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\echo 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\echo 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

