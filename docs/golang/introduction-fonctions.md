### **Pourquoi utiliser des fonctions ?**

Jusqu'à présent, tout notre code se trouvait à l'intérieur d'une seule et unique fonction : `main()`.

C'est un bon point de départ, mais pour des programmes plus complexes, tout mettre au même endroit devient rapidement un désordre ingérable.

La solution est d'organiser notre code en **fonctions**.

Une fonction est un bloc de code nommé, indépendant et réutilisable, conçu pour accomplir une tâche spécifique. Pensez à une fonction comme à une mini-recette à l'intérieur de votre grand livre de cuisine : au lieu de réécrire les instructions pour faire une sauce béchamel à chaque fois, vous écrivez la recette une bonne fois pour toutes et vous y faites référence quand vous en avez besoin.

L'utilisation de fonctions est l'un des principes les plus fondamentaux de la programmation. Elle offre trois avantages majeurs :

1.  **Organisation :** les fonctions découpent un gros problème complexe en plusieurs petits problèmes simples et gérables. Votre fonction `main()` devient alors un chef d'orchestre qui appelle d'autres fonctions pour accomplir des tâches spécifiques, rendant le flux du programme beaucoup plus clair.
    
2.  **Réutilisabilité :** une fois qu'une fonction est écrite et testée, vous pouvez l'appeler (l'utiliser) autant de fois que vous le souhaitez, depuis n'importe quel endroit de votre programme, avec des données différentes. Cela évite la duplication de code, qui est une source majeure de bugs.
    
3.  **Lisibilité :** un code bien découpé en fonctions est beaucoup plus facile à lire et à comprendre. Le nom de la fonction (`calculerMoyenne`, `saluerUtilisateur`) décrit ce qu'elle fait, ce qui rend le code presque auto-documenté.
    

### **Définir une fonction**

En `Go`, la syntaxe pour définir une fonction est la suivante :

content\_copy

    func nomDeLaFonction(parametre1 type1, parametre2 type2) typeDeRetour {
        // Corps de la fonction (la logique)
        return valeurDeRetour
    }
     

Décortiquons chaque partie :

*   `func` : le mot-clé qui indique que nous définissons une fonction.
    
*   `nomDeLaFonction` : le nom que vous donnez à votre fonction. Il doit être descriptif.
    
*   `(parametre1 type1, ...)` : la liste des **paramètres** (aussi appelés arguments). Ce sont les "ingrédients" que la fonction reçoit pour travailler. Chaque paramètre a un nom et un type. Une fonction peut n'avoir aucun paramètre `()`.
    
*   `typeDeRetour` : le type de la "réponse" que la fonction renvoie une fois son travail terminé. Une fonction peut ne rien retourner.
    
*   `{ ... }` : le corps de la fonction, qui contient les instructions à exécuter.
    
*   `return` : le mot-clé pour renvoyer la réponse. L'exécution de la fonction s'arrête immédiatement après un `return`.
    

### **Le passage par valeur (_`pass by value`_)**

C'est un concept **fondamental** en `Go`.

Lorsque vous appelez une fonction avec une variable, `Go` ne donne pas la variable originale à la fonction. Il en fait une **copie** et donne cette copie à la fonction.

Cela signifie que si la fonction modifie la valeur du paramètre qu'elle a reçu, elle ne modifie que sa copie locale.

La variable originale, à l'extérieur de la fonction, n'est **jamais** affectée.

content\_copy

    package main
    
    import "fmt"
    
    func incrementer(nombre int) {
        // 'nombre' ici est une COPIE de la valeur passée en argument.
        nombre = nombre + 1
        fmt.Printf("Dans la fonction, la valeur est : %d\n", nombre)
    }
    
    func main() {
        valeurOriginale := 10
        fmt.Printf("Avant l'appel, la valeur originale est : %d\n", valeurOriginale)
    
        incrementer(valeurOriginale) // On passe une copie de 10 à la fonction.
    
        fmt.Printf("Après l'appel, la valeur originale est toujours : %d\n", valeurOriginale)
    }
     

**Résultat :**

content\_copy

    Avant l'appel, la valeur originale est : 10
    Dans la fonction, la valeur est : 11
    Après l'appel, la valeur originale est toujours : 10

C'est une garantie de sécurité : une fonction ne peut pas modifier accidentellement l'état de votre programme sans que vous le sachiez.

### **Exemples pratiques**

#### **Une fonction qui retourne une valeur**

Cette fonction prend un nom en paramètre et retourne un message de salutation.

content\_copy

    package main
    
    import "fmt"
    
    func creerMessageSalutation(nom string) string {
        message := fmt.Sprintf("Bonjour, %s ! Bienvenue.", nom)
        return message
    }
    
    func main() {
        salutationPourAlice := creerMessageSalutation("Alice")
        fmt.Println(salutationPourAlice)
    }

`   `**Une fonction qui retourne un calcul**

Si plusieurs paramètres consécutifs ont le même type, on peut écrire le type une seule fois à la fin.

content\_copy

    package main
    
    import "fmt"
    
    func additionner(a, b int) int {
        somme := a + b
        return somme
    }
    
    func main() {
        resultat := additionner(10, 5)
        fmt.Printf("10 + 5 = %d\n", resultat)
    }

`   `**Une fonction qui ne retourne rien (une "procédure")**

Parfois, une fonction a juste besoin d'effectuer une action, comme afficher quelque chose, sans avoir besoin de renvoyer une réponse.

Dans ce cas, on omet simplement le type de retour.

content\_copy

    package main
    
    import "fmt"
    
    func afficherLigneSeparatrice() {
        fmt.Println("--------------------")
    }
    
    func main() {
        fmt.Println("Première section")
        afficherLigneSeparatrice()
        fmt.Println("Deuxième section")
    }

### Sur cette page

*   Pourquoi utiliser des fonctions ?
*   Définir une fonction
*   Le passage par valeur (pass by value)
*   Exemples pratiques
*   Une fonction qui retourne une valeur