## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.storageClass Global StorageClass for Persistent Volume(s)
## @param global.postgresql.username PostgreSQL username (overrides `postgresql.username`)
## @param global.postgresql.password PostgreSQL password (overrides `postgresql.password`)
## @param global.postgresql.database PostgreSQL database (overrides `postgresql.database`)
## @param global.postgresql.repmgrUsername PostgreSQL repmgr username (overrides `postgresql.repmgrUsername`)
## @param global.postgresql.repmgrPassword PostgreSQL repmgr password (overrides `postgresql.repmgrpassword`)
## @param global.postgresql.repmgrDatabase PostgreSQL repmgr database (overrides `postgresql.repmgrDatabase`)
## @param global.postgresql.existingSecret Name of existing secret to use for PostgreSQL passwords (overrides `postgresql.existingSecret`)
## @param global.ldap.bindpw LDAP bind password (overrides `ldap.bindpw`)
## @param global.ldap.existingSecret Name of existing secret to use for LDAP passwords (overrides `ldap.existingSecret`)
## @param global.pgpool.adminUsername Pgpool Admin username (overrides `pgpool.adminUsername`)
## @param global.pgpool.adminPassword Pgpool Admin password (overrides `pgpool.adminPassword`)
## @param global.pgpool.existingSecret Pgpool existing secret
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ""
  postgresql:
    username: "${database_user}"
    password: "${database_password}"
    database: "${database_name}"
    repmgrUsername: ""
    repmgrPassword: ""
    repmgrDatabase: ""
    existingSecret: "${passwords_secret_name}"
  ldap:
    bindpw: ""
    existingSecret: ""
  pgpool:
    adminUsername: ""
    adminPassword: ""
    existingSecret: ""

## @section Common parameters

## @param kubeVersion Override Kubernetes version
##
kubeVersion: ""
## @param nameOverride String to partially override common.names.fullname template (will maintain the release name)
##
nameOverride: ""
## @param fullnameOverride String to fully override common.names.fullname template
##
fullnameOverride: ""
## @param namespaceOverride String to fully override common.names.namespace
##
namespaceOverride: ""
## @param commonLabels Common labels to add to all resources (sub-charts are not considered). Evaluated as a template
##
commonLabels: {}
## @param commonAnnotations Common annotations to add to all resources (sub-charts are not considered). Evaluated as a template
##
commonAnnotations: {}
## @param clusterDomain Kubernetes Cluster Domain
##
clusterDomain: cluster.local
## @param extraDeploy Array of extra objects to deploy with the release (evaluated as a template)
##
extraDeploy: []
## Diagnostic mode in the deployment
##
diagnosticMode:
  ## @param diagnosticMode.enabled Enable diagnostic mode (all probes will be disabled and the command will be overridden)
  ##
  enabled: false
  ## @param diagnosticMode.command [array] Command to override all containers in the deployment
  ##
  command:
    - sleep
  ## @param diagnosticMode.args [array] Args to override all containers in the deployment
  ##
  args:
    - infinity

## @section PostgreSQL with Repmgr parameters

## PostgreSQL parameters
##
postgresql:
  ## ref: https://hub.docker.com/r/bitnami/postgresql/tags/
  ## @param postgresql.image.registry PostgreSQL with Repmgr image registry
  ## @param postgresql.image.repository PostgreSQL with Repmgr image repository
  ## @param postgresql.image.tag PostgreSQL with Repmgr image tag
  ## @param postgresql.image.digest PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param postgresql.image.pullPolicy PostgreSQL with Repmgr image pull policy
  ## @param postgresql.image.pullSecrets Specify docker-registry secret names as an array
  ## @param postgresql.image.debug Specify if debug logs should be enabled
  ##
  image:
    registry: docker.io
    repository: bitnami/postgresql-repmgr
    tag: 15.2.0-debian-11-r2
    digest: ""
    ## Specify a imagePullPolicy. Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
    ## Set to true if you would like to see extra information on logs
    ##
    debug: false
  ## @param postgresql.labels Labels to add to the StatefulSet. Evaluated as template
  ##
  labels: {}
  ## @param postgresql.podLabels Labels to add to the StatefulSet pods. Evaluated as template
  ##
  podLabels: {}
  ## @param postgresql.serviceAnnotations Provide any additional annotations for PostgreSQL service
  ##
  serviceAnnotations: {}
  ## @param postgresql.replicaCount Number of replicas to deploy. Use an odd number. Having 3 replicas is the minimum to get quorum when promoting a new primary.
  ##
  replicaCount: ${replica_count}
  ## @param postgresql.updateStrategy.type Postgresql statefulset strategy type
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ## e.g:
  ## updateStrategy:
  ##  type: RollingUpdate
  ##  rollingUpdate:
  ##    maxSurge: 25%
  ##    maxUnavailable: 25%
  ##
  updateStrategy:
    type: RollingUpdate
  ## @param postgresql.containerPorts.postgresql PostgreSQL port
  ##
  containerPorts:
    postgresql: ${database_port}
  ## @param postgresql.hostAliases Deployment pod host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param postgresql.hostNetwork Specify if host network should be enabled for PostgreSQL pod
  ##
  hostNetwork: false
  ## @param postgresql.hostIPC Specify if host IPC should be enabled for PostgreSQL pod
  ##
  hostIPC: false
  ## @param postgresql.podAnnotations Additional pod annotations
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param postgresql.podAffinityPreset PostgreSQL pod affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param postgresql.podAntiAffinityPreset PostgreSQL pod anti-affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## PostgreSQL node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param postgresql.nodeAffinityPreset.type PostgreSQL node affinity preset type. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param postgresql.nodeAffinityPreset.key PostgreSQL node label key to match Ignored if `postgresql.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param postgresql.nodeAffinityPreset.values PostgreSQL node label values to match. Ignored if `postgresql.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param postgresql.affinity Affinity for PostgreSQL pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: postgresql.podAffinityPreset, postgresql.podAntiAffinityPreset, and postgresql.nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param postgresql.nodeSelector Node labels for PostgreSQL pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param postgresql.tolerations Tolerations for PostgreSQL pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param postgresql.topologySpreadConstraints Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#spread-constraints-for-pods
  ##
  topologySpreadConstraints: []
  ## @param postgresql.priorityClassName Pod priority class
  ## Ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
  ##
  priorityClassName: ""
  ## @param postgresql.schedulerName Use an alternate scheduler, e.g. "stork".
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param postgresql.terminationGracePeriodSeconds Seconds PostgreSQL pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## K8s Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param postgresql.podSecurityContext.enabled Enable security context for PostgreSQL with Repmgr
  ## @param postgresql.podSecurityContext.fsGroup Group ID for the PostgreSQL with Repmgr filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Container Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param postgresql.containerSecurityContext.enabled Enable container security context
  ## @param postgresql.containerSecurityContext.runAsUser User ID for the PostgreSQL with Repmgr container
  ## @param postgresql.containerSecurityContext.runAsNonRoot Set PostgreSQL with Repmgr containers' Security Context runAsNonRoot
  ## @param postgresql.containerSecurityContext.readOnlyRootFilesystem Set PostgreSQL with Repmgr containers' Security Context runAsNonRoot
  ## e.g:
  ##   containerSecurityContext:
  ##     enabled: true
  ##     capabilities:
  ##       drop: ["NET_RAW"]
  ##     readOnlyRootFilesystem: true
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
    readOnlyRootFilesystem: false
  ## @param postgresql.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param postgresql.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param postgresql.lifecycleHooks LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template
  ##
  lifecycleHooks: {}
  ## @param postgresql.extraEnvVars Array containing extra environment variables
  ## For example:
  ##  - name: PG_EXPORTER_DISABLE_DEFAULT_METRICS
  ##    value: "true"
  ##
  extraEnvVars: []
  ## @param postgresql.extraEnvVarsCM ConfigMap with extra environment variables
  ##
  extraEnvVarsCM: ""
  ## @param postgresql.extraEnvVarsSecret Secret with extra environment variables
  ##
  extraEnvVarsSecret: ""
  ## @param postgresql.extraVolumes Extra volumes to add to the deployment
  ##
  extraVolumes: []
  ## @param postgresql.extraVolumeMounts Extra volume mounts to add to the container. Normally used with `extraVolumes`.
  ##
  extraVolumeMounts: []
  ## @param postgresql.initContainers Extra init containers to add to the deployment
  ##
  initContainers: []
  ## @param postgresql.sidecars Extra sidecar containers to add to the deployment
  ##
  sidecars: []
  ## PostgreSQL containers' resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param postgresql.resources.limits The resources limits for the container
  ## @param postgresql.resources.requests The requested resources for the container
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## PostgreSQL container's liveness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param postgresql.livenessProbe.enabled Enable livenessProbe
  ## @param postgresql.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param postgresql.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param postgresql.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param postgresql.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param postgresql.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## PostgreSQL container's readiness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param postgresql.readinessProbe.enabled Enable readinessProbe
  ## @param postgresql.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param postgresql.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param postgresql.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param postgresql.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param postgresql.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## PostgreSQL container's startup probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param postgresql.startupProbe.enabled Enable startupProbe
  ## @param postgresql.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param postgresql.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param postgresql.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param postgresql.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param postgresql.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 10
  ## @param postgresql.customLivenessProbe Override default liveness probe
  ##
  customLivenessProbe: {}
  ## @param postgresql.customReadinessProbe Override default readiness probe
  ##
  customReadinessProbe: {}
  ## @param postgresql.customStartupProbe Override default startup probe
  ##
  customStartupProbe: {}
  ## Pod disruption budget configuration
  ## @param postgresql.pdb.create Specifies whether to create a Pod disruption budget for PostgreSQL with Repmgr
  ## @param postgresql.pdb.minAvailable Minimum number / percentage of pods that should remain scheduled
  ## @param postgresql.pdb.maxUnavailable Maximum number / percentage of pods that may be made unavailable
  ##
  pdb:
    create: false
    minAvailable: 1
    maxUnavailable: ""
  ## PostgreSQL configuration parameters
  ## @param postgresql.username PostgreSQL username
  ## @param postgresql.password PostgreSQL password
  ## @param postgresql.database PostgreSQL database
  ##
  username: postgres
  password: ""
  database: ""
  ## @param postgresql.existingSecret PostgreSQL password using existing secret
  ##
  existingSecret: ""
  ## @param postgresql.postgresPassword PostgreSQL password for the `postgres` user when `username` is not `postgres`
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#creating-a-database-user-on-first-run (see note!)
  ##
  postgresPassword: ""
  ## @param postgresql.usePasswordFile Set to `true` to mount PostgreSQL secret as a file instead of passing environment variable
  ##
  usePasswordFile: ""
  ## @param postgresql.repmgrUsePassfile Set to `true` to configure repmgrl to use `passfile` instead of `password` vars*:*:*:username:password" and use it to configure Repmgr instead of using password (Requires Postgresql 10+, otherwise ignored)
  ## ref: https://repmgr.org/docs/current/configuration-password-management.html
  ##      https://www.postgresql.org/docs/current/libpq-pgpass.html
  ##
  repmgrUsePassfile: ""
  ## @param postgresql.repmgrPassfilePath Custom path where `passfile` will be stored
  ##
  repmgrPassfilePath: ""
  ## @param postgresql.upgradeRepmgrExtension Upgrade repmgr extension in the database
  ##
  upgradeRepmgrExtension: false
  ## @param postgresql.pgHbaTrustAll Configures PostgreSQL HBA to trust every user
  ##
  pgHbaTrustAll: false
  ## @param postgresql.syncReplication Make the replication synchronous. This will wait until the data is synchronized in all the replicas before other query can be run. This ensures the data availability at the expenses of speed.
  ##
  syncReplication: false
  ## Repmgr configuration parameters
  ## @param postgresql.repmgrUsername PostgreSQL Repmgr username
  ## @param postgresql.repmgrPassword PostgreSQL Repmgr password
  ## @param postgresql.repmgrDatabase PostgreSQL Repmgr database
  ## @param postgresql.repmgrLogLevel Repmgr log level (DEBUG, INFO, NOTICE, WARNING, ERROR, ALERT, CRIT or EMERG)
  ## @param postgresql.repmgrConnectTimeout Repmgr backend connection timeout (in seconds)
  ## @param postgresql.repmgrReconnectAttempts Repmgr backend reconnection attempts
  ## @param postgresql.repmgrReconnectInterval Repmgr backend reconnection interval (in seconds)
  ## @param postgresql.repmgrFenceOldPrimary Set if fencing of old primary in multiple primary situation is desired
  ## @param postgresql.repmgrChildNodesCheckInterval Repmgr child nodes check interval (in seconds)
  ## @param postgresql.repmgrChildNodesConnectedMinCount Repmgr minimum number of connected child nodes before being considered as failed primary for fencing
  ## @param postgresql.repmgrChildNodesDisconnectTimeout Repmgr time before node will be fenced when insufficient child nodes are detected (in seconds)
  ##
  repmgrUsername: repmgr
  repmgrPassword: ""
  repmgrDatabase: repmgr
  repmgrLogLevel: NOTICE
  repmgrConnectTimeout: 5
  repmgrReconnectAttempts: 2
  repmgrReconnectInterval: 3
  repmgrFenceOldPrimary: false
  repmgrChildNodesCheckInterval: 5
  repmgrChildNodesConnectedMinCount: 1
  repmgrChildNodesDisconnectTimeout: 30
  ## EXPERMENTAL: Use pg_rewind for standby failover
  ## @param postgresql.usePgRewind Use pg_rewind for standby failover (experimental)
  ##
  usePgRewind: false
  ## Audit settings
  ## https://github.com/bitnami/containers/tree/main/bitnami/postgresql#auditing
  ##
  audit:
    ## @param postgresql.audit.logHostname Add client hostnames to the log file
    ##
    logHostname: true
    ## @param postgresql.audit.logConnections Add client log-in operations to the log file
    ##
    logConnections: false
    ## @param postgresql.audit.logDisconnections Add client log-outs operations to the log file
    ##
    logDisconnections: false
    ## @param postgresql.audit.pgAuditLog Add operations to log using the pgAudit extension
    ##
    pgAuditLog: ""
    ## @param postgresql.audit.pgAuditLogCatalog Log catalog using pgAudit
    ##
    pgAuditLogCatalog: "off"
    ## @param postgresql.audit.clientMinMessages Message log level to share with the user
    ##
    clientMinMessages: error
    ## @param postgresql.audit.logLinePrefix Template string for the log line prefix
    ##
    logLinePrefix: ""
    ## @param postgresql.audit.logTimezone Timezone for the log timestamps
    ##
    logTimezone: ""
  ## @param postgresql.sharedPreloadLibraries Shared preload libraries (comma-separated list)
  ##
  sharedPreloadLibraries: "pgaudit, repmgr"
  ## @param postgresql.maxConnections Maximum total connections
  ##
  maxConnections: ""
  ## @param postgresql.postgresConnectionLimit Maximum connections for the postgres user
  ##
  postgresConnectionLimit: ""
  ## @param postgresql.dbUserConnectionLimit Maximum connections for the created user
  ##
  dbUserConnectionLimit: ""
  ## @param postgresql.tcpKeepalivesInterval TCP keepalives interval
  ##
  tcpKeepalivesInterval: ""
  ## @param postgresql.tcpKeepalivesIdle TCP keepalives idle
  ##
  tcpKeepalivesIdle: ""
  ## @param postgresql.tcpKeepalivesCount TCP keepalives count
  ##
  tcpKeepalivesCount: ""
  ## @param postgresql.statementTimeout Statement timeout
  ##
  statementTimeout: ""
  ## @param postgresql.pghbaRemoveFilters Comma-separated list of patterns to remove from the pg_hba.conf file
  ## (cannot be used with custom pg_hba.conf)
  ##
  pghbaRemoveFilters: ""
  ## @param postgresql.extraInitContainers Extra init containers
  ## Example:
  ## extraInitContainers:
  ##   - name: do-something
  ##     image: busybox
  ##     command: ['do', 'something']
  ##
  extraInitContainers: []
  ## @param postgresql.repmgrConfiguration Repmgr configuration
  ## You can use this parameter to specify the content for repmgr.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## repmgrConfiguration: |-
  ##   ssh_options='-o "StrictHostKeyChecking no" -v'
  ##   use_replication_slots='1'
  ##   ...
  ##
  repmgrConfiguration: ""
  ## @param postgresql.configuration PostgreSQL configuration
  ## You can use this parameter to specify the content for postgresql.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## configuration: |-
  ##   listen_addresses = '*'
  ##   port = '5432'
  ##   ...
  ##
  configuration: ""
  ## @param postgresql.pgHbaConfiguration PostgreSQL client authentication configuration
  ## You can use this parameter to specify the content for pg_hba.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## pgHbaConfiguration: |-
  ##   host     all            repmgr    0.0.0.0/0    md5
  ##   host     repmgr         repmgr    0.0.0.0/0    md
  ##   ...
  ##
  pgHbaConfiguration: ""
  ## @param postgresql.configurationCM Name of existing ConfigMap with configuration files
  ## NOTE: This will override postgresql.repmgrConfiguration, postgresql.configuration and postgresql.pgHbaConfiguration
  ##
  configurationCM: ""
  ## @param postgresql.extendedConf Extended PostgreSQL configuration (appended to main or default configuration). Implies `volumePermissions.enabled`.
  ## Similar to postgresql.configuration, but _appended_ to the main configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#allow-settings-to-be-loaded-from-files-other-than-the-default-postgresqlconf
  ## Example:
  ## extendedConf: |-
  ##   deadlock_timeout = 1s
  ##   max_locks_per_transaction = 64
  ##   ...
  ##
  extendedConf: ""
  ## @param postgresql.extendedConfCM ConfigMap with PostgreSQL extended configuration
  ## NOTE: This will override postgresql.extendedConf and implies `volumePermissions.enabled`
  ##
  extendedConfCM: ""
  ## @param postgresql.initdbScripts Dictionary of initdb scripts
  ## Specify dictionary of scripts to be run at first boot
  ## The allowed extensions are `.sh`, `.sql` and `.sql.gz`
  ## ref: https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha#initialize-a-fresh-instance
  ## e.g:
  ## initdbScripts:
  ##   my_init_script.sh: |
  ##      #!/bin/sh
  ##      echo "Do something."
  ##
  initdbScripts: {}
  ## @param postgresql.initdbScriptsCM ConfigMap with scripts to be run at first boot
  ## NOTE: This will override initdbScripts
  ##
  initdbScriptsCM: ""
  ## @param postgresql.initdbScriptsSecret Secret with scripts to be run at first boot
  ## Note: can be used with initdbScriptsCM or initdbScripts
  ##
  initdbScriptsSecret: ""
  ## TLS configuration
  ##
  tls:
    ## @param postgresql.tls.enabled Enable TLS traffic support for end-client connections
    ##
    enabled: false
    ## @param postgresql.tls.preferServerCiphers Whether to use the server's TLS cipher preferences rather than the client's
    ##
    preferServerCiphers: true
    ## @param postgresql.tls.certificatesSecret Name of an existing secret that contains the certificates
    ##
    certificatesSecret: ""
    ## @param postgresql.tls.certFilename Certificate filename
    ##
    certFilename: ""
    ## @param postgresql.tls.certKeyFilename Certificate key filename
    ##
    certKeyFilename: ""

witness:
  ## ref: https://hub.docker.com/r/bitnami/postgresql/tags/
  ## @param witness.create Create PostgreSQL witness nodes
  ##
  create: false
  ## @param witness.labels Labels to add to the StatefulSet. Evaluated as template
  ##
  labels: {}
  ## @param witness.podLabels Labels to add to the StatefulSet pods. Evaluated as template
  ##
  podLabels: {}
  ## @param witness.replicaCount Number of replicas to deploy.
  ##
  replicaCount: 1
  ## @param witness.updateStrategy.type Postgresql statefulset strategy type
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ## e.g:
  ## updateStrategy:
  ##  type: RollingUpdate
  ##  rollingUpdate:
  ##    maxSurge: 25%
  ##    maxUnavailable: 25%
  ##
  updateStrategy:
    type: RollingUpdate
  ## @param witness.containerPorts.postgresql PostgreSQL witness port
  ##
  containerPorts:
    postgresql: ${database_port}
  ## @param witness.hostAliases Deployment pod host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param witness.hostNetwork Specify if host network should be enabled for PostgreSQL witness pod
  ##
  hostNetwork: false
  ## @param witness.hostIPC Specify if host IPC should be enabled for PostgreSQL witness pod
  ##
  hostIPC: false
  ## @param witness.podAnnotations Additional pod annotations
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param witness.podAffinityPreset PostgreSQL witness pod affinity preset. Ignored if `witness.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param witness.podAntiAffinityPreset PostgreSQL witness pod anti-affinity preset. Ignored if `witness.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## PostgreSQL witness node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param witness.nodeAffinityPreset.type PostgreSQL witness node affinity preset type. Ignored if `witness.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param witness.nodeAffinityPreset.key PostgreSQL witness node label key to match Ignored if `witness.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param witness.nodeAffinityPreset.values PostgreSQL witness node label values to match. Ignored if `witness.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param witness.affinity Affinity for PostgreSQL witness pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: witness.podAffinityPreset, witness.podAntiAffinityPreset, and witness.nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param witness.nodeSelector Node labels for PostgreSQL witness pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param witness.tolerations Tolerations for PostgreSQL witness pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param witness.topologySpreadConstraints Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#spread-constraints-for-pods
  ##
  topologySpreadConstraints: []
  ## @param witness.priorityClassName Pod priority class
  ## Ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
  ##
  priorityClassName: ""
  ## @param witness.schedulerName Use an alternate scheduler, e.g. "stork".
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param witness.terminationGracePeriodSeconds Seconds PostgreSQL witness pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## K8s Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param witness.podSecurityContext.enabled Enable security context for PostgreSQL witness with Repmgr
  ## @param witness.podSecurityContext.fsGroup Group ID for the PostgreSQL witness with Repmgr filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Container Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param witness.containerSecurityContext.enabled Enable container security context
  ## @param witness.containerSecurityContext.runAsUser User ID for the PostgreSQL witness with Repmgr container
  ## @param witness.containerSecurityContext.runAsNonRoot Set PostgreSQL witness with Repmgr containers' Security Context runAsNonRoot
  ## @param witness.containerSecurityContext.readOnlyRootFilesystem Set PostgreSQL witness with Repmgr containers' Security Context runAsNonRoot
  ## e.g:
  ##   containerSecurityContext:
  ##     enabled: true
  ##     capabilities:
  ##       drop: ["NET_RAW"]
  ##     readOnlyRootFilesystem: true
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
    readOnlyRootFilesystem: false
  ## @param witness.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param witness.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param witness.lifecycleHooks LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template
  ##
  lifecycleHooks: {}
  ## @param witness.extraEnvVars Array containing extra environment variables
  ## For example:
  ##  - name: PG_EXPORTER_DISABLE_DEFAULT_METRICS
  ##    value: "true"
  ##
  extraEnvVars: []
  ## @param witness.extraEnvVarsCM ConfigMap with extra environment variables
  ##
  extraEnvVarsCM: ""
  ## @param witness.extraEnvVarsSecret Secret with extra environment variables
  ##
  extraEnvVarsSecret: ""
  ## @param witness.extraVolumes Extra volumes to add to the deployment
  ##
  extraVolumes: []
  ## @param witness.extraVolumeMounts Extra volume mounts to add to the container. Normally used with `extraVolumes`.
  ##
  extraVolumeMounts: []
  ## @param witness.initContainers Extra init containers to add to the deployment
  ##
  initContainers: []
  ## @param witness.sidecars Extra sidecar containers to add to the deployment
  ##
  sidecars: []
  ## PostgreSQL containers' resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param witness.resources.limits The resources limits for the container
  ## @param witness.resources.requests The requested resources for the container
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## PostgreSQL container's liveness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param witness.livenessProbe.enabled Enable livenessProbe
  ## @param witness.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param witness.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param witness.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param witness.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param witness.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## PostgreSQL container's readiness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param witness.readinessProbe.enabled Enable readinessProbe
  ## @param witness.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param witness.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param witness.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param witness.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param witness.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## PostgreSQL container's startup probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param witness.startupProbe.enabled Enable startupProbe
  ## @param witness.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param witness.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param witness.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param witness.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param witness.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 10
  ## @param witness.customLivenessProbe Override default liveness probe
  ##
  customLivenessProbe: {}
  ## @param witness.customReadinessProbe Override default readiness probe
  ##
  customReadinessProbe: {}
  ## @param witness.customStartupProbe Override default startup probe
  ##
  customStartupProbe: {}
  ## Pod disruption budget configuration
  ## @param witness.pdb.create Specifies whether to create a Pod disruption budget for PostgreSQL witness with Repmgr
  ## @param witness.pdb.minAvailable Minimum number / percentage of pods that should remain scheduled
  ## @param witness.pdb.maxUnavailable Maximum number / percentage of pods that may be made unavailable
  ##
  pdb:
    create: false
    minAvailable: 1
    maxUnavailable: ""

  ## @param witness.upgradeRepmgrExtension Upgrade repmgr extension in the database
  ##
  upgradeRepmgrExtension: false
  ## @param witness.pgHbaTrustAll Configures PostgreSQL HBA to trust every user
  ##
  pgHbaTrustAll: false
  ## Repmgr configuration parameters
  ## @param witness.repmgrLogLevel Repmgr log level (DEBUG, INFO, NOTICE, WARNING, ERROR, ALERT, CRIT or EMERG)
  ## @param witness.repmgrConnectTimeout Repmgr backend connection timeout (in seconds)
  ## @param witness.repmgrReconnectAttempts Repmgr backend reconnection attempts
  ## @param witness.repmgrReconnectInterval Repmgr backend reconnection interval (in seconds)
  ##
  repmgrLogLevel: NOTICE
  repmgrConnectTimeout: 5
  repmgrReconnectAttempts: 2
  repmgrReconnectInterval: 3

  ## Audit settings
  ## https://github.com/bitnami/containers/tree/main/bitnami/postgresql#auditing
  ##
  audit:
    ## @param witness.audit.logHostname Add client hostnames to the log file
    ##
    logHostname: true
    ## @param witness.audit.logConnections Add client log-in operations to the log file
    ##
    logConnections: false
    ## @param witness.audit.logDisconnections Add client log-outs operations to the log file
    ##
    logDisconnections: false
    ## @param witness.audit.pgAuditLog Add operations to log using the pgAudit extension
    ##
    pgAuditLog: ""
    ## @param witness.audit.pgAuditLogCatalog Log catalog using pgAudit
    ##
    pgAuditLogCatalog: "off"
    ## @param witness.audit.clientMinMessages Message log level to share with the user
    ##
    clientMinMessages: error
    ## @param witness.audit.logLinePrefix Template string for the log line prefix
    ##
    logLinePrefix: ""
    ## @param witness.audit.logTimezone Timezone for the log timestamps
    ##
    logTimezone: ""
  ## @param witness.maxConnections Maximum total connections
  ##
  maxConnections: ""
  ## @param witness.postgresConnectionLimit Maximum connections for the postgres user
  ##
  postgresConnectionLimit: ""
  ## @param witness.dbUserConnectionLimit Maximum connections for the created user
  ##
  dbUserConnectionLimit: ""
  ## @param witness.tcpKeepalivesInterval TCP keepalives interval
  ##
  tcpKeepalivesInterval: ""
  ## @param witness.tcpKeepalivesIdle TCP keepalives idle
  ##
  tcpKeepalivesIdle: ""
  ## @param witness.tcpKeepalivesCount TCP keepalives count
  ##
  tcpKeepalivesCount: ""
  ## @param witness.statementTimeout Statement timeout
  ##
  statementTimeout: ""
  ## @param witness.pghbaRemoveFilters Comma-separated list of patterns to remove from the pg_hba.conf file
  ## (cannot be used with custom pg_hba.conf)
  ##
  pghbaRemoveFilters: ""
  ## @param witness.extraInitContainers Extra init containers
  ## Example:
  ## extraInitContainers:
  ##   - name: do-something
  ##     image: busybox
  ##     command: ['do', 'something']
  ##
  extraInitContainers: []
  ## @param witness.repmgrConfiguration Repmgr configuration
  ## You can use this parameter to specify the content for repmgr.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## repmgrConfiguration: |-
  ##   ssh_options='-o "StrictHostKeyChecking no" -v'
  ##   use_replication_slots='1'
  ##   ...
  ##
  repmgrConfiguration: ""
  ## @param witness.configuration PostgreSQL configuration
  ## You can use this parameter to specify the content for witness.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## configuration: |-
  ##   listen_addresses = '*'
  ##   port = '5432'
  ##   ...
  ##
  configuration: ""
  ## @param witness.pgHbaConfiguration PostgreSQL client authentication configuration
  ## You can use this parameter to specify the content for pg_hba.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#configuration-file
  ## Example:
  ## pgHbaConfiguration: |-
  ##   host     all            repmgr    0.0.0.0/0    md5
  ##   host     repmgr         repmgr    0.0.0.0/0    md
  ##   ...
  ##
  pgHbaConfiguration: ""
  ## @param witness.configurationCM Name of existing ConfigMap with configuration files
  ## NOTE: This will override witness.repmgrConfiguration, witness.configuration and witness.pgHbaConfiguration
  ##
  configurationCM: ""
  ## @param witness.extendedConf Extended PostgreSQL configuration (appended to main or default configuration). Implies `volumePermissions.enabled`.
  ## Similar to witness.configuration, but _appended_ to the main configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#allow-settings-to-be-loaded-from-files-other-than-the-default-postgresqlconf
  ## Example:
  ## extendedConf: |-
  ##   deadlock_timeout = 1s
  ##   max_locks_per_transaction = 64
  ##   ...
  ##
  extendedConf: ""
  ## @param witness.extendedConfCM ConfigMap with PostgreSQL extended configuration
  ## NOTE: This will override witness.extendedConf and implies `volumePermissions.enabled`
  ##
  extendedConfCM: ""
  ## @param witness.initdbScripts Dictionary of initdb scripts
  ## Specify dictionary of scripts to be run at first boot
  ## The allowed extensions are `.sh`, `.sql` and `.sql.gz`
  ## ref: https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha#initialize-a-fresh-instance
  ## e.g:
  ## initdbScripts:
  ##   my_init_script.sh: |
  ##      #!/bin/sh
  ##      echo "Do something."
  ##
  initdbScripts: {}
  ## @param witness.initdbScriptsCM ConfigMap with scripts to be run at first boot
  ## NOTE: This will override initdbScripts
  ##
  initdbScriptsCM: ""
  ## @param witness.initdbScriptsSecret Secret with scripts to be run at first boot
  ## Note: can be used with initdbScriptsCM or initdbScripts
  ##
  initdbScriptsSecret: ""
## @section Pgpool parameters

## Pgpool parameters
##
pgpool:
  ## Bitnami Pgpool image
  ## ref: https://hub.docker.com/r/bitnami/pgpool/tags/
  ## @param pgpool.image.registry Pgpool image registry
  ## @param pgpool.image.repository Pgpool image repository
  ## @param pgpool.image.tag Pgpool image tag
  ## @param pgpool.image.digest Pgpool image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param pgpool.image.pullPolicy Pgpool image pull policy
  ## @param pgpool.image.pullSecrets Specify docker-registry secret names as an array
  ## @param pgpool.image.debug Specify if debug logs should be enabled
  ##
  image:
    registry: docker.io
    repository: bitnami/pgpool
    tag: 4.4.2-debian-11-r8
    digest: ""
    ## Specify a imagePullPolicy. Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
    ## Set to true if you would like to see extra information on logs
    ##
    debug: false
  ## @param pgpool.customUsers Additional users that will be performing connections to the database using
  ## pgpool. Use this property in order to create new user/password entries that
  ## will be appended to the "pgpool_passwd" file
  ##
  customUsers: {}
  ## @param pgpool.usernames Comma or semicolon separated list of postgres usernames
  ## e.g:
  ## usernames: 'user01;user02'
  ##
  usernames: ""
  ## @param pgpool.passwords Comma or semicolon separated list of the associated passwords for the users above
  ## e.g:
  ## passwords: 'pass01;pass02'
  ##
  passwords: ""
  ## @param pgpool.hostAliases Deployment pod host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param pgpool.customUsersSecret Name of a secret containing the usernames and passwords of accounts that will be added to pgpool_passwd
  ## The secret must contain the keys "usernames" and "passwords" respectively.
  ##
  customUsersSecret: ""
  ## @param pgpool.existingSecret Pgpool admin password using existing secret
  ##
  existingSecret: ""
  ## @param pgpool.srCheckDatabase Name of the database to perform streaming replication checks
  ##
  srCheckDatabase: postgres
  ## @param pgpool.labels Labels to add to the Deployment. Evaluated as template
  ##
  labels: {}
  ## @param pgpool.podLabels Labels to add to the pods. Evaluated as template
  ##
  podLabels: {}
  ## @param pgpool.serviceLabels Labels to add to the service. Evaluated as template
  ##
  serviceLabels: {}
  ## @param pgpool.serviceAnnotations Provide any additional annotations for Pgpool service
  ##
  serviceAnnotations: {}
  ## @param pgpool.customLivenessProbe Override default liveness probe
  ##
  customLivenessProbe: {}
  ## @param pgpool.customReadinessProbe Override default readiness probe
  ##
  customReadinessProbe: {}
  ## @param pgpool.customStartupProbe Override default startup probe
  ##
  customStartupProbe: {}
  ## @param pgpool.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param pgpool.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param pgpool.lifecycleHooks LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template
  ##
  lifecycleHooks: {}
  ## @param pgpool.extraEnvVars Array containing extra environment variables
  ## For example:
  ##  - name: BEARER_AUTH
  ##    value: true
  ##
  extraEnvVars: []
  ## @param pgpool.extraEnvVarsCM ConfigMap with extra environment variables
  ##
  extraEnvVarsCM: ""
  ## @param pgpool.extraEnvVarsSecret Secret with extra environment variables
  ##
  extraEnvVarsSecret: ""
  ## @param pgpool.extraVolumes Extra volumes to add to the deployment
  ##
  extraVolumes: []
  ## @param pgpool.extraVolumeMounts Extra volume mounts to add to the container. Normally used with `extraVolumes`
  ##
  extraVolumeMounts: []
  ## @param pgpool.initContainers Extra init containers to add to the deployment
  ##
  initContainers: []
  ## @param pgpool.sidecars Extra sidecar containers to add to the deployment
  ##
  sidecars: []
  ## @param pgpool.replicaCount The number of replicas to deploy
  ##
  replicaCount: 1
  ## @param pgpool.podAnnotations Additional pod annotations
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param pgpool.priorityClassName Pod priority class
  ## Ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/
  ##
  priorityClassName: ""
  ## @param pgpool.schedulerName Use an alternate scheduler, e.g. "stork".
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param pgpool.terminationGracePeriodSeconds Seconds pgpool pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## @param pgpool.topologySpreadConstraints Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#spread-constraints-for-pods
  ##
  topologySpreadConstraints: []
  ## @param pgpool.podAffinityPreset Pgpool pod affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param pgpool.podAntiAffinityPreset Pgpool pod anti-affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Pgpool node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param pgpool.nodeAffinityPreset.type Pgpool node affinity preset type. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param pgpool.nodeAffinityPreset.key Pgpool node label key to match Ignored if `pgpool.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param pgpool.nodeAffinityPreset.values Pgpool node label values to match. Ignored if `pgpool.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param pgpool.affinity Affinity for Pgpool pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: pgpool.podAffinityPreset, pgpool.podAntiAffinityPreset, and pgpool.nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param pgpool.nodeSelector Node labels for Pgpool pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param pgpool.tolerations Tolerations for Pgpool pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## K8s Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param pgpool.podSecurityContext.enabled Enable security context for Pgpool
  ## @param pgpool.podSecurityContext.fsGroup Group ID for the Pgpool filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Container Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param pgpool.containerSecurityContext.enabled Enable container security context
  ## @param pgpool.containerSecurityContext.runAsUser User ID for the Pgpool container
  ## @param pgpool.containerSecurityContext.runAsNonRoot Set Pgpool containers' Security Context runAsNonRoot
  ## @param pgpool.containerSecurityContext.readOnlyRootFilesystem Set Pgpool containers' Security Context runAsNonRoot
  ## e.g:
  ##   containerSecurityContext:
  ##     enabled: true
  ##     capabilities:
  ##       drop: ["NET_RAW"]
  ##     readOnlyRootFilesystem: true
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
    readOnlyRootFilesystem: false
  ## Pgpool containers' resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param pgpool.resources.limits The resources limits for the container
  ## @param pgpool.resources.requests The requested resources for the container
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## Pgpool container's liveness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param pgpool.livenessProbe.enabled Enable livenessProbe
  ## @param pgpool.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param pgpool.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param pgpool.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param pgpool.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param pgpool.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## Pgpool container's readiness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param pgpool.readinessProbe.enabled Enable readinessProbe
  ## @param pgpool.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param pgpool.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param pgpool.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param pgpool.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param pgpool.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## Pgpool container's startup probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param pgpool.startupProbe.enabled Enable startupProbe
  ## @param pgpool.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param pgpool.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param pgpool.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param pgpool.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param pgpool.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 10
  ## Pod disruption budget configuration
  ## @param pgpool.pdb.create Specifies whether a Pod disruption budget should be created for Pgpool pods
  ## @param pgpool.pdb.minAvailable Minimum number / percentage of pods that should remain scheduled
  ## @param pgpool.pdb.maxUnavailable Maximum number / percentage of pods that may be made unavailable
  ##
  pdb:
    create: false
    minAvailable: 1
    maxUnavailable: ""
  ## @param pgpool.updateStrategy Strategy used to replace old Pods by new ones
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
  ##
  updateStrategy: {}
  ## @param pgpool.containerPorts.postgresql Pgpool port
  ##
  containerPorts:
    postgresql: ${database_port}
  ## @param pgpool.minReadySeconds How many seconds a pod needs to be ready before killing the next, during update
  ##
  minReadySeconds: ""
  ## Credentials for the pgpool administrator
  ## @param pgpool.adminUsername Pgpool Admin username
  ## @param pgpool.adminPassword Pgpool Admin password
  ##
  adminUsername: admin
  adminPassword: ""
  ## @param pgpool.usePasswordFile Set to `true` to mount pgpool secret as a file instead of passing environment variable
  ##
  usePasswordFile: ""
  ## Authentication method for pgpool container (PGPOOL_AUTHENTICATION_METHOD)
  ## @param pgpool.authenticationMethod Pgpool authentication method. Use 'md5' for PSQL < 14.
  ##
  authenticationMethod: scram-sha-256
  ## @param pgpool.logConnections Log all client connections (PGPOOL_ENABLE_LOG_CONNECTIONS)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  logConnections: false
  ## @param pgpool.logHostname Log the client hostname instead of IP address (PGPOOL_ENABLE_LOG_HOSTNAME)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  logHostname: true
  ## @param pgpool.logPerNodeStatement Log every SQL statement for each DB node separately (PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  logPerNodeStatement: false
  ## @param pgpool.logLinePrefix Format of the log entry lines (PGPOOL_LOG_LINE_PREFIX)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ## ref: https://www.pgpool.net/docs/latest/en/html/runtime-config-logging.html
  ##
  logLinePrefix: ""
  ## @param pgpool.clientMinMessages Log level for clients
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  clientMinMessages: error
  ## @param pgpool.numInitChildren The number of preforked Pgpool-II server processes. It is also the concurrent
  ## connections limit to Pgpool-II from clients. Must be a positive integer. (PGPOOL_NUM_INIT_CHILDREN)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  numInitChildren: ""
  ## @param pgpool.reservedConnections Number of reserved connections. When zero, excess connection block. When non-zero, excess connections are refused with an error message.
  ## When this parameter is set to 1 or greater, incoming connections from clients are not accepted with error message
  ## "Sorry, too many clients already", rather than blocked if the number of current connections from clients is more than
  ## (num_init_children - reserved_connections).
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  reservedConnections: 1

  ## @param pgpool.maxPool The maximum number of cached connections in each child process (PGPOOL_MAX_POOL)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  maxPool: ""
  ## @param pgpool.childMaxConnections The maximum number of client connections in each child process (PGPOOL_CHILD_MAX_CONNECTIONS)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  childMaxConnections: ""
  ## @param pgpool.childLifeTime The time in seconds to terminate a Pgpool-II child process if it remains idle (PGPOOL_CHILD_LIFE_TIME)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  childLifeTime: ""
  ## @param pgpool.clientIdleLimit The time in seconds to disconnect a client if it remains idle since the last query (PGPOOL_CLIENT_IDLE_LIMIT)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  clientIdleLimit: ""
  ## @param pgpool.connectionLifeTime The time in seconds to terminate the cached connections to the PostgreSQL backend (PGPOOL_CONNECTION_LIFE_TIME)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ##
  connectionLifeTime: ""
  ## @param pgpool.useLoadBalancing Use Pgpool Load-Balancing
  ##
  useLoadBalancing: true
  ## @param pgpool.loadBalancingOnWrite LoadBalancer on write actions behavior
  ## one of: [off, transaction, trans_transaction, always]
  ##
  loadBalancingOnWrite: transaction
  ## @param pgpool.configuration Pgpool configuration
  ## You can use this parameter to specify the content for pgpool.conf
  ## Otherwise, a repmgr.conf will be generated based on the environment variables
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/pgpool#configuration-file
  ## Example:
  ## configuration: |-
  ##   listen_addresses = '*'
  ##   port = '5432'
  ##   ...
  ##
  configuration: ""
  ## @param pgpool.configurationCM ConfigMap with Pgpool configuration
  ## NOTE: This will override pgpool.configuration parameter
  ## The file used must be named `pgpool.conf`
  ##
  configurationCM: ""
  ## @param pgpool.initdbScripts Dictionary of initdb scripts
  ## Specify dictionary of scripts to be run every time Pgpool container is initialized
  ## The allowed extension is `.sh`
  ## ref: https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha#initialize-a-fresh-instance
  ## e.g:
  ## initdbScripts:
  ##   my_init_script.sh: |
  ##      #!/bin/sh
  ##      echo "Do something."
  ##
  initdbScripts: {}
  ## @param pgpool.initdbScriptsCM ConfigMap with scripts to be run every time Pgpool container is initialized
  ## NOTE: This will override pgpool.initdbScripts
  ##
  initdbScriptsCM: ""
  ## @param pgpool.initdbScriptsSecret Secret with scripts to be run every time Pgpool container is initialized
  ## Note: can be used with initdbScriptsCM or initdbScripts
  ##
  initdbScriptsSecret: ""
  ##
  ## TLS configuration
  ##
  tls:
    ## @param pgpool.tls.enabled Enable TLS traffic support for end-client connections
    ##
    enabled: false
    ## @param pgpool.tls.autoGenerated Create self-signed TLS certificates. Currently only supports PEM certificates
    ##
    autoGenerated: false
    ## @param pgpool.tls.preferServerCiphers Whether to use the server's TLS cipher preferences rather than the client's
    ##
    preferServerCiphers: true
    ## @param pgpool.tls.certificatesSecret Name of an existing secret that contains the certificates
    ##
    certificatesSecret: ""
    ## @param pgpool.tls.certFilename Certificate filename
    ##
    certFilename: ""
    ## @param pgpool.tls.certKeyFilename Certificate key filename
    ##
    certKeyFilename: ""
    ## @param pgpool.tls.certCAFilename CA Certificate filename
    ## If provided, PgPool will authenticate TLS/SSL clients by requesting them a certificate
    ## ref: https://www.pgpool.net/docs/latest/en/html/runtime-ssl.html
    ##
    certCAFilename: ""

## @section LDAP parameters

## LDAP parameters
## @param ldap.enabled Enable LDAP support
## @param ldap.existingSecret Name of existing secret to use for LDAP passwords
## @param ldap.uri LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`
## DEPRECATED ldap.base will be removed in a future, please use 'ldap.basedn' instead
## @param ldap.basedn LDAP base DN
## @param ldap.binddn LDAP bind DN
## @param ldap.bindpw LDAP bind password
## @param ldap.bslookup LDAP base lookup
## @param ldap.scope LDAP search scope
## @param ldap.tlsReqcert LDAP TLS check on server certificates
## @param ldap.nssInitgroupsIgnoreusers LDAP ignored users
##
ldap:
  enabled: false
  existingSecret: ""
  uri: ""
  basedn: ""
  binddn: ""
  bindpw: ""
  bslookup: ""
  scope: ""
  tlsReqcert: ""
  nssInitgroupsIgnoreusers: root,nslcd

## @section Other Parameters

## RBAC configuration
## Required for PSP
##
rbac:
  ## @param rbac.create Create Role and RoleBinding (required for PSP to work)
  ##
  create: false
  ## @param rbac.rules Custom RBAC rules to set
  ## e.g:
  ## rules:
  ##   - apiGroups:
  ##       - ""
  ##     resources:
  ##       - pods
  ##     verbs:
  ##       - get
  ##       - list
  ##
  rules: []

## ServiceAccount configuration
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
##
serviceAccount:
  ## @param serviceAccount.create Enable creation of ServiceAccount for Airflow pods
  ##
  create: false
  ## @param serviceAccount.name The name of the ServiceAccount to use.
  ## If not set and create is true, a name is generated using the common.names.fullname template
  ##
  name: ""
  ## @param serviceAccount.annotations Additional custom annotations for the ServiceAccount
  ##
  annotations: {}
  ## @param serviceAccount.automountServiceAccountToken Allows auto mount of ServiceAccountToken on the serviceAccount created
  ## Can be set to false if pods using this serviceAccount do not need to use K8s API
  ##
  automountServiceAccountToken: true

## Pod Security Policy configuration
## ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
## @param psp.create Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later
##
psp:
  create: false

## @section Metrics parameters

## PostgreSQL Prometheus exporter parameters
##
metrics:
  ## Bitnami PostgreSQL Prometheus exporter image
  ## @param metrics.enabled Enable PostgreSQL Prometheus exporter
  ##
  enabled: ${metrics_enabled}
  ## ref: https://hub.docker.com/r/bitnami/pgpool/tags/
  ## @param metrics.image.registry PostgreSQL Prometheus exporter image registry
  ## @param metrics.image.repository PostgreSQL Prometheus exporter image repository
  ## @param metrics.image.tag PostgreSQL Prometheus exporter image tag
  ## @param metrics.image.digest PostgreSQL Prometheus exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy PostgreSQL Prometheus exporter image pull policy
  ## @param metrics.image.pullSecrets Specify docker-registry secret names as an array
  ## @param metrics.image.debug Specify if debug logs should be enabled
  ##
  image:
    registry: docker.io
    repository: bitnami/postgres-exporter
    tag: 0.11.1-debian-11-r61
    digest: ""
    ## Specify a imagePullPolicy. Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
    ## Set to true if you would like to see extra information on logs
    ##
    debug: false
  ## K8s Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param metrics.podSecurityContext.enabled Enable security context for PostgreSQL Prometheus exporter
  ## @param metrics.podSecurityContext.runAsUser User ID for the PostgreSQL Prometheus exporter container
  ##
  podSecurityContext:
    enabled: true
    runAsUser: 1001
  ## Prometheus exporter containers' resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param metrics.resources.limits The resources limits for the container
  ## @param metrics.resources.requests The requested resources for the container
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## @param metrics.containerPorts.http Prometheus metrics exporter port
  ##
  containerPorts:
    http: 9187
  ## Prometheus exporter container's liveness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.livenessProbe.enabled Enable livenessProbe
  ## @param metrics.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param metrics.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param metrics.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param metrics.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param metrics.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## Prometheus exporter container's readiness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.readinessProbe.enabled Enable readinessProbe
  ## @param metrics.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param metrics.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param metrics.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param metrics.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param metrics.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## Prometheus exporter container's startup probes
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.startupProbe.enabled Enable startupProbe
  ## @param metrics.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param metrics.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param metrics.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param metrics.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param metrics.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 10
  ## @param metrics.customLivenessProbe Override default liveness probe
  ##
  customLivenessProbe: {}
  ## @param metrics.customReadinessProbe Override default readiness probe
  ##
  customReadinessProbe: {}
  ## @param metrics.customStartupProbe Override default startup probe
  ##
  customStartupProbe: {}

  ## Metrics service parameters
  ##
  service:
    ## @param metrics.service.type PostgreSQL Prometheus exporter metrics service type
    ##
    type: ClusterIP
    ## @param metrics.service.ports.metrics PostgreSQL Prometheus exporter metrics service port
    ##
    ports:
      metrics: 9187
    ## @param metrics.service.nodePorts.metrics PostgreSQL Prometheus exporter Node Port
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePorts:
      metrics: ""
    ## @param metrics.service.clusterIP PostgreSQL Prometheus exporter metrics service Cluster IP
    ## e.g.:
    ## clusterIP: None
    ##
    clusterIP: ""
    ## @param metrics.service.loadBalancerIP PostgreSQL Prometheus exporter service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerIP: ""
    ## @param metrics.service.loadBalancerSourceRanges PostgreSQL Prometheus exporter service Load Balancer sources
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g:
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param metrics.service.externalTrafficPolicy PostgreSQL Prometheus exporter service external traffic policy
    ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
  ## @param metrics.annotations [object] Annotations for PostgreSQL Prometheus exporter service
  ##
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9187"
  ## @param metrics.customMetrics Additional custom metrics
  ## ref: https://github.com/wrouesnel/postgres_exporter#adding-new-metrics-via-a-config-file
  ## customMetrics:
  ##   pg_database:
  ##     query: "SELECT d.datname AS name, CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT') THEN pg_catalog.pg_database_size(d.datname) ELSE 0 END AS size_bytes FROM pg_catalog.pg_database d where datname not in ('template0', 'template1', 'postgres')"
  ##     metrics:
  ##       - name:
  ##           usage: "LABEL"
  ##           description: "Name of the database"
  ##       - size_bytes:
  ##           usage: "GAUGE"
  ##           description: "Size of the database in bytes"
  ##
  customMetrics: {}
  ## @param metrics.extraEnvVars Array containing extra environment variables
  ## For example:
  ##  - name: BEARER_AUTH
  ##    value: true
  ##
  extraEnvVars: []
  ## @param metrics.extraEnvVarsCM ConfigMap with extra environment variables
  ##
  extraEnvVarsCM: ""
  ## @param metrics.extraEnvVarsSecret Secret with extra environment variables
  ##
  extraEnvVarsSecret: ""
  ## Metrics serviceMonitor parameters
  ## Enable this if you're using Prometheus Operator
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)
    ##
    enabled: false
    ## @param metrics.serviceMonitor.namespace Optional namespace which Prometheus is running in
    ## Fallback to the prometheus default unless specified
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval How frequently to scrape metrics (use by default, falling back to Prometheus' default)
    ## e.g:
    ## interval: 10s
    ##
    interval: ""
    ## @param metrics.serviceMonitor.scrapeTimeout Service monitor scrape timeout
    ## e.g:
    ## scrapeTimeout: 10s
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.annotations Additional annotations for the ServiceMonitor
    ##
    annotations: {}
    ## @param metrics.serviceMonitor.labels Additional labels that can be used so ServiceMonitor will be discovered by Prometheus
    ##
    labels: {}
    ## @param metrics.serviceMonitor.selector [object] Defaults to what's used if you follow CoreOS Prometheus Install Instructions (https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus#tldr)
    ## Prometheus Selector Label (https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus#prometheus-operator-parameters)
    ## Kube Prometheus Selector Label (https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus#exporters)
    ##
    selector:
      prometheus: kube-prometheus
    ## @param metrics.serviceMonitor.relabelings ServiceMonitor relabelings. Value is evaluated as a template
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
    ##
    relabelings: []
    ## @param metrics.serviceMonitor.metricRelabelings ServiceMonitor metricRelabelings. Value is evaluated as a template
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.jobLabel The name of the label on the target service to use as the job name in prometheus.
    ##
    jobLabel: ""

## @section Volume permissions parameters

## Init Container parameters
## volumePermissions: Change the owner and group of the persistent volume mountpoint
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container to adapt volume permissions
  ##
  enabled: false
  ## @param volumePermissions.image.registry Init container volume-permissions image registry
  ## @param volumePermissions.image.repository Init container volume-permissions image repository
  ## @param volumePermissions.image.tag Init container volume-permissions image tag
  ## @param volumePermissions.image.digest Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy Init container volume-permissions image pull policy
  ## @param volumePermissions.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 11-debian-11-r86
    digest: ""
    ## Specify a imagePullPolicy. Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## K8s Security Context
  ## https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param volumePermissions.podSecurityContext.runAsUser Init container volume-permissions User ID
  ##
  podSecurityContext:
    runAsUser: 0
  ## Init container' resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param volumePermissions.resources.limits The resources limits for the container
  ## @param volumePermissions.resources.requests The requested resources for the container
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 100m
    ##    memory: 128Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 100m
    ##    memory: 128Mi
    ##
    requests: {}

## @section Persistence parameters

## Enable persistence using Persistent Volume Claims
## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
##
persistence:
  ## @param persistence.enabled Enable data persistence
  ##
  enabled: true
  ## @param persistence.existingClaim A manually managed Persistent Volume and Claim
  ## If defined, PVC must be created manually before volume will be bound.
  ## All replicas will share this PVC, using existingClaim with replicas > 1 is only useful in very special use cases.
  ## The value is evaluated as a template.
  ##
  existingClaim: ""
  ## @param persistence.storageClass Persistent Volume Storage Class
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ## set, choosing the default provisioner.
  ##
  storageClass: "${volume_storage_class}"
  ## @param persistence.mountPath The path the volume will be mounted at, useful when using different PostgreSQL images.
  ##
  mountPath: /bitnami/postgresql
  ## @param persistence.accessModes List of access modes of data volume
  ##
  accessModes:
    - ReadWriteOnce
  ## @param persistence.size Persistent Volume Claim size
  ##
  size: ${volume_storage_size}
  ## @param persistence.annotations Persistent Volume Claim annotations
  ##
  annotations: {}
  ## @param persistence.labels Persistent Volume Claim labels
  ##
  labels: {}
  ## @param persistence.selector Selector to match an existing Persistent Volume (this value is evaluated as a template)
  ## selector:
  ##   matchLabels:
  ##     app: my-app
  ##
  selector: {}

## @section Traffic Exposure parameters

## PostgreSQL service parameters
##
service:
  ## @param service.type Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)
  ##
  type: ClusterIP
  ## @param service.ports.postgresql PostgreSQL port
  ##
  ports:
    postgresql: ${database_port}
  ## @param service.portName PostgreSQL service port name
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#multi-port-services
  ##
  portName: postgresql
  ## @param service.nodePorts.postgresql Kubernetes service nodePort
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
  ##
  nodePorts:
    postgresql: ""
  ## @param service.loadBalancerIP Load balancer IP if service type is `LoadBalancer`
  ## Set the LoadBalancer service type to internal only
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
  ##
  loadBalancerIP: ""
  ## @param service.loadBalancerSourceRanges Addresses that are allowed when service is LoadBalancer
  ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
  ##
  ## loadBalancerSourceRanges:
  ## - 10.10.10.0/24
  ##
  loadBalancerSourceRanges: []
  ## @param service.clusterIP Set the Cluster IP to use
  ## Static clusterIP or None for headless services
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#choosing-your-own-ip-address
  ## e.g:
  ## clusterIP: None
  ##
  clusterIP: ""
  ## @param service.externalTrafficPolicy Enable client source IP preservation
  ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
  ##
  externalTrafficPolicy: Cluster
  ## @param service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
  ##
  extraPorts: []
  ## @param service.sessionAffinity Control where client requests go, to the same pod or round-robin
  ## Values: ClientIP or None
  ## ref: https://kubernetes.io/docs/user-guide/services/
  ##
  sessionAffinity: "None"
  ## @param service.sessionAffinityConfig Additional settings for the sessionAffinity
  ## sessionAffinityConfig:
  ##   clientIP:
  ##     timeoutSeconds: 300
  sessionAffinityConfig: {}
  ## @param service.annotations Provide any additional annotations both for PostgreSQL and Pgpool services
  ##
  annotations: {}
  ## @param service.serviceLabels Labels for PostgreSQL service
  ##
  serviceLabels: {}

## NetworkPolicy parameters
##
networkPolicy:
  ## @param networkPolicy.enabled Enable NetworkPolicy
  ##
  enabled: false
  ## @param networkPolicy.allowExternal Don't require client label for connections
  ## The Policy model to apply. When set to false, only pods with the correct
  ## client labels will have network access to the port PostgreSQL is listening
  ## on. When true, PostgreSQL will accept connections from any source
  ## (with the correct destination port).
  ##
  allowExternal: true
  ## @param networkPolicy.egressRules.denyConnectionsToExternal Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53)
  ## @param networkPolicy.egressRules.customRules [object] Custom network policy rule
  ##
  egressRules:
    # Deny connections to external. This is not compatible with an external database.
    denyConnectionsToExternal: false
    ## Additional custom egress rules
    ## e.g:
    ## customRules:
    ##   - to:
    ##       - namespaceSelector:
    ##           matchLabels:
    ##             label: example
    ##
    customRules: []
