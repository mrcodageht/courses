Dans la leçon précédente, nous avons vu que les fonctions `Go` peuvent retourner plusieurs valeurs en spécifiant leurs types. 

`Go` nous offre une fonctionnalité syntaxique supplémentaire : la possibilité de **nommer** ces valeurs de retour directement dans la signature de la fonction.

Cette fonctionnalité a deux objectifs principaux :

1.  **Améliorer la lisibilité :** la signature de la fonction devient auto-documentée, agissant comme un commentaire intégré sur l'intention de chaque valeur retournée.
    
2.  **Simplifier le code dans certains cas :** elle permet l'utilisation d'une instruction `return` "nue" (`_naked return_`).
    

Avant de plonger, un point crucial : l'utilisation des retours nommés n'a **aucune incidence sur la performance**.

C'est une fonctionnalité purement syntaxique et stylistique. Le choix se fait uniquement sur la base de la clarté et de la maintenabilité du code.

### **La syntaxe des retours nommés**

La syntaxe est une extension de celle que nous connaissons. Au lieu de ne lister que les types, nous donnons un nom à chaque valeur de retour, comme s'il s'agissait de paramètres.

*   **Retours non nommés (classique) :** `func maFonction() (string, int) { ... }`
    
*   **Retours NOMMÉS :** `func maFonction() (message string, code int) { ... }`
    

Comment ça marche en coulisses ?

Lorsque vous nommez vos valeurs de retour, Go fait quelque chose de très pratique pour vous : au tout début de votre fonction, il déclare automatiquement des variables avec ces noms et ces types. Ces variables sont initialisées à leur valeur zéro.

À l'intérieur de la fonction, vous pouvez alors traiter `message` et `code` comme des variables locales ordinaires. Vous pouvez leur assigner des valeurs, les lire et les modifier au fil de votre logique.

### **L'idiome `(n int, err error)` dans la bibliothèque standard**

Pour comprendre l'intérêt immédiat des retours nommés, il suffit de regarder la bibliothèque standard. Un grand nombre de fonctions de bas niveau, notamment celles liées aux entrées/sorties (`I/O`), adoptent cet idiome.

*   `io.ReadFull(r Reader, buf []byte) (n int, err error)`
    
*   `(*bytes.Buffer).Read(p []byte) (n int, err error)`
    
*   `net.Conn.Read(b []byte) (n int, err error)`
    

Cette signature est extraordinairement claire grâce aux noms :

*   `n int` : il ne s'agit pas de n'importe quel `int`, mais bien de `n`, la **convention universelle** en Go pour désigner le **nombre d'octets ou d'éléments lus/écrits**. Quand vous voyez ce duo dans une signature, vous savez immédiatement à quoi vous attendre.
    
*   `err error` : l'erreur potentielle.
    

Cet idiome rend les `API` prévisibles et faciles à comprendre.

### **Le `return` nu ("_`naked return`_")**

L'avantage syntaxique des retours nommés est qu'ils permettent d'utiliser un `return` "nu" (ou _bare return_). C'est une instruction `return` sans aucune valeur spécifiée.

Lorsque Go rencontre un `return` nu, il retourne automatiquement les **valeurs actuelles** des variables de retour nommées.

Reprenons notre fonction de division en utilisant un `return` nu.

content\_copy

    package main
    
    import (
    	"errors"
    )
    
    func diviserAvecReturnNu(a, b int) (quotient int, err error) {
    	if b == 0 {
    		err = errors.New("division par zéro impossible")
    		// Retourne les valeurs actuelles de `quotient` (0) et `err`.
    		return
    	}
    
    	quotient = a / b
    	// `err` est déjà nil, pas besoin de le réassigner.
    
    	// Retourne les valeurs actuelles de `quotient` et `err`.
    	return
    }
    
    func main() {
    	// Exemple d'utilisation
    	q, err := diviserAvecReturnNu(10, 2)
    	if err != nil {
    		println("Erreur :", err.Error())
    	} else {
    		println("Quotient :", q)
    	}
    
    	q, err = diviserAvecReturnNu(10, 0)
    	if err != nil {
    		println("Erreur :", err.Error())
    	} else {
    		println("Quotient :", q)
    	}
    }
    

### **Un cas d'usage avancé et puissant : `defer` et retours nommés**

L'une des utilisations les plus élégantes des retours nommés apparaît lorsqu'on les combine avec l'instruction `defer`. Comme `defer` s'exécute juste avant que la fonction ne retourne, elle a la capacité de **lire et de modifier les valeurs de retour nommées**.

C'est un pattern très puissant pour la gestion des erreurs ou des ressources.

content\_copy

    package main
    
    import "fmt"
    
    func uneFonctionComplexe() (err error) { // `err` est déclaré et vaut `nil`.
    	defer func() {
    		if r := recover(); r != nil {
    			// Si une panique a eu lieu, on la "rattrape" et on peut
    			// modifier la variable de retour `err` pour que l'appelant
    			// reçoive une erreur propre au lieu d'un crash.
    			err = fmt.Errorf("une erreur interne est survenue : %v", r)
    		}
    	}()
    
    	panic("quelque chose s'est mal passé")
    
    	return // Normalement, on retournerait `nil` ici, mais le defer va intercepter la panique.
    }
    
    func main() {
    	err := uneFonctionComplexe()
    	if err != nil {
    		fmt.Println("Erreur attrapée dans main:", err)
    	}
    }
    

### **Les pièges et la règle d'or : quand les utiliser ?**

Les retours nommés sont un outil à double tranchant. Mal utilisés, ils peuvent rendre le code bien plus difficile à lire.

#### **Piège n°1 : lisibilité réduite dans les fonctions longues**

Dans une fonction longue avec plusieurs `if/else`, un `return` nu à la fin peut être très obscur.

Le lecteur doit remonter tout le code et tracer mentalement l'état des variables pour comprendre quelles valeurs sont réellement retournées.

#### **Piège n°2 : le "`shadowing`" (masquage de variable)**

C'est l'erreur la plus fréquente et la plus subtile.

Si vous utilisez `:=` à l'intérieur de la fonction, vous pouvez accidentellement déclarer une **nouvelle variable locale** avec le même nom que votre variable de retour.

content\_copy

    package main
    
    import "fmt"
    
    func exempleDeShadowing() (err error) { // `err` est déclaré et vaut `nil`.
    	// ERREUR ! `:=` crée une NOUVELLE variable `err` locale.
    	// La variable de retour `err` (qui vaut `nil`) est masquée ("shadowed").
    	val, err := uneAutreFonction()
    
    	fmt.Println(val)
    	if err != nil {
    		return // Retourne la variable de retour `err` originale, qui est `nil` !
    	}
    	return // Retourne encore `nil`.
    }
    
    func exempleDeShadowingCorrect() (err error) {
    	val, err := uneAutreFonction()
    	if err != nil {
    		return err // Retourne l'erreur de `uneAutreFonction`.
    	}
    	fmt.Println(val)
    	return nil // Retourne `nil` si tout s'est bien passé.
    }
    
    func uneAutreFonction() (string, error) {
    	return "Hello", nil
    }
    
    func main() {
    	// Exemple de shadowing incorrect
    	fmt.Println("Exemple de shadowing incorrect:")
    	err := exempleDeShadowing()
    	if err != nil {
    		fmt.Printf("Erreur inattendue: %v\n", err)
    	} else {
    		fmt.Println("Aucune erreur (mais potentiellement incorrect).")
    	}
    
    	// Exemple de shadowing correct
    	fmt.Println("\nExemple de shadowing correct:")
    	err = exempleDeShadowingCorrect()
    	if err != nil {
    		fmt.Printf("Erreur attendue: %v\n", err)
    	} else {
    		fmt.Println("Aucune erreur.")
    	}
    }
    

#### **Règle d'or et conventions communautaires**

**Utilisez les retours nommés** pour améliorer la **documentation** des signatures de vos fonctions, surtout pour les `API` publiques et les fonctions de bas niveau (comme les opérations de lecture/écriture `io`), ou quand il y a une variable naturelle à suivre (`n int, err error`).

Dans les fonctions de logique métier plus longues, les signatures restent souvent avec des retours **non nommés**, sauf si le nommage clarifie fortement l'intention.

Utilisez le **`return` nu avec une extrême prudence**. La documentation de référence "`i`" est très claire à ce sujet : _“`Naked returns should be used only in short functions, as they can harm readability in longer ones`.”_ Les retours nus ne devraient être utilisés que dans les fonctions courtes, car ils peuvent nuire à la lisibilité dans les plus longues.

Dans tous les autres cas, **privilégiez un `return` explicite** (`return quotient, err`). C'est plus clair, moins sujet aux erreurs, et tout aussi performant.

### Sur cette page

*   La syntaxe des retours nommés
*   L'idiome (n int, err error) dans la bibliothèque standard
*   Le return nu ("naked return")
*   Un cas d'usage avancé et puissant : defer et retours nommés
*   Les pièges et la règle d'or : quand les utiliser ?
*   Piège n°1 : lisibilité réduite dans les fonctions longues
*   Piège n°2 : le "shadowing" (masquage de variable)
*   Règle d'or et conventions communautaires