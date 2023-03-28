## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass

## @param global.imageRegistry Global Docker Image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.storageClass Global storage class for dynamic provisioning
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ""

## @section Common parameters

## @param nameOverride String to partially override mariadb.fullname
##
nameOverride: ""
## @param fullnameOverride String to fully override mariadb.fullname
##
fullnameOverride: ""
## @param clusterDomain Default Kubernetes cluster domain
##
clusterDomain: cluster.local
## @param commonAnnotations Common annotations to add to all MariaDB resources (sub-charts are not considered)
##
commonAnnotations: {}
## @param commonLabels Common labels to add to all MariaDB resources (sub-charts are not considered)
##
commonLabels: {}
## @param schedulerName Name of the scheduler (other than default) to dispatch pods
## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
##
schedulerName: ""
## @param extraDeploy Array of extra objects to deploy with the release (evaluated as a template)
##
extraDeploy: []

## Enable diagnostic mode in the deployment
##
diagnosticMode:
  ## @param diagnosticMode.enabled Enable diagnostic mode (all probes will be disabled and the command will be overridden)
  ##
  enabled: false
  ## @param diagnosticMode.command Command to override all containers in the deployment
  ##
  command:
    - sleep
  ## @param diagnosticMode.args Args to override all containers in the deployment
  ##
  args:
    - infinity

## @section MariaDB common parameters

## Bitnami MariaDB image
## ref: https://hub.docker.com/r/bitnami/mariadb/tags/
## @param image.registry MariaDB image registry
## @param image.repository MariaDB image repository
## @param image.tag MariaDB image tag (immutable tags are recommended)
## @param image.pullPolicy MariaDB image pull policy
## @param image.pullSecrets Specify docker-registry secret names as an array
## @param image.debug Specify if debug logs should be enabled
##
image:
  registry: docker.io
  repository: bitnami/mariadb
  tag: 10.5.12-debian-10-r68
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets (secrets must be manually created in the namespace)
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## Example:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Set to true if you would like to see extra information on logs
  ## It turns BASH and/or NAMI debugging in the image
  ##
  debug: false
## @param architecture MariaDB architecture (`standalone` or `replication`)
##
architecture: ${architecture}
## MariaDB Authentication parameters
##
auth:
  ## @param auth.rootPassword Password for the `root` user. Ignored if existing secret is provided.
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb#setting-the-root-password-on-first-run
  ##
  rootPassword: ""
  ## @param auth.database Name for a custom database to create
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-on-first-run
  ##
  database: "${database_name}"
  ## @param auth.username Name for a custom user to create
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-user-on-first-run
  ##
  username: "${database_name}_user"
  ## @param auth.password Password for the new user. Ignored if existing secret is provided
  ##
  password: ""
  ## @param auth.replicationUser MariaDB replication user
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb#setting-up-a-replication-cluster
  ##
  replicationUser: replicator
  ## @param auth.replicationPassword MariaDB replication user password. Ignored if existing secret is provided
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb#setting-up-a-replication-cluster
  ##
  replicationPassword: ""
  ## @param auth.existingSecret Use existing secret for password details (`auth.rootPassword`, `auth.password`, `auth.replicationPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password`
  ##
  existingSecret: "${passwords_secret_name}"
  ## @param auth.forcePassword Force users to specify required passwords
  ##
  forcePassword: false
  ## @param auth.usePasswordFiles Mount credentials as a files instead of using an environment variable
  ##
  usePasswordFiles: false
  ## @param auth.customPasswordFiles Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication`
  ## Example:
  ## customPasswordFiles:
  ##   root: /vault/secrets/mariadb-root
  ##   user: /vault/secrets/mariadb-user
  ##   replicator: /vault/secrets/mariadb-replicator
  ##
  customPasswordFiles: {}
## @param initdbScripts Dictionary of initdb scripts
## Specify dictionary of scripts to be run at first boot
## Example:
## initdbScripts:
##   my_init_script.sh: |
##      #!/bin/bash
##      echo "Do something."
##
initdbScripts: {}
## @param initdbScriptsConfigMap ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)
##
initdbScriptsConfigMap: ""

## @section MariaDB Primary parameters

## Mariadb Primary parameters
##
primary:
  ## @param primary.command Override default container command on MariaDB Primary container(s) (useful when using custom images)
  ##
  command: []
  ## @param primary.args Override default container args on MariaDB Primary container(s) (useful when using custom images)
  ##
  args: []
  ## @param primary.hostAliases Add deployment host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param primary.configuration [string] MariaDB Primary configuration to be injected as ConfigMap
  ## ref: https://mysql.com/kb/en/mysql/configuring-mysql-with-mycnf/#example-of-configuration-file
  ##
  configuration: |-
    [mysqld]
    skip-name-resolve
    explicit_defaults_for_timestamp
    basedir=/opt/bitnami/mariadb
    plugin_dir=/opt/bitnami/mariadb/plugin
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    tmpdir=/opt/bitnami/mariadb/tmp
    max_allowed_packet=16M
    bind-address=0.0.0.0
    pid-file=/opt/bitnami/mariadb/tmp/mysqld.pid
    log-error=/opt/bitnami/mariadb/logs/mysqld.log
    character-set-server=UTF8
    collation-server=utf8_general_ci

    [client]
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    default-character-set=UTF8
    plugin_dir=/opt/bitnami/mariadb/plugin

    [manager]
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    pid-file=/opt/bitnami/mariadb/tmp/mysqld.pid
  ## @param primary.existingConfiguration Name of existing ConfigMap with MariaDB Primary configuration.
  ## NOTE: When it's set the 'configuration' parameter is ignored
  ##
  existingConfiguration: ""
  ## @param primary.updateStrategy Update strategy type for the MariaDB primary statefulset
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy: RollingUpdate
  ## @param primary.rollingUpdatePartition Partition update strategy for Mariadb Primary statefulset
  ## https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions
  ##
  rollingUpdatePartition: ""
  ## @param primary.podAnnotations Additional pod annotations for MariaDB primary pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param primary.podAffinityPreset MariaDB primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param primary.podAntiAffinityPreset MariaDB primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Mariadb Primary node affinity preset
  ## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param primary.nodeAffinityPreset.type MariaDB primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param primary.nodeAffinityPreset.key MariaDB primary node label key to match Ignored if `primary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param primary.nodeAffinityPreset.values MariaDB primary node label values to match. Ignored if `primary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param primary.affinity Affinity for MariaDB primary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: podAffinityPreset, podAntiAffinityPreset, and  nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param primary.nodeSelector Node labels for MariaDB primary pods assignment
  ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param primary.tolerations Tolerations for MariaDB primary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param primary.topologySpreadConstraints Topology Spread Constraints for MariaDB primary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: topology.kubernetes.io/zone
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: {}
  ## @param primary.priorityClassName Priority class for MariaDB primary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
  ##
  priorityClassName: ""
  ## MariaDB primary Pod security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param primary.podSecurityContext.enabled Enable security context for MariaDB primary pods
  ## @param primary.podSecurityContext.fsGroup Group ID for the mounted volumes' filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## MariaDB primary container security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param primary.containerSecurityContext.enabled MariaDB primary container securityContext
  ## @param primary.containerSecurityContext.runAsUser User ID for the MariaDB primary container
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## MariaDB primary container's resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param primary.resources.limits The resources limits for MariaDB primary containers
  ## @param primary.resources.requests The requested resources for MariaDB primary containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 100m
    ##    memory: 256Mi
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 100m
    ##    memory: 256Mi
    requests: {}
  ## Configure extra options for startup probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
  ## @param primary.startupProbe.enabled Enable startupProbe
  ## @param primary.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param primary.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param primary.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param primary.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param primary.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 120
    periodSeconds: 15
    timeoutSeconds: 5
    failureThreshold: 10
    successThreshold: 1
  ## Configure extra options for liveness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param primary.livenessProbe.enabled Enable livenessProbe
  ## @param primary.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param primary.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param primary.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param primary.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param primary.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 120
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for readiness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param primary.readinessProbe.enabled Enable readinessProbe
  ## @param primary.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param primary.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param primary.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param primary.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param primary.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## @param primary.customStartupProbe Override default startup probe for MariaDB primary containers
  ##
  customStartupProbe: {}
  ## @param primary.customLivenessProbe Override default liveness probe for MariaDB primary containers
  ##
  customLivenessProbe: {}
  ## @param primary.customReadinessProbe Override default readiness probe for MariaDB primary containers
  ##
  customReadinessProbe: {}
  ## @param primary.startupWaitOptions Override default builtin startup wait check options for MariaDB primary containers
  ## `bitnami/mariadb` Docker image has built-in startup check mechanism,
  ## which periodically checks if MariaDB service has started up and stops it
  ## if all checks have failed after X tries. Use these to control these checks.
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/pull/240
  ## Example (with default options):
  ## startupWaitOptions:
  ##   retries: 300
  ##   waitTime: 2
  ##
  startupWaitOptions: {}
  ## @param primary.extraFlags MariaDB primary additional command line flags
  ## Can be used to specify command line flags, for example:
  ## E.g.
  ## extraFlags: "--max-connect-errors=1000 --max_connections=155"
  ##
  extraFlags: ""
  ## @param primary.extraEnvVars Extra environment variables to be set on MariaDB primary containers
  ## E.g.
  ## extraEnvVars:
  ##  - name: TZ
  ##    value: "Europe/Paris"
  ##
  extraEnvVars: []
  ## @param primary.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for MariaDB primary containers
  ##
  extraEnvVarsCM: ""
  ## @param primary.extraEnvVarsSecret Name of existing Secret containing extra env vars for MariaDB primary containers
  ##
  extraEnvVarsSecret: ""
  ## Enable persistence using Persistent Volume Claims
  ## ref: http://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param primary.persistence.enabled Enable persistence on MariaDB primary replicas using a `PersistentVolumeClaim`. If false, use emptyDir
    ##
    enabled: true
    ## @param primary.persistence.existingClaim Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas
    ## NOTE: When it's set the rest of persistence parameters are ignored
    ##
    existingClaim: ""
    ## @param primary.persistence.subPath Subdirectory of the volume to mount at
    ##
    subPath: ""
    ## @param primary.persistence.storageClass MariaDB primary persistent volume storage Class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: "${volume_storage_class}"
    ## @param primary.persistence.annotations MariaDB primary persistent volume claim annotations
    ##
    annotations: {}
    ## @param primary.persistence.accessModes MariaDB primary persistent volume access Modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param primary.persistence.size MariaDB primary persistent volume size
    ##
    size: ${volume_size}
    ## @param primary.persistence.selector Selector to match an existing Persistent Volume
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
  ## @param primary.extraVolumes Optionally specify extra list of additional volumes to the MariaDB Primary pod(s)
  ##
  extraVolumes: []
  ## @param primary.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the MariaDB Primary container(s)
  ##
  extraVolumeMounts: []
  ## @param primary.initContainers Add additional init containers for the MariaDB Primary pod(s)
  ##
  initContainers: []
  ## @param primary.sidecars Add additional sidecar containers for the MariaDB Primary pod(s)
  ##
  sidecars: []
  ## MariaDB Primary Service parameters
  ##
  service:
    ## @param primary.service.type MariaDB Primary Kubernetes service type
    ##
    type: ClusterIP
    ## @param primary.service.port MariaDB Primary Kubernetes service port
    ##
    port: 3306
    ## @param primary.service.nodePort MariaDB Primary Kubernetes service node port
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePort: ""
    ## @param primary.service.clusterIP MariaDB Primary Kubernetes service clusterIP IP
    ##
    clusterIP: ""
    ## @param primary.service.loadBalancerIP MariaDB Primary loadBalancerIP if service type is `LoadBalancer`
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param primary.service.externalTrafficPolicy Enable client source IP preservation
    ## ref http://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param primary.service.loadBalancerSourceRanges Address that are allowed when MariaDB Primary service is LoadBalancer
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## E.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param primary.service.annotations Provide any additional annotations which may be required
    ##
    annotations: {}
  ## MariaDB primary Pod Disruption Budget configuration
  ## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
  ##
  pdb:
    ## @param primary.pdb.enabled Enable/disable a Pod Disruption Budget creation for MariaDB primary pods
    ##
    enabled: false
    ## @param primary.pdb.minAvailable Minimum number/percentage of MariaDB primary pods that must still be available after the eviction
    ##
    minAvailable: 1
    ## @param primary.pdb.maxUnavailable Maximum number/percentage of MariaDB primary pods that can be unavailable after the eviction
    ##
    maxUnavailable: ""
  ## @param primary.revisionHistoryLimit Maximum number of revisions that will be maintained in the StatefulSet
  ##
  revisionHistoryLimit: 10

## @section MariaDB Secondary parameters

## Mariadb Secondary parameters
##
secondary:
  ## @param secondary.replicaCount Number of MariaDB secondary replicas
  ##
  replicaCount: ${secondary_replica_count}
  ## @param secondary.command Override default container command on MariaDB Secondary container(s) (useful when using custom images)
  ##
  command: []
  ## @param secondary.args Override default container args on MariaDB Secondary container(s) (useful when using custom images)
  ##
  args: []
  ## @param secondary.hostAliases Add deployment host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param secondary.configuration [string] MariaDB Secondary configuration to be injected as ConfigMap
  ## ref: https://mysql.com/kb/en/mysql/configuring-mysql-with-mycnf/#example-of-configuration-file
  ##
  configuration: |-
    [mysqld]
    skip-name-resolve
    explicit_defaults_for_timestamp
    basedir=/opt/bitnami/mariadb
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    tmpdir=/opt/bitnami/mariadb/tmp
    max_allowed_packet=16M
    bind-address=0.0.0.0
    pid-file=/opt/bitnami/mariadb/tmp/mysqld.pid
    log-error=/opt/bitnami/mariadb/logs/mysqld.log
    character-set-server=UTF8
    collation-server=utf8_general_ci

    [client]
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    default-character-set=UTF8

    [manager]
    port=3306
    socket=/opt/bitnami/mariadb/tmp/mysql.sock
    pid-file=/opt/bitnami/mariadb/tmp/mysqld.pid
  ## @param secondary.existingConfiguration Name of existing ConfigMap with MariaDB Secondary configuration.
  ## NOTE: When it's set the 'configuration' parameter is ignored
  ##
  existingConfiguration: ""
  ## @param secondary.updateStrategy Update strategy type for the MariaDB secondary statefulset
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy: RollingUpdate
  ## @param secondary.rollingUpdatePartition Partition update strategy for Mariadb Secondary statefulset
  ## https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions
  ##
  rollingUpdatePartition: ""
  ## @param secondary.podAnnotations Additional pod annotations for MariaDB secondary pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param secondary.podAffinityPreset MariaDB secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param secondary.podAntiAffinityPreset MariaDB secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
  ## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Mariadb Secondary node affinity preset
  ## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param secondary.nodeAffinityPreset.type MariaDB secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param secondary.nodeAffinityPreset.key MariaDB secondary node label key to match Ignored if `secondary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param secondary.nodeAffinityPreset.values MariaDB secondary node label values to match. Ignored if `secondary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param secondary.affinity Affinity for MariaDB secondary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: podAffinityPreset, podAntiAffinityPreset, and  nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param secondary.nodeSelector Node labels for MariaDB secondary pods assignment
  ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param secondary.tolerations Tolerations for MariaDB secondary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param secondary.topologySpreadConstraints Topology Spread Constraints for MariaDB secondary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: topology.kubernetes.io/zone
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: {}
  ## @param secondary.priorityClassName Priority class for MariaDB secondary pods assignment
  ## Ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
  ##
  priorityClassName: ""
  ## MariaDB secondary Pod security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param secondary.podSecurityContext.enabled Enable security context for MariaDB secondary pods
  ## @param secondary.podSecurityContext.fsGroup Group ID for the mounted volumes' filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## MariaDB secondary container security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param secondary.containerSecurityContext.enabled MariaDB secondary container securityContext
  ## @param secondary.containerSecurityContext.runAsUser User ID for the MariaDB secondary container
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## MariaDB secondary container's resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param secondary.resources.limits The resources limits for MariaDB secondary containers
  ## @param secondary.resources.requests The requested resources for MariaDB secondary containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 100m
    ##    memory: 256Mi
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 100m
    ##    memory: 256Mi
    requests: {}
  ## Configure extra options for startup probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
  ## @param secondary.startupProbe.enabled Enable startupProbe
  ## @param secondary.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param secondary.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param secondary.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param secondary.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param secondary.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 120
    periodSeconds: 15
    timeoutSeconds: 5
    failureThreshold: 10
    successThreshold: 1
  ## Configure extra options for liveness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param secondary.livenessProbe.enabled Enable livenessProbe
  ## @param secondary.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param secondary.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param secondary.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param secondary.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param secondary.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 120
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for readiness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param secondary.readinessProbe.enabled Enable readinessProbe
  ## @param secondary.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param secondary.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param secondary.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param secondary.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param secondary.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## @param secondary.customStartupProbe Override default startup probe for MariaDB primary containers
  ##
  customStartupProbe: {}
  ## @param secondary.customLivenessProbe Override default liveness probe for MariaDB secondary containers
  ##
  customLivenessProbe: {}
  ## @param secondary.customReadinessProbe Override default readiness probe for MariaDB secondary containers
  ##
  customReadinessProbe: {}
  ## @param secondary.startupWaitOptions Override default builtin startup wait check options for MariaDB secondary containers
  ## `bitnami/mariadb` Docker image has built-in startup check mechanism,
  ## which periodically checks if MariaDB service has started up and stops it
  ## if all checks have failed after X tries. Use these to control these checks.
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/pull/240
  ## Example (with default options):
  ## startupWaitOptions:
  ##   retries: 300
  ##   waitTime: 2
  ##
  startupWaitOptions: {}
  ## @param secondary.extraFlags MariaDB secondary additional command line flags
  ## Can be used to specify command line flags, for example:
  ## E.g.
  ## extraFlags: "--max-connect-errors=1000 --max_connections=155"
  ##
  extraFlags: ""
  ## @param secondary.extraEnvVars Extra environment variables to be set on MariaDB secondary containers
  ## E.g.
  ## extraEnvVars:
  ##  - name: TZ
  ##    value: "Europe/Paris"
  ##
  extraEnvVars: []
  ## @param secondary.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for MariaDB secondary containers
  ##
  extraEnvVarsCM: ""
  ## @param secondary.extraEnvVarsSecret Name of existing Secret containing extra env vars for MariaDB secondary containers
  ##
  extraEnvVarsSecret: ""
  ## Enable persistence using Persistent Volume Claims
  ## ref: http://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param secondary.persistence.enabled Enable persistence on MariaDB secondary replicas using a `PersistentVolumeClaim`
    ##
    enabled: true
    ## @param secondary.persistence.subPath Subdirectory of the volume to mount at
    ##
    subPath: ""
    ## @param secondary.persistence.storageClass MariaDB secondary persistent volume storage Class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: "${volume_storage_class}"
    ## @param secondary.persistence.annotations MariaDB secondary persistent volume claim annotations
    ##
    annotations: {}
    ## @param secondary.persistence.accessModes MariaDB secondary persistent volume access Modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param secondary.persistence.size MariaDB secondary persistent volume size
    ##
    size: ${volume_size}
    ## @param secondary.persistence.selector Selector to match an existing Persistent Volume
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
  ## @param secondary.extraVolumes Optionally specify extra list of additional volumes to the MariaDB secondary pod(s)
  ##
  extraVolumes: []
  ## @param secondary.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the MariaDB secondary container(s)
  ##
  extraVolumeMounts: []
  ## @param secondary.initContainers Add additional init containers for the MariaDB secondary pod(s)
  ##
  initContainers: []
  ## @param secondary.sidecars Add additional sidecar containers for the MariaDB secondary pod(s)
  ##
  sidecars: []
  ## MariaDB Secondary Service parameters
  ##
  service:
    ## @param secondary.service.type MariaDB secondary Kubernetes service type
    ##
    type: ClusterIP
    ## @param secondary.service.port MariaDB secondary Kubernetes service port
    ##
    port: 3306
    ## @param secondary.service.nodePort MariaDB secondary Kubernetes service node port
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePort: ""
    ## @param secondary.service.clusterIP MariaDB secondary Kubernetes service clusterIP IP
    ## e.g:
    ## clusterIP: None
    ##
    clusterIP: ""
    ## @param secondary.service.loadBalancerIP MariaDB secondary loadBalancerIP if service type is `LoadBalancer`
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param secondary.service.externalTrafficPolicy Enable client source IP preservation
    ## ref http://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param secondary.service.loadBalancerSourceRanges Address that are allowed when MariaDB secondary service is LoadBalancer
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## E.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param secondary.service.annotations Provide any additional annotations which may be required
    ##
    annotations: {}
  ## MariaDB secondary Pod Disruption Budget configuration
  ## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
  ##
  pdb:
    ## @param secondary.pdb.enabled Enable/disable a Pod Disruption Budget creation for MariaDB secondary pods
    ##
    enabled: false
    ## @param secondary.pdb.minAvailable Minimum number/percentage of MariaDB secondary pods that should remain scheduled
    ##
    minAvailable: 1
    ## @param secondary.pdb.maxUnavailable Maximum number/percentage of MariaDB secondary pods that may be made unavailable
    ##
    maxUnavailable: ""
  ## @param secondary.revisionHistoryLimit Maximum number of revisions that will be maintained in the StatefulSet
  ##
  revisionHistoryLimit: 10

## @section RBAC parameters

## MariaDB pods ServiceAccount
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
##
serviceAccount:
  ## @param serviceAccount.create Enable the creation of a ServiceAccount for MariaDB pods
  ##
  create: true
  ## @param serviceAccount.name Name of the created ServiceAccount
  ## If not set and create is true, a name is generated using the mariadb.fullname template
  ##
  name: ""
  ## @param serviceAccount.annotations Annotations for MariaDB Service Account
  ##
  annotations: {}
## Role Based Access
## ref: https://kubernetes.io/docs/admin/authorization/rbac/
##
rbac:
  ## @param rbac.create Whether to create and use RBAC resources or not
  ##
  create: false

## @section Volume Permissions parameters

## Init containers parameters:
## volumePermissions: Change the owner and group of the persistent volume mountpoint to runAsUser:fsGroup values from the securityContext section.
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`
  ##
  enabled: false
  ## @param volumePermissions.image.registry Init container volume-permissions image registry
  ## @param volumePermissions.image.repository Init container volume-permissions image repository
  ## @param volumePermissions.image.tag Init container volume-permissions image tag (immutable tags are recommended)
  ## @param volumePermissions.image.pullPolicy Init container volume-permissions image pull policy
  ## @param volumePermissions.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 10-debian-10-r232
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets (secrets must be manually created in the namespace)
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param volumePermissions.resources.limits Init container volume-permissions resource limits
  ## @param volumePermissions.resources.requests Init container volume-permissions resource requests
  ##
  resources:
    limits: {}
    requests: {}

## @section Metrics parameters

## Mysqld Prometheus exporter parameters
##
metrics:
  ## @param metrics.enabled Start a side-car prometheus exporter
  ##
  enabled: ${metrics_enabled}
  ## @param metrics.image.registry Exporter image registry
  ## @param metrics.image.repository Exporter image repository
  ## @param metrics.image.tag Exporter image tag (immutable tags are recommended)
  ## @param metrics.image.pullPolicy Exporter image pull policy
  ## @param metrics.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    registry: docker.io
    repository: bitnami/mysqld-exporter
    tag: 0.13.0-debian-10-r135
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets (secrets must be manually created in the namespace)
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param metrics.annotations [object] Annotations for the Exporter pod
  ##
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9104"
  ## @param metrics.extraArgs [object] Extra args to be passed to mysqld_exporter
  ## ref: https://github.com/prometheus/mysqld_exporter/
  ## E.g.
  ## - --collect.auto_increment.columns
  ## - --collect.binlog_size
  ## - --collect.engine_innodb_status
  ## - --collect.engine_tokudb_status
  ## - --collect.global_status
  ## - --collect.global_variables
  ## - --collect.info_schema.clientstats
  ## - --collect.info_schema.innodb_metrics
  ## - --collect.info_schema.innodb_tablespaces
  ## - --collect.info_schema.innodb_cmp
  ## - --collect.info_schema.innodb_cmpmem
  ## - --collect.info_schema.processlist
  ## - --collect.info_schema.processlist.min_time
  ## - --collect.info_schema.query_response_time
  ## - --collect.info_schema.tables
  ## - --collect.info_schema.tables.databases
  ## - --collect.info_schema.tablestats
  ## - --collect.info_schema.userstats
  ## - --collect.perf_schema.eventsstatements
  ## - --collect.perf_schema.eventsstatements.digest_text_limit
  ## - --collect.perf_schema.eventsstatements.limit
  ## - --collect.perf_schema.eventsstatements.timelimit
  ## - --collect.perf_schema.eventswaits
  ## - --collect.perf_schema.file_events
  ## - --collect.perf_schema.file_instances
  ## - --collect.perf_schema.indexiowaits
  ## - --collect.perf_schema.tableiowaits
  ## - --collect.perf_schema.tablelocks
  ## - --collect.perf_schema.replication_group_member_stats
  ## - --collect.slave_status
  ## - --collect.slave_hosts
  ## - --collect.heartbeat
  ## - --collect.heartbeat.database
  ## - --collect.heartbeat.table
  ##
  extraArgs:
    primary: []
    secondary: []
  ## Mysqld Prometheus exporter resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param metrics.resources.limits The resources limits for MariaDB prometheus exporter containers
  ## @param metrics.resources.requests The requested resources for MariaDB prometheus exporter containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 100m
    ##    memory: 256Mi
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 100m
    ##    memory: 256Mi
    requests: {}
  ## Configure extra options for liveness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param metrics.livenessProbe.enabled Enable livenessProbe
  ## @param metrics.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param metrics.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param metrics.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param metrics.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param metrics.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 120
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  ## Configure extra options for readiness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param metrics.readinessProbe.enabled Enable readinessProbe
  ## @param metrics.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param metrics.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param metrics.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param metrics.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param metrics.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  ## Prometheus Service Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor Resource for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.serviceMonitor.namespace Namespace which Prometheus is running in
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval Interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.serviceMonitor.scrapeTimeout Specify the timeout after which the scrape is ended
    ## e.g:
    ## scrapeTimeout: 30s
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.relabellings Specify Metric Relabellings to add to the scrape endpoint
    ##
    relabellings: ""
    ## @param metrics.serviceMonitor.honorLabels honorLabels chooses the metric's labels on collisions with target labels.
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.release Used to pass Labels release that sometimes should be custom for Prometheus Operator
    ##
    release: ""
    ## @param metrics.serviceMonitor.additionalLabels Used to pass Labels that are required by the Installed Prometheus Operator
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
    ##
    additionalLabels: {}
