<

## Introduction à `Ansible`


`Ansible` est un outil d'automatisation `IT` open-source écrit en `Python` qui permet de gérer la configuration de systèmes, le déploiement d'applications et l'exécution de tâches sur un ensemble de machines de manière automatisée. 

Il utilise une approche `agentless`, ce qui signifie qu'aucun logiciel supplémentaire ou agent n'est nécessaire sur les machines cibles. Il utilise le protocole `SSH` pour la communication.

`Ansible` a été créé par `Michael DeHaan` en 2012 et compte plus de 5500 contributeurs, ce qui en fait un des projets open source les plus suivis.

Le nom `Ansible` a été choisi en référence à un roman de science-fiction qui désigne un moyen de communication plus rapide que la lumière.

`Ansible Inc.` qui était la société qui développait commercialement l'application `Ansible` a été racheté par `Red Hat` en 2015.

Il existe donc aujourd'hui une version communautaire gratuite et le produit commercial _`Red Hat Ansible Automation Platform Life Cycle`_.

### Les principes d'`Ansible`

La philosophie d'`Ansible` comporte plusieurs grands principes que nous allons voir ensemble.

**Avoir un processus de configuration extrêmement simple avec une courbe d'apprentissage minimale**

L'outil est facile à installer et à configurer. Une personne avec peu ou pas d'expérience en automatisation doit pouvoir rapidement comprendre comment utiliser l'outil. L'apprentissage peut donc être très progressif.

**Gérer les machines rapidement et en parallèle**

L'outil doit être capable d'exécuter des tâches sur plusieurs machines en même temps, réduisant ainsi le temps nécessaire pour l'automatisation.

**Eviter des agents personnalisés et des ports ouverts supplémentaires, être `agentless` en exploitant l'utilitaire `SSH` existant**

Pas besoin d'installer de logiciel supplémentaire sur les machines que vous souhaitez automatiser. Utilise `SSH`, qui est généralement déjà installé et configuré sur les systèmes `UNIX`, pour communiquer avec les machines distantes.

**Décrire l'infrastructure dans un langage qui est à la fois adapté aux machines et aux humains**

Le langage utilisé pour écrire les `scripts` ou les configurations doit être facile à lire et à comprendre, tout en étant interprétable par la machine. C'est pourquoi `Ansible` utilise `YAML`.

**Se concentrer sur la sécurité et la facilité d'auditabilité/examen/réécriture du contenu**

L'outil doit être conçu avec la sécurité à l'esprit. Il doit également permettre un audit facile du code et des configurations, de sorte que les revues de code et la conformité aux normes de sécurité puissent être facilement réalisées.

**Gérer de nouvelles machines distantes instantanément, sans initialisation de logiciel**

L'idée est de pouvoir ajouter de nouvelles machines à votre infrastructure et de commencer à les automatiser immédiatement, sans avoir à installer de logiciel supplémentaire ou à faire des configurations complexes.

**Permettre le développement de `modules` dans n'importe quel langage dynamique, pas seulement en `Python`**

Bien qu'Ansible soit écrit en `Python`, il permet l'intégration de modules écrits dans d'autres langages de programmation. Cela le rend plus extensible et permet aux développeurs d'utiliser les langages avec lesquels ils sont les plus à l'aise.

**Être utilisable en tant que `non-root`**

Il devrait être possible d'utiliser l'outil sans privilèges d'administrateur, ce qui réduit les risques de sécurité.

**Être le système d'automatisation `IT` le plus facile à utiliser, pour toujours**

Cela résume en quelque sorte tous les principes ci-dessus. L'objectif est de créer un outil qui est non seulement puissant mais aussi extrêmement facile à utiliser, rendant l'automatisation accessible à autant de personnes que possible.

Ces principes guident le développement et les améliorations de l'outil, assurant qu'il reste utile, efficace et facile à utiliser.

### Sur cette page

*   Introduction à Ansible
*   Les principes d'Ansible
