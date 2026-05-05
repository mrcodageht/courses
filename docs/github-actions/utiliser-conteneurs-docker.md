### Utilisation de conteneurs

Les conteneurs peuvent être utilisés pour exécuter des étapes dans un `job`. 

#### Exemple : exécution d'un `job` dans un conteneur

Dans cet exemple, nous avons un `job` qui fonctionne sur `ubuntu-latest`.

Le conteneur pour ce `job` utilise l'image `node:18`.

content\_copy

```
name: Exemple de CI avec conteneur
on:
  push:
    branches: [ main ]
jobs:
  exemple-job:
    runs-on: ubuntu-latest
    container:
      image: node:18
    steps:
      - name: vérifie l'existence du fichier .dockerenv
        run: (ls /.dockerenv && echo "fichier .dockerenv trouvé") || echo "fichier .dockerenv absent"
```

#### Définition de l'image du conteneur

La clé `jobs.<job_id>.container.image` sert à spécifier l'image `Docker` à utiliser.

Vous pouvez utiliser le nom de l'image `Docker Hub` ou un autre nom de registre.

#### Définition des informations d'identification pour un registre de conteneur

Si le registre de l'image nécessite une authentification, vous pouvez utiliser `jobs.<job_id>.container.credentials` pour indiquer les identifiants.

content\_copy

```
name: exemple avec image Docker privée
on:
  push:
    branches: [ main ]

jobs:
  mon-job:
    runs-on: ubuntu-latest
    container:
      image: ${{ secrets.DOCKERHUB_USERNAME }}/mon-image-privee:tag
      credentials:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    steps:
    - name: vérifie le fichier dockerenv
      run: (ls /.dockerenv && echo fichier dockerenv trouvé) || (echo fichier dockerenv non trouvé)
```

#### Utilisation de variables d'environnement avec un conteneur

Vous pouvez utiliser `jobs.<job_id>.container.env` pour définir des variables d'environnement dans le conteneur.

#### Exposition des ports réseau sur un conteneur

Utilisez `jobs.<job_id>.container.ports` pour définir une liste des ports à exposer sur le conteneur.

#### Montage de volumes dans un conteneur

Utilisez `jobs.<job_id>.container.volumes` pour définir une liste des volumes à utiliser dans le conteneur.

content\_copy

```
volumes:
  - mon_volume_docker:/point_de_montage
  - /data/mes_donnees
  - /dossier/source:/dossier/destination
```

#### Configuration des options de ressources du conteneur

Utilisez `jobs.<job_id>.container.options` pour configurer des options de ressources Docker supplémentaires.

Voici un exemple complet qui combine toutes ces options :

content\_copy

```
name: Exemple de CI avec conteneur
on:
  push:
    branches: [ main ]
jobs:
  exemple-job:
    runs-on: ubuntu-latest
    container:
      image: node:18
      env:
        MA_VARIABLE: valeur
      ports:
        - 80
      volumes:
        - mon_volume:/point_de_montage
      options: --cpus 1
    steps:
      - name: vérifie l'existence du fichier .dockerenv
        run: (ls /.dockerenv && echo "fichier .dockerenv trouvé") || echo "fichier .dockerenv absent"
```

### Sur cette page

*   Utilisation de conteneurs
*   Exemple : exécution d'un job dans un conteneur
*   Définition de l'image du conteneur
*   Définition des informations d'identification pour un registre de conteneur
*   Utilisation de variables d'environnement avec un conteneur
*   Exposition des ports réseau sur un conteneur
*   Montage de volumes dans un conteneur
*   Configuration des options de ressources du conteneur