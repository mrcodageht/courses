### **Focus sur quelques fonctions avancées**

#### **Découpage intelligent avec la famille `Cut`**

Introduites en Go 1.18, les fonctions `Cut`, `CutPrefix` et `CutSuffix` offrent une manière plus idiomatique et plus sûre de découper des chaînes. Leur grand avantage est qu'elles retournent un second argument `bool` qui indique si la découpe a réussi. Cela permet d'écrire du code plus clair que le pattern `if index := strings.Index(...); index != -1`.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
    	// 1. strings.Cut : parfait pour extraire des paires clé-valeur
    	ligne := "USER=gopher"
    	cle, valeur, found := strings.Cut(ligne, "=")
    	if found {
    		fmt.Printf("Clé: '%s', Valeur: '%s'\n", cle, valeur)
    	}
    
    	// 2. strings.CutPrefix : idéal pour traiter des commandes ou des identifiants
    	commande := "CMD_START_SERVER"
    	action, found := strings.CutPrefix(commande, "CMD_")
    	if found {
    		fmt.Printf("Action à exécuter : %s\n", action) // Affiche "START_SERVER"
    	}
    
    	// 3. strings.CutSuffix : très utile pour manipuler les noms de fichiers
    	fichier := "document.pdf"
    	nomDeBase, found := strings.CutSuffix(fichier, ".pdf")
    	if found {
    		fmt.Printf("Le nom du fichier sans extension est : '%s'\n", nomDeBase)
    	}
    }

#### **Remplacements multiples et performants : `NewReplacer`**

Que faire si vous devez effectuer de nombreux remplacements différents sur une chaîne ? Enchaîner les appels à `strings.ReplaceAll` est très inefficace, car chaque appel parcourt la chaîne entière depuis le début.

La solution idiomatique est **`strings.NewReplacer`**. Cette fonction crée un objet `Replacer` optimisé qui effectue tous les remplacements en **un seul passage**. La création du `Replacer` a un coût initial, il est donc particulièrement efficace si vous devez appliquer le même jeu de remplacements à de nombreuses chaînes.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
        // On crée le Replacer une seule fois.
        // Il prend une liste de paires "ancien, nouveau".
        replacer := strings.NewReplacer(" ", "-", "é", "e", "ç", "c")
    
        texte := "Leçon de Go français"
        
        // On peut ensuite réutiliser cet objet autant de fois que nécessaire.
        urlSlug := replacer.Replace(texte)
    
        fmt.Println("Texte original :", texte)
        fmt.Println("Slug pour URL  :", urlSlug) // Affiche "Lecon-de-Go-francais"
    }

#### **Transformation avancée : `Map`**

`Map` est une fonction de transformation très puissante. Elle prend en argument une autre fonction qui sait comment transformer une `rune` en une autre `rune`, ou la supprimer.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    	"unicode"
    )
    
    func main() {
        // Exemple: Fonction pour ne garder que les chiffres d'une chaîne
        garderLesChiffres := func(r rune) rune {
            if unicode.IsDigit(r) {
                return r // On garde la rune si c'est un chiffre
            }
            return -1 // On supprime la rune dans tous les autres cas
        }
    
        telephone := "+33 (0)6 12 34 56 78"
        numeroNettoye := strings.Map(garderLesChiffres, telephone)
        fmt.Println("Numéro nettoyé :", numeroNettoye) // Affiche "330612345678"
    }

#### **Optimisation : construire des chaînes efficacement avec `strings.Builder`**

Un piège courant est de construire une longue chaîne de caractères en utilisant l'opérateur `+` dans une boucle. Ce code est très inefficace car, les chaînes étant immuables, chaque `+=` crée une **toute nouvelle chaîne en mémoire** et y copie l'ancienne plus le nouveau caractère. Pour des milliers d'itérations, cela peut paralyser une application.

La solution idiomatique est d'utiliser **`strings.Builder`**, un type optimisé pour construire des chaînes. Il utilise un tampon de `byte` mutable en interne qui grandit intelligemment pour minimiser le nombre d'allocations mémoire.

**Avertissement important : Ne copiez jamais un `strings.Builder`**

Un `Builder` n'est pas une simple variable ; il contient un état interne complexe. Copier un `Builder` peut mener à des comportements imprévisibles. Vous devez toujours l'utiliser tel quel ou le passer par pointeur (`*strings.Builder`). _Nous verrons les pointeurs plus tard._

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
    	var builder strings.Builder
    
    	// Écrire dans le builder est très rapide
    	elements := []string{"un", "deux", "trois"}
    	for _, elem := range elements {
    		builder.WriteString(elem)
    		builder.WriteString(" ")
    	}
    
    	// On récupère la chaîne finale une seule fois à la fin
    	resultat := builder.String()
    
    	fmt.Println("Chaîne construite efficacement :", resultat)
    }

### Sur cette page

*   Focus sur quelques fonctions avancées
*   Découpage intelligent avec la famille Cut
*   Remplacements multiples et performants : NewReplacer
*   Transformation avancée : Map
*   Optimisation : construire des chaînes efficacement avec strings.Builder