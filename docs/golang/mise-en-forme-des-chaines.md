### Mise en forme des chaînes (`fmt`)

Jusqu'à présent, nous avons utilisé `fmt.Println()` pour afficher nos variables.

C'est une fonction simple et efficace : elle prend n'importe quelle donnée, l'affiche de manière lisible et ajoute un saut de ligne.

Cependant, elle ne nous donne aucun contrôle sur l'apparence finale du texte.

Dans cette leçon, nous allons découvrir `fmt.Printf()`, un outil beaucoup plus puissant qui vous permet de formater des chaînes de caractères avec une précision totale.

Maîtriser `fmt.Printf` est essentiel pour créer des affichages clairs, des messages de log structurés et des sorties de programme professionnelles.

### **`fmt.Printf` : le "texte à trous" de vos données**

Pensez à `fmt.Printf` comme à un "texte à trous".

Son fonctionnement repose sur deux éléments :

1.  Une **chaîne de formatage** : c'est un `string` qui sert de modèle, contenant du texte normal et des "espaces réservés" spéciaux.
    
2.  Des **valeurs** : ce sont les données (vos variables) que vous voulez insérer dans les espaces réservés.
    

Ces "espaces réservés" sont appelés des **verbes de formatage**. Ils commencent toujours par le symbole `%` :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        nom := "Alice"
        age := 30
    
        // La chaîne de formatage est le premier argument.
        // %s est un verbe pour une chaîne de caractères.
        // %d est un verbe pour un nombre entier.
        // Les variables `nom` et `age` sont les arguments suivants.
        fmt.Printf("L'utilisatrice %s a %d ans.\n", nom, age)
        // Note : Printf n'ajoute pas de saut de ligne, nous devons l'ajouter nous-mêmes avec `\n`.
    }

**Résultat :** `L'utilisatrice Alice a 30 ans.`

### **Les verbes de formatage essentiels**

Chaque type de donnée a des verbes spécifiques, mais certains sont plus courants que d'autres.

#### **Le verbe universel : `%v`**

Le verbe `%v` (pour `_value_` ou valeur) est le plus simple et le plus polyvalent.

Il demande à `Go` d'afficher la variable dans son format par défaut, le plus naturel.

content\_copy

    var nom = "Bob"       // string
    var age = 42        // int
    var prix = 19.99    // float64
    var estActif = true // bool
    
    fmt.Printf("Profil : %v, %v ans, %v€, Actif: %v\n", nom, age, prix, estActif)
    // Affiche : Profil : Bob, 42 ans, 19.99€, Actif: true

C'est un excellent choix lorsque vous n'avez pas besoin d'un formatage spécifique.

#### **Les verbes spécifiques par type**

Pour un contrôle plus précis, utilisez des verbes spécifiques.

*   **Pour les `string` :**
    
    *   `%s` : Affiche le texte.
        
    *   `%q` : Affiche le texte **entre guillemets doubles**. Très utile pour voir les espaces ou les caractères spéciaux.
        
*   **Pour les `int` :**
    
    *   `%d` : Affiche le nombre en base `10` (décimal).
        
    *   `%b` : Affiche le nombre en base `2` (binaire).
        
    *   `%x` : Affiche le nombre en base `16` (hexadécimal).
        
        content\_copy
        
            nombre := 14
            fmt.Printf("Décimal: %d, Binaire: %b, Hexadécimal: %x\n", nombre, nombre, nombre)
            // Affiche : Décimal: 14, Binaire: 1110, Hexadécimal: e
        
*   **Pour les `float` :**
    
    *   `%f` : Affiche le nombre avec une partie décimale (précision par défaut).
        
    *   `%.2f` : Affiche le nombre avec **exactement deux chiffres** après la virgule (parfait pour les prix).
        
    *   `%g` : Choisit automatiquement le format le plus compact (`%f` ou la notation scientifique). 
        
        content\_copy
        
            prix := 49.95
            fmt.Printf("Prix standard: %f, Prix formaté: %.2f€\n", prix, prix)
            // Affiche : Prix standard: 49.950000, Prix formaté: 49.95€
             
        
*   **Pour les `bool` :**
    
    *   `%t` : Affiche `true` ou `false`.
        

#### **Le verbe de débogage : `%T`**

Un verbe extrêmement utile pour apprendre et déboguer est `%T`. Il n'affiche pas la valeur de la variable, mais son **type**.

content\_copy

    nom := "Charles"
    age := 50
    
    fmt.Printf("La variable 'nom' a la valeur %q et est de type %T\n", nom, nom)
    fmt.Printf("La variable 'age' a la valeur %v et est de type %T\n", age, age)
    // Affiche :
    // La variable 'nom' a la valeur "Charles" et est de type string
    // La variable 'age' a la valeur 50 et est de type int

#### **Ajouter des modificateurs : largeur et `padding`**

`Printf` vous permet aussi de contrôler la largeur et l'alignement, ce qui est très utile pour créer des tableaux bien alignés.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        fmt.Printf("|%10s|%10s|\n", "Prénom", "Nom")
        fmt.Printf("|%10s|%10s|\n", "Alice", "Dubois")
        fmt.Printf("|%10s|%10s|\n", "Bob", "Martin")
    }
    
    
    
    Résultat :
    
    |    Prénom|       Nom|
    |     Alice|    Dubois|
    |       Bob|    Martin|

`%10s` signifie : "Réserve un espace de 10 caractères pour cette chaîne. Si la chaîne est plus courte, ajoute des espaces à gauche (alignement à droite par défaut)".

Pour aligner à gauche, utilisez un signe moins : `%-10s`.

### **Les autres fonctions de la famille `Print`**

`Printf` a deux cousines très utiles :

#### **`fmt.Sprintf` : créer une chaîne au lieu de l'afficher**

Parfois, vous ne voulez pas afficher immédiatement le résultat dans la console. Vous voulez peut-être le stocker dans une variable pour l'utiliser plus tard (l'enregistrer dans un fichier, l'envoyer sur un réseau, etc.).

C'est le rôle de `fmt.Sprintf` (`_String Print Format_`). Elle fonctionne exactement comme `fmt.Printf`, mais au lieu d'afficher le résultat, elle le **retourne sous forme d'une nouvelle variable `string`**.

#### **`fmt.Fprintf` : écrire dans un fichier ou sur le réseau**

`fmt.Fprintf` (`_File Print Format_`) est similaire à `Printf`, mais elle prend un premier argument supplémentaire : un endroit où écrire la sortie.

Cet "endroit" peut être un fichier, une connexion réseau, ou toute autre destination qui satisfait l'interface `io.Writer`.

C'est un concept un peu avancé, mais il est bon de savoir qu'elle existe. C'est la fonction que vous utiliserez pour écrire des logs formatés dans un fichier, par exemple.

Nous la reverrons plus tard.

### Sur cette page

*   Mise en forme des chaînes (fmt)
*   fmt.Printf : le "texte à trous" de vos données
*   Les verbes de formatage essentiels
*   Le verbe universel : %v
*   Les verbes spécifiques par type
*   Le verbe de débogage : %T
*   Ajouter des modificateurs : largeur et padding
*   Les autres fonctions de la famille Print
*   fmt.Sprintf : créer une chaîne au lieu de l'afficher
*   fmt.Fprintf : écrire dans un fichier ou sur le réseau