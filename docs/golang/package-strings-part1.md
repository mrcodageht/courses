Manipuler du texte est l'une des tâches les plus courantes en programmation.

Que ce soit pour valider une entrée utilisateur, analyser un fichier de configuration, extraire des informations d'un journal ou formater une sortie, nous avons constamment besoin de chercher, remplacer, découper ou joindre des chaînes de caractères.

`Go` nous facilite grandement la vie avec le paquet `strings`, qui est le couteau suisse de la manipulation de texte.

Il contient une collection de fonctions simples, performantes et puissantes pour effectuer toutes ces opérations de manière efficace et idiomatique. Maîtriser ce paquet vous fera gagner un temps précieux.

### **Comment utiliser le paquet `strings` ?**

Comme pour tous les paquets de la bibliothèque standard, il suffit de l'importer en haut de votre fichier pour pouvoir utiliser ses fonctions.

content\_copy

    import "strings"

 Toutes les fonctions du paquet sont alors accessibles via la notation `strings.NomDeLaFonction()`.

### **Exploration des fonctions par catégorie**

Avant de présenter un grand tableau récapitulatif, explorons en détail la logique de quelques fonctions clés.

#### **Recherche et Vérification**

Ces fonctions vous permettent d'inspecter une chaîne pour voir si elle contient une autre chaîne ou un certain motif. Elles retournent généralement un `bool` (`true` ou `false`).

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
    	phrase := "Le soleil brille aujourd'hui."
    
    	fmt.Println("La phrase contient 'soleil' ?", strings.Contains(phrase, "soleil"))
    	fmt.Println("La phrase commence par 'Le' ?", strings.HasPrefix(phrase, "Le"))
    	fmt.Println("La phrase se termine par '.' ?", strings.HasSuffix(phrase, "."))
    }

#### **Modification et Nettoyage**

Ces fonctions créent une **nouvelle chaîne** modifiée à partir d'une chaîne originale (rappelez-vous, les chaînes sont immuables !).

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
    	entreeUtilisateur := "   Bienvenue sur Go !   "
    	nettoye := strings.TrimSpace(entreeUtilisateur)
    	fmt.Printf("'%s' -> '%s'\n", entreeUtilisateur, nettoye)
    
    	message := "Go est super, Go est amusant."
    	messageModifie := strings.ReplaceAll(message, "Go", "Le langage Go")
    	fmt.Println(messageModifie)
    }

#### **Découpage et Assemblage**

Ces fonctions permettent de passer d'une chaîne à une collection de chaînes, et vice-versa. `Fields` est particulièrement utile pour analyser du texte écrit par des humains, car il gère intelligemment les espaces multiples.

content\_copy

    package main
    
    import (
    	"fmt"
    	"strings"
    )
    
    func main() {
    	entree := "  hello    world  "
    	mots := strings.Fields(entree)
    	fmt.Printf("Avec Fields : %q (propre et sans chaînes vides)\n", mots)
    }

### **Tableau récapitulatif des fonctions courantes**

Voici une référence rapide des fonctions les plus utilisées du paquet `strings`. C'est votre aide-mémoire pour trouver rapidement l'outil dont vous avez besoin.

Fonction

Description

Exemple

**Recherche et Comparaison**

 

 

`Contains(s, substr)`

Vérifie si `s` contient `substr`.

`strings.Contains("gopher", "go")` → `true`

`ContainsAny(s, chars)`

Vérifie si `s` contient au moins **un** des caractères de `chars`.

`strings.ContainsAny("golang", "xyzg")` → `true`

`Compare(a, b)`

Compare deux chaînes lexicographiquement. Renvoie -1 si `a < b`, 0 si `a == b`, +1 si `a > b`.

`strings.Compare("a", "b")` → `-1`

`EqualFold(a, b)`

Compare deux chaînes en ignorant la casse.

`strings.EqualFold("Go", "go")` → `true`

`HasPrefix(s, prefix)`

Vérifie si `s` commence par `prefix`.

`strings.HasPrefix("main.go", "main")` → `true`

`HasSuffix(s, suffix)`

Vérifie si `s` se termine par `suffix`.

`strings.HasSuffix("main.go", ".go")` → `true`

`Index(s, substr)`

Retourne l'index de la **première** occurrence de `substr` (-1 si absente).

`strings.Index("chocolat", "co")` → `3`

`LastIndex(s, substr)`

Retourne l'index de la **dernière** occurrence de `substr` (-1 si absente).

`strings.LastIndex("go gopher go", "go")` → `10`

`Count(s, substr)`

Compte les occurrences **non superposées** de `substr`.

`strings.Count("banana", "ana")` → `1`

**Modification et Nettoyage**

 

 

`ToUpper(s)`

Met toute la chaîne en majuscules.

`strings.ToUpper("hello")` → `"HELLO"`

`ToLower(s)`

Met toute la chaîne en minuscules.

`strings.ToLower("WORLD")` → `"world"`

`Replace(s, old, new, n)`

Remplace les `n` premières occurrences de `old` par `new`. `n=-1` pour toutes.

`strings.Replace("go go", "go", "GO", 1)` → `"GO go"`

`ReplaceAll(s, old, new)`

Remplace toutes les occurrences de `old` par `new`.

`strings.ReplaceAll("go go", "go", "GO")` → `"GO GO"`

`TrimSpace(s)`

Supprime les espaces blancs au début et à la fin.

`strings.TrimSpace(" go ")` → `"go"`

`Trim(s, cutset)`

Supprime les caractères de `cutset` au début et à la fin.

`strings.Trim("!!!go!!!", "!")` → `"go"`

`TrimLeft(s, cutset)`

Supprime les caractères de `cutset` uniquement au début.

`strings.TrimLeft("¡¡Hello!!", "¡")` → `"Hello!!"`

`TrimRight(s, cutset)`

Supprime les caractères de `cutset` uniquement à la fin.

`strings.TrimRight("¡¡Hello!!", "!")` → `"¡¡Hello"`

`Repeat(s, count)`

Répète la chaîne `s` `count` fois.

`strings.Repeat("ha", 3)` → `"hahaha"`

**Découpage, Assemblage, Transformation**

 

 

`Split(s, sep)`

Découpe `s` selon le séparateur `sep`.

`strings.Split("a,b,c", ",")` → `[]string{"a", "b", "c"}`

`SplitN(s, sep, n)`

Découpe `s` en `n` sous-chaînes au maximum. La dernière contient le reste.

`strings.SplitN("a,b,c", ",", 2)` → `[]string{"a", "b,c"}`

`SplitAfter(s, sep)`

Découpe `s` après chaque occurrence de `sep`. Le séparateur est conservé.

`strings.SplitAfter("a,b,c", ",")` → `[]string{"a,", "b,", "c"}`

`Fields(s)`

Découpe `s` autour des espaces blancs, sans créer de chaînes vides.

`strings.Fields(" hello world ")` → `[]string{"hello", "world"}`

`Join(elems, sep)`

Assemble les éléments d'une slice avec le séparateur `sep`.

`strings.Join([]string{"Go", "est", "cool"}, " ")` → `"Go est cool"`

`Cut(s, sep)`

Découpe `s` autour de la première occurrence de `sep`.

(voir leçon suivante)

`CutPrefix(s, prefix)`

Coupe le préfixe de `s`, si présent.

(voir leçon suivante)

`CutSuffix(s, suffix)`

Coupe le suffixe de `s`, si présent.

(voir leçon suivante)

`Map(mapping, s)`

Applique une fonction `rune`→`rune` à chaque caractère de `s`.

(voir leçon suivante)

### Sur cette page

*   Comment utiliser le paquet strings ?
*   Exploration des fonctions par catégorie
*   Recherche et Vérification
*   Modification et Nettoyage
*   Découpage et Assemblage
*   Tableau récapitulatif des fonctions courantes