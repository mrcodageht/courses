### Que sont les contextes ?

**Les `contexts` sont un moyen d'accéder aux informations concernant les exécutions de `workflow`, les variables, les environnements des `runner`, les `job` et les étapes.**

Chaque `context` est un objet qui contient des propriétés, qui peuvent être des chaînes de caractères ou d'autres objets.

Les `context`, les objets et les propriétés varieront considérablement en fonction des conditions d'exécution du `workflow`.

Par exemple, le `context` de matrice n'est rempli que pour les `job` dans une matrice. _Nous y reviendrons._

### Utilisation des contextes pour accéder aux valeurs des variables

Les contextes sont un moyen d'accéder aux informations sur les exécutions de `workflow`, aux variables, aux environnements des `runner`, aux `job` et aux étapes. Les variables d'environnement peuvent être accessibles via le contexte `env`.

#### Utilisation du contexte `env` pour accéder aux valeurs des variables d'environnement

Outre les variables d'environnement du `runner`, `GitHub Actions` vous permet de définir et de lire les valeurs des clés `env` en utilisant les contextes. Les variables d'environnement et les contextes sont destinés à être utilisés à différents moments dans le `workflow`.

**Les étapes `run` d'un `workflow`, ou dans une `action` référencée, sont traitées par un `runner`.**

Par conséquent, vous pouvez utiliser ici les variables d'environnement du `runner`, en utilisant la syntaxe appropriée pour le `shell` que vous utilisez sur le `runner`.

Par exemple, `$NAME` pour le `shell bash` sur un `runner` `Linux`, ou `$env:NAME` pour `PowerShell` sur un `runner` `Windows`.

Dans la plupart des cas, vous pouvez également utiliser des contextes, avec la syntaxe `${{ CONTEXT.PROPRIETE }}`, pour accéder à la même valeur.

La différence est que le contexte sera interpolé et remplacé par une chaîne avant que le `job` ne soit envoyé à un `runner`.

**Cependant, vous ne pouvez pas utiliser les variables d'environnement du `runner` dans les parties d'un `workflow` qui sont traitées par `GitHub Actions` et qui ne sont pas envoyées au `runner`.**

**À la place, vous devez utiliser des contextes.**

Par exemple, une condition `if` qui détermine si un `job` ou une étape est envoyé au `runner` est toujours traitée par `GitHub Actions`. Vous devez donc utiliser un contexte dans une instruction conditionnelle `if` pour accéder à la valeur d'une variable.



```yaml
env :
  JOUR_DE_LA_SEMAINE: Lundi  # Définition d'une variable d'environnement globale

jobs :
  job_de_salutation :  # Nom du job
    runs-on: ubuntu-latest  # Utilisation de la dernière version d'Ubuntu comme environnement de runner
    env :
      Salutation: Bonjour  # Définition d'une variable d'environnement au niveau du job
    steps :
      - name : "Dire bonjour à Pierre parce que c'est lundi"  # Nom de l'étape
        if : ${{ env.JOUR_DE_LA_SEMAINE == 'Lundi' }}  # Condition pour exécuter cette étape
        run : echo "$Salutation $Prenom. Aujourd'hui, c'est $JOUR_DE_LA_SEMAINE !"  # Commande à exécuter
        env :
          Prenom: Pierre  # Définition d'une variable d'environnement au niveau de l'étape
```

Dans cette modification, l'étape du `job` n'est exécutée que si `JOUR_DE_LA_SEMAINE` est défini à "Lundi".

**La valeur est accessible depuis l'instruction conditionnelle `if` en utilisant le contexte `env`.**

**Le contexte `env` n'est pas nécessaire pour les variables référencées dans la commande `run`.** Elles sont référencées comme variables d'environnement du `runner` et sont interpolées après que le `job` est reçu par le `runner`.

### Tableau des contextes disponibles

`env` n'est pas le seul contexte disponible, il y en a plein d'autres :

| Nom du context  | Type  | Description |
-----------------|---------|------------|
|`github`       |   objet   | Informations concernant l'exécution du `workflow`.|
| `env`   | objet   | Contient les variables définies dans un `workflow`, un `job` ou une étape.  |
| `job` | objet | Informations concernant le `job` en cours d'exécution. |
| `jobs` |  objet | Uniquement pour les `workflow` réutilisables, contient les sorties des `job` du `workflow` réutilisable.  |
| `steps` | objet | Informations concernant les étapes qui ont été exécutées dans le `job` en cours.  |
| `runner`  | objet   | Informations concernant le `runner` qui exécute le `job` en cours.  |
| `secrets` | objet | Contient les noms et les valeurs des secrets disponibles pour une exécution de `workflow`.  |
| `strategy`  | objet   | Informations concernant la stratégie d'exécution de matrice pour le `job` en cours. |
| `matrix`  | objet   | Contient les propriétés de matrice définies dans le `workflow` qui s'appliquent au `job` en cours. |
| `needs`   | objet   | Contient les sorties de tous les `job` qui sont définis comme une dépendance du `job` en cours. |
| `inputs`  | objet | Contient les entrées d'un `workflow` réutilisable ou déclenché manuellement.  |
| `vars`  | objet   | Contient des variables de configuration personnalisées définies au niveau de l’organisation, du dépôt et de l’environnement. |

Pour voir toutes les clés disponibles sur chaque objet [rendez-vous ici](https://docs.github.com/en/github-ae@latest/actions/learn-github-actions/contexts#github-context).

### Exemples

Nous verrons un seul exemple par contexte car il y a énormément de clés disponibles, mais nous les utiliserons largement dans la suite du cours.

_Certains exemples nécessitent des connaissances plus avancées, aussi vous pourrez y revenir plus tard et les survoler rapidement pour le moment._

#### `Context github`



```yaml
name: Exemple github context
on: push
jobs:
  afficher:
    runs-on: ubuntu-latest
    steps:
    - name: Affiche des infos github
      run: echo "Ce `workflow` a été déclenché par ${{ github.event_name }} sur la branche ${{ github.ref }}"
```

#### `Context job`



```yaml
name: Exemple job context
on: push
jobs:
  afficher:
    runs-on: ubuntu-latest
    steps:
    - name: Affiche le statut du job
      run: echo "Nom du `job` : ${{ job.status }}" // success, failure, ou cancelled.
```

#### `Context jobs`



```yaml
# Nom du workflow
name: Workflow réutilisable simple

# Événements déclencheurs
on:
  workflow_call:
    # Associe les sorties du workflow aux sorties des jobs
    outputs:
      premier_mot:
        description: "La première chaîne de sortie"
        value: ${{ jobs.job_example.outputs.output1 }}
      deuxieme_mot:
        description: "La deuxième chaîne de sortie"
        value: ${{ jobs.job_example.outputs.output2 }}

# Les jobs du workflow
jobs:
  # Un job d'exemple
  job_example:
    name: Génère des sorties
    runs-on: ubuntu-latest
    # Associe les sorties du job aux sorties des étapes
    outputs:
      output1: ${{ steps.step1.outputs.firstword }}
      output2: ${{ steps.step2.outputs.secondword }}
    steps:
      # Première étape
      - id: step1
        run: echo "::set-output name=firstword::bonjour"
      # Deuxième étape
      - id: step2
        run: echo "::set-output name=secondword::monde"
```

#### `Context steps`



```yaml
name: Exemple steps context
on: push
jobs:
  afficher:
    runs-on: ubuntu-latest
    steps:
    - name: Etape 1
      run: echo "Ceci est l'étape 1"
      id: etape1
    - name: Affiche le résultat de l'étape 1
      run: echo "L'étape 1 a exécuté le run : ${{ steps.etape1.conclusion }}" // utilise l'id défini
```

#### `Context runner`



```yaml
name: Exemple runner context
on: push
jobs:
  afficher:
    runs-on: ubuntu-latest
    steps:
    - name: Affiche l'OS du runner
      run: echo "Le runner utilise l'OS ${{ runner.os }}"
```

#### `Context secrets`



```yaml
name: Exemple secrets context
on: push
jobs:
  afficher:
    runs-on: ubuntu-latest
    steps:
    - name: Utilise un secret
      run: echo "Le secret est ${{ secrets.MY_SECRET }}"
```

#### `Context strategy`



```yaml
# Nom du workflow
name: Test de matrice

# Événement déclencheur
on: push

# Les jobs du workflow
jobs:
  # Job de test
  test:
    # Système d'exploitation sur lequel le job s'exécute
    runs-on: ubuntu-latest

    # Stratégie de matrice
    strategy:
      # Utilisation d'une matrice pour exécuter des combinaisons de tests
      matrix:
        groupe_de_test: [1, 2]
        node: [14, 16]

    # Étapes du job
    steps:
      # Checkout du code
      - uses: actions/checkout@v4

      # Exécution des tests et sauvegarde des résultats dans un fichier texte
      # Le nom du fichier texte inclut l'indice du job dans la matrice
      - run: npm test > test-job-${{ strategy.job-index }}.txt

      # Téléversement des logs
      - name: Téléversement des logs
        uses: actions/upload-artifact@v3
        with:
          # Nom unique pour l'artefact, incluant l'indice du job
          name: Log de construction pour le job ${{ strategy.job-index }}
          
          # Chemin du fichier à téléverser
          path: test-job-${{ strategy.job-index }}.txt
```

#### `Context matrix`



```yaml
name: Exemple matrix context
on: push
jobs:
  build:
    strategy:
      matrix:
        node: [ '10', '12' ]
    runs-on: ubuntu-latest
    steps:
    - name: Affiche la version de node
      run: echo "Version de node : ${{ matrix.node }}"
```

#### `Context needs`



```yaml
# Nom du workflow
name: Construction et déploiement

# Événement déclencheur
on: push

# Jobs du workflow
jobs:
  # Job de construction
  build:
    runs-on: ubuntu-latest
    # Sorties du job de construction
    outputs:
      build_id: ${{ steps.etape_construction.outputs.id_construction }}
    steps:
      - uses: actions/checkout@v4
      - name: Construction
        id: etape_construction
        run: |
          ./construire
          echo "::set-output name=id_construction::123"

  # Job de déploiement
  deploy:
    # Ce job nécessite le job de construction
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./deploiement --build ${{ needs.build.outputs.build_id }}

  # Job de débogage
  debug:
    # Ce job nécessite les jobs de construction et de déploiement
    needs: [build, deploy]
    runs-on: ubuntu-latest
    # Ce job s'exécute seulement si un autre job échoue
    if: ${{ failure() }}
    steps:
      - uses: actions/checkout@v4
      - run: ./debugger
```

#### `Context inputs`



```yaml
# Nom du workflow réutilisable
name: workflow de déploiement réutilisable

# Événement déclencheur pour le workflow réutilisable
on:
  workflow_call:
    inputs:
      build_id:
        required: true
        type: number
      cible_deploy:
        required: true
        type: string
      effectuer_deploy:
        required: true
        type: boolean

# Jobs
jobs:
  deploy:
    runs-on: ubuntu-latest
    # le job s'exécute si effectuer_deploy est vrai
    if: ${{ inputs.effectuer_deploy }}
    steps:
      - name: déploiement sur cible
        run: deploy --build ${{ inputs.build_id }} --target ${{ inputs.cible_deploy }}
```

#### `Context vars`

L’exemple suivant montre l’utilisation de variables de configuration avec le contexte vars dans un `workflow`. Chacune des variables de configuration suivantes a été définie au niveau du dépôt, de l’organisation ou de l’environnement.



```yaml
on:
  workflow_dispatch:
env:
  env_var: ${{ vars.ENV_CONTEXT_VAR }}

jobs:
  display-variables:
    name: ${{ vars.JOB_NAME }}
    if: ${{ vars.USE_VARIABLES == 'true' }}
    runs-on: ${{ vars.RUNNER }}
    environment: ${{ vars.ENVIRONMENT_STAGE }}
    steps:
    - name: Use variables
      run: |
        echo "repository variable : $REPOSITORY_VAR"
        echo "organization variable : $ORGANIZATION_VAR"
        echo "overridden variable : $OVERRIDE_VAR"
        echo "variable from shell environment : $env_var"
      env:
        REPOSITORY_VAR: ${{ vars.REPOSITORY_VAR }}
        ORGANIZATION_VAR: ${{ vars.ORGANIZATION_VAR }}
        OVERRIDE_VAR: ${{ vars.OVERRIDE_VAR }}
        
    - name: ${{ vars.HELLO_WORLD_STEP }}
      if: ${{ vars.HELLO_WORLD_ENABLED == 'true' }}
      uses: actions/hello-world-javascript-action@main
      with:
        who-to-greet: ${{ vars.GREET_NAME }}
```