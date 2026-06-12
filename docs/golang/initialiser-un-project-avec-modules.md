### Initialiser un projet avec les modules `Go`

Jusqu'à présent, nous avons travaillé avec un unique fichier `main.go` dans un simple dossier. Cela fonctionne parfaitement pour de petits scripts, mais dès qu'un projet grandit et que l'on souhaite utiliser du code écrit par d'autres (des "dépendances"), cette approche atteint ses limites.

Pour gérer des projets réels, `Go` utilise un système appelé **modules `Go`**.

Un module est la manière standard de structurer un projet. Il permet de déclarer l'identité de votre projet et, surtout, de gérer les versions des bibliothèques externes dont il dépend. Dans cette leçon, nous allons transformer notre simple dossier `hello-go` en un véritable module `Go`.

### **Qu'est-ce qu'un module `Go` ?**

Pensez à un module comme à la carte d'identité de votre projet. C'est une collection de paquets `Go` qui sont gérés ensemble, avec un fichier central qui définit ses propriétés.

Ce fichier, nommé `go.mod`, est le cœur du module. Il contient des informations cruciales :

1.  **Le nom unique du module** : c'est son chemin d'importation, comment d'autres projets pourraient le trouver (par exemple, `github.com/votre-nom/votre-projet`).
    
2.  **La version de `Go`** avec laquelle le projet a été écrit.
    
3.  **La liste de toutes les dépendances externes** et leurs versions exactes.
    

Avoir un module garantit que n'importe quel développeur qui récupère votre projet utilisera exactement les mêmes versions des dépendances que vous, assurant ainsi des compilations **reproductibles** et évitant de nombreux bugs.

### **La commande `go mod init`**

Pour transformer un dossier en module, `Go` nous fournit la commande `go mod init` (abréviation de "`initialize module`").

Son rôle est très simple : créer le fichier `go.mod` à la racine de votre projet.

La syntaxe est la suivante :

content\_copy

    go mod init [nom-du-module]

Le `[nom-du-module]` est le nom unique que vous donnez à votre projet. Pour l'instant, nous utiliserons simplement le nom de notre dossier.

### **Transformer notre projet en module**

Mettons cela en pratique avec notre projet `hello-go`.

1.  **Ouvrez votre terminal intégré** dans `VS Code`, en vous assurant d'être dans le dossier `hello-go`.
    
2.  **Lancez la commande d'initialisation.** Tapez la commande suivante et appuyez sur Entrée :
    
    content\_copy
    
        go mod init hello-go
    

En regardant l'explorateur de fichiers de `VS Code`, vous verrez qu'un nouveau fichier, `go.mod`, est apparu à côté de votre `main.go`.

Observez également le message suivant :

content\_copy

    go: creating new go.mod: module hello-go
    go: to add module requirements and sums:
            go mod tidy

### **Anatomie du fichier `go.mod`**

Ouvrez ce nouveau fichier `go.mod`. Son contenu est très simple pour le moment :

content\_copy

    module hello-go
    
    go 1.25

_Votre version de Go peut être légèrement différente, cela n'a aucune importance._

Décortiquons ces deux lignes :

*   `module hello-go` : c'est la déclaration d'identité. Elle définit le nom de notre module.
    
*   `go 1.25` : cette ligne indique la version de Go avec laquelle ce module a été créé. Cela garantit que le compilateur activera les fonctionnalités compatibles avec cette version.
    

Pour l'instant, il n'y a pas de dépendances listées, car notre programme n'en utilise aucune.

### **Gérer les dépendances : `go get`, `go mod tidy` et le fichier `go.sum`**

Maintenant que nous avons un module, nous avons besoin d'outils pour le maintenir propre et sécurisé.

#### **La commande `go get` : ajouter une dépendance spécifique**

La manière la plus directe d'ajouter une nouvelle dépendance à votre projet est d'utiliser la commande `go get`. C'est une commande explicite : vous lui dites exactement quel paquet vous voulez télécharger et ajouter à votre module.

Par exemple, si vous vouliez utiliser une bibliothèque populaire pour générer des identifiants uniques (`UUID`), vous pourriez lancer :

content\_copy

    go get github.com/google/uuid

En lançant cette commande, `Go` va :

1.  Télécharger le code source de la bibliothèque `uuid`.
    
2.  Ajouter automatiquement une ligne `require github.com/google/uuid`  à votre fichier `go.mod`. Vous pourriez par exemple avoir :
    
    content\_copy
    
        module hello-go
        
        go 1.24.6
        
        require github.com/google/uuid v1.6.0 // indirect
        
    
3.  Mettre à jour le fichier `go.sum` avec l'empreinte de sécurité de ce nouveau paquet.
    
    content\_copy
    
        github.com/google/uuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
        github.com/google/uuid v1.6.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
        
    

#### **La commande `go mod tidy` : le nettoyeur automatique**

La commande `go mod tidy` (`tidy` signifie "ranger") est complémentaire. Son rôle est de **synchroniser** votre fichier `go.mod` avec le code que vous avez réellement écrit dans vos fichiers `.go`. Lorsque vous la lancez, elle effectue deux actions principales :

1.  Elle **lit tous vos fichiers `.go`**, regarde toutes vos lignes `import` et ajoute au fichier `go.mod` toutes les dépendances que vous utilisez mais qui n'y sont pas encore listées.
    
2.  Elle **lit votre fichier `go.mod`** et supprime toutes les dépendances qui y sont listées mais que vous n'utilisez plus dans votre code.
    

C'est la commande à utiliser pour vous assurer que votre `go.mod` est toujours un reflet exact des besoins de votre projet.

Essayez de la lancer. Que constatez vous ?

#### **Le fichier `go.sum` : le sceau de sécurité**

Lorsque vous utilisez `go get` ou `go mod tidy` pour la première fois, vous verrez apparaître un nouveau fichier : `go.sum`.

**Ce fichier est généré automatiquement et ne doit jamais être modifié manuellement.**

Son but est la **sécurité et la reproductibilité**. Il contient les "empreintes digitales" cryptographiques (des sommes de contrôle, ou `_hashes_`) de chaque version de chaque dépendance que vous utilisez. Cela garantit que lorsque vous (ou un autre développeur) compilez le projet, vous utilisez exactement la même version du code externe, sans modification inattendue.

**Important :** les deux fichiers, `go.mod` et `go.sum`, doivent être ajoutés à votre système de contrôle de version (comme `Git`).

### Sur cette page

*   Initialiser un projet avec les modules Go
*   Qu'est-ce qu'un module Go ?
*   La commande go mod init
*   Transformer notre projet en module
*   Anatomie du fichier go.mod
*   Gérer les dépendances : go get, go mod tidy et le fichier go.sum
*   La commande go get : ajouter une dépendance spécifique
*   La commande go mod tidy : le nettoyeur automatique
*   Le fichier go.sum : le sceau de sécurité