Dans ce chapitre, nous allons apprendre à contrôler le **flux d'exécution** de notre programme.

Jusqu'à présent, notre code s'exécute de manière linéaire, du haut vers le bas, sans jamais dévier. Les structures de contrôle nous permettent de prendre des décisions et de répéter des actions, rendant nos programmes dynamiques et intelligents.

La structure de contrôle la plus fondamentale est la condition `if`.

Elle permet à votre programme de poser une question et d'exécuter un bloc de code uniquement si la réponse est "vrai".

Pensez à un GPS : **si** la prochaine sortie est la vôtre, **alors** tournez à droite. Sinon, continuez tout droit. C'est exactement ce que nous allons apprendre à faire.

### **La condition `if` simple**

La forme la plus simple du `if` teste une seule condition.

**Syntaxe :**

content\_copy

    if condition {
        // Ce bloc de code est exécuté si la 'condition' est true.
    }
     

La `condition` doit toujours être une expression qui retourne une valeur booléenne (`true` ou `false`).

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        age := 20
    
        // On pose la question : "est-ce que age est supérieur ou égal à 18 ?"
        if age >= 18 {
            // La réponse est 'true', donc ce bloc est exécuté.
            fmt.Println("Vous êtes majeur.")
        }
    
        temperature := 15
        if temperature > 25 {
            // La réponse est 'false', donc ce bloc est ignoré.
            fmt.Println("C'est une journée chaude !")
        }
    }
     

**Important :** en `Go`, les accolades `{}` sont **obligatoires**, même si le bloc ne contient qu'une seule ligne.

### **Ajouter une alternative avec `else`**

Souvent, vous voulez faire quelque chose si la condition est vraie, et **autre chose** si elle est fausse.

C'est le rôle du `else`.

**Syntaxe :**

content\_copy

    if condition {
        // Exécuté si la condition est true.
    } else {
        // Exécuté si la condition est false.
    }
    ```go
    package main
    
    import "fmt"
    
    func main() {
        nombre := 7
    
        if nombre%2 == 0 { // Le modulo 2 est 0 si le nombre est pair.
            fmt.Println("Le nombre est pair.")
        } else {
            // La condition était false, donc on exécute ce bloc.
            fmt.Println("Le nombre est impair.")
        }
    }
     

content\_copy

    Le nombre est impair.

### **Enchaîner les conditions avec `else if`**

Que faire si vous avez plus de deux possibilités ?

Vous pouvez enchaîner plusieurs questions avec `else if`.

**Syntaxe :**

content\_copy

    if premiereCondition {
        // ...
    } else if deuxiemeCondition {
        // ...
    } else {
        // ... (exécuté si aucune des conditions précédentes n'est vraie)
    }
     

`Go` évalue les conditions dans l'ordre.

Dès qu'il en trouve une qui est `true`, il exécute le bloc correspondant et ignore toutes les autres.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        note := 85
    
        if note >= 90 {
            fmt.Println("Mention : Excellent (A)")
        } else if note >= 80 {
            // La première condition (>= 90) était false.
            // On teste la deuxième (>= 80), qui est true.
            // On exécute ce bloc et on s'arrête là.
            fmt.Println("Mention : Très Bien (B)")
        } else if note >= 70 {
            fmt.Println("Mention : Bien (C)")
        } else {
            fmt.Println("Mention : Passable (D)")
        }
    }

**Résultat :** `Mention : Très Bien (B)`

### **L'idiome `Go` : déclaration courte dans le `if`**

`Go` propose une syntaxe spéciale et très idiomatique qui vous permet de déclarer une variable et de la tester dans la même ligne.

**Syntaxe :**

content\_copy

    if variable := expression; condition {
        // La 'variable' n'est visible qu'à l'intérieur de ce bloc if/else.
    }

Cette syntaxe est extrêmement utile, notamment avec les fonctions qui retournent une valeur et une erreur.

content\_copy

    package main
    
    import (
        "fmt"
        "strconv"
    )
    
    func main() {
        // La fonction Atoi peut retourner une erreur.
        // On déclare 'nombre' et 'err' directement dans le if.
        if nombre, err := strconv.Atoi("123"); err != nil {
            // Ce bloc est exécuté si une erreur est survenue.
            // 'nombre' et 'err' sont accessibles ici.
            fmt.Println("Erreur de conversion :", err)
        } else {
            // Ce bloc est exécuté si la conversion a réussi.
            // 'nombre' et 'err' sont aussi accessibles ici.
            fmt.Println("Le nombre est :", nombre)
        }
    
        // Erreur de compilation ! 'nombre' et 'err' n'existent plus
        // en dehors du bloc if/else.
        // fmt.Println(nombre)
    }

L'avantage principal est la **portée limitée**.

Les variables déclarées de cette manière n'existent que pour la durée de la condition, ce qui rend le code plus propre et évite de "polluer" la portée de la fonction avec des variables temporaires.

_Nous verrons les portées en détail plus tard._

### Sur cette page

*   La condition if simple
*   Ajouter une alternative avec else
*   Enchaîner les conditions avec else if
*   L'idiome Go : déclaration courte dans le if