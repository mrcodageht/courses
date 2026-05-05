### À propos des conteneurs de `service`

Les conteneurs de `service` sont des conteneurs `Docker` qui fournissent un moyen simple pour utiliser des `services` nécessaires pour tester ou faire fonctionner votre application dans un `workflow`.

Par exemple, votre `workflow` peut nécessiter d'exécuter des tests d'intégration qui requièrent l'accès à une base de données et un cache en mémoire.

### Communication avec les conteneurs de service

La communication entre un `job` et ses conteneurs de `service` est différente selon que le `job` s'exécute directement sur la machine du `runner` ou dans un conteneur.

*   **`Jobs` dans un conteneur** : vous pouvez accéder au conteneur de `service` en utilisant le `label` que vous configurez dans le `workflow`. Par exemple, si le `label` du conteneur de service est `redis`, le nom d'hôte du conteneur de `service` est également `redis`.
    
*   **`Jobs` sur la machine du `runner`** : vous pouvez accéder aux conteneurs de `service` en utilisant `localhost:<port>` ou `127.0.0.1:<port>`. Vous devez également mapper les ports du conteneur de `service` sur les ports de la machine hôte.
    

#### Exemple de `workflow` avec un conteneur

Dans cet exemple, nous allons configurer un `job` qui utilise un conteneur de `service` `Redis` et un `job` dans un conteneur.

content\_copy

```
name: exemple avec Redis
on: push

jobs:
  mon_job:
    runs-on: ubuntu-latest
    container: redis/redis-stack
    services:
      redis:
        image: redis
    steps:
    - name: vérifier la connexion à Redis
      run: |
        echo "Vérification de la connexion à Redis..."
        redis-cli -h redis ping
```

**`container: redis/redis-stack`** spécifie que le `job` doit être exécuté dans un conteneur `Docker`. Le conteneur utilisé est basé sur l'image `redis/redis-stack`, qui est une image `Docker` fournie par `Redis`. Elle inclut notamment le `CLI` de `Redis` et des outils supplémentaires.

**`redis-cli -h redis ping`** utilise `redis-cli` pour envoyer une commande `PING` à au `service Redis`. `-h redis` spécifie que `redis-cli` doit se connecter au `service Redis` nommé `redis` défini dans ce `workflow`. La commande `PING` est un moyen simple de vérifier si l'instance `Redis` est opérationnelle et accessible sur le réseau.

#### Exemple de mappage de ports Redis

Cet exemple montre comment mapper le `port 6379` du conteneur de `service Redis` au `port 6379` de la machine hôte.

content\_copy

```
# .github/workflows/exemple_mappage_ports.yml
name: exemple de mappage de ports Redis
on: push

jobs:
  mon_job:
    runs-on: ubuntu-latest
    services:
      redis:
        image: redis
        ports:
          - 6379:6379
    steps:
    - name: Installer redis-cli
      run: sudo apt-get update && sudo apt-get install -y redis-tools
      
    - name: vérifier la connexion à Redis sur le port mappé
      run: |
        echo "Vérification de la connexion à Redis sur le port 6379..."
        redis-cli -h localhost -p 6379 ping
```

### Sur cette page

*   À propos des conteneurs de service
*   Communication avec les conteneurs de service
*   Exemple de workflow avec un conteneur
*   Exemple de mappage de ports Redis