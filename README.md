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

**Application en production**

Voir http://srvz-isic04.he-arc.ch/socialevents

## Configuration pour déploiement local

L'application a été conçue avec Rails 4.1 et Ruby 2.1/2.2.

SocialEvents nécessite la création d'une application Facebook, avec [Facebook Developers](https://developers.facebook.com/). Avec l'application, vous récupérez un ID d'application et un secret. Ces derniers doivent être ajoutés dans le fichier de configuration `config/app.yml` à créer au format suivant :

```
# file config/app.yml
 
defaults: &defaults
  :secret_key_base: # XXX
  :facebook_app_id: # APP ID
  :facebook_app_secret: # APP SECRET
 
development:
  <<: *defaults
  :secret_key_base: # XXX
  :devise_secret_key: # XXX
 
test:
  <<: *defaults
  :devise_secret_key: # XXX
 
production:
  <<: *defaults
  :devise_secret_key: # XXX
```
Une fois les fichiers de l'application configurée, vous pouvez lancer son installation:

```
bundle install
rake db:create
rake db:migrate
```

Pour importer des événements, la gem [Delayed Jobs](https://github.com/collectiveidea/delayed_job) est utilisée. Cette dernière fonctionne avec des threads d'arrières plans (workers) qui consomment des tâches à exécuter en asynchrone. Ces workers doivent être lancés pour que les tâches, mises en attente dans une table de la base de données, soient consommées.

Pour lancer l'application Rails avec les workers, SocialEvents propose le script SocialEvents RunTime:
````
./sert
```

Ce dernier équivaut à:
```
rails s &
rake jobs:work # lancement des workers
```

D'autres possibilités pour l'interaction avec les workers sont:
```
bin/delayed_jobs [start|stop|restart]
RAILS_ENV=production bin/delayed_job -n8 restart  # Pour lancer 8 workers en production par exemple
```

Le lancement de DelayedJobs en production est géré par Capistrano.

DelayedJobs ne demande pas de configuration supplémentaire en général. Cependant, en cas de problèmes avec DelayedJobs, les sources peuvent être multiples, par exemple des permissions d'accès incorrectes. [Le Wiki de la gem propose différentes pistes possibles.](https://github.com/collectiveidea/delayed_job/wiki/Common-problems) 
