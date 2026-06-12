### **Le `Zen` de `Go` : les proverbes idiomatiques**

Ces proverbes, [partagés par `Rob Pike`](https://youtu.be/PAAkCSZUG1c?si=CnY-ScZMy_v7zn9a&t=12), l'un des co-créateurs de `Go`, sont des [principes qui guident l'écriture](https://go-proverbs.github.io/) de code simple, fiable et maintenable.

Voyons les principaux qui nous permettront de bien débuter votre apprentissage.

#### **"`Clear is better than clever.`" (la clarté est préférable à l'ingéniosité)**

Le but principal de votre code n'est pas de montrer à quel point vous êtes intelligent, mais de résoudre un problème de la manière la plus simple et la plus lisible possible. Un code que vous devez relire trois fois pour le comprendre est un mauvais code, même s'il est court et astucieux. La maintenabilité l'emporte toujours sur la concision obscure.

Peu importe que vous ne compreniez pas les exemples pour le moment, il vous suffit de comprendre l'esprit.

**Mauvaise pratique ("`Clever`") :**

content\_copy

    // Un débutant pourrait écrire ceci, en pensant être malin.
    // Mais ce code est buggé : que se passe-t-il si la clé existe,
    // mais que sa valeur est justement "" (une chaîne vide) ?
    // La fonction retournerait la valeur par défaut à tort.
    func GetSetting(settings map[string]string, key string) string {
        if val := settings[key]; val != "" {
            return val
        }
        return "default_value"
    }

**Bonne pratique ("`Clear`") :**

content\_copy

    // La manière idiomatique en Go utilise l'idiome "comma ok".
    // L'intention est limpide et le code est correct.
    func GetSetting(settings map[string]string, key string) string {
        val, ok := settings[key] // ok est un booléen : true si la clé existe, false sinon.
        if !ok {
            return "default_value" // La clé n'existe pas, on retourne la valeur par défaut.
        }
        return val // La clé existe, on retourne sa valeur (même si c'est "").
    }

#### **"`Don't just check errors, handle them gracefully`." (Ne vous contentez pas de vérifier les erreurs, gérez-les avec élégance)**

En `Go`, les erreurs ne sont pas des accidents exceptionnels, ce sont des valeurs attendues. Une fonction qui peut échouer retournera son résultat _et_ une erreur.

Votre travail n'est pas seulement de voir si l'erreur existe (`if err != nil`), mais de prendre une décision significative à ce sujet : logger l'erreur, réessayer, ou retourner une erreur plus contextuelle à la fonction appelante.

**Mauvaise pratique :**

content\_copy

    file, err := os.Open("un_fichier.txt")
    if err != nil {
        // Ignorer une erreur ou planter brutalement est rarement la bonne solution.
        log.Fatal(err) // Arrête tout le programme.
    }

**Bonne pratique :**

content\_copy

    file, err := os.Open("un_fichier.txt")
    if err != nil {
        // On ajoute du contexte à l'erreur avant de la remonter.
        // Le prochain développeur saura d'où vient le problème.
        return nil, fmt.Errorf("échec lors de l'ouverture du fichier de configuration: %w", err)
    }

#### **"`A little copying is better than a little dependency.`" (Un peu de duplication vaut mieux qu'une petite dépendance)**

Avant d'importer une bibliothèque externe pour une seule petite fonction, demandez-vous si vous ne pouvez pas l'écrire vous-même en quelques lignes. Chaque dépendance externe ajoute de la complexité, un risque de sécurité et un coût de maintenance à votre projet. Go vous encourage à maîtriser votre code base.

Vous avez besoin d'une fonction qui met la première lettre d'une chaîne en majuscule.

**L'approche "Dépendance" :** vous cherchez sur `Google` et trouvez une bibliothèque `strutil`. Vous ajoutez `go get github.com/auteur/strutil` à votre projet juste pour cette fonction.

**L'approche "copie" (ou "autonomie") :** vous écrivez vous-même une petite fonction pour le faire. C'est peut-être quelques lignes de plus dans votre projet, mais vous n'avez aucune dépendance externe à gérer.

### **Ressources et communauté : où trouver de l'aide**

Vous n'êtes pas seul dans votre apprentissage ! La communauté Go est accueillante et les ressources sont abondantes et de grande qualité.

*   [**go.dev**](https://go.dev/) **: le portail officiel** C'est votre point de départ pour tout. Il contient des liens vers la documentation, des tutoriels, des articles de blog et des outils. Mettez-le dans vos favoris.
    
*   [**pkg.go.dev**](https://pkg.go.dev/) **: l'explorateur de paquets** C'est ici que vous trouverez la documentation pour **tous** les paquets Go publics, y compris la bibliothèque standard et toutes les bibliothèques tierces. Si vous vous demandez comment utiliser une fonction du paquet `fmt` ou de `github.com/google/uuid`, c'est le site à consulter.
    
*   **La commande `go doc`** : n'oubliez pas que la documentation est aussi dans votre terminal ! Pour obtenir rapidement des informations sur n'importe quelle fonction sans quitter votre éditeur, tapez :
    
    content\_copy
    
        # Pour obtenir la documentation du paquet fmt
        go doc fmt
        
        # Pour obtenir la documentation de la fonction Println
        go doc fmt.Println
    
*   **Le blog `Go` (**[**go.dev/blog**](https://go.dev/blog)**)** Tenu par l'équipe de développement de `Go`, ce blog contient des articles approfondis sur les nouvelles fonctionnalités, les meilleures pratiques et la philosophie du langage. C'est une lecture essentielle pour approfondir votre compréhension.
    
*   **Communautés en ligne** Pour poser des questions et échanger avec d'autres développeurs :
    
    *   `**Stack Overflow**` : le site de questions/réponses de référence pour les problèmes de programmation. Utilisez le tag `[go]`.
        
    *   **`Reddit` (`r/golang)`** : une communauté très active où vous trouverez des actualités, des discussions et de l'aide.
        

### Sur cette page

*   Le Zen de Go : les proverbes idiomatiques
*   "Clear is better than clever." (la clarté est préférable à l'ingéniosité)
*   "Don't just check errors, handle them gracefully." (Ne vous contentez pas de vérifier les erreurs, gérez-les avec élégance)
*   "A little copying is better than a little dependency." (Un peu de duplication vaut mieux qu'une petite dépendance)
*   Ressources et communauté : où trouver de l'aide