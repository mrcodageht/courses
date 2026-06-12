Nous arrivons à la dernière instruction de contrôle de ce chapitre. C'est une instruction que vous ne verrez que très rarement dans du code `Go` moderne, **et que vous ne devriez probablement jamais utiliser vous-même**. Cependant, elle fait partie du langage, et il est bon de savoir ce qu'elle fait au cas où vous la croiseriez.

L'instruction `goto` est un héritage d'anciens langages de programmation. **Son utilisation est fortement déconseillée** car elle rend le code difficile à lire et à maintenir, un phénomène souvent qualifié de "code spaghetti".

### **Qu'est-ce que `goto` ?**

`goto` est un saut inconditionnel. Il permet de transférer le contrôle du programme à un autre point arbitraire **à l'intérieur de la même fonction**. Ce point de destination est marqué par un **label**.

Un label est simplement un nom suivi de deux-points (`:`).

content\_copy

    // ... code ...
    goto MonLabel // Saute à l'endroit marqué par MonLabel
    
    // ... autre code qui sera sauté ...
    
    MonLabel:
    // L'exécution reprend ici.
    // ... suite du code ...

### **Exemple de fonctionnement**

Voici un exemple simple, bien que totalement artificiel, pour illustrer le mécanisme de saut.

content\_copy

    package main
    
    import "fmt"
    
    func main() {
        compteur := 0
    
    BoucleDeVerification: // On définit un label ici.
        fmt.Println("Vérification numéro", compteur)
        compteur++
        if compteur < 3 {
            goto BoucleDeVerification // On saute en arrière pour répéter le bloc.
        }
    
        fmt.Println("Fin des vérifications.")
    }

**Résultat :**

content\_copy

    Vérification numéro 0
    Vérification numéro 1
    Vérification numéro 2
    Fin des vérifications.

Cet exemple aurait bien sûr dû être écrit avec une simple boucle `for`. Il ne sert qu'à vous montrer comment `goto` force le programme à sauter à un autre endroit.

### **Pourquoi `goto` est-il considéré comme une mauvaise pratique ?**

**Lisibilité détruite :** la plus grande force de `Go` est sa clarté. Le code se lit généralement de haut en bas. `goto` brise ce flux de lecture. En voyant un `goto`, vous ne savez pas où l'exécution va se poursuivre sans chercher le label, qui peut se trouver n'importe où dans la fonction.

**"Code spaghetti" :** dans des fonctions complexes, plusieurs `goto` peuvent créer un enchevêtrement de sauts dans tous les sens, rendant la logique du programme impossible à suivre. C'est comme essayer de suivre un plat de spaghettis en ne regardant qu'un seul fil.

**Il existe toujours de meilleures alternatives :** toutes les structures que nous avons vues (`if`, `switch`, `for`, `break`, `continue`) et que nous verrons plus tard (`defer`, `return`) ont été conçues pour structurer le code de manière claire et prévisible. Dans la quasi-totalité des cas, l'une de ces instructions est une bien meilleure solution qu'un `goto`. Même pour sortir d'une boucle imbriquée, le `break` avec un label est plus propre et plus clair.

### **Contraintes du compilateur**

Pour limiter les abus et les erreurs les plus graves, le compilateur `Go` impose des règles de sécurité strictes à l'utilisation de `goto` :

#### **Impossible de sauter par-dessus une déclaration de variable**

Vous ne pouvez pas utiliser `goto` pour sauter à un label si ce saut traverse une ligne où une nouvelle variable est déclarée. Cela empêche d'utiliser une variable qui n'a pas encore été initialisée.

content\_copy

    // CE CODE NE COMPILE PAS
    goto MonLabel
    x := 5 // Le saut passe par-dessus cette déclaration
    MonLabel:
    // À ce point, 'x' ne serait pas défini, d'où l'erreur de compilation.

#### `goto` ne peut pas **entrer** dans un bloc

Un `goto` à l’extérieur d’un bloc ne peut pas sauter vers un `label` à l’intérieur de ce bloc.

content\_copy

    package main
    
    func main() {
        goto Interieur // ❌ interdit : saute dans un bloc
    
        if true {
        Interieur:
            println("on ne peut pas entrer dans ce bloc via goto")
        }
    }
    

Le compilateur renvoie une erreur du type : `goto Interieur jumps into block`

#### **Un label doit être utilisé**

Si vous déclarez un label dans votre code mais qu'aucun `goto` ne pointe vers lui, le compilateur générera une erreur. Cela permet de garder le code propre et d'éviter les "points morts".

### **Existe-t-il un cas d'usage légitime ?**

Dans des cas extrêmement rares et pour du code de très bas niveau (par exemple, du code traduit automatiquement depuis le `C`), un `goto` peut être utilisé pour sauter à une section de nettoyage à la fin d'une fonction, mais même ce cas est généralement mieux géré avec `defer`.

**Pour un développeur `Go`, la règle est simple : n'utilisez pas `goto`.**

### Sur cette page

*   Qu'est-ce que goto ?
*   Exemple de fonctionnement
*   Pourquoi goto est-il considéré comme une mauvaise pratique ?
*   Contraintes du compilateur
*   Impossible de sauter par-dessus une déclaration de variable
*   goto ne peut pas entrer dans un bloc
*   Un label doit être utilisé
*   Existe-t-il un cas d'usage légitime ?