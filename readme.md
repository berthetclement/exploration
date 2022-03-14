README
================

## Projet boite a outils

Ajouts informations utiles :

  - Utilisation de GIT  
  - Utilisation de {renv} dans un projet

## GIT

Quelques commandes :

  - Initialiser git dans un repertoire : `git init`  
  - Precharger des fichiers dans l’index git : `git add fichier1
    fichier2` ou encore `git add .` ou encore `git add --all`  
  - Charger les fichiers selectionnes precedemment : `git commit` ou
    avec un message `git commit -m "message"`  
  - Pousser vers le repos distant : `git push origin master`

## RENV

{renv} est un package disponible sur le cran qui permet de gerer les
packages necessaires au code de votre projet. Une documentation est
dispo
[ici](https://elise.maigne.pages.mia.inra.fr/2021_package_renv/presentation.html#13)

**Quelques commandes :**

  - Initialiser la gestion des packages dans le projet courant :
    `renv::init()`  
  - Sauvegarder l’etat des packages du projet : `renv::snapshot()`  
  - Voir l’etat des packages du projet : `renv::status()` (a utiliser
    apres avoir recuperer un projet)

**Exemple d’utilisation :**

Apres avoir copie un projet ou clone un projet comportant {renv}, faire
`renv::restore()` qui installera les packages manquant avec les versions
de celui qui a initie le projet.
