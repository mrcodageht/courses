### À propos des déclencheurs de `workflow` (_`workflow triggers`_)

Les déclencheurs de `workflow` sont des événements qui provoquent l'exécution d'un `workflow`.

Ces événements peuvent être :

*   Des événements qui se produisent dans le dépôt de votre `workflow`
*   Des horaires programmés
*   Manuel

Par exemple, vous pouvez configurer votre `workflow` pour qu'il s'exécute lorsqu'un `push` est effectué sur la branche par défaut de votre dépôt, lorsqu'une `release` est créée, ou lorsqu'une `issue` est ouverte.

#### Comment ça marche ?

1.  Un événement se produit sur votre dépôt. Cet événement est associé à un `SHA` de `commit` et à une référence `Git` (`Git ref`).
2.  `GitHub` recherche dans le répertoire `.github/workflows` de votre dépôt les fichiers de `workflow` qui sont présents
3.  Une exécution de `workflow` est déclenchée pour tous les `workflows` qui ont des valeurs `on:` correspondant à l'événement déclencheur.

### Utilisation des événements pour déclencher des `workflows`

#### Clé `on`

Utilisez la clé `on` pour spécifier quels événements déclenchent votre `workflow`.

#### Un seul événement

Par exemple, un `workflow` avec la valeur `on` suivante s'exécutera lorsqu'un `push` est effectué sur n'importe quelle branche du dépôt du `workflow` :

content\_copy

```
on: push
```

Nous avons déjà vu un exemple mais vous pouvez retester directement dans `Github Actions` :

content\_copy

```
name: Test un seul événement

on: push

jobs:
  echo-message:
    runs-on: ubuntu-latest

    steps:
    - name: affiche un message
      run: echo "Un push a été effectué !"
```

#### Événements multiples

Vous pouvez spécifier un seul événement ou plusieurs événements. Par exemple, un `workflow` avec la valeur `on` suivante s'exécutera lorsqu'un `push` est effectué sur n'importe quelle branche du dépôt ou lorsqu'un `fork` du dépôt est créé :

content\_copy

```
on: [push, fork]
```

Pour tester :

content\_copy

```
name: Test Evénements multiples

on: [push, fork]

jobs:
  echo-message:
    runs-on: ubuntu-latest

    steps:
    - name: affiche un message
      run: echo "Un push ou un fork a été effectué !"
```

Essayez de forker votre répertoire pour tester le déclenchement.

### Utiliser d'autres filtres

Il est possible d'utiliser divers filtres pour contrôler quand et comment un `workflow` doit s'exécuter.

Comme nous venons de le voir, ces filtres peuvent être appliqués sur des événements tels que `push` et `pull_request`. _Nous verrons une liste exhaustive dans la prochaine leçon._

Ils peuvent également cibler des branches spécifiques, des balises (`tags`) ou des chemins de fichiers.

#### Filtrer par branches

Pour exécuter un `workflow` seulement quand il y a un `push` vers certaines branches, utilisez le filtre `branches`.

`GitHub Actions` permet d'utiliser des `patterns glob` pour matcher plusieurs noms de branches. Ces patterns peuvent être utilisés avec les mots-clés `branches` et `branches-ignore` dans la configuration du `workflow`.

Voici quelques caractères spéciaux utilisés dans les patterns `glob` et ce qu'ils signifient :

*   `*` : correspond à n'importe quel nombre de caractères, mais pas aux `/`.
*   `**` : correspond à n'importe quel nombre de caractères, y compris les `/`.
*   `?` : correspond à n'importe quel caractère unique, sauf les `/`.
*   `!` : utilisé pour nier un pattern. En d'autres termes, exclure les branches qui correspondent au pattern.

**Exemples**

*   `main` : correspond exactement à la branche `main`.
*   `feature/*` : correspond à toutes les branches dans le répertoire `feature`, comme `feature/new`, `feature/old`, mais pas `feature/sub/new`.
*   `feature/**` : correspond à toutes les branches dans le répertoire `feature` et ses sous-répertoires.
*   `release/?` : correspond à toutes les branches `release` suivies d'un seul caractère, comme `release/1` ou `release/2`.
*   `*bug*` : correspond à toutes les branches qui contiennent le mot "bug".
*   `!*bug*` : correspond à toutes les branches qui ne contiennent pas le mot "bug".

content\_copy

```
on:
  push:
    branches:
      - main
      - 'releases/**'
```

Dans cet exemple, la `workflow` se déclenche uniquement lorsque des modifications sont `push` sur la branche `main` ou sur toute branche qui commence par `releases/`.

Testable directement dans `GitHub Actions` :

content\_copy

```
on:
  push:
    branches:
      - main
      - 'releases/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: affichage
      run: |
        echo "La branche ciblée a déclenché la workflow."
        sleep 2
```

#### Exclure certaines branches

Inversement, pour éviter que la `workflow` ne se déclenche pour certaines branches, utilisez `branches-ignore`.

content\_copy

```
on:
  push:
    branches-ignore:
      - 'develop'
      - 'releases/**-alpha'
```

#### Filtres de chemin

Vous pouvez également utiliser des filtres basés sur les chemins de fichiers qui ont été modifiés. 

content\_copy

```
on:
  push:
    paths:
      - '**.js'
```

Ici, le `workflow` s'exécute uniquement lorsque des fichiers `JavaScript` (`.js`) sont modifiés.

Vous pouvez essayer de créer un fichier `JavaScript` sur le répertoire et de déclencher ce `workflow` :

content\_copy

```
on:
  push:
    paths:
      - '**.js'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: affichage
      run: |
        echo "Un fichier JavaScript a été modifié, déclenchant cette workflow."
        sleep 2
```

#### Exclure des chemins

Si tous les chemins correspondent à `paths-ignore`, le `workflow` ne s'exécutera pas. 

**Si au moins un chemin ne correspond pas aux motifs de `paths-ignore`, même si certains chemin correspondent aux motifs, le `workflow` s'exécutera.**

Un `workflow` avec le filtre de chemin suivant ne s'exécutera que sur les événements "`push`" qui incluent au moins un fichier en dehors du répertoire `docs` :

content\_copy

```
on:
  push:
    paths-ignore:
      - 'docs/**'
```

#### Filtres de chemin négatifs

Vous ne pouvez pas utiliser `paths` et `paths-ignore` pour filtrer le même événement dans un seul `workflow`.

Si vous souhaitez à la fois inclure et exclure des modèles de chemins pour un même événement, utilisez le filtre chemins précédé du caractère `!` pour indiquer les chemins à exclure.

Les motifs négatifs commencent par un point d'exclamation.

Un motif négatif (`!`) après un motif positif exclura les références ou les chemins correspondants.

content\_copy

```
on:
  push:
    paths:
      - 'sub-project/**'
      - '!sub-project/docs/**'
```

Dans cet exemple, le `workflow` sera déclenché par un `push` qui modifie un fichier dans le répertoire `sub-project/` ou ses sous-répertoires, sauf si le fichier est dans le répertoire `sub-project/docs/`.

### Sur cette page

*   À propos des déclencheurs de workflow (workflow triggers)
*   Comment ça marche ?
*   Utilisation des événements pour déclencher des workflows
*   Clé on
*   Un seul événement
*   Événements multiples
*   Utiliser d'autres filtres
*   Filtrer par branches
*   Exclure certaines branches
*   Filtres de chemin
*   Exclure des chemins
*   Filtres de chemin négatifs