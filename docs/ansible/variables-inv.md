### Que sont les variables ?

Les variables peuvent être définies pour des hôtes spécifiques ou des groupes entiers, et peuvent être organisées de différentes manières pour une gestion plus efficace.

#### Ajout de variables à l'inventaire

Vous pouvez ajouter des variables directement dans le fichier d'inventaire principal pour chaque hôte ou groupe en procédant de cette manière :

content\_copy

```
paris:
  hosts:
    host1:
      http_port: 80
      maxRequestsPerChild: 808
    host2:
      http_port: 303
      maxRequestsPerChild: 909
```

#### Variables pour plusieurs hôtes : les variables de groupe

Vous pouvez assigner une variable à tous les hôtes d'un groupe.

content\_copy

```
paris:
  vars:
    email_server: email.paris.example.com
```

#### Héritage de variables: variables de groupe pour des groupes de groupes

Vous pouvez appliquer des variables à des groupes parents ainsi qu'à des groupes enfants.

content\_copy

```
france:
  children:
    paris:
    lyon:
  vars:
    email_server: email.france.example.com
```

#### Syntaxe de la définition des variables

Vous pouvez définir simplement un nom et une valeur :

content\_copy

```
clé: valeur
```

**Listes**

Les variables de liste contiennent plusieurs valeurs. Vous pouvez définir une liste avec la syntaxe `YAML` suivante :

content\_copy

```
regions:
  - northeast
  - southeast
  - midwest
```

Pour lire les variables qui contiennent des listes vous pouvez faire :

content\_copy

```
- ansible.builtin.debug:
    msg: "The first region is {{ regions[0] }}"
```

**Dictionnaires**

Les dictionnaires stockent les données sous forme de paires clé-valeur.

content\_copy

```
database:
  host: dbserver
  port: 5432
```

Pour accéder à une clé :

content\_copy

```
- ansible.builtin.debug:
    msg: "Database port is {{ database['port'] }}"
```

### Portée des variables

#### Les variables globales

Les variables globales sont configurées à travers les fichiers de configuration d'Ansible, les variables d'environnement, ou directement via la ligne de commande lors de l'exécution d'un `playbook`.

Ces variables sont accessibles depuis n'importe quel endroit dans vos `playbooks`. Elles sont utiles pour définir des configurations qui doivent être cohérentes à travers tous les hôtes et toutes les tâches, comme les paramètres de connexion ou les chemins de répertoires de base.

Vous pouvez par exemple créer un fichier `group_vars/all.yml` :

content\_copy

```
# group_vars/all.yml
api_server: "https://restapi.fr"
```

Ce fichier contient des variables qui sont automatiquement appliquées à tous les hôtes de votre inventaire, rendant `api_server` disponible globalement.

content\_copy

```
- name: Accéder à la configuration globale du serveur API
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Afficher l'adresse du serveur API
      ansible.builtin.debug:
        msg: "L'adresse du serveur API est {{ api_server }}"

    - name: Utiliser le serveur API dans une tâche
      uri:
        url: "{{ api_server }}/api/recipes"
        method: GET
        return_content: yes
      register: reponse

    - name: Afficher la réponse du serveur API
      ansible.builtin.debug:
        msg: "Le serveur API a répondu avec : {{ reponse.content }}"
 
```

Cet exemple est testable sur notre `API` `Dyma`, `restapi.fr`.

Vous pouvez définir des variables non seulement pour tous les hôtes via `group_vars/all`, mais également pour des groupes spécifiques en utilisant des dossiers et fichiers dédiés sous `group_vars`.

Par exemple, pour restreindre ces variables globales au groupe `webservers` :

content\_copy

```
# group_vars/webservers.yml
http_port: 80
max_clients: 200
```

Vous pouvez également définir des variables directement en ligne de commande lors du lancement d'un `playbook`, ce qui est utile pour passer des valeurs dynamiques ou des secrets sans les écrire dans un fichier.

content\_copy

```
ansible-playbook playbook.yml -e "api_key=12345 secret_key=abcde"
```

#### Au niveau du `play`

Les variables sont définies dans la section `vars` du `play`. 

Les variables définies dans un `play` sont **locales à ce `play` (leur portée est restreinte)**. Cela signifie qu'elles ne sont accessibles que pour les tâches exécutées dans le cadre de ce `play`. Elles ne sont pas disponibles pour d'autres `plays` dans le même `playbook`, ce qui aide à isoler les configurations et à réduire les risques de conflits entre variables.

À l'intérieur du `play`, ces variables peuvent être utilisées par toutes les tâches.

Par exemple, si vous définissez une variable `http_port`, vous pouvez l'utiliser dans n'importe quelle tâche de ce `play` pour configurer un serveur web, ouvrir un port spécifique dans les règles de pare-feu, etc.

content\_copy

```
- hosts: webservers
  vars:
    http_port: 80

  tasks:
    - name: Configure http port for web server
      ansible.builtin.template:
        src: templates/httpd.conf.j2
        dest: /etc/httpd/conf/httpd.conf
        mode: '0644'

    - name: Open HTTP port in firewall
      ansible.builtin.firewalld:
        port: "{{ http_port }}/tcp"
        permanent: true
        state: enabled
```

Dans un `playbook`, **vous pouvez inclure des fichiers de variables externe** pour structurer votre gestion des variables avec `vars_files`.

content\_copy

```
- hosts: all
  vars_files:
    - secrets.yml
    - more_vars.yml
  tasks:
    - debug:
        msg: "The secret is {{ secret_key }}"
```

#### Les variables d'hôte

Les variables d'hôte sont des variables spécifiques à un hôte individuel, utilisées pour gérer les configurations et les comportements qui varient d'un hôte à l'autre. Elles sont particulièrement utiles pour définir des paramètres uniques à chaque machine ou serveur dans votre infrastructure.

Les variables d'hôte ont une portée limitée à l'hôte pour lequel elles sont définies. Cela signifie que chaque hôte peut avoir ses propres valeurs spécifiques pour des variables qui ne sont pas partagées avec d'autres hôtes, même s'ils sont dans le même groupe ou exécutent le même `playbook`.

**Vous pouvez créer un fichier sous le répertoire `host_vars` portant le nom de l'hôte. Les variables définies dans ce fichier seront appliquées uniquement à cet hôte spécifique.**

content\_copy

```
├── host_vars
│   ├── hostname1.yml
│   └── hostname2.yml
```

Avec par exemple dans `host_vars/hostname1.yml` :

content\_copy

```
ansible_user: admin
ansible_ssh_private_key_file: /path/to/private/key
```

Vous pouvez définir des variables d'hôte directement dans votre fichier d'inventaire (sous forme `INI` ou `YAML`).

content\_copy

```
all:
  hosts:
    hostname1:
      http_port: 80
      max_clients: 100
    hostname2:
      http_port: 8080
      max_clients: 150
```

Les variables d'hôte peuvent être passées à `Ansible` en ligne de commande avec l'option `-e` (`--extra-vars`) lors de l'exécution d'un `playbook`.

content\_copy

```
ansible-playbook site.yml -i inventory -e "hostname1_http_port=8081"
```

### Organisation des variables

Il est recommandé de stocker les variables d'hôte et de groupe dans des fichiers séparés pour une meilleure organisation.

**Avec `Ansible` le nom des dossier est important car `Ansible` va rechercher les dossiers avec des noms spécifiques.**

**`Ansible` va automatiquement détecter les répertoires `group_vars` et `host_vars` aussi leur nom et leur emplacement sont importants.**

content\_copy

```
/chemin/vers/inventaire/ansible/
  group_vars/
    paris.yaml
  host_vars/
    host1.yaml
```

**Pour `ansible-playbook`, vous devez ajouter les répertoires group\_vars/ et host\_vars/ à votre répertoire `playbook`.**

Les autres commandes `Ansible` (par exemple, `ansible`, `ansible-console`, etc.) ne chercheront que `group_vars/` et `host_vars/` dans le répertoire `inventory`.

Si vous souhaitez que d'autres commandes chargent les variables de groupe et d'hôte à partir d'un répertoire `playbook`, vous devez fournir l'option `--playbook-dir` sur la ligne de commande.

Si vous chargez des fichiers d'inventaire à partir du répertoire `playbook` et du répertoire `inventory`, les variables du répertoire `playbook` auront la priorité sur les variables définies dans le répertoire `inventory`.

### Exemple sur nos VMs pour les groupes et les variables

Voici un petit exemple que vous pouvez tester avec notre configuration de trois VMs.

#### Création ou modification de l'inventaire

Si vous ne l'avez pas déjà fait, créez un fichier nommé `inventory.yaml` dans la VM `ansible-control` à ce chemin `/home/vagrant/ansible/inventory.yaml` :

content\_copy

```
 all:
  children:
    managed_nodes:
      hosts:
        managed-node1:
          ansible_host: 192.168.56.11
          ansible_user: vagrant
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node1/virtualbox/private_key
        managed-node2:
          ansible_host: 192.168.56.12
          ansible_user: vagrant
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node2/virtualbox/private_key
      vars:
        example_variable: "Je suis une variable de groupe"
```

Dans cet inventaire, nous avons défini un groupe `managed_nodes` qui contient nos deux nœuds gérés.

Pour chaque nœud, nous spécifions l'adresse IP, l'utilisateur et le chemin d'accès à la clé privée SSH pour la connexion. Nous avons également défini une variable de groupe `example_variable`.

#### Création ou modification du `playbook`

Si vous ne l'avez pas déjà fait, créez un fichier nommé `playbook.yaml` dans la VM `ansible-control` à ce chemin `/home/vagrant/ansible/playbook.yaml` :

content\_copy

```
- name: Exemple de playbook
  hosts: managed_nodes
  tasks:
    - name: Afficher une variable de groupe
      debug:
        msg: "La variable de groupe est : {{ example_variable }}"
```

_Nous verrons bien sûr les `playbooks` en détail dans un chapitre dédié._

Ce `playbook` contient une seule tâche qui affiche la valeur de la variable de groupe `example_variable`.

Toujours dans la VM `ansible-control` :

content\_copy

```
ansible-playbook -i inventory.yaml playbook.yaml
```

### Exemple plus complexe

Pour complexifier l'exemple et mieux comprendre tout ce que nous avons vu jusqu'à maintenant, nous allons structurer les fichiers et dossiers selon l'architecture recommandée pour un projet `Ansible` et utiliser plusieurs variables d'hôtes et de groupes.

Créez cette structure toujours sur `ansible-control` :

content\_copy

```
ansible/
├── group_vars/
│   ├── all.yaml
│   └── managed_nodes.yaml
├── host_vars/
│   ├── managed-node1.yaml
│   └── managed-node2.yaml
├── inventory/
│   └── hosts.yaml
└── playbook.yaml
```

#### Définition de l'inventaire (`inventory/hosts.yaml`)

L'inventaire ne change pas sauf que nous ne mettons pas de variable ici, comme recommandé :

content\_copy

```
 all:
  children:
    managed_nodes:
      hosts:
        managed-node1:
          ansible_host: 192.168.56.11
          ansible_user: vagrant
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node1/virtualbox/private_key
        managed-node2:
          ansible_host: 192.168.56.12
          ansible_user: vagrant
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node2/virtualbox/private_key
```

#### Définition des variables de groupe

*   `group_vars/all.yaml` :

content\_copy

```
common_variable: "Je suis une variable commune à tous les hôtes"
```

*   `group_vars/managed_nodes.yaml` :

content\_copy

```
group_variable: "Je suis une variable du groupe managed_nodes"
```

#### Définition des variables d'hôte

*   `host_vars/managed-node1.yaml` :

content\_copy

```
host_variable: "Je suis une variable spécifique à managed-node1"
```

*   `host_vars/managed-node2.yaml` :

content\_copy

```
host_variable: "Je suis une variable spécifique à managed-node2"
```

#### Création du playbook (`anible/playbook.yaml`)

content\_copy

```
- name: Exemple de playbook
  hosts: managed_nodes
  tasks:
    - name: Afficher les variables
      debug:
        msg: |
          Variable commune : {{ common_variable }}
          Variable de groupe : {{ group_variable }}
          Variable d'hôte : {{ host_variable }}
```

Exécutez :

content\_copy

```
ansible-playbook -i inventory/hosts.yaml playbook.yaml
```

### Sur cette page

*   Que sont les variables ?
*   Ajout de variables à l'inventaire
*   Variables pour plusieurs hôtes : les variables de groupe
*   Héritage de variables: variables de groupe pour des groupes de groupes
*   Syntaxe de la définition des variables
*   Portée des variables
*   Les variables globales
*   Au niveau du play
*   Les variables d'hôte
*   Organisation des variables
*   Exemple sur nos VMs pour les groupes et les variables
*   Création ou modification de l'inventaire
*   Création ou modification du playbook
*   Exemple plus complexe
*   Définition de l'inventaire (inventory/hosts.yaml)
*   Définition des variables de groupe
*   Définition des variables d'hôte
*   Création du playbook (anible/playbook.yaml)