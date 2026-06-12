### **Les opérateurs arithmétiques**

Ce sont les opérateurs mathématiques de base que vous connaissez déjà. Ils fonctionnent avec les types numériques (`int`, `float64`, etc.).

Opérateur

Description

Exemple

Résultat

`+`

Addition

`10 + 5`

`15`

`-`

Soustraction

`10 - 5`

`5`

`*`

Multiplication

`10 * 5`

`50`

`/`

Division

`10 / 5`

`2`

`%`

Modulo (reste de la division)

`10 % 3`

`1`

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        a := 15
        b := 4
    
        fmt.Printf("Addition: %d + %d = %d\n", a, b, a+b)
        fmt.Printf("Soustraction: %d - %d = %d\n", a, b, a-b)
        fmt.Printf("Multiplication: %d * %d = %d\n", a, b, a*b)
        fmt.Printf("Division (entière): %d / %d = %d\n", a, b, a/b)
        fmt.Printf("Modulo: %d %% %d = %d\n", a, b, a%b) // On double le % pour l'échapper dans Printf
    }

**Attention au piège de la division entière !** Regardez le résultat de la division : `15 / 4 = 3`, et non `3.75`.

En `Go`, lorsque vous divisez deux entiers (`int`), le résultat est toujours un entier. La partie décimale est simplement **tronquée** (coupée).

Nous verrons comment gérer cela dans la section sur les conversions.

### **Incrémentation et décrémentation (`++` et `--`)**

Go possède aussi des opérateurs pour ajouter ou soustraire 1 à une variable.

*   `x++` est un raccourci pour `x = x + 1`
    
*   `x--` est un raccourci pour `x = x - 1`
    

**Important :** contrairement à d'autres langages, en `Go`, `++` et `--` sont des **instructions**, pas des expressions.

Cela signifie qu'ils ne retournent pas de valeur. Vous ne pouvez pas écrire `y := x++`.

content\_copy

    compteur := 5
    compteur++ // compteur vaut maintenant 6
    fmt.Println("Compteur :", compteur)

### **Les opérateurs de comparaison**

Ces opérateurs comparent deux valeurs et retournent toujours un résultat booléen (`true` ou `false`).

Ils sont essentiels pour la logique conditionnelle.

Opérateur

Description

Exemple

Résultat

`==`

Égal à

`5 == 5`

`true`

`!=`

Différent de

`5 != 5`

`false`

`<`

Inférieur à

`5 < 8`

`true`

`>`

Supérieur à

`5 > 8`

`false`

`<=`

Inférieur ou égal à

`5 <= 5`

`true`

`>=`

Supérieur ou égal à

`5 >= 8`

`false`

Ces opérateurs fonctionnent aussi avec les `string`, où ils effectuent une comparaison lexicographique (ordre alphabétique).

`"apple" < "banana"` est `true`.

### **Les opérateurs logiques**

Ces opérateurs permettent de combiner plusieurs expressions booléennes pour créer une logique plus complexe.

Opérateur

Description

Exemple

`&&`

ET logique (vrai si les deux côtés sont vrais)

`age >= 18 && aLePermis == true`

`||`

OU logique (vrai si un des côtés est vrai)

`age >= 18 || aLePermis == true`

`!`

NON logique (inverse la valeur booléenne)

`!estBanni`

**Le court-circuit (`short-circuiting`)**

`Go` optimise l'évaluation de ces opérateurs :

*   Pour `A && B`, si `A` est `false`, `Go` ne prend même pas la peine d'évaluer `B`, car le résultat sera forcément `false`.
    
*   Pour `A || B`, si `A` est `true`, `Go` n'évalue pas `B`, car le résultat sera forcément `true`.
    

C'est un comportement important à connaître pour la performance et pour éviter des erreurs.

### **Les conversions de type explicites**

**`Go` est très strict sur les types.**

Vous ne pouvez **jamais** effectuer une opération entre deux variables de types différents, même s'ils semblent compatibles (comme `int` et `float64`).

`Go` ne fera jamais de conversion de type "magique" ou implicite pour vous. C'est une mesure de sécurité pour éviter les bugs inattendus.

Pour effectuer une opération entre différents types, vous devez **explicitement** convertir l'une des valeurs dans le type de l'autre.

La syntaxe est simple : `TypeDestination(valeurAConvertir)`.

Reprenons notre problème de division entière :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        nombreDePoints := 100
        nombreDeJoueurs := 3
    
        // La bonne façon : on convertit un des entiers en float64 AVANT la division.
        scoreMoyen := float64(nombreDePoints) / float64(nombreDeJoueurs)
    
        fmt.Printf("Le score moyen est de : %.2f\n", scoreMoyen)
    }

**Résultat :** `Le score moyen est de : 33.33`

### **Cas spécial : convertir vers et depuis `string`**

La conversion entre les nombres et les chaînes de caractères est une opération très courante, mais elle ne se fait pas avec la syntaxe `string(nombre)`.

Pour cela, `Go` nous fournit un paquet spécialisé : `strconv` (`_string conversion_`) :

content\_copy

    package main
    
    import (
        "fmt"
        "strconv"
    )
    
    func main() {
        // De string vers int
        chaineDeNombre := "123"
        // Atoi (ASCII to integer) peut échouer (ex: si la chaîne est "abc"),
        // donc elle retourne un résultat ET une erreur. Nous verrons la gestion
        // des erreurs en détail plus tard.
        nombre, _ := strconv.Atoi(chaineDeNombre)
        fmt.Printf("Le nombre est %d (type %T)\n", nombre, nombre)
    
        // De int vers string
        age := 42
        chaineAge := strconv.Itoa(age) // Itoa (Integer to ASCII)
        fmt.Printf("L'âge en chaîne est \"%s\" (type %T)\n", chaineAge, chaineAge)
    }
     

_Nous reverrons cela en détail dans le chapitre sur les chaînes de caractères et les nombres._

**Attention à la perte de données !**

La conversion est une opération qui peut entraîner une perte d'information. Par exemple, si vous convertissez un `float64` en `int`, la partie décimale sera perdue.

content\_copy

    prix := 99.99
    prixEnEntier := int(prix) // La partie .99 est tronquée
    
    fmt.Println("Le prix en entier est :", prixEnEntier) // Affiche 99
     

_Nous le reverrons également en détail dans le chapitre sur les chaînes de caractères et les nombres._

### Sur cette page

*   Les opérateurs arithmétiques
*   Incrémentation et décrémentation (++ et --)
*   Les opérateurs de comparaison
*   Les opérateurs logiques
*   Les conversions de type explicites
*   Cas spécial : convertir vers et depuis string