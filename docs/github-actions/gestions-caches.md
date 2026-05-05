### La mise en cache

La mise en cache dans `GitHub Actions` peut être un outil puissant pour accélérer vos `workflows`.

Vous pouvez éviter de télécharger à chaque fois les mêmes dépendances ou de générer à nouveau des fichiers qui n'ont pas changé.

Cela est particulièrement utile pour des outils de gestion de dépendances comme `npm`, `Maven`, `pip`, etc.

**Vous pouvez utiliser l'action `actions/cache` de `GitHub` pour mettre en cache des fichiers entre les exécutions de `job`.**

**Un `cache` est identifié par une clé unique**. Vous pouvez également utiliser une liste de clés de restauration (`restore-keys`) en tant que plan B, dans le cas où une clé de `cache` ne correspond pas exactement.

### Les paramètres de `action/cache`

#### `key`

C'est la clé explicite pour une entrée de `cache`. Cette clé est souvent composée d'une chaîne fixe, du système d'exploitation et d'un `hash` des fichiers de dépendances pour s'assurer qu'elle est unique.

Exemple :

content\_copy

```
key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

#### `path`

Il s'agit de la liste des fichiers, répertoires et motifs génériques à mettre en cache et à restaurer. Vous pouvez utiliser les motifs supportés par `@actions/glob`.

Exemple :

content\_copy

```
path: |
    path: ~/.npm
```

#### `restore-keys`

C'est une liste ordonnée de clés à utiliser pour restaurer un `cache` obsolète si aucune correspondance exacte n'a été trouvée pour `key`.

Exemple :

content\_copy

```
restore-keys: |
  ${{ runner.os }}-node-
  ${{ runner.os }}-
```

#### `enableCrossOsArchive`

C'est un booléen optionnel qui, lorsqu'il est activé, permet aux `runners Windows` de sauvegarder ou de restaurer des `caches` pouvant être restaurés ou sauvegardés respectivement sur d'autres plateformes. Par défaut, cette option est désactivée (`false`).

#### `fail-on-cache-miss`

Si cette option est activée (`true`), le `workflow` échouera si l'entrée de `cache` n'est pas trouvée. Par défaut, cette option est désactivée (`false`).

#### `lookup-only`

Si cette option est activée (`true`), l'action vérifie uniquement si une entrée de `cache` existe et saute le téléchargement. Cela n'affecte pas le comportement de sauvegarde du `cache`. Par défaut, cette option est désactivée (`false`).

### Premier exemple : `npm`

content\_copy

```
name: Exemple de mise en cache avec npm

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Vérification du code
      uses: actions/checkout@v4

    - name: Mise en cache des dépendances npm
      uses: actions/cache@v3
      with:
        path: ~/.npm
        key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
        restore-keys: |
          ${{ runner.os }}-node-

    - name: Installation des dépendances
      run: npm ci --cache .npm
```

Dans cet exemple, le `job` effectue les étapes suivantes :

1.  Il récupère le code source.
2.  Il tente de restaurer le `cache` basé sur une clé unique générée à partir du système d'exploitation et du contenu du fichier `package-lock.json`. Plus précisément, il génère un `hash SHA-256` à partir du fichier grâce à la fonction `hashFiles()`.
3.  S'il y a un `cache hit` (une correspondance exacte de la clé), le `cache` est restauré.
4.  S'il y a un `cache miss` (aucune correspondance exacte), le `job` continue et installe les dépendances qui seront mises en cache pour les prochains `runs`.

#### Pourquoi mettre en cache `.npm` et non `node_modules` ?

action/cache recommande pour `Node.js` de mettre en cache le cache `npm` ou `yarn` et non pas `node_modules` pour les raisons suivantes :

*   **Compatibilité entre systèmes d'exploitation** : le cache de `npm` est plus neutre en termes de système d'exploitation et d'architecture, ce qui rend le cache plus portable entre différentes configurations de `runners`.
    
*   **Performance** : `npm` utilise son propre cache pour stocker des fichiers de package et des métadonnées de manière optimisée. Lors de l'exécution de `npm install`, `npm` peut décider de manière plus intelligente quelles dépendances doivent être téléchargées et lesquelles peuvent être récupérées du cache.
    
*   **Intégrité** : `npm` vérifie l'intégrité des packages en utilisant des sommes de contrôle. Cela réduit le risque de corruption du `cache`.
    
*   **Espace disque / vitesse téléchargement** : le cache de `npm` est souvent plus petit que le répertoire `node_modules` car il ne contient pas les dépendances décompressées. Cela peut accélérer la sauvegarde et la restauration du `cache`.
    

### Deuxième exemple : `PHP`

content\_copy

```
name: Mon PHP Workflow

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: checkout le code
      uses: actions/checkout@v4

    - name: Get Composer Cache Directory
      id: composer-cache
      run: |
        echo "dir=$(composer config cache-files-dir)" >> $GITHUB_OUTPUT

    - uses: actions/cache@v3
      with:
        path: ${{ steps.composer-cache.outputs.dir }}
        key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.lock') }}
        restore-keys: |
          ${{ runner.os }}-composer-

    # Installe les dépendances
    - name: installer les dépendances
      run: composer install
```

### Autres codes pour les environnements les plus courants

#### `Python`

content\_copy

```
- uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

#### `Java - Gradle`

content\_copy

```
- uses: actions/cache@v3
  with:
    path: |
      ~/.gradle/caches
      ~/.gradle/wrapper
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
    restore-keys: |
      ${{ runner.os }}-gradle-
```

#### `Java - Maven`

content\_copy

```
- name: Cache local Maven repository
  uses: actions/cache@v3
  with:
    path: ~/.m2/repository
    key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
    restore-keys: |
      ${{ runner.os }}-maven-
```

#### `C#`

content\_copy

```
- uses: actions/cache@v3
  with:
    path: ~/.nuget/packages
    key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json') }}
    restore-keys: |
      ${{ runner.os }}-nuget-
```

### Ordre de recherche pour un cache

Supposons que nous ayons :

content\_copy

```
key:
  npm-feature-d5ea0750 # termine par le hash
restore-keys: |
  npm-feature-
  npm-
```

#### Ordre de recherche :

1.  Cherche `npm-feature-d5ea0750` dans la branche `feature`.
2.  Cherche `npm-feature-` dans la branche `feature`.
3.  Cherche `npm-` dans la branche `feature`.
4.  Cherche `npm-feature-d5ea0750` dans la branche `main`.
5.  Cherche `npm-feature-` dans la branche `main`.
6.  Cherche `npm-` dans la branche `main`.

### Gestion des caches sur l'`UI`

#### Affichage des entrées de cache

Vous pouvez utiliser l'interface web pour afficher une liste des entrées de cache pour un dépôt. Dans cette liste, vous pouvez voir combien d'espace disque chaque cache utilise, quand le cache a été créé et quand il a été utilisé pour la dernière fois.

#### Suppression des entrées de cache

Les utilisateurs ayant un accès en écriture à un dépôt peuvent utiliser l'interface web de GitHub pour supprimer des entrées de cache.

#### Étapes :

1.  Accédez à la page principale du dépôt sur `GitHub.com`.
2.  Sous le nom de votre dépôt, cliquez sur « `Actions` ».
3.  Dans la barre latérale gauche, sous la section « `Management` », cliquez sur « `Caches` ».
4.  À côté de l'entrée de cache que vous souhaitez supprimer, cliquez sur le bouton de suppression.

![Screenshot of the list of cache entries.](./gestions-caches_files/actions-cache-entry-list.png)

### Notes importantes

*   **Nettoyage :** `GitHub` supprime automatiquement toute entrée de cache à laquelle on n'a pas été accédée depuis plus de 7 jours. Il n'y a pas de limite sur le nombre de caches que vous pouvez stocker, mais la taille totale de tous les caches dans un dépôt est limitée à `10 Go.` Une fois qu'un dépôt a atteint sa capacité de stockage maximale, la politique d'éviction du cache crée de l'espace en supprimant les caches les plus anciens dans le dépôt.
*   **Sécurité :** n'enregistrez aucune information sensible dans le `cache`. Toute personne ayant un accès en lecture à votre dépôt pourrait accéder aux données du `cache`.
    
*   **`Runners` auto-gérés :** le `cache` est stocké sur le stockage `cloud` de `GitHub`, même si vous utilisez vos `runners`.
    
*   **Comparaison avec `artifacts` :** utilisez le `cache` pour les fichiers qui ne changent pas souvent entre les `runs`. Utilisez les `artifacts` pour les fichiers générés pendant un `run` que vous souhaitez conserver pour une utilisation ultérieure.
    
*   **Restrictions d'accès :** le `cache` est généralement accessible uniquement depuis la branche qui l'a créé ou depuis la branche par défaut (`main` le plus souvent). Des exceptions s'appliquent pour les `pull requests`.
    

### Sur cette page

*   La mise en cache
*   Les paramètres de action/cache
*   key
*   path
*   restore-keys
*   enableCrossOsArchive
*   fail-on-cache-miss
*   lookup-only
*   Premier exemple : npm
*   Pourquoi mettre en cache .npm et non node\_modules ?
*   Deuxième exemple : PHP
*   Autres codes pour les environnements les plus courants
*   Python
*   Java - Gradle
*   Java - Maven
*   C#
*   Ordre de recherche pour un cache
*   Ordre de recherche :
*   Gestion des caches sur l'UI
*   Affichage des entrées de cache
*   Suppression des entrées de cache
*   Étapes :
*   Notes importantes