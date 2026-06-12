Maintenant que nous avons exploré les différents types de nombres, il est temps de voir comment les manipuler.

`Go` est livré avec une bibliothèque standard très riche qui nous évite d'avoir à réécrire des fonctions de base.

Pour les mathématiques, deux paquets sont incontournables : `math` pour les opérations courantes et `math/rand` pour tout ce qui touche à l'aléatoire.

### **Le paquet `math` : votre boîte à outils de calcul**

Le paquet `math` contient un ensemble de fonctions mathématiques communes.

Il est important de noter que la plupart de ces fonctions opèrent sur des nombres de type `float64`.

**Comment l'utiliser ?** Il suffit de l'importer en haut de votre fichier :

content\_copy

    import "math"

Voici quelques-unes des fonctions les plus utiles :

Fonction

Description

Exemple

`math.Sqrt(x)`

Calcule la racine carrée de `x`.

`math.Sqrt(64)` retourne `8.0`

`math.Pow(x, y)`

Calcule `x` élevé à la puissance `y`.

`math.Pow(2, 3)` retourne `8.0`

`math.Round(x)`

Arrondit `x` à l'entier le plus proche.

`math.Round(3.7)` retourne `4.0`

`math.Ceil(x)`

Arrondit `x` à l'entier **supérieur** (plafond).

`math.Ceil(3.1)` retourne `4.0`

`math.Floor(x)`

Arrondit `x` à l'entier **inférieur** (plancher).

`math.Floor(3.9)` retourne `3.0`

`math.Abs(x)`

Calcule la valeur absolue de `x`.

`math.Abs(-5)` retourne `5.0`

`math.Max(x, y)`

Retourne le plus grand des deux nombres `x` et `y`.

`math.Max(10, 20)` retourne `20.0`

`math.Min(x, y)`

Retourne le plus petit des deux nombres `x` et `y`.

`math.Min(10, 20)` retourne `10.0`

**Exemple concret :**

content\_copy

    package main
    
    import (
    	"fmt"
    	"math"
    )
    
    func main() {
    	nombre := 64.0
    	racineCarree := math.Sqrt(nombre)
    	fmt.Printf("La racine carrée de %.1f est %.1f\n", nombre, racineCarree)
    
    	arrondiSuperieur := math.Ceil(9.01)
    	fmt.Printf("L'arrondi supérieur de 9.01 est %.1f\n", arrondiSuperieur)
    }

### **Le paquet `math/rand` : générer de l'aléatoire**

Générer des nombres aléatoires est une tâche courante : pour un jeu de dés, pour choisir un élément au hasard dans une liste, ou pour des simulations.

Générer des nombres aléatoires est une tâche courante. Depuis `Go 1.22`, le paquet `math/rand/v2` est la manière recommandée et moderne de le faire.

#### **Pourquoi une `v2` : l'amélioration de l'aléatoire**

Le passage à une version `v2` n'est pas anodin, il corrige des problèmes historiques et améliore l'ergonomie :

*   **Le piège de `rand.Seed` est supprimé :** dans l'ancienne version, si vous oubliiez d'initialiser la source de l'aléatoire (avec `rand.Seed`), votre programme générait **toujours la même suite de nombres "aléatoires"**. C'était une source d'erreur très fréquente pour les débutants. La `v2` résout ce problème en s'initialisant automatiquement, garantissant un vrai caractère aléatoire à chaque exécution.
    
*   **Une API plus moderne et flexible :** la `v2` introduit la fonction générique `rand.N()` qui simplifie les multiples fonctions précédentes (`Intn`, `Int32n`, `Int64n`...). Elle est plus simple à utiliser et plus puissante.
    
*   **De meilleurs algorithmes :** la `v2` utilise des algorithmes de génération de nombres pseudo-aléatoires plus performants et plus robustes.
    

#### **Comment l'utiliser ?**

Il est crucial d'utiliser le bon chemin d'import :

content\_copy

    import "math/rand/v2"

Voici les deux fonctions que vous utiliserez le plus souvent :

Fonction

Description

`rand.IntN(n)`

Retourne un entier pseudo-aléatoire `int` dans l'intervalle `[0, n)`. Cela inclut `0` mais **exclut** `n`.

`rand.Float64()` 

Retourne un nombre pseudo-aléatoire `float64` dans l'intervalle `[0.0, 1.0)`.

#### **Exemple : simuler un lancer de dé**

Un dé a 6 faces, numérotées de 1 à 6.

La fonction `rand.N(6)` nous donne un nombre entre 0 et 5. Pour obtenir un résultat entre 1 et 6, il suffit d'ajouter 1.

content\_copy

    package main
    
    import (
    	"fmt"
    	"math/rand/v2" // On importe bien la v2 !
    )
    
    func main() {
    	// Génère un nombre `int` entre 0 et 5, puis on ajoute 1.
    	// `rand.N(6)` est équivalent à `rand.N[int](6)`.
    	resultatDe := rand.N(6) + 1
    	fmt.Printf("Résultat du lancer de dé : %d\n", resultatDe)
    
    	// On peut aussi être explicite avec un autre type entier.
    	// Génère un nombre `uint32` entre 0 et 99.
    	nombreSecret := rand.N(uint32(100))
    	fmt.Printf("Un nombre secret (uint32) : %d\n", nombreSecret)
    }

**Résultat (sera différent à chaque exécution) :**

content\_copy

    Résultat du lancer de dé : 4
    Un nombre secret (uint32) : 73

#### **Aléatoire vs pseudo-aléatoire (sécurité)**

Il est crucial de comprendre que `math/rand` génère des nombres **pseudo-aléatoires**.

Cela signifie qu'ils sont produits par un algorithme mathématique déterministe.

Pour une même version de `Go` et une même initialisation (la "graine"), la séquence de nombres sera toujours la même.

C'est parfait pour des simulations ou des jeux, mais **totalement inapproprié pour des besoins de sécurité**.

Si un attaquant peut prédire vos nombres "aléatoires", il peut compromettre votre système.

Pour générer des mots de passe, des jetons de session ou des clés de chiffrement, il faut un vrai hasard, imprévisible.

Pour cela, `Go` fournit un paquet spécifique : **`crypto/rand`**, qui s'appuie sur des sources d'aléa du système d'exploitation.

### Sur cette page

*   Le paquet math : votre boîte à outils de calcul
*   Le paquet math/rand : générer de l'aléatoire
*   Pourquoi une v2 : l'amélioration de l'aléatoire
*   Comment l'utiliser ?
*   Exemple : simuler un lancer de dé
*   Aléatoire vs pseudo-aléatoire (sécurité)