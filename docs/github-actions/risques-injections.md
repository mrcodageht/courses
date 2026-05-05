### Comprendre les risques d'injections de scripts

Lors de la création de `workflows`, il est important de s'assurer que le code ne puisse pas exécuter des entrées non fiables.

Par exemple, un attaquant pourrait injecter du code malveillant dans le contexte `GitHub`, en utilisant des champs comme `github.event.issue.title` ou `github.event.pull_request.body`.

#### Exemple d'une attaque par injection de script

Imaginons un `workflow` avec le code suivant :

content\_copy

```
name: Vérifier le titre d'une PR
on:
  pull_request:
    types:
      - opened

jobs:
  check-title:
    runs-on: ubuntu-latest
    steps:
      - name: Vérifier le titre
        run: |
          titre="${{ github.event.pull_request.title }}"
          if [[ $titre =~ ^octocat ]]; then
            echo "Le titre de la PR commence par 'octocat'"
            exit 0
          else
            echo "Le titre de la PR ne commence pas par 'octocat'"
            exit 1
          fi
```

Cet exemple est vulnérable à l'injection de `script`. Un attaquant pourrait créer une `pull request` (`PR`) avec un titre comme `a"; ls $GITHUB_WORKSPACE`, ce qui interromprait le script et exécuterait la commande `ls`.

### Bonnes pratiques pour atténuer les risques

**Utiliser une action au lieu d'un `script inline`** : au lieu d'utiliser un `script inline`, il serait plus sûr de créer une `action` qui accepte le titre de la `PR` comme argument :

content\_copy

```
uses: uneaction/checktitle@v3
with:
  title: ${{ github.event.pull_request.title }}
```

**Utiliser une variable d'environnement intermédiaire** : dans les `scripts inline`, l'approche préférée pour gérer les entrées non fiables est de définir la valeur de l'expression à une variable d'environnement intermédiaire.

content\_copy

```
jobs:
  check-title:
    runs-on: ubuntu-latest
    steps:
    - name: Vérifier le titre
      env:
        TITRE: ${{ github.event.pull_request.title }}
      run: |
        if [[ "$TITRE" =~ ^octocat ]]; then
          echo "Le titre de la PR commence par 'octocat'"
          exit 0
        else
          echo "Le titre de la PR ne commence pas par 'octocat'"
          exit 1
        fi
```

Dans cet exemple, l'injection de `script` est neutralisée parce que la variable `TITRE` est isolée et ne fait pas partie du processus de génération de `script`.

**Pour le `CI/CD` les risques d'injection de `scripts` sont moindres si votre répertoire est privé et que seuls les membres de votre équipe peuvent faire des `PR`.**

### Utilisation d'`actions` tierces

Lors de l'utilisation de `GitHub Actions`, chaque `job` au sein d'un `workflow` peut potentiellement interagir avec les autres `jobs` et les compromettre.

Par exemple, un `job` pourrait lire les variables d'environnement utilisées par un autre `job`, écrire des fichiers dans un répertoire partagé que d'autres `jobs` vont traiter, ou interagir directement avec la `socket Docker`.

#### Risques liés aux `actions` tierces

L'impact d'un compromis d'une seule `action` peut être important.

Par exemple, une `action` compromise pourrait avoir accès à tous les `secrets` configurés sur votre dépôt, et pourrait utiliser le `GITHUB_TOKEN` pour écrire dans le dépôt.

#### Bonnes pratiques pour atténuer les risques

**Utiliser un `SHA` complet pour utiliser une `action tierce`**  
Cela empêche toute modification non désirée du code de l'`action`, car toutes modifications ultérieures par des attaquants ne pourraient impacter vos `workflows`.

content\_copy

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@e2a3e7ccc276908b1ff9339813909cd348e27c10 # SHA
```

**Auditer le code source de l'action**

Examinez comment l'`action` traite les `secrets` et le contenu de votre dépôt. Assurez-vous, par exemple, que les `secrets` ne sont pas envoyés à des hôtes non prévus.

**Utiliser les `tags` seulement si vous faites confiance au créateur de l'`action`**

C'est plus pratique mais moins sûr. Un `tag` peut être déplacé ou supprimé si un mauvais acteur obtient l'accès au dépôt.

content\_copy

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4 # tag
```

### Sur cette page

*   Comprendre les risques d'injections de scripts
*   Exemple d'une attaque par injection de script
*   Bonnes pratiques pour atténuer les risques
*   Utilisation d'actions tierces
*   Risques liés aux actions tierces
*   Bonnes pratiques pour atténuer les risques