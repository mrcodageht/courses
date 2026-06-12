Nous maîtrisons maintenant les différentes manières de créer des boucles en `Go`.

Cependant, il arrive souvent que nous n'ayons pas besoin d'exécuter _toutes_ les itérations d'une boucle.

Parfois, nous voulons l'arrêter prématurément une fois qu'une condition est remplie, ou simplement sauter une itération qui ne nous intéresse pas.

`Go` nous fournit deux mots-clés très puissants pour contrôler finement le flux d'exécution à l'intérieur d'une boucle : `break` et `continue`.

### **Sortir d'une boucle avec `break`**

Le mot-clé `break` a un rôle très simple et direct : il **termine immédiatement** la boucle dans laquelle il se trouve.

Le programme saute alors à la première ligne de code qui suit la boucle.

C'est l'outil que vous utiliserez lorsque vous cherchez quelque chose et que vous l'avez trouvé, ou lorsqu'une condition d'erreur se produit et que continuer la boucle n'a plus de sens.

#### **Exemple : trouver le premier nombre divisible par 7**

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Nous cherchons le premier nombre entre 10 et 100 qui est divisible par 7.
        for i := 10; i <= 100; i++ {
            fmt.Printf("Test du nombre %d...\n", i)
            if i%7 == 0 { // Si le reste de la division par 7 est 0...
                fmt.Printf("Trouvé ! %d est le premier nombre divisible par 7.\n", i)
                break // ...on a trouvé ce qu'on cherchait, on arrête la boucle.
            }
        }
    
        fmt.Println("La boucle est terminée.")
    }

**Résultat :**

content\_copy

    Test du nombre 10...
    Test du nombre 11...
    Test du nombre 12...
    Test du nombre 13...
    Test du nombre 14...
    Trouvé ! 14 est le premier nombre divisible par 7.
    La boucle est terminée.

Comme vous pouvez le voir, la boucle s'est arrêtée à `i = 14` et n'a pas continué jusqu'à 100, car le `break` a forcé sa sortie.

### **Sauter une itération avec `continue`**

Le mot-clé `continue` est moins radical que `break`. Il n'arrête pas la boucle, mais il **interrompt l'itération en cours** et passe directement au début de la **prochaine itération**.

Tout le code qui se trouve après le `continue` dans le bloc de la boucle est ignoré pour cette itération. C'est utile lorsque vous voulez traiter uniquement certains éléments d'une collection et ignorer les autres.

#### **Exemple : afficher uniquement les nombres impairs**

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        for i := 0; i < 10; i++ {
            // Si le nombre est pair...
            if i%2 == 0 {
                continue // ...on saute le reste de cette itération et on passe à la suivante.
            }
    
            // Cette ligne n'est exécutée que si le 'continue' n'a pas été déclenché.
            fmt.Printf("Nombre impair : %d\n", i)
        }
    }

**Résultat :**

content\_copy

    Nombre impair : 1
    Nombre impair : 3
    Nombre impair : 5
    Nombre impair : 7
    Nombre impair : 9

Chaque fois que `i` était pair, le `continue` a été exécuté, et l'appel à `fmt.Printf` a été sauté.

### **`break` et `continue` avec des labels (avancé)**

Que se passe-t-il si vous avez des boucles imbriquées ? Par défaut, `break` et `continue` n'agissent que sur la boucle la plus interne.

content\_copy

    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            if j == 1 {
                break // Ce break ne sort que de la boucle sur 'j'.
            }
        }
    }

Pour sortir de plusieurs boucles imbriquées d'un seul coup, vous pouvez utiliser un **label**. Un label est simplement un nom que vous donnez à une boucle.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
    BoucleExterne: // On donne un nom à notre boucle externe.
        for i := 0; i < 3; i++ {
            for j := 0; j < 3; j++ {
                fmt.Printf("i=%d, j=%d\n", i, j)
                if i == 1 && j == 1 {
                    fmt.Println("Sortie de la boucle externe !")
                    break BoucleExterne // On sort de la boucle nommée 'BoucleExterne'.
                }
            }
        }
        fmt.Println("Fin du programme.")
    }
     

**Résultat :**

content\_copy

    i=0, j=0
    i=0, j=1
    i=0, j=2
    i=1, j=0
    i=1, j=1
    Sortie de la boucle externe !
    Fin du programme.

### Sur cette page

*   Sortir d'une boucle avec break
*   Exemple : trouver le premier nombre divisible par 7
*   Sauter une itération avec continue
*   Exemple : afficher uniquement les nombres impairs
*   break et continue avec des labels (avancé)