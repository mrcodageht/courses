<!DOCTYPE html>
<!-- saved from url=(0081)https://dyma.fr/l/ansible/learn/653e6e34162c43e903703938/662bc217ccc287ce03f2d659 -->
<html lang="en" data-beasties-container="" class="dark">

<body>
  <app-cours class="flex-1">
                      <div class="flex justify-center gap-6 pb-40 sm:px-10 flex-1">
                        <div class="flex flex-col lg:flex-row gap-8 items-start relative max-w-content w-full mt-6">
                          <div
                            class="flex-1 border bg-surface-container-lowest border-surface-container-high rounded-xl w-full class-container min-w-0">
                            <div appcodecopy="" apppreventtextcopy=""
                              class="flex-1 pt-8 mx-auto prose prose-neutral prose-pre:my-0 prose-code:before:content-none prose-code:after:content-none prose-pre:rounded-xl max-w-content dark:prose-invert cours content px-4 sm:px-8">
                              <h3 id="toc-heading-0" class="scroll-mt-32">Qu'est-ce que le <code>DevOps</code> ?</h3>
                              <p><code>"Devops"</code> est la concaténation des trois premières lettres du mot anglais
                                <em><code>development</code></em> (développement) et de l'abréviation
                                <em><code>ops</code></em> du mot anglais <em><code>operations</code></em>
                                (exploitation).
                              </p>
                              <p>C'est un terme qui a été inventé par le belge <code>Patrick Debois</code> en 2007.</p>
                              <p>Le <code>DevOps</code> est un ensemble de pratiques qui visent à réduire le fossé entre
                                le <strong>développement logiciel</strong> (<em><code>Dev</code></em>) et les
                                <strong>opérations informatiques</strong> (<em><code>Ops</code></em>), d'où le terme.
                              </p>
                              <p>L'idée est de favoriser une collaboration plus étroite et une meilleure communication
                                entre ces deux entités qui, dans les modèles traditionnels, opèrent souvent de manière
                                isolée.</p>
                              <p>Les principes clés du <code>DevOps</code> comprennent aujourd'hui :</p>
                              <ul>
                                <li><strong>l'intégration continue</strong> (<code>CI</code> pour
                                  <em><code>continuous integration</code></em> en anglais - le code est régulièrement
                                  fusionné et testé),&nbsp;
                                </li>
                                <li><strong>la livraison continue</strong> (<code>CD</code> pour
                                  <em><code>continuous delivery</code></em> - les mises à jour du logiciel sont
                                  régulièrement libérées pour la production),
                                </li>
                                <li><strong>l'infrastructure en tant que code</strong> (la gestion et la provision des
                                  infrastructures informatiques via le code - <em><code>IAC</code> en anglais pour
                                    <code>Infrastructures As Code</code></em>),</li>
                                <li><strong>la surveillance et la journalisation</strong> (le suivi en temps réel de la
                                  performance et des erreurs du logiciel)</li>
                                <li><strong>la culture de la rétroaction</strong> (l'encouragement à l'amélioration
                                  constante via les retours d'information)</li>
                              </ul>
                              <p>Le schéma classique est celui-ci :</p>
                              <p><img src="./introduction-aux-devops_files/640px-Devops-toolchain.svg.png"></p>
                              <p>&nbsp;</p>
                              <h3 id="toc-heading-1" class="scroll-mt-32">Outils&nbsp;<code>DevOps</code> principaux
                              </h3>
                              <h4 id="toc-heading-2" class="scroll-mt-32"><strong>1 - Planification et collaboration
                                  :</strong></h4>
                              <p>Ces outils permettent de créer des tâches et de gérer un projet. Les plus utilisés sont
                                :</p>
                              <ul>
                                <li><strong><code>Gitlab</code></strong></li>
                                <li><strong><code>Github</code></strong></li>
                                <li><strong><code>Jira</code></strong></li>
                              </ul>
                              <h4 id="toc-heading-3" class="scroll-mt-32"><strong>2 - Gestion du code
                                  (développement)</strong></h4>
                              <p>Ces outils permettent d'effectuer un contrôle de version du code. Les plus utilisés
                                sont :</p>
                              <ul>
                                <li><code><strong>GitHub</strong></code></li>
                                <li><strong><code>GitLab</code></strong></li>
                                <li><strong><code>Bitbucket</code></strong></li>
                              </ul>
                              <h4 id="toc-heading-4" class="scroll-mt-32"><strong>3 - Intégration Continue / Déploiement
                                  Continu (CI/CD) :</strong></h4>
                              <p>Ces outils surveillent les <code>commits</code> dans votre dépôt par exemple
                                <code>Github</code>. Lorsqu'un commit est effectué, ils lancent automatiquement un
                                "<code>pipeline</code>" d'intégration continue qui peut compiler le code, exécuter des
                                tests unitaires, des tests d'intégration, et d'autres types de tests pour s'assurer que
                                les dernières modifications n'ont pas introduit de bugs.
                              </p>
                              <p>Si tous les tests passent, ces outils peuvent être configurés pour déployer
                                automatiquement les changements sur un environnement de production, de
                                <code>staging</code> ou de <code>test</code>. Cela accélère le processus de livraison de
                                nouvelles fonctionnalités et de corrections de bugs.
                              </p>
                              <p>Des solutions très connues sont :</p>
                              <ul>
                                <li><strong><code>Jenkins</code></strong></li>
                                <li><strong><code>GitLab CI/CD</code></strong></li>
                                <li><code><strong>Github actions</strong></code></li>
                                <li><code><strong>AWS CodePipeline</strong></code></li>
                                <li><code><strong>Azure DevOps<br></strong></code></li>
                                <li><strong><code>CircleCI</code></strong></li>
                                <li><strong><code>Travis CI</code></strong></li>
                              </ul>
                              <h4 id="toc-heading-5" class="scroll-mt-32"><strong>4 - Gestion de l'infrastructure
                                  :</strong></h4>
                              <p>Ces outils permettent de faire des choses très différentes mais concernent les serveurs
                                et les&nbsp;<code>clusters</code>.</p>
                              <p>Nous pouvons citer quelques exemples :</p>
                              <ul>
                                <li><strong><code>Docker</code> </strong>: pour créer des images et ensuite les exécuter
                                  dans des conteneurs sur un <code>cluster</code>.</li>
                                <li><strong><code>Docker Hub</code></strong> (<em>ou tout autre
                                    <code>Container Registry</code> - il y en a plusieurs dizaines</em>) : plateforme de
                                  service <code>cloud</code> qui permet aux développeurs de stocker et d'utiliser des
                                  images d'applications conteneurisées.</li>
                                <li><strong><code>Kubernetes</code></strong> : plateforme qui automatise la déploiement,
                                  la mise à l'échelle et la gestion des applications conteneurisées, offrant un cadre
                                  pour orchestrer et coordonner des conteneurs au sein d'un environnement de
                                  <code>cloud</code>.
                                </li>
                                <li><strong><code>Terraform</code> </strong>: outil d'Infrastructure as Code
                                  (<strong><code>IaC</code></strong>) open source qui permet aux développeurs de définir
                                  et de fournir des infrastructures de centres de données en utilisant un langage de
                                  description déclaratif, facilitant ainsi la gestion et l'orchestration des ressources
                                  <code>cloud</code>.
                                </li>
                                <li><strong><code>Ansible</code></strong> : outil d'automatisation open source qui
                                  permet la gestion de configuration, le déploiement d'applications et l'orchestration
                                  de tâches sur une variété de systèmes et de plateformes (en résumé permet de
                                  configurer et de gérer des serveurs plus simplement).</li>
                              </ul>
                              <h4 id="toc-heading-6" class="scroll-mt-32"><strong>5 - Surveillance et retour
                                  d'information :</strong></h4>
                              <p>Ces outils permettent de surveiller (<em><code>monitoring</code></em>) des
                                <code>clusters</code> ou plus généralement des applications exécutées sur des serveurs.
                              </p>
                              <p>Voici une liste des outils les plus courants :</p>
                              <ul>
                                <li><strong><code>Prometheus</code></strong> : système de surveillance et d'alerte qui
                                  collecte et stocke les métriques d'application et de système en temps réel, offrant
                                  des fonctionnalités de requête et d'alerte pour aider à la détection et à la
                                  résolution des problèmes.</li>
                                <li><strong><code>Grafana</code></strong> : plateforme pour la visualisation et
                                  l'analyse de données, permettant aux utilisateurs de créer des tableaux de bord
                                  interactifs et compréhensibles pour surveiller et analyser en temps réel les données
                                  provenant de diverses sources, le plus souvent de <code>Prometheus</code>.</li>
                                <li><code><strong>ELK Stack</strong></code><strong> (<code>Elasticsearch</code>,
                                    <code>Logstash</code>, <code>Kibana</code>)</strong> : suite d'outils qui fournit
                                  des capacités de recherche, d'analyse, de journalisation et de visualisation de
                                  données, permettant aux utilisateurs de transformer leurs données en insights
                                  précieux.</li>
                                <li><strong><code>Datadog / Nagios / New Relic / Sentry</code></strong> : plateformes de
                                  surveillance et d'analyse des performances en temps réel pour les infrastructures
                                  <code>cloud</code>, les applications, les journaux et les métriques, facilitant la
                                  détection des problèmes et leur résolution.
                                </li>
                              </ul>
                            </div><!---->
                            <div class="pb-28"></div><!---->
                          </div>
                        </div>
                        <div class="hidden lg:block mt-6 min-w-40"><app-table-of-content
                            class="sticky top-8 block overflow-y-auto">
                            <nav class="flex flex-col border-l-4 border-course-primary">
                              <h3 class="pl-2 text-sm font-medium">Sur cette page</h3>
                              <ul class="flex flex-col">
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-course-primary font-medium">
                                  Qu'est-ce que le DevOps ? </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary">
                                  Outils&nbsp;DevOps principaux </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary pl-4">
                                  1 - Planification et collaboration : </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary pl-4">
                                  2 - Gestion du code (développement) </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary pl-4">
                                  3 - Intégration Continue / Déploiement Continu (CI/CD) : </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary pl-4">
                                  4 - Gestion de l'infrastructure : </li>
                                <li
                                  class="cursor-pointer text-sm pl-2 transition-all duration-200 hover:text-course-primary w-full text-secondary pl-4">
                                  5 - Surveillance et retour d'information : </li><!---->
                              </ul>
                            </nav>
                          </app-table-of-content></div><!---->
                      </div><!---->
                    </app-cours>
</body>

</html>