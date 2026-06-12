Dans la leçon précédente, nous avons vu comment gérer les erreurs attendues avec le type `error`.

C'est la manière idiomatique de gérer 99% des cas d'échec en `Go` (un fichier qui n'existe pas, une connexion réseau qui échoue, une entrée utilisateur invalide, etc.).

Cependant, il existe une catégorie d'erreurs beaucoup plus rares et plus graves : les erreurs d'exécution critiques qui rendent la poursuite du programme impossible.

Pour ces situations exceptionnelles, `Go` fournit un mécanisme spécial : `panic` et `recover`.

### **Qu'est-ce qu'une `panic` ?**

Une `panic` est une erreur d'exécution qui arrête immédiatement le flux normal du programme.

Lorsqu'une `panic` est déclenchée :

1.  L'exécution de la fonction actuelle s'arrête.
    
2.  Toutes les fonctions différées (`defer`) de cette fonction sont exécutées.
    
3.  Le programme remonte la pile d'appels, exécutant les `defer` de chaque fonction parente.
    
4.  Le programme se termine brutalement en affichant un message de `panic` et la "`stack trace`" (la liste des fonctions qui ont mené à l'erreur).
    

Vous avez déjà rencontré des paniques sans le savoir.

Par exemple, essayer d'accéder à un index qui n'existe pas dans une slice déclenche une `panic`.

**Quand utiliser `panic` ?** La règle est simple : **presque jamais**. Vous ne devriez déclencher une `panic` manuellement que pour des erreurs qui ne devraient **jamais** se produire, des "bugs" qui indiquent un état impossible et incohérent de votre programme.

### **Déclencher une `panic`**

On utilise la fonction intégrée `panic()` en lui passant un argument (souvent une chaîne de caractères) qui décrit l'erreur.

content\_copy

    package main
    
    import "fmt"
    
    func verifierConnexion() {
        connexionOK := false
        if !connexionOK {
            // C'est une erreur critique, le programme ne peut pas continuer.
            panic("Impossible d'établir la connexion à la base de données")
        }
        fmt.Println("La connexion est établie.") // Cette ligne ne sera jamais atteinte.
    }
    
    func main() {
        fmt.Println("Début du programme.")
        verifierConnexion()
        fmt.Println("Fin du programme.") // Cette ligne ne sera jamais atteinte.
    }

**Résultat :**

content\_copy

    Début du programme.
    panic: Impossible d'établir la connexion à la base de données
    
    goroutine 1 [running]:
    main.verifierConnexion()
            .../main.go:9 +0x...
    main.main()
            .../main.go:15 +0x...
    exit status 2

### **Reprendre le contrôle avec `recover`**

Une `panic` fait normalement planter tout le programme.

Cependant, il est **parfois souhaitable de "rattraper" une** **`panic` pour permettre au programme de se terminer proprement, ou pour transformer une `panic` en une valeur d'erreur `error` classique.**

C'est le rôle de la fonction intégrée `recover()`.

Il y a une règle très stricte : `recover` n'est utile que s'il est appelé **à l'intérieur d'une fonction différée (`defer`)**.

*   Si la `goroutine` actuelle n'est pas en train de paniquer, un appel à `recover` retourne `nil`.
    
*   Si la `goroutine` actuelle panique, un appel à `recover` "capture" la valeur passée à `panic` et permet au programme de reprendre une exécution normale.
    

### **L'idiome `defer-panic-recover`**

Voici comment on combine les trois concepts pour gérer une `panic` de manière contrôlée :

content\_copy

    package main
    
    import "fmt"
    
    func gestionnaireDePanic() {
        // recover() permet de "rattraper" la panique.
        if r := recover(); r != nil {
            fmt.Println("Panic rattrapée :", r)
        }
    }
    
    func fonctionQuiPanique() {
        // On "défère" notre gestionnaire. Il sera exécuté lorsque la fonction
        // se terminera, y compris en cas de panic.
        defer gestionnaireDePanic()
    
        fmt.Println("Sur le point de paniquer...")
        panic("quelque chose de grave s'est produit")
        fmt.Println("Cette ligne n'est jamais atteinte.")
    }
    
    func main() {
        fmt.Println("Appel de la fonction qui panique.")
        fonctionQuiPanique()
        // L'exécution continue ici car la panic a été gérée !
        fmt.Println("Le programme s'est terminé normalement.")
    }
     

**Résultat :**

content\_copy

    Appel de la fonction qui panique.
    Sur le point de paniquer...
    Panic rattrapée : quelque chose de grave s'est produit
    Le programme s'est terminé normalement.

**En résumé :**

*   Utilisez les **erreurs (`error`)** pour les échecs attendus et gérables.
    
*   Utilisez la **panique (`panic`)** pour les erreurs de programmation vraiment exceptionnelles et normalement irrécupérables.
    
*   Utilisez `recover` avec parcimonie, souvent à la frontière de votre application (par exemple, dans un serveur web pour qu'une requête en erreur ne fasse pas planter tout le serveur).
    

### Sur cette page

*   Qu'est-ce qu'une panic ?
*   Déclencher une panic
*   Reprendre le contrôle avec recover
*   L'idiome defer-panic-recover