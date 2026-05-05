### À propos des variables

Vous pouvez utiliser des variables pour stocker des informations que vous souhaitez référencer dans votre `workflow`.

Les variables sont interpolées sur la machine de l'exécuteur (`runner`) qui exécute votre `workflow`. Les commandes exécutées dans les `actions` ou les étapes du `workflow` peuvent créer, lire et modifier des variables.

**Les variables sont sensibles à la casse.**

Voici les variables utilisables :

*   **Variables personnalisées** : ce sont des variables que vous définissez vous-même dans le fichier `YAML` de votre `workflow`.
*   **Variables par défaut** : `GitHub` définit automatiquement certaines variables, comme `GITHUB_REPOSITORY` qui contient le nom du dépôt `GitHub`, ou `GITHUB_RUN_ID` qui contient l'ID du `workflow` en cours d'exécution.
*   **Variables d'environnement du système** : ces variables sont définies par le système d'exploitation sur lequel le `runner` s'exécute.

#### Définir des variables d'environnement

Pour définir une variable d'environnement personnalisée, vous pouvez utiliser **la clé `env`** dans le fichier de `workflow`.

La portée d'une variable personnalisée définie par cette méthode est limitée à l'élément dans lequel elle est définie. **Vous pouvez définir des variables avec différentes portées** :

*   Pour tout le `workflow`, en utilisant `env` au niveau supérieur du fichier de `workflow`.
*   Pour le contenu d'un `job` dans un `workflow`, en utilisant `jobs.<job_id>.env`.
*   Pour une étape spécifique dans un `job`, en utilisant `jobs.<job_id>.steps[*].env`.

Ainsi :

content\_copy

```
env:
  MA_VARIABLE: valeur
```

content\_copy

```
jobs:
  mon_job:
    env:
      MA_VARIABLE_JOB: valeur_job
```

content\_copy

```
jobs:
  mon_job:
    steps:
      - name: Étape 1
        env:
          MA_VARIABLE_ETAPE: valeur_etape
        run: echo "$MA_VARIABLE_ETAPE"
```

Et un exemple complet :

content\_copy

```
env:
  NIVEAU_WORKFLOW: "Je suis une variable de workflow"

jobs:
  mon_job:
    runs-on: ubuntu-latest
    env:
      NIVEAU_JOB: "Je suis une variable de job"
    steps:
      - name: Étape 1
        env:
          NIVEAU_ETAPE: "Je suis une variable d'étape"
        run: |
          echo "$NIVEAU_WORKFLOW"
          echo "$NIVEAU_JOB"
          echo "$NIVEAU_ETAPE"
```

Ici, toutes les variables seront disponibles dans l'étape 1, mais leur portée diffère.

#### Utiliser des contextes pour accéder aux valeurs des variables

Les contextes sont un moyen d'accéder à des informations sur les exécutions de `workflow`, les variables, les environnements de l'exécuteur, les `jobs` et les étapes. Vous pouvez accéder aux valeurs des variables d'environnement en utilisant le contexte `env`. Nous les verrons dans la leçon suivante.

### Variables par défaut

Si vous souhaitez voir toutes les variables d'environnement disponibles pour une étape de `workflow`, vous pouvez utiliser la commande `run: env` dans une étape spécifique. Ensuite, vous pouvez examiner la sortie (le "log") de cette étape pour voir toutes les variables listées.

content\_copy

```
jobs:
  list_env_variables:
    runs-on: ubuntu-latest
    steps:
      - name: List all environment variables
        run: env
```

#### Détails des variables d'environnement `GitHub Actions`

*   **`CI`** : toujours définie à `true`. Cette variable indique que le `CI` (Intégration Continue) est actif.
    
*   **`GITHUB_ACTION`** : nom de l'`action` en cours d'exécution ou l'identifiant d'une étape. Des suffixes peuvent être ajoutés si une action ou un `script` est utilisé plusieurs fois dans le même `job`.
    
*   **`GITHUB_ACTION_PATH`** : chemin où une action composite est localisée. Permet d'accéder aux fichiers situés dans le même dépôt que l'action.
    
*   **`GITHUB_ACTION_REPOSITORY`** : pour une étape exécutant une action, c'est le propriétaire et le nom du dépôt de l'`action`.
    
*   **`GITHUB_ACTIONS`** : youjours définie à `true` quand `GitHub Actions` exécute le `workflow`. Utile pour différencier les tests locaux des tests exécutés par `GitHub Actions`.
    
*   **`GITHUB_ACTOR`** : nom de la personne ou de l'application qui a initié le `workflow`.
    
*   **`GITHUB_API_URL`** : URL de l'`API GitHub`.
    
*   **`GITHUB_BASE_REF`** : nom de la branche de base pour une pull request. Définie uniquement pour les événements `pull_request` ou `pull_request_target`.
    
*   **`GITHUB_ENV`** : chemin vers le fichier qui définit les variables depuis les commandes de `workflow`. Ce fichier est unique pour chaque étape.
    
*   **`GITHUB_EVENT_NAME`** : nom de l'événement qui a déclenché le `workflow`.
    
*   **`GITHUB_EVENT_PATH`** : chemin vers le fichier contenant les données de l'événement webhook complet.
    
*   **`GITHUB_GRAPHQL_URL`** : URL de l'API GraphQL de GitHub.
    
*   **`GITHUB_HEAD_REF`** : nom de la branche source pour une pull request. Définie uniquement pour les événements `pull_request` ou `pull_request_target`.
    
*   **`GITHUB_JOB`** : ID du `job` en cours d'exécution.
    
*   **`GITHUB_OUTPUT`** : chemin vers le fichier qui définit les sorties de l'étape actuelle depuis les commandes de `workflow`.
    
*   **`GITHUB_PATH`** : chemin vers le fichier qui définit les variables `PATH` du système depuis les commandes de `workflow`.
    
*   **`GITHUB_REF`** : référence complète de la branche ou du tag qui a déclenché le `workflow`.
    
*   **`GITHUB_REF_NAME`** : nom court de la branche ou du tag qui a déclenché le `workflow`.
    
*   **`GITHUB_REF_PROTECTED`** : `true` si des protections de branche sont configurées pour la référence déclencheuse.
    
*   **`GITHUB_REF_TYPE`** : type de référence qui a déclenché le `workflow`. Valeurs valides : `branch` ou `tag`.
    
*   **`GITHUB_REPOSITORY`** : propriétaire et nom du dépôt.
    
*   **`GITHUB_REPOSITORY_OWNER`** : nom du propriétaire du dépôt.
    
*   **`GITHUB_RETENTION_DAYS`** : nombre de jours pendant lesquels les journaux et artefacts du `workflow` sont conservés.
    
*   **`GITHUB_RUN_ATTEMPT`** : numéro unique pour chaque tentative d'un `workflow` dans un dépôt.
    
*   **`GITHUB_RUN_ID`** : numéro unique pour chaque `workflow` dans un dépôt.
    
*   **`GITHUB_RUN_NUMBER`** : numéro unique pour chaque exécution d'un `workflow` spécifique dans un dépôt.
    
*   **`GITHUB_SERVER_URL`** : `URL` du serveur `GitHub AE`.
    
*   **`GITHUB_SHA`** : `SHA` du `commit` qui a déclenché le `workflow`.
    
*   **`GITHUB_STEP_SUMMARY`** : chemin vers le fichier contenant les résumés des `jobs` depuis les commandes de `workflow`.
    
*   **`GITHUB_WORKFLOW`** : nom du `workflow`.
    
*   **`GITHUB_WORKSPACE`** : répertoire de travail par défaut sur le `runner`.
    
*   **`RUNNER_ARCH`** : architecture du `runner` exécutant le `job`.
    
*   **`RUNNER_DEBUG`** : définie à `1` si le débogage est activé.
    
*   **`RUNNER_NAME`** : nom du `runner` exécutant le `job`.
    
*   **`RUNNER_OS`** : système d'exploitation du `runner` exécutant le `job`.
    
*   **`RUNNER_TEMP`** : chemin vers un répertoire temporaire sur le `runner`.
    

### Les `secrets`

Les `secrets` sont des variables que vous créez à l'échelle d'une organisation, d'un dépôt ou d'un environnement de dépôt.

Ces `secrets` sont ensuite utilisables dans vos `workflows`. Il est important de noter que ces `secrets` ne sont accessibles que si vous les incluez explicitement dans un `workflow`.

#### Caractéristiques principales des `secrets`

*   Les noms de `secrets` ne peuvent contenir que des caractères alphanumériques ou des `underscores`.
*   Les noms ne doivent pas commencer par le préfixe `GITHUB_`.
*   Les `secrets` sont sensibles à la casse.
*   Les `secrets` sont limités à une taille de `48 Ko`.

#### Comment créer et utiliser un secret simple

1.  Tout d'abord, créez un `secret` dans `Settings > Secrets and variables > Actions > Add new Secret` sur votre dépôt `GitHub`. Appelez-le `MON_SECRET`.
    
2.  Ensuite, modifiez votre fichier de `workflow GitHub Actions` pour inclure ce `secret`.
    

Voici comment vous pouvez faire ça :

content\_copy

```
name: Utiliser un secret
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Étape pour utiliser un secret
      run: echo Mon secret est ${{ secrets.MON_SECRET }}
```

Dans cet exemple, le secret `MON_SECRET` est rendu accessible dans l'étape du `workflow` via `${{ secrets.MON_SECRET }}`.

**GitHub masque automatiquement les `secrets` dans les `logs`, donc même si vous utilisez un `echo`, le `secret` ne sera pas visible dans les `logs`.**

### Exemple d'utilisation de `secrets` dans différents `shells`

#### `Bash`

content\_copy

```
steps:
- shell: bash
  env:
    SUPER_SECRET: ${{ secrets.SuperSecret }}
  run: |
    example-command "$SUPER_SECRET"
```

#### `PowerShell`

content\_copy

```
steps:
- shell: pwsh
  env:
    SUPER_SECRET: ${{ secrets.SuperSecret }}
  run: |
    example-command "$env:SUPER_SECRET"
```

### Sur cette page

*   À propos des variables
*   Définir des variables d'environnement
*   Utiliser des contextes pour accéder aux valeurs des variables
*   Variables par défaut
*   Détails des variables d'environnement GitHub Actions
*   Les secrets
*   Caractéristiques principales des secrets
*   Comment créer et utiliser un secret simple
*   Exemple d'utilisation de secrets dans différents shells
*   Bash
*   PowerShell