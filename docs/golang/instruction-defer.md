Nous avons vu comment prendre des décisions et répéter des actions.

`Go` propose une instruction unique et extrêmement utile pour gérer des actions de "nettoyage" : `defer`.

Imaginez que vous ouvrez un fichier. Il est crucial de penser à le fermer à la fin, quoi qu'il arrive.

Si vous oubliez, ou si une erreur se produit au milieu de votre fonction, le fichier pourrait rester ouvert, consommant des ressources système. 

`defer` a été conçu pour résoudre ce problème de manière élégante et fiable.

### **Qu'est-ce que `defer` ?**

Le mot-clé `defer` place un appel de fonction sur une "liste d'attente".

Les fonctions sur cette liste sont exécutées **juste avant que la fonction environnante ne se termine**, que ce soit normalement (via un `return`) ou à cause d'une erreur (un `panic`).

Son but principal est de garantir que les actions de nettoyage (comme fermer un fichier, déverrouiller un `mutex`, fermer une connexion à une base de données) sont toujours exécutées, en plaçant l'action de nettoyage juste à côté de l'action d'ouverture.

**Syntaxe :**

content\_copy

    defer nomDeLaFonction(arguments)

### **Comportement de base**

Voyons un exemple simple pour observer l'ordre d'exécution.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // On "défère" l'appel à fmt.Println. Il ne sera pas exécuté tout de suite.
        defer fmt.Println("Monde")
    
        fmt.Println("Bonjour")
    }
     

**Résultat :**

content\_copy

    Bonjour
    Monde

Comme vous pouvez le voir, bien que la ligne `defer` soit écrite en premier, son exécution est reportée à la toute fin de la fonction `main`.

### **L'ordre d'exécution : `LIFO` (`Last-In`, `First-Out`)**

Que se passe-t-il si vous avez plusieurs instructions `defer` dans la même fonction ?

Elles sont empilées les unes sur les autres, et exécutées dans l'ordre **inverse** de leur déclaration.

C'est le principe `LIFO` : le dernier entré est le premier sorti :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        fmt.Println("Début de la fonction")
    
        defer fmt.Println("Première instruction defer (exécutée en dernier)")
        defer fmt.Println("Deuxième instruction defer")
        defer fmt.Println("Troisième instruction defer (exécutée en premier)")
    
        fmt.Println("Fin de la fonction")
    }
     

**Résultat :**

content\_copy

    Début de la fonction
    Fin de la fonction
    Troisième instruction defer (exécutée en premier)
    Deuxième instruction defer
    Première instruction defer (exécutée en dernier)

### **Le cas d'usage idiomatique : la gestion de fichiers**

Voici l'exemple le plus classique et le plus important. 

`defer` rend la gestion des ressources beaucoup plus propre et moins sujette aux erreurs.

content\_copy

    package main
    
    import (
    	"fmt"
    	"os"
    )
    
    func lireUnFichier() {
    	// On ouvre un fichier. Cette opération peut retourner une erreur.
    	fichier, err := os.Open("mon_fichier.txt")
    	if err != nil {
    		fmt.Println("Erreur à l'ouverture du fichier:", err)
    		return // On quitte la fonction si le fichier n'a pas pu être ouvert.
    	}
    	// C'est la magie de defer : on place l'instruction de fermeture
    	// juste après l'ouverture. On est certain de ne pas l'oublier.
    	// fichier.Close() sera appelé à la fin de la fonction lireUnFichier().
    	defer fichier.Close()
    
    	// ...
    	// Ici, on pourrait avoir beaucoup de code pour lire et traiter le fichier.
    	// ...
    	fmt.Println("Le fichier a été ouvert et sera fermé à la fin.")
    }
    
    func main() {
    	lireUnFichier()
    }
     

Sans `defer`, vous devriez penser à appeler `fichier.Close()` avant chaque `return` de votre fonction (par exemple, en cas d'erreur de lecture au milieu du fichier).

Avec `defer`, vous le dites une fois et vous êtes tranquille.

### **Évaluation des arguments**

Un point très important : les arguments d'une fonction différée sont **évalués au moment de l'instruction `defer`**, et non au moment de l'exécution.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        nombre := 5
    
        // L'argument de la fonction Println est évalué ICI.
        // Go voit que 'nombre' vaut 5 et met de côté l'instruction "afficher 5".
        defer fmt.Println("La valeur différée est :", nombre)
    
        // On modifie la variable 'nombre'.
        nombre = 10
    
        fmt.Println("La valeur actuelle est :", nombre)
    }

**Résultat :**

content\_copy

    La valeur actuelle est : 10
    La valeur différée est : 5

L'appel différé a bien affiché la valeur que `nombre` avait au moment où `defer` a été appelé, pas sa valeur finale.

### Sur cette page

*   Qu'est-ce que defer ?
*   Comportement de base
*   L'ordre d'exécution : LIFO (Last-In, First-Out)
*   Le cas d'usage idiomatique : la gestion de fichiers
*   Évaluation des arguments