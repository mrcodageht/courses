### Les artéfacts

Les artéfacts vous permettent de conserver des données une fois qu'un `job` est terminé et de partager ces données avec un autre `job` dans le même `workflow`.

**Un artéfact est un fichier ou une collection de fichiers produits pendant l'exécution d'un `workflow`.**

Par exemple, vous pouvez utiliser des artéfacts pour enregistrer les résultats de vos compilations et tests après la fin d'une exécution de `workflow`.

#### Durée de conservation par défaut

Par défaut, `GitHub` conserve les artéfacts pendant 90 jours. Cette période peut être personnalisée.

#### Types d'artéfacts courants

*   fichiers de `logs`
*   résultats de tests, échecs et captures d'écran
*   fichiers binaires ou compressés
*   résultats de tests de performance et couverture de code

#### Espace de stockage

Le stockage des artéfacts utilise de l'espace sur `GitHub`. Pour les dépôts publics, l'utilisation est gratuite. Pour les dépôts privés, des limites d'utilisation sont appliquées selon le plan du compte.

### Téléverser et télécharger des artéfacts

`GitHub` fournit deux actions pour cela : `upload-artifact` et `download-artifact`.

*   **Chargement de fichiers** : donnez un nom au fichier téléversé et faites-le avant la fin du `job`.
*   **Téléchargement de fichiers** : vous ne pouvez télécharger que des artefacts qui ont été téléchargés pendant la même exécution de `workflow`.



```yaml
uses: actions/upload-artifact@v3
with:
  name: mon-artefact
  path: mon_fichier.txt
  retention-days: 5
```



```yaml
uses: actions/download-artifact@v3
with:
  name: mon-artefact
```

### Passage de données entre `jobs`

Ce `workflow` utilise le mot-clé `needs` pour s'assurer que `job_1`, `job_2`, et `job_3` s'exécutent séquentiellement.



```yaml
name: partager des données entre les jobs

on: [push]

jobs:
  job_1:
    name: ajouter 3 et 7
    runs-on: ubuntu-latest
    steps:
      - shell: bash
        run: |
          expr 3 + 7 > math-homework.txt
      - name: charger le résultat mathématique pour job 1
        uses: actions/upload-artifact@v3
        with:
          name: devoirs
          path: math-homework.txt

  job_2:
    name: multiplier par 9
    needs: job_1
    runs-on: windows-latest
    steps:
      - name: télécharger le résultat mathématique pour job 1
        uses: actions/download-artifact@v3
        with:
          name: devoirs
      - shell: bash
        run: |
          valeur=`cat math-homework.txt`
          expr $valeur \* 9 > math-homework.txt
      - name: charger le résultat mathématique pour job 2
        uses: actions/upload-artifact@v3
        with:
          name: devoirs
          path: math-homework.txt

  job_3:
    name: afficher les résultats
    needs: job_2
    runs-on: macOS-latest
    steps:
      - name: télécharger le résultat mathématique pour job 2
        uses: actions/download-artifact@v3
        with:
          name: devoirs
      - name: imprimer le résultat final
        shell: bash
        run: |
          valeur=`cat math-homework.txt`
          echo le résultat est $valeur
```

`job_1` :

1.  effectue un calcul mathématique et enregistre le résultat dans un fichier texte appelé `math-homework.txt`.
2.  utilise l'action `upload-artifact` pour téléverser ce fichier. Le nom de l'`artéfact` est `homework`.

`job_2` :

1.  télécharge l'`artéfact` `homework` qui a été téléversé par le `job` précédent.
2.  lit la valeur dans le fichier `math-homework.txt`, effectue un autre calcul mathématique et sauvegarde le résultat dans le même fichier, en écrasant son contenu.
3.  téléverse à nouveau le fichier `math-homework.txt`. Cette nouvelle version écrase `l'artéfact` précédemment téléversé parce qu'ils partagent le même nom (`homework`).

`job_3` :

1.  télécharge `l'artéfact` `homework`.
2.  affiche le résultat de l'équation mathématique dans le journal de `logs` : `(3+7)×9=90`.

### Comparaison entre les artéfacts et la mise en cache

Les artéfacts et la mise en cache sont similaires car ils permettent de stocker des fichiers sur `GitHub`, mais chaque fonctionnalité offre des cas d'utilisation différents et ne peut pas être utilisée de manière interchangeable.

Utilisez **la mise en cache** lorsque vous souhaitez réutiliser des fichiers qui ne changent pas souvent entre les `jobs` et les `workflows`, tels que les dépendances d'un système de gestion de paquets.

Utilisez **les artéfacts** lorsque vous souhaitez sauvegarder les fichiers produits par un `job` pour les consulter après la fin de l'exécution du `workflow`, tels que les binaires construits ou les logs de `build`.
