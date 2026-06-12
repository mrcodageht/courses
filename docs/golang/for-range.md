Dans la leçon précédente, nous avons exploré les formes classiques de la boucle `for`.

Elles sont parfaites pour des répétitions basées sur un compteur ou une condition.

Cependant, une des tâches les plus courantes en programmation est de parcourir les éléments d'une collection de données (comme une liste de noms, un panier d'achats, etc.).

Pour ce cas de figure, `Go` propose une forme spéciale de la boucle `for` qui est plus simple, plus sûre et plus lisible : la boucle `for...range`.

_Nous verrons les collections très en détail dans un chapitre dédié mais il faut quand même les aborder brièvement ici pour voir `for... range`._

### **Le `for...range` : parcourir des collections**

La boucle `for...range` est la manière idiomatique en `Go` de parcourir chaque élément d'une collection.

Elle fonctionne sur les `slices`, les `arrays`, les `maps`, les `strings` et les `channels`.

**Syntaxe :**

content\_copy

    for index, valeur := range maCollection {
        // Bloc de code à exécuter pour chaque élément
    }

À chaque tour de boucle, `for...range` vous fournit deux variables :

1.  `index` : la position de l'élément dans la collection (ou sa **clé** s'il s'agit d'une `map`).
    
2.  `valeur` : une **copie** de la valeur de l'élément lui-même.
    

### **Parcourir une `slice`**

C'est l'utilisation la plus fréquente.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Une slice est une liste dynamique, nous la verrons en détail plus tard.
        noms := []string{"Alice", "Bob", "Charlie"}
    
        for index, nom := range noms {
            fmt.Printf("À l'index %d, le nom est %s\n", index, nom)
        }
    }

**Résultat :**

content\_copy

    À l'index 0, le nom est Alice
    À l'index 1, le nom est Bob
    À l'index 2, le nom est Charlie

### **Ignorer l'index ou la valeur**

Parfois, l'une des deux variables retournées par `range` ne vous intéresse pas.

En `Go`, vous ne pouvez pas déclarer une variable sans l'utiliser.

La solution est d'utiliser l'**identifiant vide** (le _blank identifier_), représenté par un tiret bas `_`.

#### **Ignorer l'index**

Si seule la valeur vous intéresse, remplacez `index` par `_`.

content\_copy

    noms := []string{"Alice", "Bob", "Charlie"}
    
    for _, nom := range noms {
        fmt.Println("Bonjour,", nom)
    }
     

#### **Ignorer la valeur**

Si seul l'index vous intéresse, remplacez `valeur` par `_`.

content\_copy

    noms := []string{"Alice", "Bob", "Charlie"}
    
    for index := range noms { // Si on omet la deuxième variable, Go ne retourne que l'index.
        fmt.Printf("Traitement de l'élément à l'index %d\n", index)
    }

_Note : Si vous n'avez besoin que de l'index, vous pouvez simplement omettre la deuxième variable, comme dans l'exemple ci-dessus._

### **Parcourir une chaîne de caractères (`string`)**

C'est un cas d'usage très important qui montre la puissance de `for...range`.

Comme nous l'avons vu dans le chapitre sur les types, une `string` en `Go` est une séquence de `bytes` encodée en `UTF-8`.

Une boucle `for` classique parcourrait les `**bytes**`, ce qui donnerait des résultats incorrects pour les caractères accentués ou les emojis.

La boucle `for...range`, elle, parcourt intelligemment les `**runes**` (les caractères conceptuels).

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        mot := "café"
    
        fmt.Println("Avec une boucle for...range (correct) :")
        for index, caractere := range mot {
            // %c affiche le caractère, %q l'affiche entre apostrophes.
            fmt.Printf("Index: %d, Caractère: %q\n", index, caractere)
        }
    }

**Résultat :**

content\_copy

    Avec une boucle for...range (correct) :
    Index: 0, Caractère: 'c'
    Index: 1, Caractère: 'a'
    Index: 2, Caractère: 'f'
    Index: 3, Caractère: 'é'

La boucle a correctement identifié les 4 caractères du mot.

### Sur cette page

*   Le for...range : parcourir des collections
*   Parcourir une slice
*   Ignorer l'index ou la valeur
*   Ignorer l'index
*   Ignorer la valeur
*   Parcourir une chaîne de caractères (string)