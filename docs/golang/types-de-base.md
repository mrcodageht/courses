### **Les nombres entiers : `int`**

Le type `int` est utilisé pour stocker des nombres entiers, c'est-à-dire des nombres sans partie décimale, qu'ils soient positifs, négatifs ou nuls.`   `

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Déclaration avec inférence de type, Go choisit `int` par défaut.
        var age = 42
        var annee = 2025
        var temperature = -5
    
        fmt.Println("Âge :", age)
        fmt.Println("Année :", annee)
        fmt.Println("Température :", temperature)
    }

**Les variantes de `int`**

En réalité, `int` est un alias. Sa taille (`32` ou `64 bits`) dépend de l'architecture de votre ordinateur. Pour un contrôle plus fin, `Go` propose des types d'entiers de taille fixe :

*   **Signés** (positifs et négatifs) : `int8`, `int16`, `int32`, `int64`
    
*   **Non signés** (uniquement 0 et positifs) : `uint8`, `uint16`, `uint32`, `uint64`
    

Le chiffre indique le nombre de `bits` utilisés pour stocker le nombre.

Plus le nombre de `bits` est grand, plus la plage de valeurs possibles est grande.

En général, vous utiliserez simplement `int` et laisserez `Go` faire le bon choix pour vous.

### **Les nombres à virgule flottante : `float`**

Pour les nombres avec une partie décimale, comme les prix, les mesures ou les résultats de calculs scientifiques, on utilise les types à virgule flottante :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        // Par défaut, Go infère le type `float64`.
        var prix = 99.99
        var pi = 3.1415926535
    
        fmt.Println("Le prix est de :", prix)
        fmt.Println("La valeur de Pi est environ :", pi)
    }

`Go` propose deux tailles :

*   `float32` : Précision simple.
    
*   `float64` : Précision double.
    

La quasi-totalité du temps, vous utiliserez `float64`.

C'est le type par défaut car il offre une bien meilleure précision, ce qui est crucial pour éviter les erreurs d'arrondi dans les calculs.

### **Le texte : `string`**

Le type `string` est utilisé pour représenter une séquence de caractères, c'est-à-dire du texte.

En `Go`, les chaînes de caractères sont placées entre des guillemets doubles `""`

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        var salutation = "Bonjour, monde !"
        var nom = "Alice"
    
        fmt.Println(salutation)
        fmt.Println("Je m'appelle", nom)
    }

Une propriété très importante des `string` en `Go` est qu'elles sont **immuables**.

Cela signifie qu'une fois qu'une chaîne est créée, vous ne pouvez pas en modifier un caractère individuel. Vous pouvez seulement créer une nouvelle chaîne à partir de l'ancienne.

### **Les valeurs de vérité : `bool`**

Le type `bool` (booléen) est le plus simple de tous. Il ne peut avoir que deux valeurs possibles : `true` (vrai) ou `false` (faux).

Les booléens sont le fondement de la logique conditionnelle (les instructions `if`, que nous verrons bientôt) :

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        var estActif = true
        var aReussi = false
    
        fmt.Println("L'utilisateur est-il actif ?", estActif)
        fmt.Println("L'opération a-t-elle réussi ?", aReussi)
    }
     

### **Les caractères : `rune` et `byte`**

C'est un point très important en `Go`. Pour comprendre la différence, utilisons une analogie : un message `SMS`.

*   Ce que **vous** écrivez est une suite de caractères : `Salut 👋`. C'est le concept humain, la `**rune**`.
    
*   Ce que votre **téléphone** envoie est une suite de données binaires (d'octets) qui représentent ce message. C'est la réalité informatique, le `**byte**`.
    

Go fait cette distinction car, avec l'encodage moderne (`UTF-8`), un caractère conceptuel ne correspond pas toujours à un seul octet.

*   `A` prend 1 `octet`.
    
*   `é` prend 2 `octets`.
    
*   `👋` prend 4 `octets`.
    

C'est pour cela que `Go` nous donne deux outils :

#### **`byte` : la vision de la machine**

*   **Qu'est-ce que c'est ?** Un `byte` est un alias pour `uint8`. C'est l'unité de base de la mémoire de l'ordinateur, un nombre entier non signé allant de `0` à `255`.
    
*   **Quand l'utiliser ?** Quand vous manipulez des **données brutes**, pas du texte. C'est le type que vous utiliserez pour lire un fichier image, recevoir des données d'un réseau, ou travailler avec des données binaires. Vous pensez en termes d'octets.
    

#### **`rune` : la vision de l'humain**

*   **Qu'est-ce que c'est ?** Une `rune` est un alias pour `int32`. Elle est assez grande pour contenir n'importe quel **caractère Unicode**, qu'il s'agisse d'une lettre, d'un accent, d'un idéogramme chinois ou d'un emoji.
    
*   **Quand l'utiliser ?** Quand vous voulez manipuler du **texte** en tant que tel. Si vous avez besoin de compter le nombre de lettres dans un mot ou d'inspecter le troisième caractère d'une phrase, vous devez penser en termes de runes.
    

Regardons le mot "résumé". Il a bien 6 lettres pour un humain.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        mot := "résumé"
    
        // 1. La vision de la machine (en bytes)
        // La fonction len() en Go retourne la taille en bytes.
        fmt.Printf("Le mot '%s' a une longueur de %d bytes.\n", mot, len(mot))
        // Affiche 8 bytes, car 'é' et 'é' prennent 2 bytes chacun en UTF-8.
    
        // 2. La vision de l'humain (en runes)
        // Pour compter les caractères, il faut convertir la chaîne en une suite de runes.
        nombreDeCaracteres := len([]rune(mot))
        fmt.Printf("Mais il contient %d caractères (runes).\n", nombreDeCaracteres)
        // Affiche 6 runes, ce qui correspond bien aux 6 lettres du mot.
    }
    

**Retenez ceci :** si vous pensez "caractère" (une lettre, un symbole), utilisez `rune`. Si vous pensez "octet" (donnée brute), utilisez `byte`.

L'utilité principale du type **`byte`** apparaît lorsque vous ne manipulez plus du texte conceptuel, mais des **données brutes**. Pensez à toutes les informations qu'un ordinateur manipule qui ne sont pas du langage humain : une image, un fichier audio, un document `PDF`, ou les données envoyées sur un réseau.

L'exemple le plus courant est la lecture d'un fichier sur votre disque dur. Quand `Go` lit un fichier, il ne sait pas si c'est du texte, une image ou une vidéo. Il le voit comme une simple séquence d'octets. Le type `[]byte` (une "slice" de `bytes`, que nous verrons plus tard) est donc le conteneur naturel pour ces données.

Utilisez **`byte`** lorsque :

*   Vous lisez ou écrivez des fichiers.
    
*   Vous communiquez sur un réseau (`HTTP`, `TCP`).
    
*   Vous manipulez des données binaires comme des images, du son, etc.
    

Le type `byte` est donc votre outil pour travailler au plus près de la machine, là où l'information est une simple suite de nombres.

### Sur cette page

*   Les nombres entiers : int
*   Les nombres à virgule flottante : float
*   Le texte : string
*   Les valeurs de vérité : bool
*   Les caractères : rune et byte
*   byte : la vision de la machine
*   rune : la vision de l'humain