Dans le chapitre 2, nous avons découvert les types numériques de base : `int` pour les entiers et `float64` pour les décimaux. Ces types sont parfaits pour un usage général.

Cependant, il arrive que nous ayons besoin d'un contrôle beaucoup plus fin, notamment pour des raisons de performance, de consommation mémoire, ou pour interagir avec des systèmes externes (bases de données, `API`, protocoles réseau) qui exigent des tailles de données très spécifiques.

`Go` nous offre pour cela une panoplie complète de types numériques de tailles fixes.

### **Les entiers signés : de `int8` à `int64`**

Un entier **signé** est un nombre entier qui peut être positif, négatif ou nul.

Le type `int` que nous connaissons est un entier signé. Les variantes de taille fixe permettent de choisir précisément la quantité de mémoire que notre nombre va occuper.

Le chiffre après `int` indique le nombre de bits utilisés pour stocker le nombre. Plus le nombre de bits est grand, plus la plage de valeurs possibles est étendue.

Type

Taille

Plage de valeurs

Cas d'usage typique

**`int8`** 

8 bits

\-128 à 127

Très petites valeurs, données de capteurs, optimisation mémoire extrême.

**`int16`** 

16 bits

\-32 768 à 32 767

Données audio, protocoles réseau plus anciens.

**`int32`** 

32 bits

\-2,1 milliards à +2,1 milliards

Identifiants de bases de données, compatibilité 32 bits, alias `rune`.

**`int64`** 

64 bits

\-9 quintillions à +9 quintillions

Très grands nombres, timestamps, identifiants uniques (`UUIDs`).

**Quand les utiliser ?** Quand vous devez interagir avec un système qui vous impose un format (par exemple, une API qui vous envoie des données sur 16 bits) ou quand vous devez stocker des millions de nombres dans un tableau et que chaque octet compte.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        var temperatureCapteur int8 = -15
        var idUtilisateur int64 = 9223372036854775807 // La valeur maximale pour un int64  
    
        fmt.Printf("Température : %d (type %T)\n", temperatureCapteur, temperatureCapteur)
        fmt.Printf("ID Utilisateur : %d (type %T)\n", idUtilisateur, idUtilisateur)
    }

### **Les entiers non signés : de `uint8` à `uint64`**

Un entier **non signé** (`u` pour `_unsigned_`) ne peut stocker que des valeurs positives ou nulles.

En contrepartie, pour une même taille en bits, il peut atteindre une valeur maximale deux fois plus élevée qu'un entier signé.

Type

Taille

Plage de valeurs

Cas d'usage typique

**`uint8`** 

8 bits

0 à 255

Valeurs de couleurs (`RGB`), manipulation de données binaires, alias **`byte`**.

**`uint16`** 

16 bits

0 à 65 535

Numéros de port réseau, graphisme.

**`uint32`** 

32 bits

0 à 4,2 milliards

Adresses `IPv4`, compteurs qui ne peuvent pas être négatifs.

**`uint64`** 

64 bits

0 à 18 quintillions

Très grands identifiants, opérations bit à bit sur de grandes valeurs.

**Quand les utiliser ?** Quand la nature de la donnée garantit qu'elle ne sera **jamais négative**. C'est un moyen d'utiliser le typage pour renforcer la logique de votre programme.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Les composantes d'une couleur sont toujours entre 0 et 255
        var rouge uint8 = 255
        var vert uint8 = 100
        var bleu uint8 = 50
    
        fmt.Printf("Couleur RGB : (%d, %d, %d)\n", rouge, vert, bleu)
    }

### **Les nombres complexes : `complex64` et `complex128`**

`Go` a un support natif pour les nombres complexes, qui sont très utilisés en ingénierie et en physique. Un nombre complexe a une partie réelle et une partie imaginaire.

*   **`complex64`** : les parties réelle et imaginaire sont des `float32`.
    
*   **`complex128`** : les parties réelle et imaginaire sont des `float64` (plus précis et plus courant).
    

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        var c complex128 = 3 + 4i // 3 est la partie réelle, 4 est la partie imaginaire
    
        fmt.Printf("Nombre complexe : %v\n", c)
        fmt.Printf("Partie réelle : %f\n", real(c))
        fmt.Printf("Partie imaginaire : %f\n", imag(c))
    }

Vous ne les utiliserez probablement pas tous les jours, mais leur présence montre que `Go` est aussi un langage adapté au calcul scientifique.

### **Règle générale : quand s'éloigner de `int` ?**

Pour un débutant, la règle est simple :

> **Utilisez toujours `int` par défaut.**

Ne choisissez un type de taille fixe que si vous avez une raison **explicite** de le faire :

*   **Contrainte externe :** une base de données, une API ou un format de fichier vous impose une taille précise (ex: `int32`).
    
*   **Sémantique du code :** la valeur ne peut logiquement pas être négative (ex: `uint` pour un compteur).
    
*   **Optimisation mémoire :** vous créez un tableau contenant des millions d'éléments et l'utilisation d'un `int8` au lieu d'un `int` (souvent 64 bits) peut diviser par 8 la mémoire utilisée.
    

Cette approche vous garantit un code simple et performant dans 99% des cas, tout en vous laissant le pouvoir de l'optimiser lorsque c'est vraiment nécessaire.

### Sur cette page

*   Les entiers signés : de int8 à int64
*   Les entiers non signés : de uint8 à uint64
*   Les nombres complexes : complex64 et complex128
*   Règle générale : quand s'éloigner de int ?