### Compiler un exécutable

Dans la leçon précédente, nous avons utilisé `go run` pour exécuter notre programme.

C'est un outil fantastique pour le développement, car il nous donne un retour immédiat.

Mais que se passe-t-il lorsque notre programme est terminé et que nous voulons le partager avec d'autres, ou le déployer sur un serveur ? Ces personnes n'auront pas forcément `Go` d'installé, ni notre code source.

**La solution est de compiler notre code.**

La compilation est le processus qui transforme notre code source (`.go`), lisible par l'homme, en un unique fichier **exécutable** (ou **binaire**), lisible par la machine.

Ce fichier est autonome : il contient tout ce dont il a besoin pour fonctionner et peut être exécuté sur n'importe quel ordinateur du même type (par exemple, un binaire `Windows` s'exécutera sur n'importe quel `Windows`) sans aucune dépendance.

### **La commande `go build`**

L'outil `Go` nous fournit une commande dédiée à cette tâche : `go build`.

1.  **Assurez-vous d'être dans le bon dossier.** Ouvrez votre projet `hello-go` dans `VS Code`. Ouvrez le terminal intégré. Votre terminal doit se trouver dans le dossier `hello-go`.
    
2.  **Lancez la commande de compilation.** Tapez la commande suivante et appuyez sur Entrée :
    
    content\_copy
    
        go build main.go
    
    L'outil `Go` va lire votre fichier `main.go`, l'analyser, le traduire en code machine et créer un nouveau fichier dans le même dossier.
    
3.  **Observez le résultat.** Regardez l'explorateur de fichiers de `VS Code` sur la gauche. Un nouveau fichier est apparu !
    
    *   Sur `macOS` ou `Linux`, il s'appellera `main`.
        
    *   Sur `Windows`, il s'appellera `main.exe`.
        
    
    Ce nouveau fichier est votre application complète, prête à être distribuée.
    

### Que contient le programme ?

Le programme fait environ `2,2` Mo ce qui peut paraitre énorme.

Sa taille s'explique par le fait que `Go` privilégie la **simplicité de déploiement** et la **fiabilité** avant tout.

Voyons ensemble son contenu.

#### Le `runtime Go` (la plus grosse partie)

C'est le "système d'exploitation" interne de votre programme. Même pour un "Hello, World!", ce `runtime` est inclus et gère des fonctionnalités essentielles qui rendent `Go` si puissant :

*   **Le `Garbage Collector` (`GC`)** : c'est un processus automatique qui surveille la mémoire de votre application. Il identifie et libère la mémoire qui n'est plus utilisée, vous évitant ainsi une des sources de bugs les plus courantes dans d'autres langages.
    
*   **Le planificateur de `Goroutines` (`Scheduler`)** : c'est le cerveau de la concurrence en `Go`. Il est capable de gérer des milliers de tâches (appelées `goroutines`) en parallèle de manière très efficace. Votre "Hello, World!" n'utilise pas la concurrence, mais le planificateur est quand même présent, prêt à fonctionner.
    
*   **La gestion des types complexes** : le code nécessaire pour faire fonctionner les `maps`, les `slices`, les `channels` et les `interfaces` est également inclus dans ce `runtime`.
    

#### **Les parties nécessaires de la bibliothèque standard**

Votre code utilise `fmt.Println`.

`Go` est intelligent : il n'inclut pas la totalité du gigantesque paquet `fmt`.

Cependant, il analyse votre code et inclut statiquement toutes les fonctions dont `fmt.Println` dépend pour fonctionner : comment formater une chaîne de caractères, comment interagir avec la sortie standard de la console (`STDOUT`) du système d'exploitation, etc.

#### **Votre code compilé**

Bien sûr, le binaire contient la version traduite en code machine de votre propre logique, c'est-à-dire le contenu de votre fonction `main`.

C'est en réalité la plus petite partie du fichier pour un programme aussi simple.

#### **Les informations de débogage (`DWARF`)**

Par défaut, le compilateur `Go` inclut des métadonnées de débogage au format `DWARF`.

Ces informations sont une sorte de carte qui relie le code machine binaire à votre code source original (`main.go`).

Elles permettent aux outils de débogage (comme `Delve`) de vous dire à quelle ligne de votre code source une erreur s'est produite, de vous laisser inspecter des variables par leur nom, etc. Ces informations prennent de la place.

### Exécuter le programme compilé

Contrairement à `go run`, nous n'avons plus besoin de spécifier le fichier source. Nous allons maintenant exécuter directement le binaire que nous venons de créer.

Dans votre terminal, tapez la commande appropriée pour votre système d'exploitation :

*   **Sur `macOS` ou `Linux` :**
    
    content\_copy
    
        ./main
    
    (Le `./` est nécessaire pour dire au terminal de chercher le programme dans le dossier actuel.)
    
*   **Sur `Windows` :**
    
    content\_copy
    
        .\main.exe
    
    (Le `.\` a le même rôle que sur les autres systèmes.)
    

Après avoir appuyé sur Entrée, le résultat sera exactement le même que celui obtenu avec `go run` :

content\_copy

    Hello, World!

La différence, c'est que cette fois, vous n'avez pas compilé-puis-exécuté. Vous avez simplement exécuté un programme qui existait déjà.

### **`go run` vs `go build` en détail**

Pour devenir un développeur Go efficace, il est crucial de comprendre la philosophie derrière ces deux commandes.

#### **`go run` : le raccourci du développeur**

Pensez à `go run` comme à votre **"mode de test rapide"**. Son seul et unique but est d'accélérer la boucle de développement : **écrire -> tester -> corriger**.

Lorsque vous lancez `go run main.go`, voici ce qui se passe en coulisses :

1.  `Go` compile votre code (`main.go` et tous les autres fichiers nécessaires) en un binaire exécutable.
    
2.  **Crucialement**, il ne sauvegarde **pas** ce binaire dans votre dossier de projet. Il le place dans un dossier temporaire caché, quelque part sur votre système d'exploitation.
    
3.  Il exécute immédiatement ce binaire temporaire.
    
4.  Une fois l'exécution terminée, il **supprime** automatiquement le binaire temporaire.
    

**L'avantage** est la simplicité : une seule commande pour voir le résultat de votre code.

**L'inconvénient** est qu'à la fin du processus, il ne reste aucun artefact. Vous ne pouvez pas prendre le résultat de `go run` et l'envoyer ou le déployer. C'est un outil exclusivement destiné au processus de développement.

#### **`go build` : l'outil de production**

Pensez à `go build` comme à votre **"mode de livraison"**. Son objectif est de produire un artefact final, stable et distribuable.

Lorsque vous lancez `go build main.go`, le processus est différent :

1.  `Go` compile votre code en un binaire exécutable.
    
2.  Il sauvegarde ce binaire **de manière permanente** dans votre dossier de projet (ou à un emplacement que vous spécifiez).
    
3.  La commande ne fait rien d'autre. Elle n'exécute pas le code. Son travail s'arrête une fois que le fichier est créé.
    

**L'avantage** est que vous obtenez un produit fini. Ce fichier `main` ou `main.exe` est autonome. Vous pouvez le copier sur une clé `USB`, l'envoyer par e-mail, ou le déployer sur un serveur, et il fonctionnera sans avoir besoin du code source ou de `Go` installé. C'est l'objectif final de la compilation.

En résumé, utilisez `go run` des dizaines de fois par jour pendant que vous codez. Utilisez `go build` une fois que vous avez terminé une fonctionnalité et que vous êtes prêt à la partager ou à la déployer.

### Sur cette page

*   Compiler un exécutable
*   La commande go build
*   Que contient le programme ?
*   Le runtime Go (la plus grosse partie)
*   Les parties nécessaires de la bibliothèque standard
*   Votre code compilé
*   Les informations de débogage (DWARF)
*   Exécuter le programme compilé
*   go run vs go build en détail
*   go run : le raccourci du développeur
*   go build : l'outil de production