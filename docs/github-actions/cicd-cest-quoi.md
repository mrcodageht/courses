### Qu'est-ce que le `CI` / `CD` ?

#### `CI` (_`Continuous Integration`_ - Intégration Continue)

L'Intégration Continue (`CI`), est une pratique de développement logiciel dans laquelle les développeurs intègrent régulièrement leur code dans un répertoire `Git`. Chaque fois qu'un développeur pousse du code, une série d'automatisations est déclenchée pour compiler, tester et vérifier le code nouvellement ajouté. L'objectif principal de la CI est de détecter les problèmes d'intégration tôt et de garantir que le code nouvellement ajouté ne casse pas l'application existante.

Les étapes typiques incluent la compilation du code (_`build`_), l'exécution de tests unitaires et d'autres tests automatisés, la vérification des normes de code, la génération de rapports de test et la fourniture de commentaires rapide aux développeurs sur l'état de leur code. Dans un contexte de conteneurisation, comme avec `Kubernetes`, c'est également pendant l'intégration continue que sont `build` les images.

Les outils `CI` couramment utilisés incluent `Jenkins`, `Travis CI`, `CircleCI`, `GitLab CI/CD`, `Github Actions`, et bien d'autres.

#### `CD` (_`Continuous Deployment`_ - Déploiement Continu)

Le `CD`, ou Déploiement Continu, est une extension de la `CI` qui vise à automatiser le déploiement des changements de code nouvellement validés vers les environnements de production ou de pré-production.

Contrairement à la `CI` qui se concentre principalement sur les `builds`, les tests et les vérifications, le **`CD` s'intéresse à l'automatisation de la mise en production des changements.**

Avec le `CD`, une fois que le code a passé avec succès les étapes de la `CI` et qu'il a été validé, il est automatiquement déployé dans un environnement cible, généralement à partir d'un pipeline automatisé. Le `CD` permet de minimiser le temps nécessaire pour mettre en production de nouvelles fonctionnalités ou des correctifs, tout en réduisant les risques liés aux déploiements manuels.

Il existe deux approches principales en matière de `CD` :

1.  `**Continuous Deployment**` (Déploiement Continu) : dans cette approche, chaque changement de code validé est automatiquement déployé dans l'environnement de production sans intervention humaine. Cela nécessite une confiance élevée dans l'automatisation et une solide suite de tests automatisés.
    
2.  `**Continuous Delivery**` (Livraison Continue) : ici, les changements de code validés sont automatiquement déployés dans un environnement de pré-production ou de `staging`. La décision de déployer dans l'environnement de production est prise manuellement, généralement par un responsable technique, après avoir évalué les risques.
    