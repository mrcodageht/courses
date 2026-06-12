Nous savons maintenant comment prendre des décisions et exécuter du code de manière conditionnelle.

L'autre pilier des structures de contrôle est la capacité à **répéter des actions**. En programmation, on appelle cela une **boucle**.

`Go` est minimaliste dans sa conception : il ne possède qu'un seul mot-clé pour toutes les formes de boucles : `for`.

Cependant, ce mot-clé est extrêmement polyvalent et peut être utilisé de plusieurs manières différentes, que nous allons explorer dans cette leçon.

### **La forme classique (avec 3 composantes)**

La forme la plus structurée de la boucle `for` est composée de trois parties, séparées par des points-virgules.

C'est la forme que vous utiliserez lorsque vous savez à l'avance combien de fois vous voulez répéter une action.

**Syntaxe :**

content\_copy

    for initialisation; condition; post-instruction {
        // Bloc de code à répéter
    }

*   **`initialisation`** : exécutée **une seule fois** au début. On y déclare généralement un compteur (ex: `i := 0`).
    
*   **`condition`** : évaluée **avant chaque tour**. Tant qu'elle est `true`, la boucle continue.
    
*   **`post-instruction`** : exécutée **à la fin de chaque tour**. On y met à jour le compteur (ex: `i++`).
    

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Affiche les nombres de 0 à 4.
        for i := 0; i < 5; i++ {
            fmt.Printf("Itération numéro %d\n", i)
        }
    }

**Déroulement de l'exécution, pas à pas**

Pour bien comprendre, suivons l'ordinateur à la trace :

1.  **Initialisation :** la variable `i` est créée et sa valeur est initialisée à `0`. Cette étape ne se produit qu'une seule fois.
    
2.  **Tour 1 :**
    
    *   **Condition :** le programme vérifie si `i < 5` (est-ce que `0 < 5` ?). La réponse est `true`, donc on entre dans la boucle.
        
    *   **Exécution :** le code à l'intérieur des accolades est exécuté. `fmt.Printf` affiche "Itération numéro 0".
        
    *   **Post-instruction :** l'instruction `i++` est exécutée. La valeur de `i` est maintenant `1`.
        
3.  **Tour 2 :**
    
    *   **Condition :** le programme vérifie si `i < 5` (est-ce que `1 < 5` ?). C'est `true`.
        
    *   **Exécution :** affiche "Itération numéro 1".
        
    *   **Post-instruction :** `i++` est exécuté. `i` vaut maintenant `2`.
        
4.  **... (Les tours 3 et 4 se déroulent de la même manière)**
    
5.  **Tour 5 :**
    
    *   **Condition :** le programme vérifie si `i < 5` (est-ce que `4 < 5` ?). C'est `true`.
        
    *   **Exécution :** affiche "Itération numéro 4".
        
    *   **Post-instruction :** `i++` est exécuté. `i` vaut maintenant `5`.
        
6.  **Dernière vérification :**
    
    *   **Condition :** le programme vérifie si `i < 5` (est-ce que `5 < 5` ?). La réponse est `false`.
        
    *   **Arrêt :** la condition étant fausse, la boucle se termine immédiatement. Le programme continue son exécution à la première ligne de code située après l'accolade fermante de la boucle.
        

**Important :** la variable `i` déclarée dans l'instruction `for` a une **portée de bloc**. Elle n'existe qu'à l'intérieur de la boucle et ne peut pas être utilisée en dehors.

### **La forme "`while`" (avec condition seule)**

Dans d'autres langages, il existe une boucle `while` pour répéter une action tant qu'une condition est vraie, sans avoir besoin d'un compteur formel.

En `Go`, on obtient le même comportement en utilisant `for` avec uniquement la partie `condition`.

**Syntaxe :**

content\_copy

    for condition {
        // Bloc de code à répéter
    }

C'est utile lorsque le nombre d'itérations n'est pas connu à l'avance.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        nombre := 1
    
        // Tant que 'nombre' est inférieur ou égal à 5...
        for nombre <= 5 {
            fmt.Println("Le nombre est :", nombre)
            nombre++ // ...on l'affiche et on l'incrémente.
        }
    }

**Résultat :**

content\_copy

    Le nombre est : 1
    Le nombre est : 2
    Le nombre est : 3
    Le nombre est : 4
    Le nombre est : 5

### **La boucle infinie**

Si vous omettez complètement les trois parties, vous créez une boucle infinie. Elle s'exécutera éternellement, à moins qu'on ne l'arrête de l'intérieur avec une instruction comme `break` (que nous verrons plus tard).

**Syntaxe :**

content\_copy

    for {
        // Ce code se répétera à l'infini.
    }
     

Les boucles infinies sont très courantes pour les programmes qui doivent tourner en continu, comme un serveur web qui attend des requêtes ou un programme qui écoute des événements.

content\_copy

    package main
    
    import (
        "fmt"
        "time"
    )
    
    func main() {
        // Boucle infinie qui affiche un message toutes les secondes.
        // Pour l'arrêter, vous devrez utiliser Ctrl+C dans votre terminal.
        for {
            fmt.Println("Le programme tourne...")
            time.Sleep(1 * time.Second)
        }
    }

### Sur cette page

*   La forme classique (avec 3 composantes)
*   La forme "while" (avec condition seule)
*   La boucle infinie