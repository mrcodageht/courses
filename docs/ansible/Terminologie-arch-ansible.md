### Introduction aux éléments `Ansible`

Dans cette leçon où nous allons explorer la terminologie clé utilisée dans `Ansible`.

Comprendre ces termes est crucial pour travailler efficacement avec cet outil d'automatisation.

C'est simplement une rapide introduction à chacun des composants principaux d'`Ansible`, nous les verrons bien sûr très en détail pendant la formation.

![Basic components of an Ansible environment include a control node, an inventory of managed nodes, and a module copied to each managed node.](./Terminologie-arch-ansible_files/ansible_inv_start.svg)

### Résumé des éléments principaux

En résumé, dans un environnement `Ansible`, le `control node` est la machine à partir de laquelle les tâches d'automatisation sont lancées.

Les `managed nodes` sont les hôtes que l'on souhaite configurer et gérer.

Pour établir quels `managed nodes` sont ciblés pour l'exécution de tâches, on utilise un `inventory` qui peut également organiser ces `nodes` en `groupes` pour faciliter leur gestion.

Des `vars` peuvent être définies au niveau des `groups` ou des `hosts` pour spécifier des variables qui affecteront le comportement des `tasks`.

Un `playbook` contient une série de `tasks` à exécuter sur les `managed nodes`.

Chaque `task` appelle un `module` qui exécute une action spécifique, comme l'installation d'un paquet ou la copie d'un fichier.

Les `rôles` permettent de regrouper des `tasks`, des `vars` et des fichiers de configuration pour une réusabilité et une organisation améliorées.

Les `plugins` ajoutent des fonctionnalités supplémentaires, comme le filtrage des données ou l'amélioration des capacités de `logging`.

Tous ces éléments travaillent ensemble pour fournir un système d'automatisation puissant et flexible qui peut gérer une multitude de scénarios complexes avec une syntaxe simple et compréhensible

### `control node` / `managed node`

Dans `Ansible`, le `control node` est la machine où `Ansible` est installé et à partir de laquelle les tâches d'automatisation sont exécutées.

Les `managed nodes` sont les serveurs sur lesquels les tâches seront effectuées.

**Exemple :**

*   `control node` : votre propre machine locale ou un serveur sécurisé.
*   `managed nodes` : serveurs Web, bases de données, etc.

### `Inventory`

L'`inventory` est un fichier qui contient la liste des `managed nodes` que le `control node` doit gérer.

**Exemple :**

content\_copy

```
[web]
192.168.1.1
192.168.1.2

[db]
192.168.1.3
```

#### `groups`

Dans un `inventory`, vous pouvez organiser les `managed nodes` en `groupes`.

Cela permet de cibler un ensemble spécifique de machines lors de l'exécution des `playbooks`.

Par exemple ci-dessus : le groupe `[web]` contient les serveurs Web, et `[db]` contient les bases de données.

#### `vars` : `groups` / `hosts`

Les variables (`vars`) peuvent être définies au niveau des `groups` ou des `hosts` individuels pour un accès facile dans les `playbooks`.

content\_copy

```
[web]
192.168.1.1 http_port=80
192.168.1.2 http_port=8080

[web:vars]
nginx_version=1.18
```

## `modules / tasks et plugins`

#### Les modules

Les `modules Ansible` sont des unités de code qui font le véritable travail dans `Ansible` : ils effectuent les tâches sur les `managed nodes`.

Un `module` prend des arguments et renvoie des informations au `control node`, généralement sous forme de `JSON`.

Les `modules` peuvent exécuter une grande variété d'opérations, y compris, mais sans s'y limiter, la gestion des paquets, la création de fichiers, la gestion des services système, et même l'interaction avec des `API` et des services externes.

Par exemple, le module `apt` pour gérer les paquets sur des systèmes `Debian`.

#### Les `tasks`

Les `tasks` sont les actions individuelles que `Ansible` exécutera sur les `managed nodes`. Une `task` utilise un `module`.

Chaque `task` dans un `playbook` appelle un `module` spécifique et lui passe un ensemble d'arguments. 

content\_copy

```
- name: installer nginx
  apt: 
    name: nginx
    state: present
```

Autre exemple :

content\_copy

```
- name: copier le fichier de configuration
  copy:
    src: /local/nginx.conf
    dest: /etc/nginx/nginx.conf
```

#### Les `plugins`

Les `plugins` étendent les fonctionnalités d'`Ansible`. Il en existe de plusieurs types, y compris des lookup plugins, des filter plugins, etc.

Par exemple, un `plugin` de recherche pour consulter les données dans un service `AWS S3`.

### Les rôles

Les `rôles` permettent de regrouper des `tasks`, des `vars`, des fichiers et d'autres composants `Ansible` en une structure organisée.

Par exemple, un rôle `web_server` qui installe et configure Nginx.

### Les `playbooks`

Les `playbooks` sont des fichiers `YAML` qui définissent quelles `tasks` exécuter et dans quel ordre. Ils peuvent inclure des `vars`, des `tasks`, et même d'autres `playbooks`.

content\_copy

```
---
- name: configurer les serveurs web
  hosts: web
  roles:
    - web_server
```

### Sur cette page

*   Introduction aux éléments Ansible
*   Résumé des éléments principaux
*   control node / managed node
*   Inventory
*   groups
*   vars : groups / hosts
*   modules / tasks et plugins
*   Les modules
*   Les tasks
*   Les plugins
*   Les rôles
*   Les playbooks