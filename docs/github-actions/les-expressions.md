### Les expressions

Vous pouvez utiliser des expressions pour définir programmatiquement des variables d'environnement dans les fichiers de `workflow` et accéder aux `contexts`.

Une expression peut être n'importe quelle combinaison de valeurs littérales, de références à un contexte ou de fonctions. Vous pouvez combiner des littéraux, des références de contexte et des fonctions en utilisant des opérateurs.

Les expressions sont souvent utilisées avec le mot-clé conditionnel `if` dans un fichier de workflow pour déterminer si une étape doit être exécutée ou non. Lorsque la condition `if` est vraie, l'étape sera exécutée.

#### Syntaxe

Pour dire à `GitHub` d'évaluer une expression plutôt que de la traiter comme une chaîne de caractères, vous devez utiliser une syntaxe spécifique :

content\_copy

```
${{ <expression> }} 
```

#### Évaluation automatique

Il existe une exception : lorsque vous utilisez **des expressions dans une condition `if`**, vous pouvez omettre la syntaxe d'expression `${{ }}` parce que `GitHub Actions` évalue automatiquement la condition `if` comme une expression. 

#### Caractères réservés

Vous devez utiliser la syntaxe d'expression `${{ }}` ou échapper avec `''`, `""`, ou `()` lorsque l'expression commence par `!`, puisque `!` est une notation réservée dans le format YAML.

### Les types d'expression supportées

#### Littéraux

Vous pouvez utiliser différents types de littéraux dans les expressions :

*   **`boolean`** : `true` ou `false`
*   **`null`** : `null`
*   **`number`** : nombres au format `JSON`
*   **`string`** : chaînes de caractères

Exemples :

*   `myNull: ${{ null }}`
*   `myBoolean: ${{ true }}`
*   `myIntegerNumber: ${{ 42 }}`
*   `myFloatNumber: ${{ 3.14 }}`

#### Opérateurs

Des opérateurs tels que `&&`, `||`, `==`, `!=`, etc. sont disponibles.

Exemples :

*   `${{ 3 < 5 }}`
*   `${{ 'foo' == 'bar' }}`
*   `${{ true || false }}`
*   `${{ 4 >= 2 }}`

**Note : `GitHub` ignore la casse des caractères lors de la comparaison de chaînes et effectue des conversions implicites.**

Exemples qui valent `true` :

*   `${{ 'FOO' == 'foo' }}`
*   `${{ 42 == '42' }}`
*   `${{ null == 0 }}`
*   `${{ true == 1 }}`

**Opérateur ternaire**

Permet de définir des valeurs basées sur des conditions.

Exemples :

*   `MY_ENV_VAR: ${{ github.ref == 'refs/heads/main' && 'main_value' || 'other_value' }}`

Dans cet exemple, nous utilisons un opérateur ternaire pour définir la valeur de la variable d'environnement `MY_ENV_VAR` selon que la référence `GitHub` est définie sur `refs/heads/main` ou non. Si c'est le cas, la variable prend la valeur `value_for_main_branch`. Sinon, elle prend la valeur `value_for_other_branches`. **Il est important de noter que la première valeur après la condition `&&` doit être vraie, sinon la valeur après le `||` sera renvoyée.**

#### Fonctions intégrées

`GitHub` offre des fonctions intégrées : `contains`, `startsWith`, `endsWith`, `format`, `join`, `toJSON`, `fromJSON` et `hashFiles`.

Exemples avec `contains` :

*   `contains('Hello world', 'llo')` retourne `true`
*   `contains(github.event.issue.labels.*.name, 'bug')` retourne `true` si l'étiquette "`bug`" est présente

exemples avec `startsWith` :

*   `startsWith('Hello world', 'He')` retourne `true`
*   `startsWith('GitHub', 'Git')` retourne `true`

#### Fonctions de vérification du statut

Ces fonctions permettent de vérifier le statut des étapes, des tâches ou des travaux dans un `workflow`.

Ce sont les fonctions : `success`, `always`, `cancelled`, `failure`.

Exemples :

*   `if: ${{ success() }}`
*   `if: ${{ failure() }}`
*   `if: ${{ cancelled() }}`
*   `if: ${{ always() }}`

#### Filtres d'objets

Utilisez la syntaxe `*` pour filtrer et sélectionner des éléments correspondants dans une collection.

Exemples :

Considérons que nous avons un tableau `fruits` contenant des objets :

content\_copy

```
[
  { "name": "apple", "quantity": 1 },
  { "name": "orange", "quantity": 2 },
  { "name": "pear", "quantity": 1 }
]
```

`fruits.*.name` retourne `[ "apple", "orange", "pear" ]`.

### Exemples

#### Premier exemple

Dans cet exemple, nous utilisons les opérateurs `==`, `&&` et `||` pour déterminer quelles tâches exécuter en fonction de la branche et du succès des étapes précédentes.

content\_copy

```
name: CI/CD pour Node.js

on:
  push:
    branches:
      - main
      - dev

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - name: checkout code
      uses: actions/checkout@v4

    - name: installe les dépendances
      run: npm install

    - name: exécute les tests
      run: npm test

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: ${{ github.ref == 'refs/heads/main' && success() }}

    steps:
    - name: déploiement sur serveur de production
      run: ./deploy.sh
```

#### Exemple 2 : `Workflow` pour la gestion des `issues`

Dans cet exemple, nous utilisons les opérateurs `contains` et `==` pour filtrer les événements et les labels.

content\_copy

```
name: Gestion des issues

on:
  issues:
    types:
      - opened
      - labeled

jobs:
  check-label:

    runs-on: ubuntu-latest

    steps:
    - name: vérifie le label "bug"
      if: ${{ contains(github.event.issue.labels.*.name, 'bug') }}
      run: echo "Une issue avec le label 'bug' a été détectée."

    - name: vérifie si l'issue est nouvellement ouverte
      if: ${{ github.event.action == 'opened' }}
      run: echo "Une nouvelle issue a été ouverte."
```

Dans cet exemple :

*   le `workflow` s'exécute lorsque une `issue` est ouverte ou labellisée.
*   la première étape s'exécute si l'`issue` contient le label "`bug`".
*   la deuxième étape s'exécute si une nouvelle `issue` est ouverte.

Il est fréquent d'avoir de nombreuses `actions` de triages pour les projets open source.

### Sur cette page

*   Les expressions
*   Syntaxe
*   Évaluation automatique
*   Caractères réservés
*   Les types d'expression supportées
*   Littéraux
*   Opérateurs
*   Fonctions intégrées
*   Fonctions de vérification du statut
*   Filtres d'objets
*   Exemples
*   Premier exemple
*   Exemple 2 : Workflow pour la gestion des issues