### Evénements disponibles

Voici tous les événements disponibles pour les `workflows`.

Nous verrons ensuite quelques exemples et en verrons d'autres plus en détail dans la suite de la formation.

Nom de l'événement

Court Descriptif

`branch_protection_rule`

Se déclenche lors des changements aux règles de protection de branche.

`check_run`

Se déclenche lors des événements de vérification (`check runs`).

`check_suite`

Se déclenche pour les événements de suite de vérification (`check suites`).

`create`

Se déclenche lors de la création d'une branche ou d'un tag.

`delete`

Se déclenche lors de la suppression d'une branche ou d'un tag.

`deployment`

Se déclenche lors du déploiement d'une application.

`deployment_status`

Se déclenche lorsque le statut d'un déploiement change.

`fork`

Se déclenche lorsqu'un dépôt est forké.

`gollum`

Se déclenche lors des modifications de pages wiki.

`issue_comment`

Se déclenche lors des commentaires sur des issues et des pull requests.

`issues`

Se déclenche lors des événements liés aux issues (ouvert, fermé, etc.).

`label`

Se déclenche lors de la création ou de la suppression de labels.

`milestone`

Se déclenche lors des événements liés aux jalons (milestones).

`page_build`

Se déclenche lors de la construction des pages GitHub.

`project`

Se déclenche lors des événements liés aux projets.

`project_card`

Se déclenche lors des événements liés aux cartes de projet.

`project_column`

Se déclenche lors des événements liés aux colonnes de projet.

`public`

Se déclenche lorsqu'un dépôt devient public.

`pull_request`

Se déclenche lors des événements liés aux pull requests (ouvert, fermé, etc.).

`pull_request_review`

Se déclenche lors des événements liés aux revues de pull requests.

`pull_request_review_comment`

Se déclenche lors de la création de commentaires sur les revues de pull requests.

`pull_request_target`

Similaire à `pull_request`, mais permet de lire des secrets à partir d'une pull request venant d'un fork.

`push`

Se déclenche lors d'un push vers une branche.

`registry_package`

Se déclenche lors des événements liés aux packages de registre.

`release`

Se déclenche lors des événements liés aux releases (création, suppression, etc.).

`repository_dispatch`

Permet des événements déclenchés manuellement depuis l'extérieur du dépôt.

`schedule`

Se déclenche à des moments planifiés.

`status`

Se déclenche lors de la modification de l'état des commits.

`watch`

Se déclenche lorsque quelqu'un mets une étoile au dépôt.

`workflow_call`

Se déclenche lorsqu'un workflow appelle un autre workflow.

`workflow_dispatch`

Permet de déclencher manuellement un workflow.

`workflow_run`

Se déclenche lors de l'exécution d'un workflow.

Pour le détail de toutes les options c'est [ici](https://docs.github.com/fr/github-ae@latest/actions/using-workflows/events-that-trigger-workflows).

### Exemples

Voici des exemples des utilisations les plus communes.

#### Exemple 1 : `pull_request`

content\_copy

```
# .github/workflows/pull_request.yml

# ce workflow se déclenche lors de la création d'une pull request
on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      # cette étape simule des tests unitaires
      - name: Exécution des tests unitaires
        run: |
          echo "Exécution des tests unitaires..."
          sleep 2
          echo "Tests unitaires passés."
```

#### Exemple 2 : `issue`

content\_copy

```
# .github/workflows/issue_created.yml

# ce workflow se déclenche lors de l'ouverture d'une nouvelle issue
on:
  issues:
    types:
      - opened

jobs:
  alert:
    runs-on: ubuntu-latest
    
    steps:
      # cette étape envoie une alerte
      - name: Envoi d'une alerte
        run: echo "Une nouvelle issue a été créée."
```

#### Exemple 3 : `release`

content\_copy

```
# .github/workflows/release_created.yml

# ce workflow se déclenche lors de la création d'une nouvelle release
on:
  release:
    types:
      - created

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      # cette étape simule le déploiement de l'application
      - name: Déploiement
        run: |
          echo "Début du déploiement..."
          sleep 2
          echo "Déploiement réussi."
```

#### Exemple 4 : `schedule`

content\_copy

```
# .github/workflows/scheduled_job.yml

# ce workflow se déclenche tous les jours à minuit
on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  maintenance:
    runs-on: ubuntu-latest
    
    steps:
      # cette étape simule une tâche de maintenance quotidienne
      - name: Tâche de maintenance
        run: |
          echo "Début de la maintenance quotidienne..."
          sleep 2
          echo "Maintenance quotidienne terminée."
```

#### Exemple 5 : `fork`

content\_copy

```
# .github/workflows/on_fork.yml

# ce workflow se déclenche lorsqu'un utilisateur fork ce dépôt
on:
  fork:

jobs:
  message:
    runs-on: ubuntu-latest
    
    steps:
      # cette étape simule un message de bienvenue
      - name: Message de bienvenue
        run: |
          echo "Bienvenue au nouveau contributeur !"
          sleep 2
          echo "Nous sommes ravis de voir votre intérêt pour ce projet."
```

### Sur cette page

*   Evénements disponibles
*   Exemples
*   Exemple 1 : pull\_request
*   Exemple 2 : issue
*   Exemple 3 : release
*   Exemple 4 : schedule
*   Exemple 5 : fork