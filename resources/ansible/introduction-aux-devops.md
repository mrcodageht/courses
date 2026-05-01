### Qu'est-ce que le `DevOps` ?

`"Devops"` est la concaténation des trois premières lettres du mot anglais _`development`_ (développement) et de l'abréviation _`ops`_ du mot anglais _`operations`_ (exploitation).

C'est un terme qui a été inventé par le belge `Patrick Debois` en 2007.

Le `DevOps` est un ensemble de pratiques qui visent à réduire le fossé entre le **développement logiciel** (_`Dev`_) et les **opérations informatiques** (_`Ops`_), d'où le terme.

L'idée est de favoriser une collaboration plus étroite et une meilleure communication entre ces deux entités qui, dans les modèles traditionnels, opèrent souvent de manière isolée.

Les principes clés du `DevOps` comprennent aujourd'hui :

*   **l'intégration continue** (`CI` pour _`continuous integration`_ en anglais - le code est régulièrement fusionné et testé), 
*   **la livraison continue** (`CD` pour _`continuous delivery`_ - les mises à jour du logiciel sont régulièrement libérées pour la production),
*   **l'infrastructure en tant que code** (la gestion et la provision des infrastructures informatiques via le code - _`IAC` en anglais pour `Infrastructures As Code`_),
*   **la surveillance et la journalisation** (le suivi en temps réel de la performance et des erreurs du logiciel)
*   **la culture de la rétroaction** (l'encouragement à l'amélioration constante via les retours d'information)

Le schéma classique est celui-ci :

![](./introduction-aux-devops_files/640px-Devops-toolchain.svg.png)

### Outils `DevOps` principaux

#### **1 - Planification et collaboration :**

Ces outils permettent de créer des tâches et de gérer un projet. Les plus utilisés sont :

*   **`Gitlab`**
*   **`Github`**
*   **`Jira`**

#### **2 - Gestion du code (développement)**

Ces outils permettent d'effectuer un contrôle de version du code. Les plus utilisés sont :

*   `**GitHub**`
*   **`GitLab`**
*   **`Bitbucket`**

#### **3 - Intégration Continue / Déploiement Continu (CI/CD) :**

Ces outils surveillent les `commits` dans votre dépôt par exemple `Github`. Lorsqu'un commit est effectué, ils lancent automatiquement un "`pipeline`" d'intégration continue qui peut compiler le code, exécuter des tests unitaires, des tests d'intégration, et d'autres types de tests pour s'assurer que les dernières modifications n'ont pas introduit de bugs.

Si tous les tests passent, ces outils peuvent être configurés pour déployer automatiquement les changements sur un environnement de production, de `staging` ou de `test`. Cela accélère le processus de livraison de nouvelles fonctionnalités et de corrections de bugs.

Des solutions très connues sont :

*   **`Jenkins`**
*   **`GitLab CI/CD`**
*   `**Github actions**`
*   `**AWS CodePipeline**`
*   `**Azure DevOps   **`
*   **`CircleCI`**
*   **`Travis CI`**

#### **4 - Gestion de l'infrastructure :**

Ces outils permettent de faire des choses très différentes mais concernent les serveurs et les `clusters`.

Nous pouvons citer quelques exemples :

*   **`Docker`** : pour créer des images et ensuite les exécuter dans des conteneurs sur un `cluster`.
*   **`Docker Hub`** (_ou tout autre `Container Registry` - il y en a plusieurs dizaines_) : plateforme de service `cloud` qui permet aux développeurs de stocker et d'utiliser des images d'applications conteneurisées.
*   **`Kubernetes`** : plateforme qui automatise la déploiement, la mise à l'échelle et la gestion des applications conteneurisées, offrant un cadre pour orchestrer et coordonner des conteneurs au sein d'un environnement de `cloud`.
*   **`Terraform`** : outil d'Infrastintroduction-aux-devopsructure as Code (**`IaC`**) open source qui permet aux développeurs de définir et de fournir des infrastructures de centres de données en utilisant un langage de description déclaratif, facilitant ainsi la gestion et l'orchestration des ressources `cloud`.
*   **`Ansible`** : outil d'automatisation open source qui permet la gestion de configuration, le déploiement d'applications et l'orchestration de tâches sur une variété de systèmes et de plateformes (en résumé permet de configurer et de gérer des serveurs plus simplement).

#### **5 - Surveillance et retour d'information :**

Ces outils permettent de surveiller (_`monitoring`_) des `clusters` ou plus généralement des applications exécutées sur des serveurs.

Voici une liste des outils les plus courants :

*   **`Prometheus`** : système de surveillance et d'alerte qui collecte et stocke les métriques d'application et de système en temps réel, offrant des fonctionnalités de requête et d'alerte pour aider à la détection et à la résolution des problèmes.
*   **`Grafana`** : plateforme pour la visualisation et l'analyse de données, permettant aux utilisateurs de créer des tableaux de bord interactifs et compréhensibles pour surveiller et analyser en temps réel les données provenant de diverses sources, le plus souvent de `Prometheus`.
*   `**ELK Stack**` **(`Elasticsearch`, `Logstash`, `Kibana`)** : suite d'outils qui fournit des capacités de recherche, d'analyse, de journalisation et de visualisation de données, permettant aux utilisateurs de transformer leurs données en insights précieux.
*   **`Datadog / Nagios / New Relic / Sentry`** : plateformes de surveillance et d'analyse des performances en temps réel pour les infrastructures `cloud`, les applications, les journaux et les métriques, facilitant la détection des problèmes et leur résolution.

### Sur cette page

*   Qu'est-ce que le DevOps ?
*   Outils DevOps principaux
*   1 - Planification et collaboration :
*   2 - Gestion du code (développement)
*   3 - Intégration Continue / Déploiement Continu (CI/CD) :
*   4 - Gestion de l'infrastructure :
*   5 - Surveillance et retour d'information :