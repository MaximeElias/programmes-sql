import sqlite3

conn = sqlite3.connect("data.db")

cur = conn.cursor()

# Suppression Tables
cur.execute("""DROP TABLE ARTICLE""")
cur.execute("""DROP TABLE CLIENT""")
cur.execute("""DROP TABLE PROPRIETAIRE""")
cur.execute("""DROP TABLE PRET""")
cur.execute("""DROP TABLE POSSEDE""")

# Table ARTICLE
cur.execute("""CREATE TABLE IF NOT EXISTS ARTICLE
                (id INTEGER PRIMARY KEY,
                nomA VARCHAR(15) NOT NULL,
                cout NUMERIC(5, 2))""")

# Table CLIENT
cur.execute('''CREATE TABLE IF NOT EXISTS CLIENT
                (id INTEGER PRIMARY KEY,
                nom VARCHAR(15) NOT NULL,
                prenom VARCHAR(15) NOT NULL,
                age INTEGER)''')

# Table PROPRIETAIRE 
cur.execute('''CREATE TABLE IF NOT EXISTS PROPRIETAIRE
                (id INTEGER PRIMARY KEY,
                nom VARCHAR(15) NOT NULL,
                prenom VARCHAR(15) NOT NULL)''')

# Table PRET
cur.execute('''CREATE TABLE IF NOT EXISTS PRET
                (id INTEGER PRIMARY KEY,
                nb_jours INTEGER NOT NULL,
                idClient INTEGER REFERENCES CLIENT(id) ON DELETE CASCADE,
                idArticle INTEGER REFERENCES ARTICLE(id) ON DELETE CASCADE,
                idProprietaire INTEGER REFERENCES PROPRIETAIRE(id) ON DELETE CASCADE)''')

# Table POSSEDE
cur.execute('''CREATE TABLE IF NOT EXISTS POSSEDE
                (id INTEGER PRIMARY KEY,
                idArticle INTEGER REFERENCES ARTICLE(id) ON DELETE CASCADE,
                idProprietaire INTEGER REFERENCES PROPRIETAIRE(id) ON DELETE CASCADE)''')

# Table COMPTES
cur.execute('''CREATE TABLE IF NOT EXISTS COMPTES
                (login STRING,
                mot_de_passe STRING)''')

# Insertion CLIENT
cur.execute("INSERT INTO CLIENT (id, nom, prenom, age) VALUES (1, 'Dupont', 'Jean', 25), (2, 'Durand', 'Marie', 30), (3, 'Martin', 'Paul', 28); ")

# Insertion ARTICLE
cur.execute("INSERT INTO ARTICLE (id, nomA, cout) VALUES (1, 'Livre', 15.99), (2, 'Tableau', 25.99), (3, 'Vase', 10.99); ")

# Insertion PROPRIETAIRE
cur.execute("INSERT INTO PROPRIETAIRE (id, nom, prenom) VALUES (1, 'Martin', 'Paul'), (2, 'Durand', 'Marie'), (3, 'Dupont', 'Jean'); ")

# Insertion PRET
cur.execute("INSERT INTO PRET (id, nb_jours, idClient, idArticle, idProprietaire) VALUES (1, 5, 1, 1, 1), (2, 3, 2, 2, 2), (3, 7, 3, 3, 3); ")

# Insertion POSSEDE
cur.execute("INSERT INTO POSSEDE (id, idArticle, idProprietaire) VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3); ")

# Insertion COMPTES
cur.execute("INSERT INTO COMPTES (login, mot_de_passe) VALUES ('maxime', '1234'), ('thomas', 'ptitrain'); ")

conn.commit()

def nosClients():
    res = cur.execute("""SELECT * FROM CLIENT""")
    print("----------- INFOS CLIENTS -----------")
    print(res.fetchall())
    print()

def nosClientsAdultes():
    res = cur.execute("""SELECT * FROM CLIENT WHERE age>=18 ORDER BY age ASC""")
    print("---------- CLIENTS MAJEUR ----------")
    print(res.fetchall())
    print()

def nosEmprunteurs():
    res = cur.execute("""SELECT * FROM CLIENT WHERE id IN (SELECT idClient FROM PRET)""")
    print("-------- CLIENTS EMPRUNTEUR --------")
    print(res.fetchall())
    print()

def nombrePrets():
    res = cur.execute("""SELECT COUNT(*) FROM PRET""")
    print("------------ NOMBRE PRET ------------")
    print(res.fetchone())
    print()

def nombreClients():
    res = cur.execute("""SELECT COUNT(*) FROM CLIENT""")
    print("----------- NOMBRE CLIENT -----------")
    print(res.fetchone())
    print()

def nombreProprios():
    res = cur.execute("""SELECT COUNT(*) FROM PROPRIETAIRE""")
    print("-------- NOMBRE PROPRIETAIRE --------")
    print(res.fetchone())
    print()
    
def ageMax():
    res = cur.execute("""SELECT MAX(age) FROM CLIENT""")
    print("--------- CLIENT PLUS VIEUX ---------")
    print(res.fetchone())
    print()
    
def clientsPlusAges():
    res = cur.execute("""SELECT * FROM CLIENT ORDER BY age DESC LIMIT 1""")
    print("--------- CLIENT PLUS AGEE ---------")
    print(res.fetchone())
    print()
    
def rapportCV():
    print("------------ RAPPORT CV ------------")
    cur.execute("""SELECT COUNT(*) FROM CLIENT""")
    nb_client = cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM PROPRIETAIRE""")
    nb_proprio = cur.fetchone()[0]
    if nb_client > nb_proprio:
        print(True)
    else:
        print(False)
    print()
    
def connexion():
    login = input("Entrez votre Login : ")
    mdp = input("Entrez votre mot de passe : ")
    cur.execute("""SELECT * FROM COMPTES WHERE login = ? AND mot_de_passe = ?""", (login, mdp))
    res = cur.fetchone()
    if res is not None:
        print('« Accès autorisé »')
    else:
        print('« Accès refusé »')

nosClients()
nosClientsAdultes()
nosEmprunteurs()
nombrePrets()
nombreClients()
nombreProprios()
ageMax()
clientsPlusAges()
rapportCV()
connexion()

cur.close()
conn.close()