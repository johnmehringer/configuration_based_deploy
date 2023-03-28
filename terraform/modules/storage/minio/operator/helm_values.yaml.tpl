# Default values for minio-operator.

operator:
  ## Setup environment variables for the Operator
  # env:
  #   - name: MINIO_OPERATOR_TLS_ENABLE
  #     value: "off"
  #   - name: CLUSTER_DOMAIN
  #     value: "cluster.domain"
  #   - name: WATCHED_NAMESPACE
  #     value: ""
  image:
    repository: minio/operator
    tag: v${version}
    pullPolicy: IfNotPresent
  imagePullSecrets: [ ]
  initcontainers: [ ]
  replicaCount: 2
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    runAsNonRoot: true
    fsGroup: 1000
  nodeSelector: { }
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: name
                operator: In
                values:
                  - minio-operator
          topologyKey: kubernetes.io/hostname
  tolerations: [ ]
  topologySpreadConstraints: [ ]
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
      ephemeral-storage: 500Mi

console:
  image:
    repository: minio/console
    tag: v0.22.1
    pullPolicy: IfNotPresent
  imagePullSecrets: [ ]
  initcontainers: [ ]
  replicaCount: 1
  nodeSelector: { }
  affinity: { }
  tolerations: [ ]
  topologySpreadConstraints: [ ]
  resources: { }
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
  ingress:
    enabled: false
    ingressClassName: ""
    labels: { }
    annotations: { }
    tls: [ ]
    host: console.local
    path: /
    pathType: Prefix
  volumes: [ ]
  volumeMounts: [ ]
