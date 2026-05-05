### Comment utiliser des `actions` ?

Les actions que vous utilisez dans votre `workflow` peuvent être définies dans :

*   Le même dépôt que votre fichier de `workflow`
*   Un dépôt interne au sein du même compte d'entreprise, configuré pour permettre l'accès aux `workflows`
*   Tout dépôt public
*   Une image de conteneur `Docker` publiée sur `Docker Hub`

Pour trouver des actions officielles ou développées par la communauté il faut se rendre sur `[GitHub Marketplace](https://github.com/marketplace?category=&query=&type=actions)`.

### Ajouter une `action` d'un dépôt différent

Si une action est définie dans un dépôt différent de votre fichier de `workflow`, vous pouvez référencer l'action avec la syntaxe `{propriétaire}/{dépôt}@{référence}` dans votre fichier de `workflow`.

L'action doit être stockée dans un dépôt public ou un dépôt interne configuré pour permettre l'accès aux `workflows`. Pour plus d'informations, voir "Partager des actions et des `workflows` avec votre entreprise".

Les actions officielles (développées par `Github/Microsoft`) ont pour propriétaire actions. Ce sera donc par exemple :

content\_copy

```
jobs:
  mon_premier_job:
    steps:
      - name: Ma première étape
        uses: actions/setup-node@v3
```

### Ajouter une `action` du même dépôt

Si une action est définie dans le même dépôt où votre fichier de `workflow` utilise l'action, vous pouvez référencer l'action avec la syntaxe `{propriétaire}/{dépôt}@{référence}` ou `./chemin/vers/repertoire` dans votre fichier de `workflow`.

Par exemple :

content\_copy

```
|-- nom-depot (dépôt)
|   |__ .github
|       └── workflows
|           └── mon-premier-workflow.yml
|       └── actions
|           |__ ma-super-action
|               └── action.yml
```

Et vous pourrez ensuite l'utiliser comme cela :

content\_copy

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ./.github/actions/ma-super-action
```

Nous verrons plus tard comment créer des `actions` personnalisées.

### Référencer un conteneur sur `Docker Hub`

Si une action est définie dans une image de conteneur `Docker` publiée sur `Docker Hub`, vous devez référencer l'action avec la syntaxe `docker://{image}:{tag}` dans votre fichier de `workflow`. Pour protéger votre code et vos données, nous vous recommandons fortement de vérifier l'intégrité de l'image de conteneur `Docker` depuis `Docker Hub` avant de l'utiliser dans votre `workflow`.

#### Exemple de `job` :

content\_copy

```
jobs:
  mon_premier_job:
    steps:
      - name: Ma première étape
        uses: docker://alpine:3.8
```

### Utilisation de la gestion des versions pour les `actions`

Les créateurs d'une `action` ont la possibilité d'utiliser des `tags`, des branches ou des valeurs `SHA` pour gérer les versions de l'`action`.

Comme pour toute dépendance, vous devriez indiquer la version de l'action que vous souhaitez utiliser.

Vous désignerez la version de l'`action` dans votre fichier de `workflow`. Consultez la documentation de l'`action` pour des informations sur leur approche de la gestion des versions, et pour voir quel `tag`, quelle branche ou quelle valeur `SHA` utiliser.

#### Utilisation de `tags`

Les `tags` sont utiles pour vous permettre de décider quand passer entre des versions majeures et mineures, mais ces derniers sont plus éphémères et peuvent être déplacés ou supprimés par le mainteneur. Cet exemple montre comment cibler une `action` qui a été taguée comme v1.0.1 :

content\_copy

```
steps:
  - uses: actions/javascript-action@v1.0.1
```

**C'est l'utilisation la plus commune et celle que nous utiliserons dans la formation.**

C'est le système `SemVer` qui est utilisé :

content\_copy

```
uses: actions/setup-node@v3
```

Lisez en à la fin de la leçon l'explication détaillée sur `SemVer` si vous ne connaissez pas car cela vous sera très utile.

#### Utilisation de `SHA`

Si vous avez besoin d'une version plus fiable, vous devriez utiliser la valeur `SHA` associée à la version de l'`action`. Les `SHA` sont immuables et donc plus fiables que les `tags` ou les branches. Cependant, cette approche signifie que vous ne recevrez pas automatiquement les mises à jour d'une `action`, y compris les corrections de bugs importantes et les mises à jour de sécurité. Vous devez utiliser la valeur `SHA` complète d'un `commit`, et non une valeur abrégée. Lors de la sélection d'un `SHA`, vous devriez vérifier qu'il provient du dépôt de l'`action` et non d'un `fork` du dépôt. Cet exemple cible le `SHA` d'une `action` :

content\_copy

```
steps:
  - uses: actions/javascript-action@a824008085750b8e136effc585c3cd6082bd575f
```

#### Utilisation de branches

Spécifier une branche cible pour l'`action` signifie qu'elle exécutera toujours la version actuellement sur cette branche. Cette approche peut créer des problèmes si une mise à jour de la branche inclut des changements qui cassent des choses. Cet exemple cible une branche nommée `@main` :

content\_copy

```
steps:
  - uses: actions/javascript-action@main
```

### Le système `SemVer`

Dans le monde du développement logiciel, la gestion de version suit souvent le schéma `majeur.mineur.patch`, également connu sous le nom de `SemVer` (Versionnage Sémantique). Voici ce que signifient ces termes :

#### Majeur

Une modification majeure est une modification qui modifie la manière dont le logiciel fonctionne d'une manière qui est incompatible avec les versions précédentes. Cela peut inclure des changements dans les interfaces `API`, des suppressions de fonctionnalités, ou d'autres modifications qui nécessitent une action de la part de l'utilisateur pour continuer à utiliser le logiciel.

#### Mineur

Une modification mineure ajoute des fonctionnalités ou des améliorations qui sont compatibles avec les versions précédentes. Par exemple, l'ajout d'une nouvelle méthode à une `API` sans supprimer ou modifier les méthodes existantes serait une modification mineure.

#### Patch

Un `patch` est une modification qui corrige des bugs ou des problèmes de sécurité, et qui est conçue pour être totalement compatible avec les versions précédentes. Cela signifie que vous pouvez appliquer le `patch` sans affecter la fonctionnalité existante.

#### Exemple `uses: actions/setup-node@v3`

Cette ligne signifie que vous utilisez l'action `setup-node` de `GitHub Actions` et que vous **ciblez la version majeure `3`**.

Cela signifie que votre `workflow` utilisera la dernière version mineure et le dernier patch qui correspondent à cette version majeure.

Dans un contexte pratique, si les versions disponibles de `setup-node` sont :

*   `3.0.0`
*   `3.1.0`
*   `3.1.1`
*   `3.2.0`
*   `4.0.0`

Utiliser `@v3` prendrait automatiquement la dernière version compatible avec la version majeure 3, qui serait `3.2.0`. Notez que la version `4.0.0` ne serait pas prise car elle appartient à une nouvelle version majeure.

Ceci vous permet d'accepter automatiquement les mises à jour mineures et les patches, tout en évitant les changements majeurs qui pourraient casser votre configuration actuelle. Garez bien cela en tête pour la suite de la formation !

### Sur cette page

*   Comment utiliser des actions ?
*   Ajouter une action d'un dépôt différent
*   Ajouter une action du même dépôt
*   Référencer un conteneur sur Docker Hub
*   Exemple de job :
*   Utilisation de la gestion des versions pour les actions
*   Utilisation de tags
*   Utilisation de SHA
*   Utilisation de branches
*   Le système SemVer
*   Majeur
*   Mineur
*   Patch
*   Exemple uses: actions/setup-node@v3