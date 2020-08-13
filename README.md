# Ubuntu clean-up

Un program bash pour MAJ Ubuntu et nettoyer le système. Je l'utilise avec ubuntu 20.04, je ne garantie pas son bon fonctionnement avec d'anciennes versions... à tester...


## Utilisation

1. Cloner le projet
2. Ouvrir le fichier
3. Renseigner votre nom d'utilisateur unix ( command  >> 'who')
4. Renseigner le nom de votre disque dur ( command >> lsblk )

`![Moi c'est nvme0n1p5 ¯\_(ツ)_/¯](screenshot.png)`

## Fonctions

* Check l'espace dispo sur le disque avant et après netoyage
* Nettoie differents logs
* Liste les snap et supprime les vieilles version inutiles
* nettoie le cache des vignettes
* supprime les vieux kernels
* vide la corbeille
* update / upgrade et nettoie les paquets