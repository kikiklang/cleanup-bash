# Ubuntu clean-up

Ce script bash est conçu pour effectuer des mises à jour sur Ubuntu et nettoyer le système. Il a été testé sur Ubuntu 20.04 & 22.04. L'utilisation avec des versions antérieures d'Ubuntu n'est pas garantie.


## Utilisation

1. Cloner le projet
2. Renseignez votre nom d'utilisateur Unix dans le fichier cleanup.sh (utilisez la commande who pour le trouver).
3. Renseignez le nom de votre disque dur dans le fichier cleanup.sh (utilisez la commande lsblk pour le trouver).
4. Dans le terminal, à la racine du dossier, exécutez le script avec la commande sudo ./cleanup.sh.

## Fonctions

* Vérifie l'espace disponible sur le disque avant et après le nettoyage.
* Nettoie différents logs.
* Liste les snaps installés et supprime les anciennes versions inutiles.
* Nettoie le cache des vignettes.
* Supprime les anciens kernels.
* Vide la corbeille.
* Effectue une mise à jour et une mise à niveau du système.
* Nettoie les paquets et le cache.
