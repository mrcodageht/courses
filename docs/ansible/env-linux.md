### **Notes sur cet environnement**

**En dehors des projets, nous n'utiliserons pas notre machine mais des `VM` pour apprendre `Ansible`.**

Vous pouvez donc procéder aux installations suivantes pour les projets que nous réaliserons sur de véritables machines.

### Prérequis pour la `control node`

Pour votre `control node` (la machine qui exécute `Ansible`), vous pouvez utiliser presque n'importe quelle machine de type UNIX avec `Python 3.9` ou une version plus récente installée.

Cela inclut `Red Hat`, `Debian`, `Ubuntu`, `macOS`, les systèmes `BSD` et `Windows` avec une distribution de `Windows Subsystem for Linux` (`WSL`).

`Windows` sans `WSL` n'est pas supporté comme `control node`.

### Installation de `Python`

Ouvrez un terminal et tapez :

content\_copy

```
python3 --version
```

Ou :

content\_copy

```
python --version
```

Il faut que vous ayez au moins la version `3.9`.

Faites simplement les commandes suivantes :

content\_copy

```
sudo add-apt-repository universe && sudo apt update
```

content\_copy

```
sudo apt install python3.12
```

### Installation de pip

Vérifiez que le gestionnaire de paquets `pip` est installé :

content\_copy

```
python3 -m pip -V
```

Sinon installez-le :

content\_copy

```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py --user
```

### Installation d'`Ansible`

Installez `Ansible` avec `pip` :

content\_copy

```
python3 -m pip install --user ansible
```

*   `python3 -m pip` : utilise le module `pip` de `Python` 3 pour exécuter l'installation. `-m` permet d'exécuter des bibliothèques en tant que `scripts`.
    
*   `--user` : installe le package uniquement pour l'utilisateur courant, plutôt que pour tous les utilisateurs du système. C'est utile lorsque vous n'avez pas les droits d'administrateur ou lorsque vous souhaitez installer une version spécifique d'un `package` pour votre utilisateur.
    
*   `ansible` : c'est le nom du package que l'on souhaite installer.
    

### Installation de `argcomplete`

`argcomplete` est une bibliothèque `Python` pour l’auto-complétion pour les programmes qui utilisent le module `argparse`.

Il est compatible avec les `shells` `zsh` et `bash`.

content\_copy

```
python3 -m pip install --user argcomplete
```

Activez-le :

content\_copy

```
activate-global-python-argcomplete
```

Si vous avez une erreur de `PATH` comme par exemple :

content\_copy

```
  WARNING: The script ansible-community is installed in '/home/erwan/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
```

Modifiez votre fichier `.bashrc` :

content\_copy

```
nano ~/.bashrc
```

Attention à modifier le lien en utilisant celui donné dans l'erreur :

content\_copy

```
export PATH="/home/erwan/.local/bin:$PATH"
```

Quittez et relancez le terminal, et refaites :

content\_copy

```
activate-global-python-argcomplete
```

Il faut que si vous fassiez :

content\_copy

```
ansible 
```

Puis `tab` vous ayez de très nombreuses options. Sinon l'installation n'est pas bonne.

### Installation de `VS Code`

Pour cette formation nous utiliserons notamment `VS Code`.

Téléchargez-le [ici](https://code.visualstudio.com/).

**Dans l'onglet extensions de `VS Code`, recherchez et téléchargez l'extension `Ansible` créée par Red Hat.**

**Au même endroit recherchez et installez l'extension `Remote - SSH` créée par `Microsoft`.**

### Sur cette page

*   Notes sur cet environnement
*   Prérequis pour la control node
*   Installation de Python
*   Installation de pip
*   Installation d'Ansible
*   Installation de argcomplete
*   Installation de VS Code