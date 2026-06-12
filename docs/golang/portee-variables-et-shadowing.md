### **La portée : les pièces de votre maison**

Nous savons maintenant déclarer et manipuler des variables. Mais une question se pose : où ces variables "vivent-elles" ? Une variable déclarée à un endroit est-elle accessible partout dans notre programme ? La réponse est non.

Chaque variable a une **portée** (en anglais, `_scope_`), qui est la zone du code où elle est visible et utilisable.

Comprendre la portée est absolument crucial pour écrire du code propre, éviter les bugs et organiser logiquement vos programmes.

Pensez à votre programme comme à une maison, et aux blocs de code délimités par des accolades `{}` comme à des pièces.

*   Une variable déclarée dans une pièce (un bloc) n'est visible et utilisable que **dans cette pièce**. C'est comme un outil que vous laissez dans la chambre ; vous ne pouvez pas l'utiliser depuis la cuisine.
    
*   Si vous êtes dans une pièce, vous pouvez aussi voir ce qui se trouve dans les pièces plus grandes qui la contiennent (comme le salon qui contient la cuisine ouverte). Depuis la cuisine, vous pouvez voir la télévision qui est dans le salon.
    
*   Mais vous ne pouvez pas voir ce qui se trouve dans une pièce voisine ou dans une pièce plus petite depuis l'extérieur. Depuis le salon, vous ne pouvez pas voir ce qui se trouve à l'intérieur de la chambre fermée.
    

Cette "visibilité" est ce qu'on appelle la **portée**.

En `Go`, la portée est **lexicale**, ce qui signifie qu'elle est définie par l'endroit où vous écrivez votre code, pas par l'endroit d'où vous l'appelez.

### **La portée de bloc (_`block scope`_)**

La plupart des variables que vous créerez auront une portée de bloc.

Une variable déclarée à l'intérieur d'un bloc `{}` (comme une fonction `main`, une condition `if`, ou une boucle `for`) n'existe qu'à l'intérieur de ce bloc.

Dès que le programme sort de ce bloc, la variable est détruite et sa mémoire est libérée :

content\_copy

    package main
    
    import "fmt"
    
    func main() { // Début du bloc de la fonction main (portée externe)
        // 'message' est visible partout dans la fonction main.
        message := "Bonjour depuis la fonction main !"
        fmt.Println(message)
    
        for i := 0; i < 2; i++ { // Début d'un bloc interne (boucle for)
            // 'messageInterne' et 'i' ne sont visibles QUE dans ce bloc for.
            messageInterne := "Salut depuis la boucle !"
            fmt.Println(i, messageInterne)
    
            // On peut accéder à 'message' car nous sommes dans un bloc contenu dans main.
            fmt.Println(message)
        } // Fin du bloc for. 'messageInterne' et 'i' sont détruits.
    
        // La ligne suivante produirait une erreur de compilation !
        // 'messageInterne' n'existe plus en dehors de son bloc.
        // fmt.Println(messageInterne) // Erreur: undefined: messageInterne
    
    } // Fin du bloc de la fonction main
     

### **Le masquage de variable (_`variable shadowing`_)**

Le masquage se produit lorsque vous déclarez une variable dans un bloc interne avec le **même nom** qu'une variable dans un bloc externe.

La nouvelle variable (interne) "masque" temporairement la variable externe.

**À l'intérieur du bloc, toute référence à ce nom concernera la variable interne.**

C'est une source fréquente de bugs pour les débutants, il est donc très important de la comprendre.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // 'niveau' est déclarée dans le bloc externe (main). Sa valeur est 1.
        niveau := 1
        fmt.Printf("Dans main, avant le bloc : niveau = %d (adresse: %p)\n", niveau, &niveau)
    
        if true {
            // On déclare une NOUVELLE variable 'niveau' avec l'opérateur :=
            // Cette nouvelle variable n'existe que dans ce bloc if.
            // Elle MASQUE la variable 'niveau' de la fonction main.
            niveau := 2
            fmt.Printf("Dans le bloc if : niveau = %d (adresse: %p)\n", niveau, &niveau) // Affiche 2
    
            // Toute modification ici affecte la variable interne.
            niveau = niveau + 1
            fmt.Printf("Dans le bloc if, après modification : niveau = %d\n", niveau) // Affiche 3
        }
    
        // De retour dans le bloc de main, la variable 'niveau' du bloc if n'existe plus.
        // Nous retrouvons la variable originale, qui n'a JAMAIS été modifiée.
        fmt.Printf("Dans main, après le bloc : niveau = %d (adresse: %p)\n", niveau, &niveau) // Affiche 1
    }

_Note : `%p` affiche l'adresse mémoire de la variable. Vous pouvez voir que les deux variables `niveau` sont bien deux entités distinctes stockées à des endroits différents._

**Comment éviter le masquage ?** Si votre intention était de modifier la variable externe, vous auriez dû utiliser l'opérateur d'assignation `=` au lieu de `:=`.

content\_copy

    // ...
    if true {
        // Ici, on ne crée pas de nouvelle variable.
        // On MODIFIE la variable 'niveau' du bloc externe.
        niveau = 2
        fmt.Printf("Dans le bloc if : niveau = %d\n", niveau) // Affiche 2
    }
    fmt.Printf("Dans main, après le bloc : niveau = %d\n", niveau) // Affiche 2

**Règle d'or :** Soyez très prudent lorsque vous utilisez `:=` à l'intérieur de blocs imbriqués. Assurez-vous que vous ne masquez pas involontairement une variable existante. La plupart des linters (outils d'analyse de code) vous avertiront lorsque vous masquez une variable.

### **La portée de paquet (_`package scope`_)**

Si vous déclarez une variable en dehors de toute fonction, au niveau supérieur de votre fichier, elle est visible par **tous les fichiers** du même paquet.

C'est ce qu'on appelle la portée de paquet.

On utilise la déclaration `var` pour cela.

content\_copy

    package main
    
    import "fmt"
    
    // 'Version' est déclarée au niveau du paquet.
    // Elle est accessible dans la fonction main et dans toute autre fonction de ce paquet.
    var Version = "1.0"
    
    func main() {
        fmt.Println("Version du programme :", Version)
        afficherVersion()
    }
    
    func afficherVersion() {
        // 'Version' est aussi accessible ici.
        fmt.Println("La fonction afficherVersion voit la version :", Version)
    }

On utilise généralement la portée de paquet avec parcimonie, pour des variables qui représentent un état global de l'application (comme une connexion à une base de données ou une configuration).

Abuser des variables globales peut rendre le code difficile à suivre et à tester.

### Sur cette page

*   La portée : les pièces de votre maison
*   La portée de bloc (block scope)
*   Le masquage de variable (variable shadowing)
*   La portée de paquet (package scope)