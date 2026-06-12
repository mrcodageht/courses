Dans la plupart des langages de programmation, une fonction ne peut retourner qu'une seule et unique valeur.

Si vous avez besoin de retourner plus d'informations, vous devez les envelopper dans une structure de données (comme une `struct` ou un tableau).

`Go` brise cette contrainte en permettant nativement à une fonction de retourner **plusieurs valeurs**.

C'est une caractéristique de conception fondamentale qui a un impact direct sur la manière dont on écrit du code idiomatique, notamment pour la gestion des erreurs.

### **La syntaxe des retours multiples**

Pour qu'une fonction retourne plusieurs valeurs, il suffit de lister les types de ces valeurs entre parenthèses dans la signature de la fonction.

content\_copy

    // Une fonction qui retourne une seule valeur (ce que nous connaissons)
    func maFonction1() int {
        return 10
    }
    
    // Une fonction qui retourne DEUX valeurs : une `string` et un `int`
    func maFonction2() (string, int) {
        return "Hello", 42
    }

L'instruction `return` doit alors fournir une valeur pour chaque type de retour déclaré, dans le bon ordre.

Les types et l'ordre des valeurs de retour font partie intégrante du **contrat** de la fonction et doivent être scrupuleusement respectés à l'appel.

### **Le cas d'usage le plus courant : le pattern `(valeur, error)`**

C'est l'utilisation la plus importante et la plus courante des retours multiples en `Go`.

Nous l'avons déjà utilisée en tant que "consommateur" (en appelant `strconv.Atoi`, par exemple), il est temps de la maîtriser en tant que "créateur".

Le pattern `(valeur, error)` permet à une fonction qui peut échouer de communiquer clairement son état :

*   Si l'opération réussit, elle retourne le **résultat attendu** et une erreur valant **`nil`**.
    
*   Si l'opération échoue, elle retourne la **valeur zéro** du type de résultat et une **erreur** décrivant le problème.
    

**Précision importante sur la valeur zéro :** retourner la valeur zéro du résultat en cas d'erreur est une **convention très forte**, mais pas une contrainte absolue du langage.

Dans la grande majorité des cas, c'est la bonne pratique à suivre pour éviter des erreurs où l'appelant utiliserait une valeur invalide.

Cependant, certaines fonctions de la bibliothèque standard, comme `io.Reader.Read`, peuvent retourner une valeur partielle (le nombre d'octets lus) _et_ une erreur (par exemple, `io.EOF` pour signifier la fin du fichier) en même temps. Pour commencer, suivez toujours la convention de la valeur zéro.

content\_copy

    package main
    
    import (
    	"errors"
    )
    
    // diviser retourne un int ET une error.
    func diviser(a, b int) (int, error) {
    	// Cas d'échec
    	if b == 0 {
    		// On retourne la valeur zéro de int (0) et une nouvelle erreur.
    		return 0, errors.New("division par zéro impossible")
    	}
    
    	// Cas de succès
    	// On retourne le résultat du calcul et une erreur nil.
    	return a / b, nil
    }
    
    func main() {
    	// Appel de la fonction diviser avec des valeurs valides.
    	result, err := diviser(10, 2)
    	if err != nil {
    		// Si une erreur est retournée, on l'affiche.
    		println("Erreur :", err.Error())
    	} else {
    		// Sinon, on affiche le résultat.
    		println("Résultat de la division :", result)
    	}
    
    	// Appel de la fonction diviser avec une division par zéro.
    	result, err = diviser(10, 0)
    	if err != nil {
    		println("Erreur :", err.Error())
    	} else {
    		println("Résultat de la division :", result)
    	}
    }
    

### **Retourner plusieurs valeurs utiles**

Les retours multiples ne sont pas réservés qu'aux erreurs.

Vous pouvez les utiliser pour retourner plusieurs informations pertinentes en une seule fois, ce qui rend le code plus clair et plus efficace.

Imaginons une fonction qui doit retourner les statistiques de base d'une `slice` d'entiers.

content\_copy

    package main
    
    import "fmt"
    
    // stats retourne la somme ET la moyenne d'une slice d'entiers.
    func stats(nombres []int) (int, float64) {
    	if len(nombres) == 0 {
    		return 0, 0.0
    	}
    
    	somme := 0
    	for _, n := range nombres {
    		somme += n
    	}
    
    	moyenne := float64(somme) / float64(len(nombres))
    
    	return somme, moyenne
    }
    
    func main() {
    	nombres := []int{1, 2, 3, 4, 5}
    	somme, moyenne := stats(nombres)
    	fmt.Printf("Somme: %d, Moyenne: %.2f\n", somme, moyenne)
    }
    

### **Gérer les retours multiples à l'appel**

Lorsque vous appelez une fonction qui retourne plusieurs valeurs, vous devez fournir autant de variables à gauche de l'opérateur `:=` ou `=` pour les capturer.

#### **Capturer toutes les valeurs**

C'est le cas le plus courant.

content\_copy

    package main
    
    import (
    	"errors"
    	"fmt"
    )
    
    // diviser prend deux entiers et retourne leur quotient et une erreur si le diviseur est zéro.
    func diviser(a, b int) (int, error) {
    	if b == 0 {
    		return 0, errors.New("division par zéro impossible")
    	}
    	return a / b, nil
    }
    
    func main() {
    	// Appel qui réussit
    	resultat1, err1 := diviser(10, 2)
    	if err1 != nil {
    		fmt.Println("Erreur inattendue :", err1)
    	} else {
    		fmt.Println("10 / 2 =", resultat1)
    	}
    
    	// Appel qui échoue
    	resultat2, err2 := diviser(10, 0)
    	if err2 != nil {
    		fmt.Println("Erreur attendue :", err2)
    	} else {
    		fmt.Println("10 / 0 =", resultat2)
    	}
    }
    

#### **Ignorer une valeur avec l'identifiant blanc `_`**

Parfois, une des valeurs retournées ne vous intéresse pas.

Le compilateur `Go` vous interdit de déclarer une variable sans l'utiliser.

Pour contourner cela, vous pouvez assigner la valeur non désirée à l'**identifiant blanc** (ou `_blank identifier_`), le `_`.

content\_copy

    package main
    
    import "fmt"
    
    func obtenirNoms() (string, string) {
    	return "Alice", "Martin"
    }
    
    func main() {
    	// Je ne veux que le prénom. J'ignore le nom de famille.
    	prenom, _ := obtenirNoms()
    	fmt.Println("Prénom :", prenom)
    }
    

**Attention :** ignorer une erreur (`resultat, _ := maFonction()`) est une très mauvaise pratique, sauf si vous êtes **absolument certain** que la fonction ne peut pas échouer dans ce contexte précis.

### **Quand utiliser les retours multiples (et quand ne pas le faire)**

Les retours multiples sont parfaits pour retourner un résultat et une erreur, ou une petite poignée de valeurs étroitement liées. Cependant, il faut éviter d'en abuser.

**Règle de lisibilité :** si votre fonction a besoin de retourner plus de deux ou trois valeurs, il est généralement plus clair et plus maintenable d'encapsuler ces valeurs dans une `struct` dédiée.

**Mauvaise pratique (difficile à lire) :** `func obtenirUtilisateur() (string, string, int, bool, error)`

**Bonne pratique (clair et extensible) :** `func obtenirUtilisateur() (Utilisateur, error)`

### **Récapitulatif**

Le retour de valeurs multiples est une des caractéristiques les plus idiomatiques et puissantes de `Go`.

*   Il rend la gestion des erreurs **explicite et robuste** grâce au pattern `(valeur, error)`.
    
*   Il permet de créer des `API` claires et efficaces en retournant plusieurs informations pertinentes en un seul appel.
    
*   Il s'utilise avec l'assignation multiple (`var1, var2 := ...`) et l'identifiant blanc (`_`) pour ignorer des valeurs.
    
*   Il ne faut pas en abuser pour ne pas perdre en lisibilité et utiliser des `structs` quand c'est possible.

### Sur cette page

*   La syntaxe des retours multiples
*   Le cas d'usage le plus courant : le pattern (valeur, error)
*   Retourner plusieurs valeurs utiles
*   Gérer les retours multiples à l'appel
*   Capturer toutes les valeurs
*   Ignorer une valeur avec l'identifiant blanc \_
*   Quand utiliser les retours multiples (et quand ne pas le faire)
*   Récapitulatif