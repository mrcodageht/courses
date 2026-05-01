### Formats d'inventaire

`Ansible` supporte différents formats d'inventaire, les plus courants étant `INI` et `YAML`.

_Le format `INI` est un format pour les fichiers de configuration créé par `Microsoft` avec le système d'exploitation `Windows` 1.0 en 1985_

Dans la formation nous utiliserons le `YAML` qui est plus clair mais nous présenterons quand même le format `INI` car il faut le connaître si vous rencontrez des configurations dans ce format.

#### Exemple d'inventaire en `INI`

content\_copy

```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

Même inventaire en `YAML`

content\_copy

```
ungrouped:
  hosts:
    mail.example.com:
webservers:
  hosts:
    foo.example.com:
    bar.example.com:
dbservers:
  hosts:
    one.example.com:
    two.example.com:
    three.example.com:
```

### Les groupes

**En général on groupe les hôtes par fonction et / ou par localisation.**

Par exemple, groupe des serveurs en Europe, groupe des serveurs de base de données etc.

#### Groupes par défaut

`Ansible` crée automatiquement deux groupes : `all`, qui contient tous les hôtes, et `ungrouped`, qui contient les hôtes qui ne sont pas dans un autre groupe.

#### Hôtes dans plusieurs groupes

Un hôte peut appartenir à plusieurs groupes, ce qui permet de classer les hôtes de différentes manières (par exemple, par application, emplacement, environnement).

Voici à quoi pourrait ressembler une architecture complète :

content\_copy

```
# Définition des serveurs web
serveurs_web:
  hosts:
    serveur_web_1:
    serveur_web_2:
    serveur_web_3:

# Définition des serveurs de base de données
serveurs_bd:
  hosts:
    serveur_bd_1:
    serveur_bd_2:

# Définition des serveurs de cache
serveurs_cache:
  hosts:
    serveur_cache_1:
    serveur_cache_2:

# Définition de l'environnement de production
production:
  hosts:
    serveur_web_1:
    serveur_bd_1:
    serveur_cache_1:

# Définition de l'environnement de test
test:
  hosts:
    serveur_web_2:
    serveur_web_3:
    serveur_bd_2:
    serveur_cache_2:

# Définition d'un groupe de serveurs nécessitant une surveillance accrue
surveillance_accrue:
  hosts:
    serveur_web_1:
    serveur_bd_1:
```

Dans cet exemple :

*   `serveur_web_1` appartient aux groupes `serveurs_web`, `production` et `surveillance_accrue`.
*   `serveur_web_2` et `serveur_web_3` appartiennent aux groupes `serveurs_web` et `test`.
*   `serveur_bd_1` appartient aux groupes `serveurs_bd`, `production` et `surveillance_accrue`.
*   `serveur_bd_2` appartient aux groupes `serveurs_bd` et `test`.
*   `serveur_cache_1` appartient aux groupes `serveurs_cache` et `production`.
*   `serveur_cache_2` appartient aux groupes `serveurs_cache` et `test`.

Ainsi, vous pouvez voir que chaque serveur peut appartenir à plusieurs groupes selon son rôle et son environnement, facilitant la gestion et l'automatisation avec `Ansible`.

#### Relations parent / enfant entre les Groupes

Vous pouvez créer des relations entre les groupes pour organiser votre inventaire de manière hiérarchique. 

Dans le format `YAML`, il faut utiliser l'entrée `children:`.

content\_copy

```
paris:
  children:
    webservers:
    dbservers:
france:
  children:
    paris:
    lyon:
prod:
  children:
    france:
test:
  children:
    europe:
```

#### Ajout de plages d'hôtes

Vous pouvez ajouter des plages d'hôtes au lieu de les lister un par un, ce qui est utile pour les hôtes avec des noms suivant un motif similaire.

content\_copy

```
web:
  hosts:
    web[01:05].example.com:
db:
  hosts:
    db[01:05].example.com:
cache:
  hosts:
    cache[01:05].example.com:
search:
  hosts:
    search[01:05].example.com:
app:
  hosts:
    app[01:05].example.com:
```

#### Organisation de l'inventaire dans un répertoire

Vous pouvez organiser votre inventaire en répertoires, ce qui facilite la gestion de sources d'inventaire multiples.

Voici à quoi pourrait ressembler une architecture complète organisée en répertoire :

content\_copy

```
inventaire/
│
├── production/                # Dossier pour l'environnement de production
│   ├── serveurs_web.yml       # Inventaire des serveurs web en production
│   ├── serveurs_bd.yml        # Inventaire des serveurs de base de données en production
│   └── group_vars/           # Variables spécifiques à l'environnement de production
│       ├── serveurs_web.yml   # Variables pour les serveurs web en production
│       └── serveurs_bd.yml    # Variables pour les serveurs de base de données en production
│
├── test/                      # Dossier pour l'environnement de test
│   ├── serveurs_web.yml       # Inventaire des serveurs web en test
│   ├── serveurs_bd.yml        # Inventaire des serveurs de base de données en test
│   └── group_vars/           # Variables spécifiques à l'environnement de test
│       ├── serveurs_web.yml   # Variables pour les serveurs web en test
│       └── serveurs_bd.yml    # Variables pour les serveurs de base de données en test
│
└── scripts_inventaire/        # Scripts d'inventaire dynamique
    ├── aws_ec2.py             # Script d'inventaire pour les instances EC2 AWS
    └── vmware_vm_inventory.py # Script d'inventaire pour les VMs VMware
```

Et voici un exemple de contenu d'un de ces fichiers, par exemple le fichier `inventaire/production/serveurs_web.yml` :

content\_copy

```
serveurs_web:
  hosts:
    web_prod_1:
      ansible_host: 192.168.1.101
    web_prod_2:
      ansible_host: 192.168.1.102
```

Il suffirait ensuite, pour déployer l'environnement de production de faire :

content\_copy

```
ansible-playbook -i inventaire/production deploy.yml
```

### Gestion de l'ordre de chargement de l'inventaire

L'ordre de chargement des sources d'inventaire est important, en particulier lorsque vous définissez des relations parent/enfant entre les groupes.

`Ansible` charge les sources d'inventaire en ordre `ASCII` selon les noms de fichier. Si les groupes parents sont chargés avant les groupes enfants, une erreur peut survenir.

### Sur cette page

*   Formats d'inventaire
*   Exemple d'inventaire en INI
*   Les groupes
*   Groupes par défaut
*   Hôtes dans plusieurs groupes
*   Relations parent / enfant entre les Groupes
*   Ajout de plages d'hôtes
*   Organisation de l'inventaire dans un répertoire
*   Gestion de l'ordre de chargement de l'inventaire