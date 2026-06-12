Dans la leçon précédente, nous avons vu comment utiliser les chaînes de `if`, `else if` et `else` pour gérer différentes conditions.

C'est une approche très puissante, mais lorsque vous devez tester une seule variable contre une multitude de valeurs possibles, le code peut rapidement devenir lourd et répétitif.

`Go` propose une alternative plus propre, plus lisible et souvent plus efficace pour ce cas de figure : l'instruction `switch`.

### **Le `switch` simple : tester une valeur**

La forme la plus courante du `switch` est de prendre une variable et de comparer sa valeur à une liste de "cas" (`case`).

**Syntaxe :**

content\_copy

    switch variable {
    case valeur1:
        // Bloc de code si variable == valeur1
    case valeur2:
        // Bloc de code si variable == valeur2
    default:
        // Bloc de code si aucune des valeurs précédentes ne correspond
    }

`Go` évalue la `variable` une seule fois, puis la compare à chaque `case` dans l'ordre.

**Dès qu'il trouve une correspondance, il exécute le bloc de code associé et sort immédiatement du `switch`.**

C'est un comportement important : contrairement à d'autres langages, il n'y a pas de "`fallthrough`" (continuation au cas suivant) par défaut

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        jour := "mardi"
    
        switch jour {
        case "lundi":
            fmt.Println("Début de la semaine de travail.")
        case "mardi":
            fmt.Println("On continue sur la lancée.")
        case "vendredi":
            fmt.Println("Bientôt le week-end !")
        case "samedi", "dimanche": // Un 'case' peut tester plusieurs valeurs
            fmt.Println("C'est le week-end !")
        default: // Le cas par défaut est optionnel
            fmt.Println("Un jour ordinaire.")
        }
    }
     

**Résultat :** `On continue sur la lancée.`

### **Le `switch` sans expression : un `if/else` plus propre**

`Go` permet une forme de `switch` très idiomatique où vous n'indiquez pas de variable après le mot-clé `switch`.

Dans ce cas, le `switch` se comporte comme une chaîne `if/else if/else` plus propre.

Chaque `case` peut alors contenir une condition booléenne complète.

C'est souvent plus lisible qu'une longue série de `if/else if/else` :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        note := 85
    
        switch { // Pas de variable ici !
        case note >= 90:
            fmt.Println("Mention : Excellent (A)")
        case note >= 80:
            fmt.Println("Mention : Très Bien (B)")
        case note >= 70:
            fmt.Println("Mention : Bien (C)")
        default:
            fmt.Println("Mention : Passable (D)")
        }
    }
     

**Résultat :** `Mention : Très Bien (B)`

Ce code fait exactement la même chose que l'exemple avec `if/else if` de la leçon précédente, mais il est souvent considéré comme plus clair car il aligne toutes les conditions verticalement.

### **Le mot-clé `fallthrough` (à utiliser avec prudence)**

Comme nous l'avons dit, `Go` sort d'un `switch` dès qu'un `case` est exécuté.

Si, pour une raison très spécifique, vous voulez forcer l'exécution à continuer dans le bloc `case` **immédiatement suivant**, vous pouvez utiliser le mot-clé `fallthrough`.

Son usage est **extrêmement rare** et est souvent un signe que votre logique pourrait être simplifiée. Il est surtout présent pour des raisons de compatibilité avec d'autres langages

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        nombre := 2
    
        switch nombre {
        case 1:
            fmt.Println("Un")
        case 2:
            fmt.Println("Deux")
            fallthrough // Attention : force l'exécution du cas suivant !
        case 3:
            fmt.Println("Trois")
        default:
            fmt.Println("Autre")
        }
    }
     

**Résultat :**

content\_copy

    Deux
    Trois

Notez que `Trois` est affiché, même si `nombre` ne vaut pas 3.

### **`switch` avec déclaration courte**

Tout comme le `if`, le `switch` peut inclure une instruction de déclaration courte, ce qui est très pratique pour limiter la portée d'une variable :

content\_copy

    package main
    
    import "fmt"
    
    func getJour() string {
        return "mercredi"
    }
    
    func main() {
        switch jour := getJour(); jour {
        case "samedi", "dimanche":
            fmt.Println(jour, ": c'est le week-end !")
        default:
            fmt.Println(jour, ": c'est un jour de semaine.")
        }
    
        // Erreur de compilation ! 'jour' n'existe pas ici.
        // fmt.Println(jour)
    }

### Sur cette page

*   Le switch simple : tester une valeur
*   Le switch sans expression : un if/else plus propre
*   Le mot-clé fallthrough (à utiliser avec prudence)
*   switch avec déclaration courte