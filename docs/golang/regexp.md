Jusqu'à présent, nous avons manipulé des chaînes de caractères en cherchant des sous-chaînes exactes (`strings.Contains`) ou en découpant selon des séparateurs fixes (`strings.Split`).

Mais que faire si vous devez trouver des motifs plus complexes ? Par exemple :

*   Valider qu'une chaîne est bien une adresse e-mail.
    
*   Extraire tous les numéros de téléphone d'un long texte.
    
*   Trouver des mots qui commencent par 'A' et se terminent par 'z'.
    

Pour ces tâches, les fonctions du paquet `strings` ne suffisent pas. Nous avons besoin d'un langage plus puissant pour décrire des **motifs de texte** : les **expressions régulières** (souvent abrégées en "`regex`" ou "`regexp`").

Le paquet `regexp` est la boîte à outils standard de `Go` pour travailler avec cet outil.

### **Qu'est-ce qu'une expression régulière ?**

Une expression régulière est une chaîne de caractères spéciale qui décrit un ensemble de chaînes possibles. C'est une sorte de "recherche avec des super-pouvoirs".

Syntaxe

Description

Exemple

`.`

N'importe quel caractère (sauf le saut de ligne par défaut)

`h.t` trouve "hat", "hot"

`*`

Zéro ou plusieurs répétitions du caractère précédent

`ab*c` trouve "ac", "abc", "abbc"

`+`

Une ou plusieurs répétitions du caractère précédent

`ab+c` trouve "abc", "abbc"

`?`

Zéro ou une répétition du caractère précédent

`colou?r` trouve "color" et "colour"

`\d`

Un chiffre `**ASCII**` (`[0-9]`)

`\d+`

`\w`

Un caractère de mot `**ASCII**` (`[a-zA-Z0-9_]`)

`\w+`

`\s`

Un espace blanc `**ASCII**` (`[ \t\n\r\f]`)

`\s+`

`\p{L}`

N'importe quelle **lettre `Unicode`**

`\p{L}+` trouve "café", "Кофе"

`\p{N}`

N'importe quel **nombre `Unicode`** (inclut `²³`)

`\p{N}+`

`[abc]`

N'importe quel caractère présent dans le jeu (`a`, `b`, ou `c`)

`[bcr]at` trouve "bat", "cat", "rat"

`[^abc]`

N'importe quel caractère **sauf** ceux du jeu

`[^bcr]at` trouve "hat", "mat"

`()`

**Groupe de capture** (pour extraire des sous-parties)

`(Go)`

`(?:...)`

**Groupe non capturant** (n’incrémente pas les indices de capture)

`(?:http|https)` trouve les deux schémas sans créer de groupe

**`ASCII` vs `Unicode` : une distinction cruciale**

Les classes de caractères courtes comme `\d`, `\w` et `\s` ne reconnaissent que les caractères `ASCII`.

Pour travailler avec du texte international, il est impératif d'utiliser les classes de propriétés `Unicode` comme `\p{L}` (Lettre), `\p{N}` (Nombre), `\p{P}` (Ponctuation), etc.

### **Le processus et les bonnes pratiques en Go**

Travailler avec `regexp` en `Go` se fait toujours en deux temps :

1.  **Compiler le motif une seule fois :** on transforme la chaîne du motif en un objet `*regexp.Regexp` optimisé.
    
2.  **Utiliser l'objet compilé plusieurs fois :** on utilise cet objet pour chercher, remplacer ou découper du texte.
    

Pour des performances optimales, compilez vos expressions régulières une seule fois et réutilisez-les.

La manière idiomatique est de les déclarer comme des variables globales au niveau du paquet en utilisant `regexp.MustCompile`.

content\_copy

    // Bonne pratique : compilé une fois, réutilisé partout.
    // Les ` ` évite d'avoir à échapper les `\`.
    var reChiffres = regexp.MustCompile(`\d+`)

#### **Qu'est-ce que "compiler" une expression régulière ?**

Cela signifie que `Go` ne va pas simplement stocker le texte `\d+`. Il va l'analyser, le valider, et le transformer en un objet optimisé (une sorte de petit programme interne).

Cet objet est ensuite capable de rechercher des correspondances de manière extrêmement rapide dans n'importe quel texte.

#### **Pourquoi `MustCompile` et pas simplement `Compile` ?**

Il existe une autre fonction, `regexp.Compile()`.

*   `Compile()` renvoie l'objet compilé **et une erreur**. Elle est utilisée quand l'expression régulière peut être invalide (par exemple, si elle vient d'une saisie utilisateur).
    
*   `MustCompile()` ne renvoie que l'objet compilé. Si l'expression est syntaxiquement incorrecte, la fonction déclenche un **`panic`**, ce qui arrête immédiatement le programme. On l'utilise au niveau global (en dehors d'une fonction) pour des expressions que l'on sait valides. Si on a fait une erreur, le programme plantera dès le démarrage, nous forçant à la corriger, ce qui est un comportement souhaitable.
    

### Exemple de base : vérifier et trouver un motif simple

Avant d'explorer les extractions complexes, voyons le cas d'usage le plus courant : vérifier si une chaîne de caractères contient un motif donné.

Dans cet exemple, nous allons simplement vérifier si une chaîne contient des chiffres.

content\_copy

    package main
    
    import (
    	"fmt"
    	"regexp"
    )
    
    // Bonne pratique : on compile l'expression une seule fois au démarrage.
    // `\d` est un métacaractère qui représente n'importe quel chiffre de 0 à 9.
    // `+` signifie "au moins une fois".
    // L'ensemble `\d+` recherche donc une séquence d'un ou plusieurs chiffres.
    var contientChiffres = regexp.MustCompile(`\d+`)
    
    func main() {
    	texte1 := "Le produit coûte 42 euros."
    	texte2 := "Ceci est une phrase sans nombre."
    	texte3 := "Les commandes 123 et 456 ont été passées le 07/09/2025."
    
    	// 1. La méthode MatchString : la plus simple
    	// Elle renvoie `true` si le motif est trouvé, sinon `false`.
    	// C'est très efficace pour une simple validation.
    	fmt.Printf("'%s' contient des chiffres ? %t\n", texte1, contientChiffres.MatchString(texte1))
    	fmt.Printf("'%s' contient des chiffres ? %t\n", texte2, contientChiffres.MatchString(texte2))
    
    	// 2. La méthode FindString : pour extraire la première correspondance
    	// Elle renvoie la première sous-chaîne qui correspond au motif.
    	// Si aucune correspondance n'est trouvée, elle renvoie une chaîne vide.
    	match := contientChiffres.FindString(texte1)
    	fmt.Printf("Le premier nombre trouvé dans le texte 1 est : '%s'\n", match)
    
    	match2 := contientChiffres.FindString(texte2)
    	fmt.Printf("Le premier nombre trouvé dans le texte 2 est : '%s'\n", match2)
    
    	// 3. La méthode FindAllString : pour extraire toutes les correspondances
    	// Elle renvoie une slice (un tableau dynamique) de toutes les sous-chaînes qui correspondent.
    	// Le deuxième argument `-1` signifie "trouver toutes les occurrences".
    	tousLesNombres := contientChiffres.FindAllString(texte3, -1)
    	fmt.Printf("Tous les nombres trouvés dans le texte 3 sont : %v\n", tousLesNombres)
    }
    

Résultat :

content\_copy

    'Le produit coûte 42 euros.' contient des chiffres ? true
    'Ceci est une phrase sans nombre.' contient des chiffres ? false
    Le premier nombre trouvé dans le texte 1 est : '42'
    Le premier nombre trouvé dans le texte 2 est : ''
    Tous les nombres trouvés dans le texte 3 sont : [123 456 07 09 2025]

### **Extraire des sous-parties avec les groupes de capture**

La fonctionnalité la plus puissante des expressions régulières est la capacité d'extraire des sous-parties d'une correspondance en utilisant des parenthèses `()`, appelées **groupes de capture**.

#### Les groupes de capture nommés

Vous pouvez les numéroter implicitement ou, mieux encore, les nommer explicitement avec la syntaxe : `(?P<nom>...)`.

#### La fonction `SubexpIndex`

La fonction `SubexpIndex` est appelée sur un objet `*regexp.Regexp` (une expression régulière compilée) et prend le nom du groupe de capture en tant que chaîne de caractères. **Elle retourne un entier qui correspond à l'index de ce groupe**.

Si le nom du groupe n'existe pas dans l'expression régulière, la fonction retourne **\-1**.

Voici les points clés :

*   **Entrée** : le nom d'un groupe de capture (`string`).
    
*   **Sortie** : l'index de ce groupe (`int`).
    

Une fois que vous avez cet index, vous pouvez l'utiliser pour accéder directement à la valeur capturée correspondante dans le slice de chaînes de caractères retourné par une fonction de correspondance de sous-expressions (par exemple, `FindStringSubmatch`).

content\_copy

    package main
    
    import (
    	"fmt"
    	"regexp"
    )
    
    func main() {
    	ligne := "fichier: rapport_2025.pdf"
    	// On nomme nos groupes de capture "nom" et "annee"
    	re := regexp.MustCompile(`(?P<nom>\w+)_(?P<annee>\d{4})\.pdf`)
    	
    	match := re.FindStringSubmatch(ligne)
    	
    	if match != nil {
    		fmt.Printf("Correspondance complète : %s\n", match[0]) // Toujours la correspondance complète
    
    		// Accès par index : moins lisible
    		fmt.Printf("Nom (index 1): %s\n", match[1])
    		fmt.Printf("Année (index 2): %s\n", match[2])
    		
    		// Accès efficace et lisible par nom de groupe
    		indexAnnee := re.SubexpIndex("annee")
    		fmt.Printf("Année trouvée efficacement : %s\n", match[indexAnnee])
    	}
    }

### **Remplacements avancés**

Le remplacement va bien au-delà de `ReplaceAllString`.

*   **Remplacement avec des groupes :** vous pouvez réutiliser le contenu des groupes capturés (numérotés `$1`, `$2` ou nommés `$nom`) dans la chaîne de remplacement.
    
*   **Remplacement littéral :** `ReplaceAllLiteralString` insère la chaîne de remplacement telle quelle, sans interpréter les `$`.
    
*   **Remplacement avec une fonction :** `ReplaceAllStringFunc` vous donne un contrôle total en vous permettant d'exécuter du code pour chaque correspondance.
    
*   **Gabarits de remplacement `Expand` :** `Expand` est une fonction avancée qui permet de construire une nouvelle chaîne à partir d'un gabarit et des résultats d'une correspondance, ce qui est très utile lorsque vous avez déjà les indices des correspondances.
    

content\_copy

    package main
    
    import (
    	"fmt"
    	"regexp"
    	"strings"
    )
    
    func main() {
    	// 1. Remplacement avec des groupes nommés
    	reDate := regexp.MustCompile(`(?P<annee>\d{4})-(?P<mois>\d{2})-(?P<jour>\d{2})`)
    	dateUS := "2025-09-07"
    	dateFR := reDate.ReplaceAllString(dateUS, "${jour}/${mois}/${annee}")
    	fmt.Println("Date formatée :", dateFR) // Affiche "07/09/2025"
    
    	// 2. Remplacement avec une fonction pour mettre en majuscules
    	texte := "J'aime Go et go est génial"
    	reGo := regexp.MustCompile(`(?i)go`) // (?i) pour ignorer la casse
    	texteMaj := reGo.ReplaceAllStringFunc(texte, strings.ToUpper)
    	fmt.Println("Texte transformé :", texteMaj) // Affiche "J'aime GO et GO est génial"
    
    	// 3. Remplacement littéral vs normal
    	reVar := regexp.MustCompile(`\$(\w+)`)
    	src := "prix : $value"
    	fmt.Println("Remplacement normal  :", reVar.ReplaceAllString(src, "<$1>")) // Affiche "prix : <value>"
    	fmt.Println("Remplacement littéral:", reVar.ReplaceAllLiteralString(src, "<$1>")) // Affiche "prix : <$1>"
    }
    

**Voici quelques précisions pour bien comprendre le dernier exemple.**

**L'expression régulière** : `\$(\w+)`

*   `\$` : recherche un caractère dollar `$` littéral (l'antislash `\` est nécessaire car `$` a un sens spécial en regex).
    
*   `(\w+)` : c'est un groupe de capture (le premier) qui attrape un ou plusieurs caractères de "mot" (lettres, chiffres). Dans `"$value"`, il capture `value`.
    

Ici, on voit la différence cruciale entre deux fonctions :

**`ReplaceAllString(src, "<$1>")` (Normal)**

*   Cette fonction **interprète** les `$` dans la chaîne de remplacement.
    
*   `$1` est un code spécial qui signifie "insérer le contenu du premier groupe de capture".
    
*   Comme le premier groupe a capturé `value`, le remplacement devient `<value>`.
    

**`ReplaceAllLiteralString(src, "<$1>")` (Littéral)**

*   Cette fonction **n'interprète rien**. Elle considère la chaîne de remplacement comme du texte brut.
    
*   Elle remplace donc la correspondance `"$value"` par la chaîne littérale `"<` `$` `1` `>"`.
    

### **Le moteur `RE2` : performance et sécurité avant tout**

Une question fondamentale est de savoir _comment_ `Go` exécute les expressions régulières.

Contrairement à de nombreux autres langages (comme `Perl`, `Python`, ou `JavaScript`) qui utilisent des moteurs basés sur le "`backtracking`", le paquet `regexp` de `Go` est basé sur le moteur `**RE2**` de `Google`.

Cette décision technique a des implications profondes :

*   **Garantie de performance :** la principale caractéristique de `RE2` est qu'il garantit une exécution en **temps linéaire** par rapport à la taille du texte d'entrée. Cela signifie que le temps de recherche est prévisible et ne peut pas "exploser" de manière exponentielle, même avec des motifs complexes sur des textes malicieux.
    
*   **Protection contre le `ReDoS` :** cette garantie protège vos applications contre les attaques par déni de service par expression régulière (`ReDoS`, `_Regular Expression Denial of Service_`), où un attaquant envoie une chaîne spécialement conçue pour bloquer votre serveur dans une boucle de `backtracking` quasi-infinie.
    

Pour offrir cette garantie de sécurité et de performance, `RE2` omet volontairement certaines fonctionnalités complexes présentes dans d'autres moteurs :

*   **Les `"lookarounds"`** (assertions avant/arrière comme `(?=...)`, `(?!...)`, etc.) ne sont pas supportés.
    
*   **Les `"backreferences"`** (comme `\1` pour faire référence au contenu du premier groupe de capture) ne sont pas supportées.
    

Pour la liste complète de la syntaxe supportée, référez-vous à la [documentation officielle de la syntaxe RE2](https://github.com/google/re2/wiki/Syntax).

### **Sémantique de recherche : `leftmost-first` vs `leftmost-longest`**

Par défaut, le moteur de `Go` utilise la sémantique **`leftmost-first`**.

Cela signifie que lorsqu'il a plusieurs correspondances possibles qui commencent au même endroit, il choisit la **première** alternative listée dans le motif.

La sémantique **`leftmost-longest`**, utilisée par les outils `POSIX` traditionnels, choisit la correspondance la **plus longue** parmi celles qui commencent le plus tôt.

`Go` vous permet de choisir le comportement :

*   `regexp.MustCompile` / `regexp.Compile` : utilisent `leftmost-first`.
    
*   `regexp.MustCompilePOSIX` / `regexp.CompilePOSIX` : utilisent `leftmost-longest`.
    
*   `re.Longest()` : bascule un `*regexp.Regexp` existant en mode `leftmost-longest`.
    

content\_copy

    package main
    
    import (
    	"fmt"
    	"regexp"
    )
    
    func main() {
    	texte := "ab"
    	motif := `a|ab`
    
    	// 1. Comportement par défaut : leftmost-first
    	re := regexp.MustCompile(motif)
    	fmt.Printf("Défaut (leftmost-first)  : %s\n", re.FindString(texte)) // Trouve 'a' et s'arrête.
    
    	// 2. Basculer en mode leftmost-longest
    	re.Longest()
    	fmt.Printf("Après .Longest()         : %s\n", re.FindString(texte))
    
    	// 3. Utiliser la compilation POSIX directement
    	rePOSIX := regexp.MustCompilePOSIX(motif)
    	fmt.Printf("POSIX (leftmost-longest) : %s\n", rePOSIX.FindString(texte))
    }

Résultat :

content\_copy

    Défaut (leftmost-first)  : a
    Après .Longest()         : ab
    POSIX (leftmost-longest) : ab

### **Drapeaux, ancres et sécurité**

#### **Drapeaux (`?flags`)**

Vous pouvez modifier le comportement d'un motif en utilisant des drapeaux.

*   `(?i)` : **insensible à la casse.** `(?i)go` trouvera "go", "Go", "GO", etc. Notez qu'il utilise le _simple case folding_ d'Unicode, qui est suffisant dans la plupart des cas.
    
*   `(?m)` : **mode multiligne.** Par défaut, `^` et `$` ne correspondent qu'au début et à la fin de la chaîne entière. Avec `(?m)`, ils correspondent aussi au début et à la fin de chaque ligne.
    
*   `(?s)` : **"`single line`" ou "`dot all`".** Par défaut, le `.` ne correspond pas aux sauts de ligne (`\n`). Avec `(?s)`, il le fait.
    
*   `(?U)` : rend les quantificateurs non gourmands par défaut (mode “`ungreedy`”). utile quand tu veux limiter la portée de \``.*`\` sans ajouter \``?`\` partout.

Nous allons utiliser les drapeaux `(?i)` pour l'insensibilité à la casse et `(?m)` pour le mode multiligne. L'objectif est de trouver toutes les lignes qui commencent par le mot "go", quelle que soit la casse.

content\_copy

    package main
    
    import (
    	"fmt"
    	"regexp"
    )
    
    func main() {
    	texteMultiLigne := `Go est un langage de programmation.
    Le code est simple en go.
    Fin de la phrase.
    go est aussi très performant.`
    
    	// On combine les drapeaux (?i) et (?m) directement dans le motif.
    	// (?i) : Rend la recherche insensible à la casse.
    	// (?m) : Permet aux ancres ^ et $ de correspondre au début et à la fin de chaque ligne.
    	// Le motif `^go` recherche donc "go" au tout début d'une ligne.
    	re := regexp.MustCompile(`(?im)^go`)
    
    	// On utilise FindAllString pour obtenir toutes les correspondances.
    	// Le -1 en deuxième argument signifie "trouver toutes les occurrences".
    	correspondances := re.FindAllString(texteMultiLigne, -1)
    
    	fmt.Println("Texte analysé :")
    	fmt.Println(texteMultiLigne)
    	fmt.Println("---")
    	fmt.Printf("Lignes commençant par 'go' (peu importe la casse) : %v\n", correspondances)
    }

Résultat :

content\_copy

    Texte analysé :
    Go est un langage de programmation.
    Le code est simple en go.
    Fin de la phrase.
    go est aussi très performant.
    ---
    Lignes commençant par 'go' (peu importe la casse) : [Go go]

#### **Ancres et assertions (`\A`, `\z`, `\b`)**

`\A` et `\z` : ancrent le début absolu (`\A`) et la fin absolue (`\z`) de la chaîne, indépendamment du mode multiligne (`?m`). c’est idéal pour valider qu’une chaîne entière correspond à un format.

`\b` : assertion de frontière de mot `ASCII` (et non une ancre). pour du texte international, préfère les classes `Unicode` comme `\p{L}`, `\p{N}`, etc.

content\_copy

    // valide qu'une chaîne est exactement un code hexadécimal ASCII de 8 caractères
    re := regexp.MustCompile(`\A[0-9A-F]{8}\z`)
    fmt.Println(re.MatchString("1234ABCD"))   // true
    fmt.Println(re.MatchString(" 1234ABCD ")) // false

**Sécuriser les entrées utilisateur avec `QuoteMeta` :** si vous devez inclure du texte fourni par un utilisateur dans une expression régulière, il est **impératif** de l'échapper avec `regexp.QuoteMeta`. Cela empêche l'utilisateur d'injecter des méta-caractères qui pourraient altérer la logique de votre motif ou causer une erreur.

content\_copy

    // L'utilisateur recherche le terme "Go (v1.25)"
    termeUtilisateur := "Go (v1.25)"
    termeEchappe := regexp.QuoteMeta(termeUtilisateur)
    // termeEchappe est maintenant "Go \(v1\.25\)"
    re := regexp.MustCompile(`\b` + termeEchappe + `\b`)

### **Quand ne PAS utiliser `regexp`**

Les expressions régulières sont un outil puissant, mais parfois excessif ou dangereux.

Pour des formats standards, la bibliothèque `Go` offre des paquets dédiés, plus robustes, plus performants et plus sûrs.

**Règle d'or idiomatique :** pour analyser des e-mails, des `URLs` ou des adresses `IP`, préférez **toujours** les paquets `net/mail`, `net/url` et `net/netip` plutôt qu'un motif fait maison, qui sera presque certainement incomplet, incorrect et potentiellement vulnérable.

### **Performance, concurrence et `I/O` avancées**

_**Ces notions sont avancées, revenez-y plus tard lorsque vous aurez terminé la formation.**_

**Sécurité en concurrence :** `Go` garantit qu'un objet `*regexp.Regexp` compilé est **sûr pour une utilisation concurrente par plusieurs `goroutines`**. Vous pouvez donc le déclarer une fois comme une variable globale et le partager dans toute votre application sans avoir besoin de verrous (`mutex`).

**Exception importante :** les méthodes de configuration comme `re.Longest()` modifient l'état interne de l'objet et **ne sont pas sûres en concurrence**. Elles ne doivent être appelées qu'une seule fois, lors de l'initialisation.

**Travailler avec `[]byte` pour moins d'allocations :** pour des chemins de code critiques (`_hot paths_`), le paquet `regexp` offre des variantes de la plupart des méthodes qui travaillent directement sur des `[]byte` (ex: `Find`, `Match`, `ReplaceAll`). Cela peut éviter des conversions coûteuses entre `[]byte` et `string`.

**Remplacements sans allocations avec `Expand` :** lorsque la performance est critique, vous pouvez éviter les allocations des méthodes `Find*Submatch` en utilisant `FindSubmatchIndex` pour obtenir les positions des correspondances, puis `Expand` pour construire le résultat dans un tampon pré-alloué.

content\_copy

    // idx contient les paires [début, fin] pour chaque groupe
    idx := re.FindSubmatchIndex(sourceBytes)
    
    // Expand utilise un gabarit ("template") et les indices pour construire le résultat
    // en l'ajoutant à `dest`, ce qui peut éviter une allocation.
    dest := re.Expand(nil, []byte("Résultat: $1"), sourceBytes, idx)  

**Lecture en flux pour les fichiers volumineux :** pour analyser un fichier de plusieurs gigaoctets, le charger entièrement en mémoire avec `os.ReadFile` est une mauvaise idée.

Le paquet `regexp` fournit des méthodes pour travailler directement sur des flux de données (`io.Reader`), ce qui est beaucoup plus efficace en termes de mémoire.

*   `re.FindReaderIndex(reader)`
    
*   `re.MatchReader(reader)`
    

content\_copy

    r := bufio.NewReader(f)            // f est un *os.File ouvert
    if re.MatchReader(r) {
        // il y a au moins une correspondance dans le flux
    }

**Optimisation `LiteralPrefix` :**  la méthode `re.LiteralPrefix()` retourne le préfixe littéral (s’il existe). tu peux t’en servir pour court-circuiter rapidement les non-candidats avant la recherche complète.

content\_copy

    p, ok := re.LiteralPrefix()
    if ok && !strings.HasPrefix(s, p) {
        // s ne peut pas correspondre : on évite le coût d'une recherche regex
        return
    }

### Sur cette page

*   Qu'est-ce qu'une expression régulière ?
*   Le processus et les bonnes pratiques en Go
*   Qu'est-ce que "compiler" une expression régulière ?
*   Pourquoi MustCompile et pas simplement Compile ?
*   Exemple de base : vérifier et trouver un motif simple
*   Extraire des sous-parties avec les groupes de capture
*   Les groupes de capture nommés
*   La fonction SubexpIndex
*   Remplacements avancés
*   Le moteur RE2 : performance et sécurité avant tout
*   Sémantique de recherche : leftmost-first vs leftmost-longest
*   Drapeaux, ancres et sécurité
*   Drapeaux (?flags)
*   Ancres et assertions (\\A, \\z, \\b)
*   Quand ne PAS utiliser regexp
*   Performance, concurrence et I/O avancées