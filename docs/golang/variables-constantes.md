### Variables et constantes

Un programme manipule des données : des noms d'utilisateurs, des scores, des âges, des adresses...

Pour pouvoir travailler avec ces données, nous devons leur donner un nom et les stocker quelque part en mémoire.

C'est le rôle des **variables** et des **constantes**.

### **Les variables : des boîtes pour vos données**

Pensez à une variable comme à une **boîte étiquetée** conçue pour contenir une information.

*   **L'étiquette** est le nom de la variable (par exemple, `age`). C'est ainsi que vous y ferez référence.
    
*   **Le contenu de la boîte** est la valeur que vous y mettez (par exemple, `30`).
    
*   **Le type de boîte** indique ce que vous avez le droit d'y mettre (par exemple, une boîte pour les nombres, une boîte pour le texte). `Go` est un langage **statiquement typé**, ce qui signifie que vous ne pouvez pas mettre du texte dans une boîte prévue pour des nombres.
    

L'intérêt principal d'une variable est que son contenu peut **changer** au cours de l'exécution du programme.

#### **La déclaration explicite avec `var`**

C'est la manière la plus formelle et la plus descriptive de déclarer une variable. On est très précis en indiquant le nom et le type.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // On déclare une variable nommée "age" qui contiendra un nombre entier (int).
        var age int
        // Pour l'instant, la "boîte" est vide. Go lui donne une valeur par défaut : 0 pour les nombres.
        fmt.Println("Mon âge est :", age) // Affiche: Mon âge est : 0
    
        // Maintenant, on met une valeur dans la boîte.
        age = 35
        fmt.Println("Mon âge est maintenant :", age) // Affiche: Mon âge est maintenant : 35
    
        // On peut aussi déclarer et initialiser sur la même ligne.
        var nom string = "Alice"
        fmt.Println("Bonjour,", nom) // Affiche: Bonjour, Alice
    }

_Nous verrons les types dans la prochaine leçon ne vous focalisez pas dessus._

**La valeur zéro (`zero value`)** : un concept important en `Go` est la **valeur zéro**. Lorsque vous déclarez une variable avec `var` sans lui donner de valeur, `Go` ne la laisse pas indéfinie. Il l'initialise automatiquement à une valeur "zéro" qui dépend de son type :

*   `0` pour les types numériques (`int`, `float64`, etc.)
    
*   `""` (une chaîne vide) pour les `string`
    
*   `false` pour les `bool`
    

**C'est une garantie de sécurité : vous ne tomberez jamais sur une variable qui n'a "aucune" valeur.**

#### **L'inférence de type avec `:=`**

C'est la manière la plus courante et la plus idiomatique de déclarer une variable en `Go`.

C'est un raccourci qui combine la déclaration et l'initialisation.

L'opérateur `:=` (appelé "`short variable declaration`" ou "opérateur morse") dit à Go : "Crée une nouvelle variable, regarde le type de la valeur que je te donne, et déduis-en le type de la variable tout seul".

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Go voit que "Bob" est une chaîne de caractères (string)
        // et crée une variable `nom` de type string.
        nom := "Bob"
    
        // Go voit que 42 est un nombre entier (int)
        // et crée une variable `age` de type int.
        age := 42
    
        // Go voit que true est un booléen (bool)
        // et crée une variable `estMajeur` de type bool.
        estMajeur := true
    
        fmt.Println(nom, "a", age, "ans. Est-il majeur ?", estMajeur)
        // Affiche: Bob a 42 ans. Est-il majeur ? true
    }

**Important : l'opérateur `:=`** **ne peut être utilisé qu'à l'intérieur d'une fonction.**

Pour déclarer une variable accessible à tout votre paquet (en dehors d'une fonction), vous devez utiliser la forme `var`.

#### `var` vs. `:=` en `Go`

En `Go`, la règle générale est simple : **privilégiez l’opérateur de déclaration courte `:=` à l’intérieur des fonctions**.

_Nous reverrons toutes ces notions en détail tout au long de la formation, mais pour une première approche, voici quoi garder en tête._

**`:=` n’est pas autorisé en dehors d’une fonction.**

**Quand utiliser `:=` en `Go` :**

*   À l’intérieur d’une fonction.
    
*   Quand vous déclarez **et initialisez immédiatement** une variable.
    
*   Quand vous laissez `Go` **déduire automatiquement le type** (inférence).
    
*   Dans la grande majorité des cas, car c’est la forme la plus idiomatique et lisible.
    

**Quand utiliser `var` en `Go` :**

*   Lors d’une déclaration **au niveau du `package`** (hors fonction).
    
*   Lorsqu’une variable doit être **déclarée sans valeur initiale** (elle prendra sa `_zero value_`).
    
*   Quand vous devez **spécifier explicitement le type** d’une variable.
    
*   Pour **déclarer plusieurs variables liées dans un bloc** `var(...)`.
    

### **Les constantes : des valeurs gravées dans le marbre**

Une constante est comme une variable, mais avec une règle très stricte : une fois que vous lui avez donné une valeur, **vous ne pouvez plus jamais la changer**.

Sa valeur est fixée au moment de la compilation.

On les utilise pour des valeurs qui sont connues à l'avance et ne doivent pas varier, comme la valeur de `Pi`, le nombre de jours dans une semaine, ou une clé d'`API`.

#### **Déclaration avec `const`**

On utilise le mot-clé `const`. La valeur doit être assignée immédiatement

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Cette constante est "non typée". Go lui donnera un type précis
        // au moment où elle sera utilisée. C'est la forme la plus flexible.
        const pi = 3.14159
        const joursParSemaine = 7
    
        fmt.Println("La valeur de Pi est", pi)
    
        // La ligne suivante produirait une erreur de compilation !
        // pi = 3.14 // Erreur: cannot assign to pi
    }

#### **`iota` : le compteur de constantes**

`Go` fournit un mot-clé spécial, `iota`, qui simplifie la déclaration de constantes qui s'incrémentent.

`iota` est un compteur qui commence à `0` dans un bloc `const` et sa valeur augmente de 1 à chaque nouvelle ligne.

content\_copy

    package main
    
    import "fmt"
    
    const (
        Lundi = iota // iota = 0
        Mardi        // iota = 1
        Mercredi     // iota = 2
        Jeudi        // iota = 3
        Vendredi     // iota = 4
        Samedi       // iota = 5
        Dimanche     // iota = 6
    )
    
    func main() {
        fmt.Println("Mardi correspond à la valeur :", Mardi)     // Affiche: 1
        fmt.Println("Vendredi correspond à la valeur :", Vendredi) // Affiche: 4
    }

C'est très utile pour créer des énumérations simples ou des ensembles de valeurs liées. `iota` peut aussi être utilisé dans des expressions plus complexes pour créer des séquences plus avancées (par exemple, pour des masques de bits).

### Sur cette page

*   Variables et constantes
*   Les variables : des boîtes pour vos données
*   La déclaration explicite avec var
*   L'inférence de type avec :=
*   var vs. := en Go
*   Les constantes : des valeurs gravées dans le marbre
*   Déclaration avec const
*   iota : le compteur de constantes