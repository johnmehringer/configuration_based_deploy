# Default values for coredns.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

image:
  repository: coredns/coredns
  tag: "1.9.3"
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets.
  ## Secrets must be manually created in the namespace.
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ##
  # pullSecrets:
  #   - myRegistryKeySecretName

replicaCount: 1

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

## Create HorizontalPodAutoscaler object.
##
# autoscaling:
#   minReplicas: 1
#   maxReplicas: 10
#   metrics:
#   - type: Resource
#     resource:
#       name: cpu
#       targetAverageUtilization: 60
#   - type: Resource
#     resource:
#       name: memory
#       targetAverageUtilization: 60

rollingUpdate:
  maxUnavailable: 1
  maxSurge: 25%

# Under heavy load it takes more that standard time to remove Pod endpoint from a cluster.
# This will delay termination of our pod by `preStopSleep`. To make sure kube-proxy has
# enough time to catch up.
# preStopSleep: 5
terminationGracePeriodSeconds: 30

podAnnotations: {}
#  cluster-autoscaler.kubernetes.io/safe-to-evict: "false"

${serviceType}

prometheus:
  service:
    enabled: false
    annotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "9153"
  monitor:
    enabled: false
    additionalLabels: {}
    namespace: ""
    interval: ""

service:
# clusterIP: ""
# loadBalancerIP: ""
# externalIPs: []
# externalTrafficPolicy: ""
  # The name of the Service
  # If not set, a name is generated using the fullname template
#  name: ""
${serviceName}
${loadBalancerIP}
${serviceAnnotations}

serviceAccount:
  create: false
  # The name of the ServiceAccount to use
  # If not set and create is true, a name is generated using the fullname template
  name: ""
  annotations: {}

rbac:
  # If true, create & use RBAC resources
  create: true
  # If true, create and use PodSecurityPolicy
  pspEnable: false
  # The name of the ServiceAccount to use.
  # If not set and create is true, a name is generated using the fullname template
  # name:

# isClusterService specifies whether chart should be deployed as cluster-service or normal k8s app.
isClusterService: ${isClusterService}

# Optional priority class to be used for the coredns pods. Used for autoscaler if autoscaler.priorityClassName not set.
priorityClassName: ""

# Default zone is what Kubernetes recommends:
# https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/#coredns-configmap-options
servers:
- zones:
  - zone: .
  port: 53
  # If serviceType is nodePort you can specify nodePort here
  # nodePort: 30053
  plugins:
  - name: errors
  # Serves a /health endpoint on :8080, required for livenessProbe
  - name: health
    configBlock: |-
      lameduck 5s
  # Serves a /ready endpoint on :8181, required for readinessProbe
  - name: ready
  # Required to query kubernetes API for data
  - name: kubernetes
    parameters: cluster.local in-addr.arpa ip6.arpa
    configBlock: |-
      pods insecure
      fallthrough in-addr.arpa ip6.arpa
      ttl 30
  # Serves a /metrics endpoint on :9153, required for serviceMonitor
  - name: prometheus
    parameters: 0.0.0.0:9153
  - name: forward
    parameters: . /etc/resolv.conf
  - name: cache
    parameters: 30
  - name: loop
  - name: reload
  - name: loadbalance

# Complete example with all the options:
# - zones:                 # the `zones` block can be left out entirely, defaults to "."
#   - zone: hello.world.   # optional, defaults to "."
#     scheme: tls://       # optional, defaults to "" (which equals "dns://" in CoreDNS)
#   - zone: foo.bar.
#     scheme: dns://
#     use_tcp: true        # set this parameter to optionally expose the port on tcp as well as udp for the DNS protocol
#                          # Note that this will not work if you are also exposing tls or grpc on the same server
#   port: 12345            # optional, defaults to "" (which equals 53 in CoreDNS)
#   plugins:               # the plugins to use for this server block
#   - name: kubernetes     # name of plugin, if used multiple times ensure that the plugin supports it!
#     parameters: foo bar  # list of parameters after the plugin
#     configBlock: |-      # if the plugin supports extra block style config, supply it here
#       hello world
#       foo bar

# Extra configuration that is applied outside of the default zone block.
# Example to include additional config files, which may come from extraVolumes:
# extraConfig:
#   import:
#     parameters: /opt/coredns/*.conf
extraConfig: {}

# To use the livenessProbe, the health plugin needs to be enabled in CoreDNS' server config
livenessProbe:
  enabled: true
  initialDelaySeconds: 60
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5
  successThreshold: 1
# To use the readinessProbe, the ready plugin needs to be enabled in CoreDNS' server config
readinessProbe:
  enabled: true
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5
  successThreshold: 1

# expects input structure as per specification https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#affinity-v1-core
# for example:
#   affinity:
#     nodeAffinity:
#      requiredDuringSchedulingIgnoredDuringExecution:
#        nodeSelectorTerms:
#        - matchExpressions:
#          - key: foo.bar.com/role
#            operator: In
#            values:
#            - master
affinity: {}

# Node labels for pod assignment
# Ref: https://kubernetes.io/docs/user-guide/node-selection/
nodeSelector: {}

# expects input structure as per specification https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#toleration-v1-core
# for example:
#   tolerations:
#   - key: foo.bar.com/role
#     operator: Equal
#     value: master
#     effect: NoSchedule
tolerations: []

# https://kubernetes.io/docs/tasks/run-application/configure-pdb/#specifying-a-poddisruptionbudget
podDisruptionBudget: {}

# configure custom zone files as per https://coredns.io/2017/05/08/custom-dns-entries-for-kubernetes/
zoneFiles: []
#  - filename: example.db
#    domain: example.com
#    contents: |
#      example.com.   IN SOA sns.dns.icann.com. noc.dns.icann.com. 2015082541 7200 3600 1209600 3600
#      example.com.   IN NS  b.iana-servers.net.
#      example.com.   IN NS  a.iana-servers.net.
#      example.com.   IN A   192.168.99.102
#      *.example.com. IN A   192.168.99.102

# optional array of extra volumes to create
extraVolumes: []
# - name: some-volume-name
#   emptyDir: {}
# optional array of mount points for extraVolumes
extraVolumeMounts: []
# - name: some-volume-name
#   mountPath: /etc/wherever

# optional array of secrets to mount inside coredns container
# possible usecase: need for secure connection with etcd backend
extraSecrets: []
# - name: etcd-client-certs
#   mountPath: /etc/coredns/tls/etcd
# - name: some-fancy-secret
#   mountPath: /etc/wherever

# Custom labels to apply to Deployment, Pod, Configmap, Service, ServiceMonitor. Including autoscaler if enabled.
customLabels: {}

# Custom annotations to apply to Deployment, Pod, Configmap, Service, ServiceMonitor. Including autoscaler if enabled.
customAnnotations: {}

## Alternative configuration for HPA deployment if wanted
#
hpa:
  enabled: false
  minReplicas: 1
  maxReplicas: 2
  metrics: {}

## Configue a cluster-proportional-autoscaler for coredns
# See https://github.com/kubernetes-incubator/cluster-proportional-autoscaler
autoscaler:
  # Enabled the cluster-proportional-autoscaler
  enabled: false

  # Number of cores in the cluster per coredns replica
  coresPerReplica: 256
  # Number of nodes in the cluster per coredns replica
  nodesPerReplica: 16
  # Min size of replicaCount
  min: 0
  # Max size of replicaCount (default of 0 is no max)
  max: 0
  # Whether to include unschedulable nodes in the nodes/cores calculations - this requires version 1.8.0+ of the autoscaler
  includeUnschedulableNodes: false
  # If true does not allow single points of failure to form
  preventSinglePointFailure: true

  ## Optionally specify some extra flags to pass to cluster-proprtional-autoscaler.
  ## Useful for e.g. the nodelabels flag.
  # customFlags:
  #   - --nodelabels=topology.kubernetes.io/zone=us-east-1a

  image:
    repository: k8s.gcr.io/cpa/cluster-proportional-autoscaler
    tag: "1.8.5"
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ##
    # pullSecrets:
    #   - myRegistryKeySecretName

  # Optional priority class to be used for the autoscaler pods. priorityClassName used if not set.
  priorityClassName: ""

  # expects input structure as per specification https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#affinity-v1-core
  affinity: {}

  # Node labels for pod assignment
  # Ref: https://kubernetes.io/docs/user-guide/node-selection/
  nodeSelector: {}

  # expects input structure as per specification https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#toleration-v1-core
  tolerations: []

  # resources for autoscaler pod
  resources:
    requests:
      cpu: "20m"
      memory: "10Mi"
    limits:
      cpu: "20m"
      memory: "10Mi"

  # Options for autoscaler configmap
  configmap:
    ## Annotations for the coredns-autoscaler configmap
    # i.e. strategy.spinnaker.io/versioned: "false" to ensure configmap isn't renamed
    annotations: {}

  # Enables the livenessProbe for cluster-proportional-autoscaler - this requires version 1.8.0+ of the autoscaler
  livenessProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 5
    timeoutSeconds: 5
    failureThreshold: 3
    successThreshold: 1

deployment:
  enabled: true
  name: ""
  ## Annotations for the coredns deployment
  annotations: {}
