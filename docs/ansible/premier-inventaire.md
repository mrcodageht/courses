### Création de l'inventaire

Créez le fichier `/home/vagrant/ansible/inventory.yaml` :



```yml
virtualmachines:
  hosts:
    vm01:
      ansible_host: 192.168.56.11
    vm02:
      ansible_host: 192.168.56.12
```

Nous verrons bien sûr les inventaires très en détail. Mais expliquons rapidement ce que cela signifie :

*   **`virtualmachines`** : c'est le nom du groupe pour nos hôtes. Nous pouvons utiliser ce groupe lorsque nous exécutons des commandes `ansible` ou des `playbooks` en utilisant ce nom de groupe comme cible.
    
*   **`hosts`** : ceci indique que vous allez lister les hôtes (ou machines) qui appartiennent à ce groupe.
    
    *   **`vm01:` et `vm02`** : ce sont les alias ou noms symboliques pour vos machines hôtes. Vous pouvez utiliser ces alias dans vos commandes `ansible` ou `playbooks` pour cibler ces machines spécifiques.
        
    *   **`ansible_host: 192.168.56.11` et `ansible_host: 192.168.56.12`** : ces clés spécifient les adresses `IP` réelles de vos hôtes `vm01` et `vm02`, respectivement. `Ansible` utilisera ces adresses `IP` pour se connecter aux machines lors de l'exécution de tâches.
        

### Première utilisation d'un module

Dans la machine `ansible-control`, dans le terminal de `VS Code` entrez :



```bash
ansible virtualmachines -m ping -i inventory.yaml
```

Cette commande `ansible` utilise le module `ping` pour vérifier si les hôtes spécifiés dans le fichier d'inventaire `inventory.yaml` sont accessibles.

Voici la décomposition de la commande :

*   **`ansible`** : c'est le nom de la commande pour exécuter des opérations `Ansible` non structurées.
    
*   **`virtualmachines`** : c'est le nom du groupe d'hôtes que vous souhaitez cibler. Ce nom doit correspondre à celui spécifié dans votre fichier d'inventaire (`inventory.yaml` dans cet exemple).
    
*   **`-m ping`** : ici, `-m` signifie "module", et `ping` est le module `Ansible` que vous souhaitez exécuter. Le module `ping` sert à vérifier que les hôtes sont en ligne et accessibles via `SSH`. Il ne réalise pas un véritable "ping", mais il tente une connexion `SSH` et renvoie un "pong" si la connexion est réussie.
    
*   **`-i inventory.yaml`** : `-i` permet de spécifier le fichier d'inventaire à utiliser. Dans cet exemple, `inventory.yaml` est le fichier qui contient les informations sur les hôtes que vous souhaitez cibler.
    

Lorsque cette commande est exécutée, `Ansible` lit le fichier `inventory.yaml`, trouve le groupe `virtualmachines`, et tente de se connecter à chaque hôte de ce groupe en utilisant `SSH`. Si la connexion est réussie, un "pong" est renvoyé, indiquant que l'hôte est accessible.

La commande retourne :



```bash
The authenticity of host '192.168.56.11 (192.168.56.11)' can't be established.
ECDSA key fingerprint is SHA256:zThP3/J6P3sskUnPF87ySuDtFZrlKrZ5DuGtQZxf76o.
The authenticity of host '192.168.56.12 (192.168.56.12)' can't be established.
ECDSA key fingerprint is SHA256:GV2ixyZqKNjPDB/7X5Z6N4L3RLn0LOc1LJHoK3kzzkU.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

**Faites `CTRL + c` pour quitter.**

Ce message est un avertissement de sécurité standard qui s'affiche lors de la première tentative de connexion à un serveur via `SSH`.

L'empreinte digitale de la clé est présentée pour que vous puissiez vérifier l'authenticité du serveur avant de continuer. En pratique, ce message vous demande de confirmer que vous faites confiance à l'hôte et **que vous souhaitez ajouter sa clé publique à la liste des hôtes connus (`~/.ssh/known_hosts`)** sur votre système.

Il est possible de ne pas utiliser cette mesure de sécurité en utilisant soit dans les options de `Ansible`, soit dans la configuration des hôtes `SSH` l'option `StrictHostKeyChecking`, cependant cela revient à s'exposer aux attaques man-in-the-middle. Nous détaillerons à la fin de la leçon.

#### Ajout des `VMs` en hôtes connus

**Ajoutons les clés publiques des `VMs managed-node1` et `managed-node2` sur la `node ansible-control` dans `~/.ssh/known_hosts` :**



```bash
ssh-keyscan 192.168.56.11 192.168.56.12 >> ~/.ssh/known_hosts
```

Affichez le contenu de `known_hosts` :



```bash
cat ~/.ssh/known_hosts
```

Vous aurez quelque chose comme :



```text
|1|6oSxo0xghTJOKoISIg58iZQ0VhY=|h11+NQI+mTMDhD0TCjeWqr31HGU= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFN/4+pe2IY5GUYdhAOnH1qGo6C6BUqEFrqE2pew14g+uc0EyuADErHlPMZbKwRtxahdUszGCOQNcNB1fRES7v0=
192.168.56.11 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBE1sL/Aro5EMLI0j0eNwEVV5ejDmXGPzsOIBqHSNmpXi6jNvrHgcLP5G0NGlDpIE6M5GVlLTUIpAeipX4V52TJD/axx83zsQPvL1K8PJNhT0gvFbpFBC2OFhhxqy5vogjxDNZVHgrH2HzGa/T7sc+NAHA/83hUBuLEa9Xq3z/qsi8O/1ZMFnXY59SMC/83+72NmHWLAtI71E2gpdOG/K6BnTyKx9T9vv2kdYa3toVBFCmVruzMBZRRm8t9sFqQfW7h/KOmLzM5bYcWvlPh0k2EENTQSe9k/tiEb7uOgearaHVQ8GxD5byDLypjCALo8wPVGc7R0VRrc6NC3TmqJyRcpdBt3JkSffm1uEryz6pmcEY2fZyOW5ngRrbg3I1nVYR/j9QbelnzfTl1D0mUoEanK5q0msIPg3wiwgRl/nQrZquIHj0DmIW6WUEmvQ5xHJK4yZXSxzqmd10JoCmMKqWqCl1tZr7JnPhOOWVjz/+6luq98J9RTyfcOaFALAmUs0=
192.168.56.11 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFN/4+pe2IY5GUYdhAOnH1qGo6C6BUqEFrqE2pew14g+uc0EyuADErHlPMZbKwRtxahdUszGCOQNcNB1fRES7v0=
192.168.56.11 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIClhnFlOziLmq9b9CWMBhrNf90wqrM/+07sV3542Jv6v
192.168.56.12 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQpJfcsvijfHeCLahHshUb6dUhp9bve2m/y9SyeswHP0z8LibDh6B+XYpGXhB0lcQG7krlHyH3q1JyDhgVqX0WGZJ07wR6W0zxrP+nwq7D/DjaLGrZ2SkocKY5eYWlGMgFEznREr64AKTwmZ+gKnonNm9lQDqRSMiS7CwLx8wU1EGVj1ez7MePaYf7S1c/G80XCLBcvm8lQz+1KIVg2UQweHvQOtUymBLrvyQiUYIJQJ5tOiST1ylZoq2ybp1NMwhZyBUfLsU+ZhTXKXk4vvLVIc9jnIDSXKvrmFWSDyRaJOe/7YjSJJxtG9SUqgLH4o0SyF3H9uMyVQ5SlVDth571LzIM0vxHmtVKEY3rumXHp77hXhBSBoJWs+XgdGxuxC+XjQRm4f3UxWPP8RRcOM66eCOmJ+tfl/ARw82tVhjy9HhxUjxvVPEBkfjQQxBLlWjGoNFBEklnBKbvttG84ICelKWj0sIucs+uwW+uzBL6lWANEnekt5QG68SA7YQDRuk=
192.168.56.12 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEz2QdVjy/6n1lYYhV2Xt/J6tCGkcHj6rPFt5EeGPIzc7/dZlyuLeTpGWwV5VgA94HUrn02K0z9+D/vwNtKeygs=
192.168.56.12 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP83a65rQVUkRqmzpzz5AotYTjBpsg11kfyEW9M/MHeg
```

Par exemple :

**192.168.56.11 ecdsa-sha2-nistp256 AAAAE2V...** :  indique que l'adresse `IP 192.168.56.11` a une clé `ECDSA` associée.

#### Création d'une paire de clés et ajout de la clé publique aux `managed-nodes`

Retapons la commande :



```bash
ansible virtualmachines -m ping -i inventory.yaml
```

Cette fois-ci nous avons :



```bash
vm01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
vm02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

Notre `VM ansible-control` peut se connecter aux autres `VMs` grâce à la clé `/home/vagrant/.ssh/id_ed25519` que nous avons générée sur cette VM et dont la clé publique correspondante a été ajoutée sur les deux autres VMs dans `authorized_keys`.

### Notes sur les attaques `MITM SSH`

Une attaque "`man-in-the-middle`" (`MITM`) est une forme d'attaque active où un attaquant intercepte, relaie ou altère la communication entre deux parties sans que celles-ci ne se rendent compte que le lien entre elles a été compromis.

Dans le contexte de `SSH`, voici comment cela pourrait se dérouler :

1.  **Interception de la connexion initiale** : l'attaquant se place entre vous (le client) et le serveur `SSH` auquel vous essayez de vous connecter. Le serveur pense qu'il parle au client et vice versa.
    
2.  **Fausse identification** : lorsque le client demande la clé publique du serveur pour établir une connexion sécurisée, l'attaquant envoie sa propre clé publique au lieu de celle du serveur.
    
3.  **Établissement de deux connexions séparées** : l'attaquant établit une connexion sécurisée avec le client en utilisant sa propre clé, et une autre connexion sécurisée avec le serveur en utilisant la clé du serveur. Le client pense qu'il communique de manière sécurisée avec le serveur, mais en réalité, toutes les communications passent par l'attaquant.
    

Si vous ne vérifiez pas l'empreinte digitale de la clé publique du serveur :

*   Vous ne pourrez pas distinguer une clé légitime d'une clé fournie par un attaquant.
*   L'attaquant pourra voir, intercepter et même modifier les données qui sont envoyées entre le client et le serveur.
*   Les identifiants, tels que les mots de passe et les clés privées, peuvent être volés.

_Pour se protéger contre ces types d'attaques, il est important de vérifier l'empreinte digitale de la clé publique du serveur dans un contexte professionnel lors de la première connexion. Cela permet de s'assurer que vous vous connectez bien au serveur que vous pensez atteindre, établissant ainsi une forme de confiance pour les connexions futures._

### Sur cette page

*   Création de l'inventaire
*   Première utilisation d'un module
*   Ajout des VMs en hôtes connus
*   Création d'une paire de clés et ajout de la clé publique aux managed-nodes
*   Notes sur les attaques MITM SSH