### Les commandes de `workflow`

Les `actions` peuvent communiquer avec la machine exécutant le `runner` (machine hôte) pour effectuer diverses tâches comme :

*   Définir des variables d'environnement
*   Sortir des valeurs qui seront utilisées par d'autres `actions`
*   Ajouter des messages de débogage aux journaux de sortie, etc.

Ces tâches sont souvent effectuées en utilisant des _`workflow commands`_.

La plupart de ces commandes utilisent la commande `echo` dans un format spécifique.

Les noms de commandes et de paramètres sont insensibles à la casse.

#### Afficher un message de débogage

Pour activer le mode déboggage, vous devez avoir défini un `secret` nommé `ACTIONS_STEP_DEBUG` avec la valeur `true` dans les paramètres de votre dépôt.



```yaml
jobs:
  exemple_debug:
    runs-on: ubuntu-latest
    steps:
      - name: Afficher un message de débogage
        run: echo "::debug::Ceci est un message de débogage"
```

#### Afficher un message de notification

Crée un message de notification et l'imprime dans les `logs`. Ce message créera une annotation, qui peut associer le message à un fichier particulier dans votre dépôt. En option, votre message peut spécifier une position dans le fichier.

La syntaxe est `::notice file={name},line={line},endLine={endLine},title={title}::{message}`.



```yaml
jobs:
  exemple_notice:
    runs-on: ubuntu-latest
    steps:
      - name: Afficher un message de notification
        run: echo "::notice file=exemple.txt,line=1,col=5::Un message de notification"
```

#### Afficher un message d'avertissement



```yaml
jobs:
  exemple_warning:
    runs-on: ubuntu-latest
    steps:
      - name: Afficher un message d'avertissement
        run: echo "::warning file=exemple.txt,line=1,col=5::Un message d'avertissement"
```

#### Afficher un message d'erreur



```yaml
jobs:
  exemple_error:
    runs-on: ubuntu-latest
    steps:
      - name: Afficher un message d'erreur
        run: echo "::error file=exemple.txt,line=1,col=5::Un message d'erreur"
```

#### Regrouper des lignes de `logs`



```yaml
jobs:
  exemple_group:
    runs-on: ubuntu-latest
    steps:
      - name: Regrouper des lignes de journal
        run: |
          echo "::group::Mon groupe"
          echo "Ceci est à l'intérieur du groupe"
          sleep 2
          echo "::endgroup::"
```

####  Masquer une valeur dans les `logs`



```yaml
jobs:
  exemple_mask:
    runs-on: ubuntu-latest
    steps:
      - name: Masquer une valeur
        run: |
          echo "::add-mask::mot_de_passe"
          echo "mon mot_de_passe est mot_de_passe"  # ceci masquera "mot_de_passe" dans le journal
```
