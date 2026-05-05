### Utilisation de `defaults` au niveau du `workflow`

Le mot-clé `defaults` permet de définir un ensemble de paramètres par défaut qui s'appliquent à toutes les tâches (`jobs`) dans un `workflow`.

Ces paramètres peuvent inclure des options pour la commande `run`, comme le `shell` à utiliser et le répertoire de travail.

_Il est possible de surcharger ces paramètres par défaut au niveau de chaque tâche (`job`) comme nous le verrons également._

#### Priorité des paramètres

Si plus d'un paramètre par défaut est défini avec le même nom, `GitHub` utilise le paramètre le plus spécifique.

Par exemple : un paramètre défini dans une tâche surchargera un paramètre ayant le même nom défini dans le `workflow`.

#### `defaults.run`

Vous pouvez utiliser `defaults.run` pour fournir les options par défaut de `shell` et de répertoire de travail (`working-directory`) pour toutes les étapes `run` dans un `workflow`.

Note : Vous ne pouvez pas utiliser de contextes ou d'expressions dans ce mot-clé.

#### Exemple : Définir le `shell` et le répertoire de travail par défaut

content\_copy

```
name: Exemple d'utilisation de defaults
on: push

defaults:
  run:
    shell: bash
    working-directory: ./scripts

jobs:
  exemple_job:
    runs-on: ubuntu-latest
    steps:
    - name: Vérifier le répertoire de travail
      run: pwd # Doit afficher /github/workspace/scripts
    - name: Attendre pour visualiser
      run: sleep 5
```

Dans cet exemple, le `shell` par défaut est défini comme `bash` et le répertoire de travail comme `./scripts`.

L'étape `run: pwd` affichera donc `/github/workspace/scripts`, ce qui montre que le répertoire de travail par défaut est bien appliqué.

Pour tester cet exemple, ajoutez-le dans votre fichier `.github/workflows/main.yml` et déclenchez un nouveau `workflow`. Vous pourrez constater que le `shell` et le répertoire de travail par défaut sont bien appliqués.

### Utilisation de `defaults` au niveau des `jobs`

Le champ `jobs.<job_id>.defaults` permet de créer des paramètres par défaut qui s'appliqueront à toutes les étapes (`steps`) dans la tâche (`job`). 

#### Priorité des paramètres

Comme pour les `defaults` du `workflow`, si plus d'un paramètre par défaut est défini avec le même nom, `GitHub` utilisera le paramètre le plus spécifique.

Un paramètre défini dans une tâche écrasera un paramètre ayant le même nom défini dans le `workflow`.

#### `jobs.<job_id>.defaults.run`

Le champ `jobs.<job_id>.defaults.run` permet de définir le shell et le répertoire de travail par défaut (`working-directory`) pour toutes les étapes `run` d'une tâche. Ce champ peut référencer plusieurs contextes.

#### Exemple : Définition des options par défaut pour une étape `run` dans une tâche

Voici un exemple de `workflow` où les paramètres par défaut sont définis au niveau de la tâche :

content\_copy

```
name: Exemple d'utilisation de jobs.<job_id>.defaults
on: push

jobs:
  job1:
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash
        working-directory: ./scripts

    steps:
    - name: Vérifier le répertoire de travail
      run: pwd # Doit afficher /github/workspace/scripts
    - name: Attendre pour visualiser
      run: sleep 5

  job2:
    runs-on: ubuntu-latest
    steps:
    - name: Vérifier le répertoire de travail
      run: pwd # Doit afficher /github/workspace, car aucun working-directory par défaut n'est défini pour cette tâche
    - name: Attendre pour visualiser
      run: sleep 5
```

Dans cet exemple, la tâche `job1` a un shell par défaut et un répertoire de travail définis à `bash` et `./scripts` respectivement. La tâche `job2` n'a pas de paramètres par défaut, donc elle utilisera les valeurs par défaut globales ou celles spécifiées par GitHub.

### Sur cette page

*   Utilisation de defaults au niveau du workflow
*   Priorité des paramètres
*   defaults.run
*   Exemple : Définir le shell et le répertoire de travail par défaut
*   Utilisation de defaults au niveau des jobs
*   Priorité des paramètres
*   jobs.<job\_id>.defaults.run
*   Exemple : Définition des options par défaut pour une étape run dans une tâche