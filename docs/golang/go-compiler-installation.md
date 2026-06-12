### Téléchargement et installation de `Go`

La source unique et fiable pour le téléchargement est le site officiel du projet `Go`. Cela garantit que vous obtenez une version authentique et sécurisée.

**Page de téléchargement officielle :** [**https://go.dev/dl/**](https://go.dev/dl/)

Sur cette page, choisissez le paquet correspondant à votre système d'exploitation et à votre architecture matérielle (la plupart des ordinateurs modernes sont en `amd64` pour `Intel/AMD` ou `arm64` pour `Apple Silicon`/autres).

### `**Windows**`

**Téléchargez l'installeur `.msi`**.

**Exécutez le fichier téléchargé**. L'assistant d'installation vous guidera à travers les étapes, qui sont très simples.

Par défaut, `Go` s'installe dans `C:\Program Files\Go`. L'avantage principal de cette méthode est que **l'installeur configure automatiquement la variable d'environnement `PATH` de votre système**. Vous n'avez aucune configuration manuelle à effectuer.

Une fois l'installation terminée, redémarrez toute console ou terminal (Invite de commandes, `PowerShell`, etc.) que vous aviez ouvert pour que les modifications du `PATH` soient prises en compte.

### `**macOS**`

**Téléchargez le package `.pkg`**.

**Ouvrez le fichier téléchargé** et suivez les instructions de l'installeur graphique.

Go sera installé dans le répertoire `/usr/local/go`, et l'installeur ajoutera automatiquement le chemin `/usr/local/go/bin` à la variable `PATH` de votre système.

**Alternative (pour les utilisateurs de `Homebrew`) :** si vous utilisez le gestionnaire de paquets [Homebrew](https://brew.sh/), vous pouvez installer `Go` avec une simple commande dans votre terminal : 

content\_copy

    brew install go

### `**Linux**`

Utilisation de `Snap` :

content\_copy

    sudo snap install core
    sudo snap refresh core
    

Installation de `Go` :

content\_copy

    sudo snap install go --classic

Méthode alternative :

La méthode manuelle via l'archive vous donne un contrôle total sur la version de `Go` et n'interfère pas avec les gestionnaires de paquets de votre distribution.

**Téléchargez l'archive `.tar.gz`** depuis le site officiel. Vous pouvez le faire via votre navigateur ou en utilisant une commande `wget` dans votre terminal :

content\_copy

    # Remplacez le nom du fichier par la dernière version stable disponible
    wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz

**Vérifiez l'intégrité de l'archive** en comparant la somme de contrôle `SHA256` affichée sur le site de téléchargement avec celle de votre fichier :

content\_copy

    sha256sum go1.25.0.linux-amd64.tar.gz

**Extrayez l'archive dans `/usr/local`**.

Ce répertoire est la convention standard pour les logiciels installés manuellement sur les systèmes `Linux`. Cette commande doit être exécutée avec des privilèges d'administrateur (`sudo`).

content\_copy

    # Supprime toute ancienne installation et extrait la nouvelle
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

**Ajoutez `Go` à la variable d'environnement `PATH`**.

Pour rendre la commande `go` accessible depuis n'importe quel répertoire, vous devez ajouter son emplacement à votre `PATH`. Modifiez le fichier de configuration de votre `shell` (`~/.profile` est un bon choix car il fonctionne pour la plupart des `shells` de connexion) :

content\_copy

    # Ajoute cette ligne à la fin de votre fichier ~/.profile ou ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin

Pour appliquer les changements immédiatement, rechargez votre fichier de profil avec `source ~/.profile` ou fermez et rouvrez simplement votre terminal.

### Vérifier l'installation

Une fois l'installation terminée, il est crucial de vérifier que tout fonctionne correctement.

**Ouvrez un NOUVEAU terminal** pour vous assurer qu'il utilise bien les variables d'environnement mises à jour.

Tapez la commande suivante pour afficher la version de `Go` installée :

content\_copy

    go version

La sortie devrait ressembler à ceci, confirmant que le système a trouvé l'exécutable Go : `go version go1.25.0 linux/amd64`

Ensuite, explorez la configuration de l'environnement Go avec la commande :

content\_copy

    go env

Cette commande affiche une liste de variables importantes. Pour un débutant, les plus pertinentes sont :

*   `GOROOT`: indique où `Go` est installé (par ex. `/usr/local/go`). Vous ne devriez jamais avoir à modifier cette variable.
    
*   `GOPATH`: l'emplacement de votre ancien espace de travail. Avec les modules `Go`, son rôle a diminué, mais il est toujours utilisé pour stocker certains outils.
    
*   `GOOS` et `GOARCH`: le système d'exploitation et l'architecture pour lesquels `Go` a été construit.
    

Si ces deux commandes s'exécutent sans erreur, votre environnement `Go` est installé et configuré avec succès.

### **Configurer un éditeur de code professionnel**

Un bon éditeur est un accélérateur. L'outillage `Go` est si bien standardisé qu'il transforme n'importe quel éditeur de texte en un environnement de développement puissant.

#### **`VS Code` : choix pour le cours**

C'est le choix le plus populaire pour sa gratuité, sa légèreté et son écosystème d'extensions riches.

1.  **Installer `Visual Studio Code`** : téléchargez-le depuis le site officiel.
    
2.  **Installer l'extension `Go`** : dans l'onglet des extensions, cherchez `Go` et installez celle publiée par l'équipe `Go` de `Google` (`Go Team at Google`).
    

Voici ce que l'extension vous offre directement :

*   **`IntelliSense` :** autocomplétion intelligente, suggestions de code et informations sur les fonctions pendant que vous tapez.
    
*   **Navigation de code :** sautez instantanément à la définition d'une variable ou d'une fonction ("`Go to Definition`") ou trouvez toutes ses utilisations.
    
*   **Diagnostics en temps réel :** les erreurs de compilation, les avertissements de `go vet` et les suggestions de `linters` apparaissent directement dans votre code au fur et à mesure que vous écrivez.
    
*   **Débogage intégré :** une intégration transparente avec le débogueur `Delve` (`dlv`) vous permet de placer des points d'arrêt, d'inspecter des variables et d'exécuter votre code pas à pas.
    
*   **Formatage et organisation :** votre code est automatiquement formaté et vos imports sont organisés à chaque sauvegarde.
    

#### **`GoLand` : la solution payante**

Développé par `JetBrains`, `GoLand` est un `IDE` payant mais exceptionnellement complet, offrant une expérience "zéro configuration" avec des outils de `refactoring` très avancés.

### Sur cette page

*   Téléchargement et installation de Go
*   Windows
*   macOS
*   Linux
*   Vérifier l'installation
*   Configurer un éditeur de code professionnel
*   VS Code : choix pour le cours
*   GoLand : la solution payante