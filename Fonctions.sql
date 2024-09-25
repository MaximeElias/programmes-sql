-- TP1.sql
-- Jean-François Condotta
-- 03/09/2023
\echo
\echo '***************************************************************************'
\echo '***************************************************************************'
\echo '**   TP 1 - Fonctions SQL - BUT2 Informatique - Jean-François Condotta   **'
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

SET client_min_messages TO warning;
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

\echo '***************************************************************************'
\echo 'Création de la table PERSONNE ...'

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

\echo '***************************************************************************'
\echo 'Contenu de la table PERSONNE ...'

-- Affichage du contenu de la table PERSONNE
SELECT * FROM PERSONNE;

\echo '***************************************************************************'
\echo 'Création de la table ARTICLE ...'

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

\echo '***************************************************************************'
\echo 'Contenu de la table ARTICLE ...'

-- Affichage du contenu de la table ARTICLE
SELECT * FROM ARTICLE;

\echo '***************************************************************************'
\echo 'Création de la table OFFRE ...'

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

\echo '***************************************************************************'
\echo 'Contenu de la table OFFRE ...'

-- Affichage du contenu de la table OFFRE
SELECT * FROM OFFRE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 1'
\echo '***************************************************************************'
\echo 'Création de la fonction annee ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION annee(date_donnee DATE) RETURNS INT AS
$$
SELECT date_part('y', date_donnee)::INT
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 1'
\echo '***************************************************************************'
\echo 'L''identifiant et l''année de naissance des personnes ...'

SELECT id_personne,annee(date_naissance)
FROM PERSONNE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 2'
\echo '***************************************************************************'
\echo 'Création de la fonction annee_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION annee_2(date_donnee DATE) RETURNS INT AS
$$
SELECT extract(YEAR FROM date_donnee)::INT
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 2'
\echo '***************************************************************************'
\echo 'L''identifiant et l''année de naissance des personnes ...'

SELECT id_personne,annee_2(date_naissance)
FROM PERSONNE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 3'
\echo '***************************************************************************'
\echo 'Création de la fonction date_jjmmaaaa ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION date_jjmmaaaa(date_donnee DATE) RETURNS VARCHAR AS
$$
SELECT to_char(date_donnee, 'DD/MM/YYYY')
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 3'
\echo '***************************************************************************'
\echo 'L''identifiant et la date de naissance des personnes au format jj/mm/aaaa ...'

SELECT id_personne,date_jjmmaaaa(date_naissance)
FROM PERSONNE;



\echo '***************************************************************************'
\echo 'Travail à réaliser 4'
\echo '***************************************************************************'
\echo 'Création de la fonction mois_texte ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION mois_texte(mois INT) RETURNS VARCHAR AS
$$
SELECT
	CASE 
		WHEN mois = 1 THEN 'Janvier'
		WHEN mois = 7 THEN 'Juillet'
		WHEN mois = 8 THEN 'Août'
		WHEN mois = 9 THEN 'Septembre'
		WHEN mois = 2 THEN 'Février'
		WHEN mois = 3 THEN 'Mars'
		WHEN mois = 4 THEN 'Avril'
		WHEN mois = 5 THEN 'Mai'
		WHEN mois = 6 THEN 'Juin'
		WHEN mois = 10 THEN 'Ocotbre'
		WHEN mois = 11 THEN 'Novembre'
		WHEN mois = 12 THEN 'Décembre'
		ELSE NULL
	END 
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 4'
\echo '***************************************************************************'
\echo 'L''identifiant et le mois de naissance des personnes ...'

SELECT id_personne,mois_texte(date_part('month',date_naissance)::int) AS "Mois de naissance"
FROM PERSONNE;

\echo 'Résultat de SELECT mois_texte(50); ...'

SELECT mois_texte(50);



\echo '***************************************************************************'
\echo 'Travail à réaliser 5'
\echo '***************************************************************************'
\echo 'Création de la fonction date_texte ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION date_texte(d DATE) RETURNS VARCHAR AS
$$
SELECT to_char(d, 'DD ') || mois_texte(date_part('month', d)::INT) || to_char(d, ' YYYY')
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 5'
\echo '***************************************************************************'
\echo 'L''identifiant et la date de naissance des personnes ...'

SELECT id_personne,date_texte(date_naissance)
FROM PERSONNE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 6'
\echo '***************************************************************************'
\echo 'Création de la fonction designation_article ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION designation_article(id_article INT) RETURNS VARCHAR AS
$$
SELECT designation
FROM ARTICLE
WHERE id_article = designation_article.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 6'
\echo '***************************************************************************'
\echo 'La désignation de l''article identifié par 4 et celle de l''article identifié par 50 (qui n''existe pas) ...'

SELECT designation_article(4),designation_article(50);


\echo '***************************************************************************'
\echo 'Travail à réaliser 7'
\echo '***************************************************************************'
\echo 'Création de la fonction designation_article_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION designation_article_2(id_article INT, OUT designation VARCHAR) AS
$$
SELECT designation
FROM ARTICLE
WHERE id_article = designation_article_2.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 7'
\echo '***************************************************************************'
\echo 'La désignation de l''article identifié par 4 et celle de l''article identifié par 50 (qui n''existe pas) ...'

SELECT designation_article_2(4),designation_article_2(50);


\echo '***************************************************************************'
\echo 'Travail à réaliser 8'
\echo '***************************************************************************'
\echo 'Création de la fonction nom_email_personne ...'

-----------------------------------------------------------------------------------
DROP TYPE IF EXISTS type_nom_email CASCADE;

CREATE TYPE type_nom_email AS (
	nom VARCHAR,
	email VARCHAR
);

CREATE OR REPLACE FUNCTION nom_email_personne(id_personne INT) RETURNS type_nom_email AS
$$
SELECT nom, email
FROM PERSONNE
WHERE id_personne = nom_email_personne.id_personne
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 8'
\echo '***************************************************************************'
\echo 'Le nom et l''email de la personne identifiée par 3 ...'

SELECT (nom_email_personne(3)).nom,(nom_email_personne(3)).email;

\echo 'Le nom et l''email de la personne identifiée par 45 (qui n''existe pas) ...'

SELECT (nom_email_personne(45)).nom,(nom_email_personne(45)).email;


\echo '***************************************************************************'
\echo 'Travail à réaliser 9'
\echo '***************************************************************************'
\echo 'Création de la fonction nom_email_personne_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nom_email_personne_2(id_personne INT, OUT nom VARCHAR, OUT email VARCHAR) AS
$$
SELECT nom, email
FROM PERSONNE
WHERE id_personne = nom_email_personne_2.id_personne
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 9'
\echo '***************************************************************************'
\echo 'Le nom et l''email de la personne identifiée par 3 ...'

SELECT (nom_email_personne_2(3)).nom,(nom_email_personne_2(3)).email;

\echo 'Le nom et l''email de la personne identifiée par 45 (qui n''existe pas) ...'

SELECT (nom_email_personne_2(45)).nom,(nom_email_personne_2(45)).email;


\echo '***************************************************************************'
\echo 'Travail à réaliser 10'
\echo '***************************************************************************'
\echo 'Création de la fonction ids_vendeurs ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ids_vendeurs() RETURNS SETOF INTEGER AS
$$
SELECT DISTINCT id_vendeur
FROM ARTICLE
ORDER BY id_vendeur
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 10'
\echo '***************************************************************************'
\echo 'Les identifiants des différents vendeurs par ordre croissant ...'

SELECT ids_vendeurs();

\echo '***************************************************************************'
\echo 'Travail à réaliser 11'
\echo '***************************************************************************'
\echo 'Création de la fonction ids_vendeurs_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ids_vendeurs_2(OUT id_vendeur INT) RETURNS SETOF INTEGER AS
$$
SELECT DISTINCT id_vendeur
FROM ARTICLE
ORDER BY id_vendeur
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 11'
\echo '***************************************************************************'
\echo 'Les identifiants des différents vendeurs par ordre croissant ...'

SELECT id_vendeur FROM ids_vendeurs_2();

\echo '***************************************************************************'
\echo 'Travail à réaliser 12'
\echo '***************************************************************************'
\echo 'Création de la fonction ids_noms_emails_vendeurs ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ids_noms_emails_vendeurs(OUT id_vendeur INT, OUT nom VARCHAR, OUT email VARCHAR) RETURNS SETOF RECORD AS
$$
SELECT ids_vendeurs, (nom_email_personne(ids_vendeurs)).*
FROM ids_vendeurs()
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 12'
\echo '***************************************************************************'
\echo 'Les identifiants, noms et emails des différents vendeurs ...'

SELECT id_vendeur,nom,email FROM ids_noms_emails_vendeurs();


\echo '***************************************************************************'
\echo 'Travail à réaliser 13'
\echo '***************************************************************************'
\echo 'Création de la fonction ids_noms_emails_vendeurs_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ids_noms_emails_vendeurs_2() RETURNS TABLE(id_vendeur INTEGER, nom VARCHAR, email VARCHAR) AS
$$
SELECT ids_vendeurs_2, (nom_email_personne_2(ids_vendeurs_2)).*
FROM ids_vendeurs_2()
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 13'
\echo '***************************************************************************'
\echo 'Les identifiants, noms et emails des différents vendeurs ...'

SELECT id_vendeur,nom,email FROM ids_noms_emails_vendeurs_2();



\echo '***************************************************************************'
\echo 'Travail à réaliser 14'
\echo '***************************************************************************'
\echo 'Création de la fonction nouvelle_personne ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nouvelle_personne(IN nom VARCHAR, IN prenom VARCHAR, IN date_naissance DATE, IN email VARCHAR) RETURNS VOID AS
$$
INSERT INTO PERSONNE(nom, prenom, date_naissance, email) VALUES(nom, prenom, date_naissance, email)
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 14'
\echo '***************************************************************************'
\echo 'Insertion de la personne (''Saule'',''Pablo'',''2000-10-24'',''pablo_48@yahoo.fr'') ...'

SELECT nouvelle_personne('Saule','Pablo','2000-10-24','pablo_48@yahoo.fr');

\echo 'Affichage du contenu de la table PERSONNE'

SELECT * FROM PERSONNE;

\echo '***************************************************************************'
\echo 'Travail à réaliser 15'
\echo '***************************************************************************'
\echo 'Création de la fonction nouvelle_personne_2 ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nouvelle_personne_2(IN nom VARCHAR, IN prenom VARCHAR, IN date_naissance DATE, IN email VARCHAR) RETURNS INTEGER AS
$$
INSERT INTO PERSONNE(nom, prenom, date_naissance, email) VALUES(nouvelle_personne_2.nom, nouvelle_personne_2.prenom, nouvelle_personne_2.date_naissance, nouvelle_personne_2.email);

SELECT id_personne
FROM PERSONNE
WHERE email = nouvelle_personne_2.email
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 15'
\echo '***************************************************************************'
\echo 'Insertion de la personne (''Catalpa'',''Arthur'',''1980-06-02'',''arthur.catalpa31@sfr.fr'') ...'

SELECT nouvelle_personne_2('Catalpa','Arthur','1980-06-02','arthur.catalpa31@sfr.fr');

\echo 'Affichage du contenu de la table PERSONNE'

SELECT * FROM PERSONNE;

\echo '***************************************************************************'
\echo 'Travail à réaliser 16'
\echo '***************************************************************************'
\echo 'Création de la fonction nouvel_article ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nouvel_article(IN designation VARCHAR, IN prix_article FLOAT, IN id_vendeur INTEGER) RETURNS VOID AS
$$
INSERT INTO ARTICLE(designation, prix_article, id_vendeur) VALUES(nouvel_article.designation, nouvel_article.prix_article, nouvel_article.id_vendeur)
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 16'
\echo '***************************************************************************'
\echo 'Insertion de l''article (''Casque Moto PX90'',45.0,3) ...'
\echo 'Remarque : la date courante étant utilisée comme date de dépôt, elle doit être différente pour vous ...'

SELECT nouvel_article('Casque Moto PX90',45.0,3);

\echo 'Affichage du contenu de la table ARTICLE'

SELECT * FROM ARTICLE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 17'
\echo '***************************************************************************'
\echo 'Création de la fonction new_personne_article  ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION new_personne_article(IN nom VARCHAR, IN prenom VARCHAR, IN date_naissance DATE, IN email VARCHAR, IN designation VARCHAR, IN prix_article FLOAT) RETURNS SETOF RECORD AS
$$
SELECT nouvel_article(designation, prix_article, nouvelle_personne_2(nom, prenom, date_naissance, email))
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 17'
\echo '***************************************************************************'
\echo 'Insertion de l''article (''Veste rouge taille XS'',8.5) pour la personne (''Bouleau'',''Lou'',''2004-10-04'',''lou.bouleau_31@free.fr'') ...'
\echo 'Remarque : la date courante étant utilisée comme date de dépôt, elle doit être différente pour vous ...'

SELECT new_personne_article('Bouleau','Lou','2004-10-04','lou.bouleau_31@free.fr','Veste rouge taille XS',8.5);

\echo 'Affichage du contenu de la table PERSONNE'

SELECT * FROM PERSONNE;

\echo 'Affichage du contenu de la table ARTICLE'

SELECT * FROM ARTICLE;

\echo '***************************************************************************'
\echo 'Travail à réaliser 18'
\echo '***************************************************************************'
\echo 'Création de la fonction nb_offres ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nb_offres(id_article INTEGER) RETURNS BIGINT AS
$$
SELECT COUNT(*)
FROM OFFRE
WHERE id_article = nb_offres.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 18'
\echo '***************************************************************************'
\echo 'Résultat de SELECT nb_offres(3),nb_offres(8),nb_offres(9),nb_offres(10);'

SELECT nb_offres(3),nb_offres(8),nb_offres(9),nb_offres(10);

\echo '***************************************************************************'
\echo 'Travail à réaliser 19'
\echo '***************************************************************************'
\echo 'Création de la fonction supprimer_offres ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION supprimer_offres(id_article INTEGER) RETURNS VOID AS
$$
DELETE FROM OFFRE
WHERE id_article = supprimer_offres.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 19'
\echo '***************************************************************************'
\echo 'Suppression des offres correspondant à l''article 8' ...

\echo 'Affichage du contenu de la table OFFRE'

SELECT * FROM OFFRE;

SELECT supprimer_offres(8);

\echo 'Affichage du contenu de la table OFFRE'

SELECT * FROM OFFRE;


\echo '***************************************************************************'
\echo 'Travail à réaliser 20'
\echo '***************************************************************************'
\echo 'Création de la fonction mettre_non_vendu ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION mettre_non_vendu(id_article INTEGER) RETURNS VOID AS
$$
UPDATE ARTICLE SET etat='Non vendu'
WHERE id_article = mettre_non_vendu.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 20'
\echo '***************************************************************************'
\echo 'Mettre à Non vendu l''article 8 ...'

SELECT mettre_non_vendu(8);

\echo '***************************************************************************'
\echo 'Travail à réaliser 21'
\echo '***************************************************************************'
\echo 'Création de la fonction meilleure_offre ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION meilleure_offre(id_article INTEGER) RETURNS OFFRE AS
$$
SELECT *
FROM OFFRE
WHERE meilleure_offre.id_article = id_article AND montant_offre = (
	SELECT MAX(montant_offre)
	FROM OFFRE
	WHERE meilleure_offre.id_article = id_article
)
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 21'
\echo '***************************************************************************'
\echo 'Meilleure offre pour l''article 10 ...'

SELECT * FROM meilleure_offre(10);


\echo '***************************************************************************'
\echo 'Travail à réaliser 22'
\echo '***************************************************************************'
\echo 'Création de la fonction mettre_vendu ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION mettre_vendu(id_article INTEGER, id_acheteur INTEGER, prix_achat FLOAT) RETURNS VOID AS
$$
UPDATE ARTICLE SET etat='Non vendu', id_acheteur = mettre_vendu.id_acheteur, prix_achat = mettre_vendu.prix_achat
WHERE id_article = mettre_vendu.id_article
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 22'
\echo '***************************************************************************'
\echo 'Mettre à Vendu l''article 9 avec l''acheteur 4 au prix de 70 euros ...'

SELECT mettre_vendu(9,4,70);

\echo 'Affichage du contenu de la table ARTICLE'

SELECT * FROM ARTICLE;



\echo '***************************************************************************'
\echo 'Travail à réaliser 23'
\echo '***************************************************************************'
\echo 'Création de la fonction terminer_vente ...'

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION terminer_vente(id_article INTEGER) RETURNS VOID AS
$$
SELECT
CASE
	WHEN nb_offres(id_article) = 0 THEN mettre_non_vendu(id_article)
	WHEN nb_offres(id_article) > 0 THEN mettre_vendu(id_article, (meilleure_offre(id_article)).id_encherisseur, (meilleure_offre(id_article)).montant_offre)
END;
SELECT supprimer_offres(id_article)
$$
LANGUAGE SQL;
-----------------------------------------------------------------------------------

\echo '***************************************************************************'
\echo 'Affichage 23'
\echo '***************************************************************************'
\echo 'Terminer la vente de l''article 10 et de l''article 12 ...'

SELECT terminer_vente(10),terminer_vente(12);

\echo 'Affichage du contenu de la table ARTICLE'

SELECT * FROM ARTICLE;

\echo 'Affichage du contenu de la table OFFRE'

SELECT * FROM OFFRE;
