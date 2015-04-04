# SocialEvents

SocialEvents est une application web qui centralise des événements publics publiés sur Facebook. C'est une application Facebook permettant aux utilisateurs de se connecter avec leurs comptes et d'importer des événements se trouvant proches de leur localisation actuelle. Les événements sont ensuite listés publiquement, sous forme d'une liste à _scroll infini_ avec possibilité de faire des recherches ou de filtrer les résultats. Des événements importés peuvent être supprimés par les utilisateurs. Un compteur de contributions sert à inciter les utilisateurs à importer des événements et figurer dans le top 5 des utilisateurs actifs.

En important des événements, les utilisateurs acceptent que ceux-ci soient liés à leurs comptes (_événement publié par l'utilisateur qui l'importe_) et sont d'accord pour que le site accède à leur localisation. S'ils ne sont pas d'accord, ils n'importe pas d'événements.

D'un _point de vue projet_, l'objectif est de réaliser une application web concrète et fonctionnelle, dans le cadre d'un processus de développement complet, comprenant la réalisation de la logique applicative se basant sur des services externes, du dynamisme côté client et la mise en pratique d'HTML5/CSS3 sans framework externe. 

**Fonctionnalités principales de l'application**
* Authentification avec Facebook
 * Récupération des informations de base de l'utilisateur

* Importation des événements depuis compte Facebook
 * API Graph de Facebook
 * Avec des tâches d'importation en arrière-plan

* Visualisation des événements
 * Recherche des événements
 * Filtrage des événements
 * Liste à scroll infini

* _Programme de fidélisation de l'internaute_ avec un concours des plus grandes contributions en événements

* Suppression des événements 
 * Suppression d'anciens événements échus avec des scripts automatiques en arrière-plan
 * Suppression manuelle d'événements importés par les utilisateurs eux-mêmes
