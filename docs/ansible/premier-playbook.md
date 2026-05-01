### Introduction à notre premier `playbook`

Dans cette leçon, nous allons découvrir comment créer un `playbook Ansible` pour automatiser des tâches sur des nœuds gérés.

Un `playbook` est un fichier `YAML` qui contient un ensemble d'instructions qu'`Ansible` exécutera dans un ordre spécifique.

**Pour rappel :**

*   `**Playbook**` : une liste d'opérations que `Ansible` doit exécuter.
*   `**Play**` : une partie spécifique d'un `playbook`, qui contient une liste ordonnée de tâches.
*   `**Task**` : une action spécifique que `Ansible` doit exécuter.
*   `**Module**` : une unité de code que `Ansible` utilise pour accomplir une tâche.

### Créer le fichier `playbook`

Toujours sur notre `VM ansible-control` et toujours dans le dossier `ansible`, créez un fichier `playbook.yaml` dans `VS Code` :

content\_copy

```
- name: Mon premier play
  hosts: virtualmachines
  tasks:
   - name: Ping mes hôtes
     ansible.builtin.ping:

   - name: Afficher un message
     ansible.builtin.debug:
       msg: Bonjour tout le monde !
```

`ansible.builtin.ping` est le même module que celui que nous avions utilisé en ligne de commande (`-m ping`).

### Exécuter le `playbook`

Dans votre terminal, naviguez jusqu'au répertoire où se trouve votre fichier `playbook.yaml` et exécutez la commande suivante :

content\_copy

```
ansible-playbook -i inventory.yaml playbook.yaml
```

Vous aurez en sortie :

content\_copy

```
PLAY [Mon premier play] *****************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [vm01]
ok: [vm02]

TASK [Ping mes hôtes] *******************************************************************************************************************************************************************************
ok: [vm01]
ok: [vm02]

TASK [Afficher un message] **************************************************************************************************************************************************************************
ok: [vm01] => {
    "msg": "Bonjour tout le monde !"
}
ok: [vm02] => {
    "msg": "Bonjour tout le monde !"
}

PLAY RECAP ******************************************************************************************************************************************************************************************
vm01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vm02                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

### Comprendre la sortie

`**PLAY [Mon premier play]**` : indique le début de l'exécution du `playbook`.

`**TASK [Gathering Facts]**` : par défaut, `Ansible` collecte des informations sur les nœuds gérés.

`**TASK [Ping mes hôtes]**` et `**TASK [Afficher un message]**` : ce sont les tâches que vous avez définies dans votre playbook.

`**PLAY RECAP**` : un résumé des tâches exécutées sur chaque hôte.

### Sur cette page

*   Introduction à notre premier playbook
*   Créer le fichier playbook
*   Exécuter le playbook
*   Comprendre la sortie