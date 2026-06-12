Dans la leçon précédente, nous avons vu comment les fonctions peuvent prendre des paramètres et retourner une unique valeur. Mais que se passe-t-il si une fonction ne peut pas faire ce qu'on lui demande ? Par exemple, si on lui demande de diviser un nombre par zéro, ou de lire un fichier qui n'existe pas ?

Dans beaucoup d'autres langages, de telles situations provoqueraient une "exception" qui interrompt brutalement le flux du programme.

`Go` adopte une approche différente, plus explicite et plus robuste.

**En `Go`, les erreurs ne sont pas des accidents, ce sont des valeurs attendues.**

Pour gérer cela, `Go` permet aux fonctions de retourner **plusieurs valeurs**.

C'est le mécanisme que nous allons utiliser pour gérer les erreurs de manière idiomatique.

### **Le retour de valeurs multiples**

Contrairement à beaucoup d'autres langages, une fonction en `Go` peut retourner plus d'un résultat.

La syntaxe consiste simplement à lister les types de retour entre parenthèses.

content\_copy

    func nomDeLaFonction() (typeRetour1, typeRetour2)

Voyons un exemple simple qui n'implique pas d'erreur. Imaginons une fonction qui retourne le prénom et le nom d'un utilisateur.

content\_copy

    package main
    
    import "fmt"
    
    func getNomComplet() (string, string) {
        prenom := "Alice"
        nom := "Dubois"
        return prenom, nom
    }
    
    func main() {
        // On peut assigner les deux valeurs de retour à deux variables.
        p, n := getNomComplet()
        fmt.Printf("Prénom : %s, Nom : %s\n", p, n)
    }

**Résultat :** `Prénom : Alice, Nom : Dubois`

### **Le pattern idiomatique : `(valeur, error)`**

L'utilisation la plus courante des retours multiples en `Go` est de retourner deux valeurs :

1.  Le **résultat** de l'opération (la valeur qui nous intéresse).
    
2.  Une **erreur** potentielle.
    

`Go` possède un type intégré spécial pour cela : `error`.

**Une variable de type `error` peut contenir deux choses :**

*   `nil` : une valeur spéciale qui signifie "aucune erreur", "tout s'est bien passé".
    
*   Un objet d'erreur : un objet qui contient des informations sur ce qui a mal tourné.
    

La convention est la suivante :

*   Si une fonction réussit, elle retourne le résultat et une erreur qui vaut `nil`.
    
*   Si une fonction échoue, elle retourne une "valeur zéro" pour le résultat (par exemple, `0` ou `""`) et un objet d'erreur non-`nil`.
    

### **Exemple pratique : une division sécurisée**

_Nous reverrons en détails les conditions au prochain chapitre, concentrez-vous seulement sur la gestion d'erreur._

Créons une fonction `diviser` qui prend deux entiers.

La division par zéro étant impossible, notre fonction doit pouvoir signaler cet échec.

content\_copy

    package main
    
    import (
        "errors" // On importe le paquet 'errors' pour créer de nouvelles erreurs.
        "fmt"
    )
    
    // Notre fonction retourne un 'int' (le résultat) ET une 'error'.
    func diviser(a, b int) (int, error) {
        // Cas d'échec : on ne peut pas diviser par zéro.
        if b == 0 {
            // On retourne une valeur zéro pour l'entier (0)
            // et une nouvelle erreur qui décrit le problème.
            return 0, errors.New("division par zéro impossible")
        }
    
        // Cas de succès : la division est possible.
        resultat := a / b
        // On retourne le résultat et 'nil' pour indiquer qu'il n'y a pas d'erreur.
        return resultat, nil
    }
    
    func main() {
        // Premier appel : un cas qui réussit.
        resultatOK, errOK := diviser(10, 2)
    
        // C'est le test le plus courant en Go !
        if errOK != nil {
            // Ce bloc n'est exécuté que si une erreur s'est produite.
            fmt.Printf("Erreur lors de la première division : %s\n", errOK)
        } else {
            // Ce bloc est exécuté si tout s'est bien passé.
            fmt.Printf("10 / 2 = %d\n", resultatOK)
        }
    
        // Deuxième appel : un cas qui va échouer.
        resultatEchec, errEchec := diviser(10, 0)
        if errEchec != nil {
            fmt.Printf("Erreur lors de la deuxième division : %s\n", errEchec)
        } else {
            fmt.Printf("10 / 0 = %d\n", resultatEchec)
        }
    }

**Résultat :**

content\_copy

    10 / 2 = 5
    Erreur lors de la deuxième division : division par zéro impossible

### **Ne pas ignorer les erreurs**

Le compilateur `Go` vous oblige à faire quelque chose avec chaque valeur retournée par une fonction. Si une fonction retourne une erreur, vous devez la gérer.

L'idiome `if err != nil` est omniprésent en `Go`.

C'est une approche volontairement explicite qui rend le code très robuste et facile à lire, car les chemins d'erreur sont toujours visibles.

### Sur cette page

*   Le retour de valeurs multiples
*   Le pattern idiomatique : (valeur, error)
*   Exemple pratique : une division sécurisée
*   Ne pas ignorer les erreurs