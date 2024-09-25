-- TP3.sql
-- Jean-François Condotta
-- 21/09/2022
\qecho
\qecho '***************************************************************************'
\qecho '***************************************************************************'
\qecho '* TP 3 - Triggers - PL/pgSQL - BUT2 Informatique - Jean-François Condotta *'
\qecho '***************************************************************************'
\qecho '***************************************************************************'
\qecho
\qecho 'Complétez ce fichier aux endroits marqués Travail à réaliser.'
\qecho 'À chaque ajout, relancez ce script et vérifiez que l''affichage produit est correct.'
\qecho 'Vous pouvez également comparer la trace des affichages avec le fichier trace fourni.'
\qecho
\qecho 'Bon TP !!!'
\qecho
\qecho '***************************************************************************'

SET client_min_messages TO info;
-- Pour s'arrêter lorsqu'il y a une première erreur
\set ON_ERROR_STOP on

-- Affichage de la valeur null avec la chaîne de caractères 'NULL'
\pset null 'NULL'
\qecho
\qecho 'Suppression et création du schéma BD_ENCHERES ...'
-- Suppression et création du schéma
DROP SCHEMA IF EXISTS BD_ENCHERES CASCADE;
CREATE SCHEMA BD_ENCHERES;
SET search_path TO BD_ENCHERES;

\qecho 'Création de la table PERSONNE ...'

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

\qecho 'Contenu de la table PERSONNE ...'

-- Affichage du contenu de la table PERSONNE
SELECT * FROM PERSONNE;

\qecho 'Création de la table ARTICLE ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la table ARTICLE

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

\qecho 'Contenu de la table ARTICLE ...'

-- Affichage du contenu de la table ARTICLE
SELECT * FROM ARTICLE;

\qecho 'Création de la table OFFRE ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la table OFFRE

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

\qecho '***************************************************************************'
\qecho 'Insertion d''enregistrements dans la table OFFRE ...'

\qecho 'Contenu de la table OFFRE ...'

-- Affichage du contenu de la table OFFRE
SELECT * FROM OFFRE;

\qecho '***************************************************************************'
\qecho 'Travail à réaliser 1'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_personne_insert_update_1 et du trigger tg_personne_insert_update_1 ...'

-----------------------------------------------------------------------------------
CREATE FUNCTION fn_personne_insert_update_1() RETURNS TRIGGER AS
$$
	BEGIN
		NEW.prenom=initcap(NEW.prenom);
		NEW.nom=upper(NEW.nom);
		NEW.email=lower(NEW.email);
		RETURN NEW;
	END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER tg_donateur_insert_update_1
BEFORE INSERT OR UPDATE OF prenom,nom,email ON PERSONNE
FOR EACH ROW
EXECUTE FUNCTION fn_personne_insert_update_1();
-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 1'
\qecho '***************************************************************************'

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;

\qecho 'Exécution de la requête SQL suivante ...'
\qecho 
\qecho 'INSERT INTO PERSONNE(nom,prenom,date_naissance,email) VALUES'
\qecho '(''devos'',''Evelyne'',''2000-10-01'',''devos31@yahoo.fr''),'
\qecho '(''PANAHI'',''LOU'',''1998-12-10'',''lou_panahi@gmail.com''),'
\qecho '(''Buzek'',''Elsa'',''1999-12-10'',''zaza62@yahoo.fr''),'
\qecho '(''AMALRIC'',''Jeanne'',''2002-03-04'',''jeanne.amalric@free.fr''),'
\qecho '(''PHEONIX'',''ARTHUR'',''2002-01-01'',''ART_PHEONIX@WANADOO.COM'');'
\qecho 

INSERT INTO PERSONNE(nom,prenom,date_naissance,email) VALUES
('devos','Evelyne','2000-10-01','devos31@yahoo.fr'),
('PANAHI','LOU','1998-12-10','lou_panahi@gmail.com'),
('Buzek','Elsa','1999-12-10','zaza62@yahoo.fr'),
('AMALRIC','Jeanne','2002-03-04','jeanne.amalric@free.fr'),
('PHEONIX','ARTHUR','2002-01-01','ART_PHEONIX@WANADOO.COM');

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;

\qecho 'Exécution de la requête SQL suivante ...'
\qecho 
\qecho 'UPDATE PERSONNE'
\qecho 'SET nom=''devos'',prenom=''evelyne'',email=''devos31@yahoo.fr'''
\qecho 'WHERE id_personne=1;'
\qecho 

UPDATE PERSONNE
SET nom='devos',prenom='evelyne',email='devos31@yahoo.fr'
WHERE id_personne=1;

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;


\qecho '***************************************************************************'
\qecho 'Travail à réaliser 2'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_personne_update_delete_2 et du trigger tg_personne_update_delete_2 ...'

-----------------------------------------------------------------------------------
CREATE FUNCTION fn_personne_update_delete_2() RETURNS TRIGGER AS 
$$
	BEGIN
	RAISE EXCEPTION 'Opération non permise !';
	END 
$$ 
LANGUAGE PLPGSQL;

CREATE TRIGGER tg_personne_update_delete_2
BEFORE DELETE OR UPDATE OF id_personne ON PERSONNE
FOR EACH STATEMENT EXECUTE FUNCTION fn_personne_update_delete_2();
-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 2'
\qecho '***************************************************************************'

\qecho 'Tentative de suppression des personnes identifiées par 1 et 2 ...'
DO LANGUAGE plpgsql
$$
BEGIN
DELETE FROM PERSONNE
WHERE id_personne=1 OR id_personne=2;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative de maj de l''identifiant de personne 1 par 100 ...'
DO LANGUAGE plpgsql
$$
BEGIN
UPDATE PERSONNE
SET id_personne=100
WHERE id_personne=1;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;

\qecho '***************************************************************************'
\qecho 'Travail à réaliser 3'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_personne_insert_3 et du trigger tg_personne_insert_3 ...'

-----------------------------------------------------------------------------------
CREATE FUNCTION fn_personne_insert_3() RETURNS TRIGGER AS 
$$
DECLARE
	nb INTEGER;
BEGIN
	SELECT COUNT(*) INTO nb FROM PERSONNE;
	RAISE INFO 'Nombre de personnes : %', nb;
	RETURN NULL;
END 
$$ 
LANGUAGE PLPGSQL;

CREATE TRIGGER tg_personne_insert_3
AFTER INSERT ON PERSONNE
FOR EACH STATEMENT 
EXECUTE FUNCTION fn_personne_insert_3();
-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 3'
\qecho '***************************************************************************'
\qecho '***************************************************************************'

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;

\qecho 'Insertion de 5 nouveaux enregistrements dans la table PERSONNE ...'

INSERT INTO PERSONNE(nom,prenom,date_naissance,email) VALUES
('PEUPLIER','JORDAN','2001-02-20','J_PEUPLIER@HOTMAIL.COM'),
('MAISON','MARION','2001-05-12','MARION45@ORANGE.FR'),
('BIOLAY','AMÉLIE','1995-06-14','BIOLAY_AMELIE@GMAIL.COM'),
('MANDOSKI','JULES','1985-03-22','MANDOSKI@LAPOSTE.FR'),
('GLYCINE','LUCAS','1995-09-23','LUCAS.GLYCINE_62@GMAIL.COM');

\qecho 'Contenu de la table PERSONNE ...'
\qecho 
SELECT * FROM PERSONNE;

\qecho '***************************************************************************'
\qecho 'Travail à réaliser 4'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_article_insert_delete_4 et du trigger tg_article_insert_delete_4 ...'

-----------------------------------------------------------------------------------
CREATE FUNCTION fn_article_insert_delete_4() RETURNS TRIGGER AS 
$$
BEGIN
	IF(TG_OP = 'INSERT') THEN
		IF(NEW.etat != 'En vente') OR (NEW.id_acheteur IS NOT NULL) OR (NEW.prix_achat IS NOT NULL) THEN
			RAISE EXCEPTION 'Insertion impossible !';
		END IF;
			PERFORM *
			FROM ARTICLE
			WHERE(ARTICLE.id_vendeur = NEW.id_vendeur)
			AND EXTRACT('month' FROM date_depot) = EXTRACT('month' FROM NEW.date_depot)
			AND EXTRACT('year' FROM date_depot) = EXTRACT('year' FROM NEW.date_depot);
			IF FOUND THEN
				RAISE EXCEPTION 'Insertion impossible !';
			END IF;
		RETURN NEW;
	END IF;
	IF(OLD.etat = 'En vente') THEN
		RETURN OLD;
	END IF;
	RAISE EXCEPTION 'Suppression impossible !';
END 
$$ 
LANGUAGE PLPGSQL;

CREATE TRIGGER tg_article_insert_delete_4
BEFORE INSERT OR DELETE ON ARTICLE
FOR EACH ROW
EXECUTE FUNCTION fn_article_insert_delete_4();
-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 4'
\qecho '***************************************************************************'

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Insertion de 9 articles dans la table ARTICLE qui ne devraient pas poser de problème ...'

INSERT INTO ARTICLE(designation,prix_article,id_vendeur,date_depot) VALUES
('Bonnet bleu',0.5,1,'2020-06-20'),
('Trottinette Adule MW34',50,2,'2020-06-25'),
('Vélo Voyageur Y300 XL',100,1,'2020-10-02'),
('Lot de 50 billes',2.5,1,'2020-12-12'),
('Ordinateur Pell 564',350,4,'2021-03-04'),
('Ordinateur Pochiba 400',345,4,'2021-06-20'),
('VTT Mountain 450 Taille S',75.5,1,'2021-10-15'),
('Truelle',2.5,8,'2022-05-05'),
('Pioche',4.25,8,'2022-07-15');

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Tentative de l''insertion d''un article avec un état ''Vendu'' ...' 
DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO ARTICLE(designation,prix_article,id_vendeur,date_depot,etat) VALUES ('Cerf-volant CVT8',4.75,1,'2022-01-18','Vendu');
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative de l''insertion d''un article avec un ientifiant d''acheteur non null ...' 
DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO ARTICLE(designation,prix_article,id_vendeur,date_depot,id_acheteur) VALUES ('Cerf-volant CVT8',4.75,1,'2022-01-18',2);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative de l''insertion d''un article avec un prix d''acheteur non null ...' 
DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO ARTICLE(designation,prix_article,id_vendeur,date_depot,prix_achat) VALUES ('Cerf-volant CVT8',4.75,1,'2022-01-18',10.0);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative de l''insertion d''un article d''un vendeur ayant déjà soumis un article le même mois ...' 
DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO ARTICLE(designation,prix_article,id_vendeur,date_depot) VALUES ('Cerf-volant CVT8',4.75,1,'2021-10-17');
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;


\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Suppression de l''article 9 (cela ne devrait pas poser de problème) ...' 
DELETE FROM ARTICLE
WHERE id_article=9;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'On fait passer l''article 8 à l''état ''Vendu'' ...'
UPDATE ARTICLE
SET etat='Vendu'
WHERE id_article=8;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Tentative de suppression de l''article 8 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
DELETE FROM ARTICLE WHERE id_article=8;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'On refait passer l''article 8 à l''état ''En vente'' ...'
UPDATE ARTICLE
SET etat='En vente'
WHERE id_article=8;



\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;


\qecho '***************************************************************************'
\qecho 'Travail à réaliser 5'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_article_update_5 et du trigger tg_article_update_5 ...'

-----------------------------------------------------------------------------------
CREATE FUNCTION fn_article_update_5() RETURNS TRIGGER AS 
$$
DECLARE
	id INTEGER;
	montant NUMERIC(12, 2);
BEGIN
	IF (NEW.id_article != OLD.id_article) OR 
	   (NEW.designation != OLD.designation) OR 
	   (NEW.prix_article != OLD.prix_article) OR 
	   (NEW.date_depot != OLD.date_depot) OR 
	   (OLD.etat != 'En vente') THEN
		RAISE EXCEPTION 'Mise à jour impossible !';
	END IF;
	
	SELECT id_encherisseur, montant_offre INTO id, montant
	FROM OFFRE
	WHERE id_article = NEW.id_article
	ORDER BY montant_offre DESC
	LIMIT 1;

	IF (NEW.etat = 'Non vendu') AND (id IS NOT NULL) THEN
		RAISE EXCEPTION 'Mise à jour impossible !';
	END IF;

	IF (NEW.etat = 'Vendu') AND 
	   ((id IS NULL) OR (montant IS NULL) OR 
	   (id != NEW.id_acheteur) OR (montant != NEW.prix_achat)) THEN
		RAISE EXCEPTION 'Mise à jour impossible !';
	END IF;

	RETURN NEW;
END 
$$ 
LANGUAGE PLPGSQL;

CREATE TRIGGER tg_article_update_5
BEFORE UPDATE ON ARTICLE
FOR EACH ROW
EXECUTE FUNCTION fn_article_update_5();
-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 5'
\qecho '***************************************************************************'

\qecho 'On ajoute quelques offres ...' 
-- Insertion de quelques offres ...

INSERT INTO OFFRE VALUES
(1,6,2,'2022-01-19',1002.5),
(4,6,5,'2022-01-25',1003.75),
(7,6,2,'2022-07-04',1005.0),
(8,7,3,'2022-07-17',105.2),
(9,7,4,'2022-07-18',108),
(10,7,5,'2022-07-20',1010),
(11,6,5,'2022-08-15',1006.5),
(12,6,6,'2022-08-15',1008.2),
(13,6,2,'2022-08-17',1009),
(14,7,3,'2022-07-18',1012)
;
\qecho 'Contenu de la table OFFRE ...'
\qecho 
SELECT * FROM OFFRE;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Tentative de changer l''identifiant de l''article 1 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
UPDATE ARTICLE
SET id_article=1000
WHERE id_article=1;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'L''article 1 est mis comme ''Non vendu'' ...'
UPDATE ARTICLE
SET etat='Non vendu'
WHERE id_article=1;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Tentative de remettre à l''état ''En vente'' l''article 1 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
UPDATE ARTICLE
SET etat='En vente'
WHERE id_article=1;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'Tentative de mettre à l''état ''Vendu'' l''article 6 avec des valeurs ne correspondant pas à la meilleur offre ...' 

DO LANGUAGE plpgsql
$$
BEGIN
UPDATE ARTICLE
SET etat='Vendu',id_acheteur=3,prix_achat=30000
WHERE id_article=6;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho 'L''article 6 est mis comme ''Vendu'' avec les valeurs de la meilleure offre ...'
UPDATE ARTICLE
SET etat='Vendu',id_acheteur=2,prix_achat=1009
WHERE id_article=6;

\qecho 'Contenu de la table ARTICLE ...'
\qecho 
SELECT * FROM ARTICLE;

\qecho '***************************************************************************'
\qecho 'Travail à réaliser 6'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_offre_update_6 et du trigger tg_offre_update_6 ...'

-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 6'
\qecho '***************************************************************************'

\qecho 'Contenu de la table OFFRE ...'
\qecho 
SELECT * FROM OFFRE;

\qecho 'Tentative de mise à jour de l''offre 14 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
UPDATE OFFRE
SET montant_offre=2*montant_offre
WHERE id_article=14;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho '***************************************************************************'
\qecho 'Travail à réaliser 7'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_offre_delete_7 et du trigger tg_offre_delete_7 ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la fonction et du trigger



-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 7'
\qecho '***************************************************************************'

\qecho 'Contenu de la table OFFRE ...'
\qecho 
SELECT * FROM OFFRE;

\qecho 'Tentative de suppression des offres correspondant à l''article 7 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
DELETE FROM OFFRE
WHERE id_article=7;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table OFFRE ...'
\qecho 
SELECT * FROM OFFRE;

\qecho 'Tentative de suppression des offres correspondant à l''article 6 ...' 

DO LANGUAGE plpgsql
$$
BEGIN
DELETE FROM OFFRE
WHERE id_article=6;
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Contenu de la table OFFRE ...'
\qecho 
SELECT * FROM OFFRE;


\qecho '***************************************************************************'
\qecho 'Travail à réaliser 8'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_offre_insert_8 et du trigger tg_offre_insert_8 ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la fonction et du trigger



-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 8'
\qecho '***************************************************************************'

\qecho 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\qecho 'Tentative d''insertion d''une nouvelle offre pour l''article 1 (état ''Non vendu'') ...' 

DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO OFFRE(id_article,id_encherisseur,date_offre,montant_offre)
VALUES (1,2,'2022-09-21',10000);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative d''insertion d''une nouvelle offre pour l''article 2 avec une mauvaise date ...' 

DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO OFFRE(id_article,id_encherisseur,date_offre,montant_offre)
VALUES (2,3,'2004-09-21',10000);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;

\qecho 'Tentative d''insertion d''une nouvelle offre pour l''article 2 (cela doit fonctionner) ...' 

DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO OFFRE(id_article,id_encherisseur,date_offre,montant_offre)
VALUES (2,3,'2022-09-21',10000);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;
\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\qecho 'Tentative d''insertion d''une nouvelle offre pour l''article 2 (cela doit fonctionner) ...' 

DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO OFFRE(id_article,id_encherisseur,date_offre,montant_offre)
VALUES (2,4,'2022-09-21',10200);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;
\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\qecho 'Tentative d''insertion d''une nouvelle offre pour l''article 2 (avec un montant trop bas) ...' 

DO LANGUAGE plpgsql
$$
BEGIN
INSERT INTO OFFRE(id_article,id_encherisseur,date_offre,montant_offre)
VALUES (2,6,'2022-09-21',10200);
EXCEPTION
	WHEN OTHERS THEN
		RAISE INFO 'Une exception a été levée avec le message : %',SQLERRM;
END;
$$;
\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;


\qecho '***************************************************************************'
\qecho 'Travail à réaliser 9'
\qecho '***************************************************************************'
\qecho 'Création de la fonction fn_article_update_9 et du trigger tg_article_update_9 ...'

-----------------------------------------------------------------------------------
-- Mettre ici l'ordre de création de la fonction et du trigger



-----------------------------------------------------------------------------------

\qecho '***************************************************************************'
\qecho 'Affichage 9'
\qecho '***************************************************************************'

\qecho 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\qecho 'On finalise la vente de l''article 7 ...'
UPDATE ARTICLE
SET etat='Vendu', id_acheteur=3,prix_achat=1012
WHERE id_article=7;

\qecho 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;

\qecho 'On finalise la vente de l''article 2 ...'
UPDATE ARTICLE
SET etat='Vendu', id_acheteur=4,prix_achat=10200
WHERE id_article=2;

\qecho 'Contenu de la table ARTICLE ...'
SELECT * FROM ARTICLE;

\qecho 'Contenu de la table OFFRE ...'
SELECT * FROM OFFRE;


