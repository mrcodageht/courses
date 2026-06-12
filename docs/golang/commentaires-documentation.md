Il est important d'écrire du code que les **humains** peuvent comprendre. Que ce soit vos collègues, ou vous-même dans six mois, un code clair et bien documenté est un code maintenable.

`Go` prend cet aspect très au sérieux. Dans cette leçon, nous allons voir comment utiliser les commentaires de manière efficace et comment écrire une documentation professionnelle directement dans notre code.

### **Les commentaires : expliquer le "pourquoi", pas le "comment"**

Un proverbe de la programmation dit : "Un bon code est sa propre meilleure documentation".

Cela signifie que votre code doit être si clair (grâce à de bons noms de variables et de fonctions) que sa lecture suffit à comprendre _comment_ il fonctionne.

Le rôle des commentaires n'est donc pas de répéter ce que fait le code, mais d'expliquer **pourquoi** il le fait. Ils ajoutent du contexte que le code seul ne peut pas fournir.

`Go` propose deux types de commentaires :

*   **Commentaire sur une seule ligne (`//`)** : tout ce qui suit `//` jusqu'à la fin de la ligne est ignoré par le compilateur.
    
    content\_copy
    
        // Calcule la taxe en se basant sur la réglementation de 2025.
        taxe := prixHT * 0.20 // 0.20 est la TVA standard.
    
*   **Commentaire sur plusieurs lignes (`/* ... */`)** : tout ce qui se trouve entre `/*` et `*/` est ignoré. C'est moins courant en `Go`, souvent utilisé pour désactiver temporairement un bloc de code.
    
    content\_copy
    
        /*
        Ceci est un commentaire
        sur plusieurs lignes.
        */
         
    

#### **Exemple : bon vs mauvais commentaire**

content\_copy

    // Mauvais commentaire : il ne fait que répéter ce que le code fait déjà.
    // Incrémente i de 1.
    i++
    
    // Bon commentaire : il explique POURQUOI on fait cette opération.
    // On incrémente le compteur pour passer au prochain enregistrement à traiter.
    compteur++

### **La documentation avec les outils `Go`**

`Go` intègre la documentation directement dans son outillage. Pour que cela fonctionne, il suffit de suivre une règle très simple.

**La règle d'or :** un commentaire devient une documentation s'il est placé **juste avant** la déclaration d'un élément (fonction, type, variable), sans aucune ligne vide entre les deux.

#### **Style des commentaires de documentation**

La convention officielle, est que la première phrase du commentaire doit commencer par le nom de l'élément documenté.

#### **Exemple pratique : documenter notre fonction `diviser`**

Prenons une fonction (_que nous verrons très en détail dans un chapitre dédié_) :

content\_copy

    package main
    
    import (
    	"errors"
    )
    
    // Diviser effectue la division entière de a par b.
    // Elle retourne le résultat de la division. Si b vaut zéro,
    // la fonction retourne une erreur et le résultat est mis à zéro.
    func Diviser(a, b int) (int, error) {
    	if b == 0 {
    		return 0, errors.New("division par zéro impossible")
    	}
    	return a / b, nil
    }
    
    func main() {
    	Diviser(10, 2)
    }
    

Ce simple commentaire est maintenant la documentation officielle et idiomatique de notre fonction.

Notez bien que l'outil `go doc` ne montre la documentation que pour les éléments **exportés** d'un paquet.

Nous le reverrons en détail, mais en `Go`, **un élément (fonction, variable, type, etc.) est exporté — c'est-à-dire visible depuis l'extérieur de son propre paquet — uniquement si son nom commence par une lettre majuscule.**

#### **Comment voir la documentation d****ans le terminal avec `go doc`**

C'est l'outil le plus rapide pour consulter la documentation sans quitter votre terminal.

Pour voir la documentation d'une fonction spécifique 

content\_copy

    go doc diviser

Le terminal affichera la signature de la fonction et le commentaire que vous avez écrit : 

content\_copy

    func Diviser(a, b int) (int, error)
    
        Diviser effectue la division entière de a par b. Elle retourne le
        résultat de la division. Si b vaut zéro, la fonction retourne une erreur
        et le résultat est mis à zéro.

### Sur cette page

*   Les commentaires : expliquer le "pourquoi", pas le "comment"
*   Exemple : bon vs mauvais commentaire
*   La documentation avec les outils Go
*   Style des commentaires de documentation
*   Exemple pratique : documenter notre fonction diviser
*   Comment voir la documentation dans le terminal avec go doc