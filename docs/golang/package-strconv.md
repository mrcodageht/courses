Dans nos programmes, les données arrivent souvent sous forme de texte (`string`), même si elles représentent des concepts numériques.

Une entrée utilisateur dans un formulaire web, une ligne dans un fichier `CSV,` un paramètre dans une `URL`... tous sont du texte. Pour pouvoir effectuer des calculs avec ces données, nous devons les convertir en types numériques (`int`, `float64`, etc.). Inversement, pour afficher un résultat ou sauvegarder des données, nous devons souvent convertir des nombres en texte.

Le paquet `strconv` (`_string conversion_`) est la boîte à outils standard de `Go` dédiée à ces conversions. Il fournit des fonctions robustes, performantes et sûres pour passer d'un monde à l'autre.

### **La conversion la plus courante : de `string` vers `int`**

La fonction que vous utiliserez le plus souvent est **`strconv.Atoi`** (`ASCII to Integer`).

Elle prend une chaîne de caractères et tente de la convertir en un `int`.

C'est un exemple parfait de la gestion d'erreurs idiomatique en `Go`.

La conversion peut échouer (si la chaîne est `"hello"`, par exemple), donc la fonction retourne deux valeurs :

*   Le nombre `int` converti.
    
*   Une `error` qui sera `nil` si la conversion a réussi, ou qui contiendra une description du problème si elle a échoué.
    

content\_copy

    package main
    
    import (
    	"fmt"
    	"strconv"
    )
    
    func main() {
    	chaineValide := "123"
    	chaineInvalide := "pas-un-nombre"
    
    	// Cas 1 : La conversion réussit
    	nombre1, err1 := strconv.Atoi(chaineValide)
    	if err1 != nil {
    		fmt.Printf("Erreur lors de la conversion de '%s': %v\n", chaineValide, err1)
    	} else {
    		fmt.Printf("Conversion réussie : '%s' -> %d (type %T)\n", chaineValide, nombre1, nombre1)
    	}
    
    	// Cas 2 : La conversion échoue
    	nombre2, err2 := strconv.Atoi(chaineInvalide)
    	if err2 != nil {
    		fmt.Printf("Erreur attendue lors de la conversion de '%s': %v\n", chaineInvalide, err2)
    		fmt.Printf("La valeur de `nombre2` est %d\n", nombre2)
    	}
    }

**Relation avec ParseInt**

`Atoi` est en réalité un simple raccourci pour `ParseInt(s, 10, 0)`, suivi d'une conversion du `int64` résultant en `int`.

Il est optimisé pour le cas le plus courant : la lecture d'un nombre décimal.

### **L'opération inverse : de `int` vers `string`**

Pour convertir un entier en chaîne de caractères, la fonction est **`strconv.Itoa`** (`Integer to ASCII`).

Cette conversion ne pouvant pas échouer, la fonction est plus simple : elle ne retourne qu'une seule valeur, la `string` résultante.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strconv"
    )
    
    func main() {
    	age := 42
    	chaineAge := strconv.Itoa(age)
    	fmt.Printf("La chaîne de l'âge est '%s' (type %T)\n", chaineAge, chaineAge)
    }

**Relation avec `FormatInt`**

De même, `Itoa` est un raccourci pratique pour `FormatInt(int64(i), 10)`.

### **Le piège à éviter : la conversion de type directe**

Un débutant venant d'un autre langage pourrait être tenté d'écrire `string(42)`.

**Ne faites jamais ça en `Go` pour convertir un nombre en chaîne !**

En `Go`, la conversion `string(un_nombre)` prend la valeur numérique (`42`) et la traite comme un **point de code `Unicode`** pour trouver le caractère correspondant (ici, l'astérisque `*`).

**Règle d'or :** pour les conversions entre `string` et types numériques, utilisez **toujours** le paquet `strconv`.

### **Pour aller plus loin : les conversions avancées et détails techniques**

Le paquet `strconv` est très riche. Il offre des fonctions plus génériques pour gérer des cas plus complexes.

#### **Analyse avancée d'entiers avec `ParseInt` et `ParseUint`**

`ParseInt(s, base, bitSize)` est la fonction la plus puissante pour lire des entiers.

*   **`s`** : la chaîne à analyser.
    
*   **`base`** : la base numérique (2 pour binaire, 8 pour octal, 10 pour décimal, 16 pour hexadécimal). **Détection automatique (`base = 0`)** : Si `base` est `0`, `Go` détecte la base depuis le préfixe de la chaîne : `0b` pour binaire, `0o` ou `0` pour octal, `0x` pour hexadécimal. Sinon, il utilise la base `10`. Les séparateurs `_` sont également autorisés pour la lisibilité (ex: `"1_000_000"`), mais uniquement quand `base` est à `0`.
    
*   **`bitSize`** : la taille attendue du résultat (0, 8, 16, 32, ou 64). `0` signifie `int` (soit 32 ou 64 bits selon l'architecture, ce que l'on peut vérifier avec `strconv.IntSize`). La fonction vérifie si le nombre analysé rentre dans cette plage de valeurs.
    

content\_copy

    package main
    
    import (
    	"fmt"
    	"strconv"
    )
    
    func main() {
        // Détection auto de la base hexadécimale
        hex, _ := strconv.ParseInt("0xFF", 0, 64) 
        fmt.Println(hex) // Affiche 255
    
        // Lecture d'un binaire avec séparateurs
        bin, _ := strconv.ParseInt("0b1101_0100", 0, 64)
        fmt.Println(bin) // Affiche 212
    }

#### **Analyse de flottants avec `ParseFloat`**

`ParseFloat(s, bitSize)` convertit une chaîne en `float64` (`bitSize=64`) ou `float32` (`bitSize=32`).

*   Elle reconnaît la notation scientifique (`1.23e5`).
    
*   Elle reconnaît les valeurs spéciales comme `NaN`, `Inf`, `Infinity` (insensible à la casse) avec un signe optionnel (`+Inf`, `-Infinity`). Le résultat est le plus proche nombre représentable au format `IEEE 754`.
    

#### **Formatage performant avec les familles `Format*` et `Append*`**

**`FormatFloat(f, fmt, prec, bitSize)`** offre un contrôle total sur le formatage des flottants. `fmt` est un caractère (`'f'` pour standard, `'e'` pour scientifique), `prec` contrôle le nombre de décimales (-1 pour le minimum nécessaire).

La famille **`Append*`** (`AppendInt`, `AppendFloat`, etc.) est optimisée pour la performance.

Au lieu de créer une nouvelle `string`, elle ajoute la représentation textuelle à une `slice` de `[]byte` existante, ce-qui évite des allocations mémoire coûteuses dans les boucles.

#### **Sérialisation sûre avec `Quote` et `Unquote`**

Parfois, vous avez besoin de représenter une chaîne de manière non ambiguë, par exemple dans un fichier de log ou de configuration.

Les fonctions `Quote` et `Unquote` gèrent les caractères d'échappement pour vous, garantissant que la chaîne peut être relue sans erreur.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strconv"
    )
    
    func main() {
        // `Quote` ajoute les guillemets et échappe les caractères spéciaux.
        chaineAvecTab := "hello\tworld"
        fmt.Println(strconv.Quote(chaineAvecTab)) // Affiche "hello\tworld"
    }

#### **Comprendre les erreurs de `strconv`**

Toutes les erreurs d'analyse (`Parse*`) retournent un type `*strconv.NumError`. Cette structure contient des informations précises :

*   `Func`: le nom de la fonction qui a échoué (ex: `"Atoi"`).
    
*   `Num`: la chaîne d'entrée qui a causé l'erreur.
    
*   `Err`: l'erreur sous-jacente, qui est soit `strconv.ErrSyntax`, soit `strconv.ErrRange`.
    

`ErrRange` est retournée si la syntaxe est bonne mais que la valeur est trop grande ou trop petite pour le type de destination (défini par `bitSize`).

Cela vous permet de distinguer une entrée mal formée d'une entrée valide mais hors limites.

Ce programme définit une fonction qui tente de convertir une chaîne en un `int8` (un entier sur 8 bits, dont la plage va de `-128` à `127`) et qui analyse en détail l'erreur si elle se produit.

_Ne vous focalisez pas maintenant sur la gestion des erreurs, nous allons voir largement la gestion d'erreur plus loin dans la formation._

content\_copy

    package main
    
    import (
    	"errors"
    	"fmt"
    	"strconv"
    )
    
    // analyserErreurStrconv tente de convertir une chaîne en int8 et affiche une analyse détaillée de l'erreur.
    func analyserErreurStrconv(s string) {
    	fmt.Printf("--- Tentative de conversion de \"%s\" ---\n", s)
    
    	// On tente de convertir la chaîne en base 10, pour un type de 8 bits.
    	_, err := strconv.ParseInt(s, 10, 8)
    
    	// Le test idiomatique de base
    	if err != nil {
    		// On va plus loin : on essaie de convertir l'erreur en son type spécifique, *strconv.NumError
    		var numErr *strconv.NumError
    		if errors.As(err, &numErr) {
    			fmt.Printf("Erreur détectée : c'est bien une NumError.\n")
    			fmt.Printf("  -> Fonction qui a échoué : %s\n", numErr.Func)
    			fmt.Printf("  -> Entrée qui a échoué   : %s\n", numErr.Num)
    
    			// Maintenant, on peut inspecter l'erreur sous-jacente
    			if errors.Is(numErr.Err, strconv.ErrSyntax) {
    				fmt.Println("  -> Type d'erreur : Erreur de syntaxe. L'entrée n'est pas un nombre valide.")
    			} else if errors.Is(numErr.Err, strconv.ErrRange) {
    				fmt.Println("  -> Type d'erreur : Nombre hors limites. Le nombre est valide mais trop grand ou trop petit pour un int8.")
    			}
    		} else {
    			// Si, pour une raison improbable, ce n'est pas une NumError, on l'affiche simplement.
    			fmt.Printf("Une erreur inattendue est survenue : %v\n", err)
    		}
    	} else {
    		fmt.Println("Conversion réussie !")
    	}
    	fmt.Println()
    }
    
    func main() {
    	// Cas 1: Erreur de syntaxe
    	analyserErreurStrconv("hello")
    
    	// Cas 2: Erreur de plage (200 est plus grand que 127, le max pour un int8)
    	analyserErreurStrconv("200")
    
    	// Cas 3: Conversion réussie
    	analyserErreurStrconv("100")
    }
    

Lorsque vous exécutez ce code, vous obtenez la sortie suivante :

content\_copy

    --- Tentative de conversion de "hello" ---
    Erreur détectée : c'est bien une NumError.
      -> Fonction qui a échoué : ParseInt
      -> Entrée qui a échoué   : hello
      -> Type d'erreur : Erreur de syntaxe. L'entrée n'est pas un nombre valide.
    
    --- Tentative de conversion de "200" ---
    Erreur détectée : c'est bien une NumError.
      -> Fonction qui a échoué : ParseInt
      -> Entrée qui a échoué   : 200
      -> Type d'erreur : Nombre hors limites. Le nombre est valide mais trop grand ou trop petit pour un int8.
    
    --- Tentative de conversion de "100" ---
    Conversion réussie !
    

Cet exemple montre que vous pouvez faire bien plus qu'un simple `if err != nil`. En inspectant le type et la nature de l'erreur, votre programme peut prendre des décisions intelligentes :

*   **Si c'est `strconv.ErrSyntax`**, vous pouvez afficher un message à l'utilisateur comme : "Veuillez entrer un nombre valide."
    
*   **Si c'est `strconv.ErrRange`**, vous pouvez donner une aide beaucoup plus précise : "Le nombre que vous avez entré est trop grand. Veuillez choisir une valeur entre -128 et 127."
    

Cette capacité à différencier les types d'erreurs est fondamentale pour créer des applications robustes et conviviales

### Sur cette page

*   La conversion la plus courante : de string vers int
*   L'opération inverse : de int vers string
*   Le piège à éviter : la conversion de type directe
*   Pour aller plus loin : les conversions avancées et détails techniques
*   Analyse avancée d'entiers avec ParseInt et ParseUint
*   Analyse de flottants avec ParseFloat
*   Formatage performant avec les familles Format\* et Append\*
*   Sérialisation sûre avec Quote et Unquote
*   Comprendre les erreurs de strconv