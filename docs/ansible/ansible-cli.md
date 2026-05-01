### Le `CLI Ansible`

Même si on utilise le plus souvent des fichiers de configuration qui permettent de mieux s'organiser, il peut parfois être utile d'utiliser le `CLI` qui est très puissant.

Vous retrouverez aussi l'expression "_`Ansible ad hoc commands`_" dans la documentation sont les commandes du `CLI Ansible`.

Voici toutes les options du `CLI` :


```bash
usage: ansible [-h] [--version] [-v] [-b] [--become-method BECOME_METHOD]
            [--become-user BECOME_USER]
            [-K | --become-password-file BECOME_PASSWORD_FILE]
            [-i INVENTORY] [--list-hosts] [-l SUBSET] [-P POLL_INTERVAL]
            [-B SECONDS] [-o] [-t TREE] [--private-key PRIVATE_KEY_FILE]
            [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
            [--ssh-common-args SSH_COMMON_ARGS]
            [--sftp-extra-args SFTP_EXTRA_ARGS]
            [--scp-extra-args SCP_EXTRA_ARGS]
            [--ssh-extra-args SSH_EXTRA_ARGS]
            [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [-C]
            [-D] [-e EXTRA_VARS] [--vault-id VAULT_IDS]
            [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES]
            [-f FORKS] [-M MODULE_PATH] [--playbook-dir BASEDIR]
            [--task-timeout TASK_TIMEOUT] [-a MODULE_ARGS] [-m MODULE_NAME]
            pattern
```

Nous ne les verrons pas toutes car cela n'a aucun intérêt, mais verrons dans cette leçon des commandes usuelles dont vous pourriez avoir besoin.

Nous expliquerons également le détail des modules plus tard, l'objectif est vraiment ici de voir les possibilités du `CLI`.

### Options les plus importantes

Voici les options principales du `CLI` `ansible` :

#### `-i INVENTORY`

Spécifie l'inventaire à utiliser pour la commande. L'inventaire peut être un fichier, un dossier ou même une source dynamique comme nous le verrons.

#### `-m MODULE_NAME`

Définit le module que `ansible` doit utiliser. Par exemple, pour utiliser le module `ping`, on peut utiliser `-m ping`.

#### `-a MODULE_ARGS`

Arguments à passer au module. Par exemple, dans un module de gestion de packages comme `apt`, on peut utiliser `-a "name=nginx state=present"`.

#### `-u REMOTE_USER`

Spécifie l'utilisateur distant à utiliser pour la connexion `SSH`. Si cette option n'est pas utilisée, `ansible` utilise l'utilisateur courant comme utilisateur distant.

#### `-b`

Active le mode `become`, qui permet à l'utilisateur d'obtenir des privilèges d'administrateur. Équivalent de `sudo` en termes d'utilité.

#### `--become-method BECOME_METHOD`

Spécifie la méthode à utiliser pour devenir un autre utilisateur. Par défaut, cette valeur est `sudo`.

#### `--become-user BECOME_USER`

Définit l'utilisateur que vous voulez devenir une fois connecté. Par défaut, il s'agit de `root`.

#### `--private-key PRIVATE_KEY_FILE`

Spécifie un fichier de clé privée SSH à utiliser pour la connexion. Cette option est utile si vous utilisez une clé autre que la clé par défaut (`~/.ssh/id_rsa`).

### Commandes les plus usuelles

Testez toutes ces commandes sur notre `VM ansible-control`.

#### Obtenir la version d'`Ansible`


```bash
ansible --version
```

#### Tester la connectivité à des hôtes


```bash
ansible all -i inventory.yaml -m ping 
```

Teste la connectivité sur tous les hôtes (`all`) de l'inventaire.

#### **Exécuter une commande `shell` sur les hôtes**


```bash
ansible all -i inventory.yaml -m shell -a "ls -lah /tmp"
```

#### Mettre à jour des packages


```bash
ansible all -i inventory.yaml -m apt -a "update_cache=yes" --become
```

#### **Installer un `package`**


```bash
ansible all -i inventory.yaml -m apt -a "name=nginx state=present" --become
```

#### **Désinstaller un `package`**


```bash
ansible all -i inventory.yaml -m apt -a "name=nginx state=absent" --become
```

#### **Redémarrer un service**


```bash
ansible all -i inventory.yaml -m service -a "name=nginx state=restarted" --become
```

#### **Arrêter un service**


```bash
ansible all -i inventory.yaml -m service -a "name=nginx state=stopped" --become
```

#### **Copier un fichier sur les hôtes**


```bash
ansible all -i inventory.yaml -m copy -a "src=/path/to/local/file dest=/path/to/remote/file" --become
```

#### **Créer un répertoire sur les hôtes**


```bash
ansible all -i inventory.yaml -m file -a "path=/path/to/directory state=directory" --become
```

#### **Supprimer un fichier sur les hôtes**


```bash
ansible all -i inventory.yaml -m file -a "path=/path/to/file state=absent" --become
```

#### **Afficher des faits sur les hôtes**


```bash
ansible all -i inventory.yaml -m setup
```

#### **Générer une clé `SSH` et la copier sur les hôtes**


```bash
ssh-keygen ansible all -i inventory.yaml -m authorized_key -a "user=username key={{ lookup('file', '/path/to/public/key') }}" --become
```

#### **Lister les hôtes dans un groupe d'inventaire**


```bash
ansible-inventory -i inventory.yaml --list
```

#### **Créer un utilisateur**


```bash
ansible all -i inventory.yaml -m user -a "name=username state=present" --become
```

#### **Changer le mot de passe d'un utilisateur**


```bash
ansible all -i inventory.yaml -m user -a "name=username password={{ 'mypassword' | password_hash('sha512') }}" --become
```

### Sur cette page

*   Le CLI Ansible
*   Options les plus importantes
*   \-i INVENTORY
*   \-m MODULE\_NAME
*   \-a MODULE\_ARGS
*   \-u REMOTE\_USER
*   \-b
*   \--become-method BECOME\_METHOD
*   \--become-user BECOME\_USER
*   \--private-key PRIVATE\_KEY\_FILE
*   Commandes les plus usuelles
*   Obtenir la version d'Ansible
*   Tester la connectivité à des hôtes
*   Exécuter une commande shell sur les hôtes
*   Mettre à jour des packages
*   Installer un package
*   Désinstaller un package
*   Redémarrer un service
*   Arrêter un service
*   Copier un fichier sur les hôtes
*   Créer un répertoire sur les hôtes
*   Supprimer un fichier sur les hôtes
*   Afficher des faits sur les hôtes
*   Générer une clé SSH et la copier sur les hôtes
*   Lister les hôtes dans un groupe d'inventaire
*   Créer un utilisateur
*   Changer le mot de passe d'un utilisateur