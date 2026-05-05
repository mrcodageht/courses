### Définir des dépendances avec `needs`

Par défaut, les `jobs` sont exécutés en parallèle.

La directive `jobs.<job_id>.needs` permet de définir les dépendances entre différents `jobs` dans un `workflow`.

Cette directive indique qu'un `job` donné ne doit démarrer qu'après la fin réussie des `jobs` dont il dépend.

`needs` peut être une chaîne de caractères unique ou un tableau de chaînes de caractères.

#### Exemple 1 : exécuter des `jobs` séquentiellement

Dans l'exemple suivant, `job1` doit terminer avec succès avant que `job2` ne commence, et `job3` attend que `job1` et `job2` se terminent.

content\_copy

```
name: Exemple de dépendances entre jobs

jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
    - name: Tâche de job1
      run: echo "Exécution de job1" && sleep 5

  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
    - name: Tâche de job2
      run: echo "Exécution de job2 après job1" && sleep 5

  job3:
    runs-on: ubuntu-latest
    needs: [job1, job2]
    steps:
    - name: Tâche de job3
      run: echo "Exécution de job3 après job1 et job2"
```

Dans cet exemple, les `jobs` sont exécutés de manière séquentielle :

1.  job1
2.  job2
3.  job

#### Exemple 2 : exécuter des `jobs` séquentiellement qu'ils échouent ou non

Dans cet exemple, `job3` utilise l'expression conditionnelle `always()` pour s'assurer qu'il sera toujours exécuté après `job1` et `job2`, qu'ils aient réussi ou non.

content\_copy

```
name: Exemple avec always()

jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
    - name: Tâche de job1
      run: echo "Exécution de job1" && sleep 5

  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
    - name: Tâche de job2
      run: echo "Exécution de job2 après job1" && sleep 5

  job3:
    runs-on: ubuntu-latest
    if: ${{ always() }}
    needs: [job1, job2]
    steps:
    - name: Tâche de job3
      run: echo "Exécution de job3 qu'importe le statut de job1 et job2"
```

Dans ce cas, même si `job1` ou `job2` échouent, `job3` sera exécuté.

**Le mot-clé `if: ${{ always() }}` permet à `job3` de s'exécuter indépendamment du succès des `jobs` précédents.**

### Passer des valeurs entre les étapes du même `job`

Si vous souhaitez passer des valeurs entre différentes étapes au sein du même `job`, vous pouvez utiliser des variables d'environnement.

Vous pouvez également écrire ces valeurs dans un fichier d'environnement spécifique appelé `GITHUB_ENV` qui sera lu par les étapes suivantes du `job`.

content\_copy

```
jobs :
  exemple :
    runs-on : ubuntu-latest
    steps :
      - name : définir une variable
        run : echo "MA_VARIABLE=Bonjour" >> $GITHUB_ENV
      - name : utiliser la variable
        run : echo "La valeur de MA_VARIABLE est $MA_VARIABLE."
```

Dans cet exemple, la première étape définit une variable d'environnement `MA_VARIABLE` avec la valeur `Bonjour`.

La deuxième étape utilise cette variable pour afficher un message.

### Passer des valeurs entre différents `jobs`

Pour passer des valeurs entre différents `jobs` dans le même `workflow`, vous pouvez utiliser les sorties de `job` (`job outputs`).

Pour cela nous pouvons écrire dans le fichier `$GITHUB_OUTPUT` en ajoutant une valeur à la suite avec `>>`.

Une fois qu'une valeur est définie comme sortie dans un `job`, elle peut être utilisée dans les `jobs` suivants.

content\_copy

```
jobs :
  premier_job :
    runs-on : ubuntu-latest
    steps :
      - name : définir une sortie
        id : etape1
        run : echo "output_var=Bonjour" >> $GITHUB_OUTPUT
    outputs :
      ma_sortie : ${{ steps.etape1.outputs.output_var }}

  deuxieme_job :
    needs : premier_job
    runs-on : ubuntu-latest
    steps :
      - name : utiliser la sortie du premier job
        run : echo "La valeur de la sortie du premier job est ${{ needs.premier_job.outputs.ma_sortie }}"
```

Dans cet exemple, le `premier_job` définit une valeur de sortie appelée `ma_sortie`.

Le `deuxieme_job` utilise ensuite cette valeur dans une de ses étapes.

**Notez que pour que cela fonctionne, le `deuxieme_job` doit avoir une dépendance sur `premier_job`, spécifiée par la clé `needs`.**

### Sur cette page

*   Définir des dépendances avec needs
*   Exemple 1 : exécuter des jobs séquentiellement
*   Exemple 2 : exécuter des jobs séquentiellement qu'ils échouent ou non
*   Passer des valeurs entre les étapes du même job
*   Passer des valeurs entre différents jobs