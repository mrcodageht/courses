### Qu'est-ce que `Github Actions` ?

`GitHub Actions` est une plateforme `CI/CD` qui vous permet d'automatiser différentes tâches dans votre dépôt `Github`.

Vous pouvez exécuter des `workflows` suite à des événements spécifiques ou selon une planification.

### Introduction aux composants de `GitHub Actions`

Les composants principaux sont :

*   **`Event`** : activité spécifique dans un dépôt qui déclenche l’exécution d’un `workflow`.
*   **`Workflow`** : un ensemble de `jobs` déclenché par un événement.
*   **`Job`** : un ensemble d'étapes (_`steps`_) exécutées sur un `runner`.
*   **`Step`** : une `action` ou un script exécuté dans un `job`.
*   **`Action`** : une tâche réutilisable.
*   **`Runner`** : l'environnement où s'exécutent les `jobs`.

![Diagramme d’un événement déclenchant Exécuteur 1 pour exécuter Travail 1, lequel déclenche Exécuteur 2 pour exécuter Travail 2. Chacun des travaux est divisé en plusieurs étapes.](./github-actions-cest-quoi_files/overview-actions-simple.png)

#### Événements (`events`)

Un `event` est une activité spécifique dans un dépôt qui déclenche l'exécution d'un `workflow`.

L'activité peut provenir de `GitHub` quand quelqu'un crée une `pull request`, ouvre une `issue`, ou effectue un `commit` dans un dépôt.

On peut aussi déclencher un `workflow` manuellement, à l'aide d'une `API REST` ou selon un calendrier (_`cron jobs`_).

#### Flux de travail (`workflows`)

Un `workflow` est un processus automatisé configurable qui exécute un ou plusieurs `jobs`.

Les `workflows` sont définis par un fichier au format `YAML` dans votre dépôt et sont déclenchés par un événement dans ce dépôt.

**Les `workflows` se trouvent dans le répertoire `.github/workflows` d'un dépôt.**

Un dépôt peut avoir plusieurs `workflows`, chacun accomplissant un ensemble de tâches différentes. Par exemple : un pour construire et tester des `pull requests`, un autre pour déployer une application à chaque nouvelle version, et un autre encore pour ajouter une étiquette lorsqu'une nouvelle `issue` est ouverte.

#### Tâches (`jobs`) et étapes (`steps`)

Un `job` est un ensemble d'étapes dans un `workflow` qui sont exécutées sur le même `runner`.

Chaque étape est soit un **`script shell`** qui sera exécuté, soit une **`action`** qui sera lancée.

**Les étapes sont exécutées dans l'ordre et sont dépendantes les unes des autres**. Par exemple : une étape peut construire votre application et la suivante peut la tester.

On peut configurer les dépendances entre `jobs`.

**Par défaut, les `jobs` n'ont pas de dépendances et s'exécutent en parallèle**. Si un `job` dépend d'un autre, il attendra que ce dernier se termine avant de démarrer.

#### Actions (`actions`)

**Une `action` est une application personnalisée pour [la plateforme `GitHub Actions`](https://github.com/marketplace?type=actions) qui effectue une tâche complexe mais fréquemment répétée.**

**Allez voir par exemple l'[`action setup-node`](https://github.com/actions/setup-node/tree/main).** Naviguez dans le répertoire `src` et constatez tout le code pour installer `Node.js` sur n'importe quel environnement.

Et l'utilisation sera aussi simple que :

content\_copy

```
- uses: actions/setup-node@v3
  with:
    node-version: 18
```

**Utiliser une `action` permet donc de réduire de beaucoup la quantité de code répétitif dans vos fichiers de `workflow`.**

Par exemple : récupérer votre dépôt `git` de `GitHub`, configurer la chaîne d'outils pour votre environnement de construction ou mettre en place l'authentification pour votre fournisseur de `cloud`.

On peut créer ses propres `actions` ou en trouver dans le `GitHub Marketplace`. Il existe [un grand nombre d'`actions` officielles maintenues par `Github` (`Microsoft`)](https://github.com/orgs/actions/repositories) et encore plus d'`actions` maintenues par la communauté. Il y en a plus de 20 000 sur la `marketplace`.

Pour les partager au sein de votre entreprise sans les publier publiquement, vous pouvez les stocker dans un dépôt interne.

#### Exécuteurs (`runners`)

Un `runner` est un serveur qui exécute vos `workflows` lorsqu'ils sont déclenchés. Chaque `runner` peut exécuter un seul `job` à la fois.

Vous pouvez utiliser les `runners` de `Github` ou les vôtres (comme avec `Gitlab`).

### Sur cette page

*   Qu'est-ce que Github Actions ?
*   Introduction aux composants de GitHub Actions
*   Événements (events)
*   Flux de travail (workflows)
*   Tâches (jobs) et étapes (steps)
*   Actions (actions)
*   Exécuteurs (runners)