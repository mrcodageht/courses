### Sur cette page

*   [Ansible inventory ](#ansible-inventory)
*   [Principales commandes et options](#principales-commandes-et-options-)

### `ansible-inventory`

La commande `ansible-inventory` est un outil en ligne de commande fourni avec `Ansible`, qui vous permet de travailler avec les inventaires `Ansible`.

Il peut être utilisé pour afficher et manipuler les inventaires, ainsi que pour convertir entre différents formats d'inventaire.

### Principales commandes et options :

*   **`--list`** : affiche l'inventaire sous forme de JSON. Cela peut être utile pour voir la structure complète de l'inventaire, y compris les hôtes, les groupes, et toutes les variables associées.
    


```json
{
    "_meta": {
        "hostvars": {
            "managed-node1": {
                "ansible_host": "192.168.56.11",
                "ansible_ssh_private_key_file": "/vagrant/.vagrant/machines/managed-node1/virtualbox/private_key",
                "ansible_user": "vagrant",
                "common_variable": "Je suis une variable commune à tous les hôtes",
                "group_variable": "Je suis une variable du groupe managed_nodes",
                "host_variable": "Je suis une variable spécifique à managed-node1"
            },
            "managed-node2": {
                "ansible_host": "192.168.56.12",
                "ansible_ssh_private_key_file": "/vagrant/.vagrant/machines/managed-node2/virtualbox/private_key",
                "ansible_user": "vagrant",
                "common_variable": "Je suis une variable commune à tous les hôtes",
                "group_variable": "Je suis une variable du groupe managed_nodes",
                "host_variable": "Je suis une variable spécifique à managed-node2"
            }
        }
    },
    "all": {
        "children": [
            "ungrouped",
            "managed_nodes"
        ]
    },
    "managed_nodes": {
        "hosts": [
            "managed-node1",
            "managed-node2"
        ]
    }
}
```

*   **`--graph`** : affiche un graphique de l'inventaire, montrant la hiérarchie des groupes et les membres de chaque groupe.
    


```
@all:
  |--@ungrouped:
  |--@managed_nodes:
  |  |--managed-node1
  |  |--managed-node2
```

*   **`--host`** : prend en argument un nom d'hôte et affiche toutes les variables associées à cet hôte en format `JSON`.
    


```bash
ansible-inventory -i inventory/ --host managed-node1
```


```json
{
    "ansible_host": "192.168.56.11",
    "ansible_ssh_private_key_file": "/vagrant/.vagrant/machines/managed-node1/virtualbox/private_key",
    "ansible_user": "vagrant",
    "common_variable": "Je suis une variable commune à tous les hôtes",
    "group_variable": "Je suis une variable du groupe managed_nodes",
    "host_variable": "Je suis une variable spécifique à managed-node1"
}
```

*   **`-i`** ou **`--inventory`** : Spécifie le chemin d'accès au fichier d'inventaire.
    
*   **`--yaml`** : utilisé avec `--list` pour afficher l'inventaire au format YAML plutôt qu'en JSON.
    


```yml
all:
  children:
    managed_nodes:
      hosts:
        managed-node1:
          ansible_host: 192.168.56.11
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node1/virtualbox/private_key
          ansible_user: vagrant
          common_variable: Je suis une variable commune à tous les hôtes
          group_variable: Je suis une variable du groupe managed_nodes
          host_variable: Je suis une variable spécifique à managed-node1
        managed-node2:
          ansible_host: 192.168.56.12
          ansible_ssh_private_key_file: /vagrant/.vagrant/machines/managed-node2/virtualbox/private_key
          ansible_user: vagrant
          common_variable: Je suis une variable commune à tous les hôtes
          group_variable: Je suis une variable du groupe managed_nodes
          host_variable: Je suis une variable spécifique à managed-node2
```

