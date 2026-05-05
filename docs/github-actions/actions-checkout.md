### L'action [`Checkout`](https://github.com/marketplace/actions/checkout)

Cette action officielle réalise un "checkout" de votre dépôt dans `$GITHUB_WORKSPACE`, permettant ainsi à votre `workflow` d'y accéder.

`$GITHUB_WORKSPACE` est une variable d'environnement qui représente le répertoire de travail dans la machine virtuelle où les `jobs` sont exécutés.

Quand un `workflow` est déclenché, `GitHub` crée un environnement virtuel et y initialise un répertoire. Ce répertoire est le `workspace`, et son chemin d'accès est stocké dans la variable `$GITHUB_WORKSPACE`.

**Quand vous utilisez l'action `actions/checkout`, le code de votre dépôt est copié dans ce `workspace`, vous permettant d'y exécuter des commandes comme si vous étiez dans le répertoire de votre projet sur votre propre machine.**

**Par défaut, seul le dernier "`commit`" est récupéré**, pour la référence qui a déclenché le `workflow`.

Un jeton d'authentification `Github` est conservé dans la configuration `git` locale, ce qui permet à vos `scripts` d'exécuter des commandes `git` authentifiées. Le jeton est supprimé pendant le nettoyage `post jobs`. (_Nous y reviendrons_).

### Options disponibles

Comme pour la plupart des actions, un grand nombre de configurations sont disponibles, même si on en utilise souvent peu :



```yaml
- uses: actions/checkout@v4
  with:
    repository: '' # Nom du dépôt avec propriétaire. Par défaut : ${{ github.repository }}
    ref: '' # Branche, étiquette ou SHA à "checkout". Par défaut : référence ou SHA déclenchant l'événement.
    token: '' # Jeton d'accès personnel (PAT) utilisé. Par défaut : ${{ github.token }}
    ssh-key: '' # Clé SSH utilisée. 
    ssh-known-hosts: '' # Hôtes connus en plus de la base de données globale des clés d'hôte.
    ssh-strict: '' # Vérification stricte de la clé d'hôte. Par défaut : true.
    persist-credentials: '' # Conserver le jeton ou la clé SSH dans la config `git` locale. Par défaut : true.
    path: '' # Chemin relatif sous $GITHUB_WORKSPACE pour placer le dépôt.
    clean: '' # Exécuter `git clean -ffdx && git reset --hard HEAD` avant de récupérer. Par défaut : true.
    filter: '' # Filtrer pour le clonage partiel. Par défaut : null.
    sparse-checkout: '' # Effectuer un "sparse checkout" sur des motifs donnés.
    sparse-checkout-cone-mode: '' # Utiliser le mode cône pour le "sparse checkout". Par défaut : true.
    fetch-depth: '' # Nombre de "commits" à récupérer. 0 pour tout l'historique. Par défaut : 1.
    fetch-tags: '' # Récupérer les étiquettes, même si fetch-depth > 0. Par défaut : false.
    show-progress: '' # Afficher la progression lors de la récupération. Par défaut : true.
    lfs: '' # Télécharger les fichiers Git-LFS. Par défaut : false.
    submodules: '' # Effectuer un "checkout" des sous-modules. Par défaut : false.
    set-safe-directory: '' # Ajouter le chemin du dépôt comme répertoire sûr dans la config `git` globale. Par défaut : true.
    github-server-url: '' # URL de base de l'instance GitHub depuis laquelle vous essayez de cloner.
```

### Quelques exemples d'utilisation

#### Récupération des fichiers racine, du dossier `.github` et du dossier `src`



```yaml
- uses: actions/checkout@v4
  with :
    sparse-checkout: |
      .github
      src
```

#### Récupération de tout l'historique pour toutes les balises et toutes les branches



```yml
- uses: actions/checkout@v4
  with :
    fetch-depth: 0
```

#### Récupération de plusieurs dépôts privés



```yml
- name: Checkout
  uses: actions/checkout@v4
  with :
    path: main
- name: Checkout private tools
  uses: actions/checkout@v4
  with :
    repository: my-org/my-private-tools
    token: ${{ secrets.GH_PAT }}
    path: my-tools
```

#### Validation d'un `commit` en utilisant le token intégré



```yml
on: pull_request
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          date > date.txt
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add .
          git commit -m "Un commit depuis l'action"
          git push
```
