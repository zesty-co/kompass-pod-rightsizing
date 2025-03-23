# Kompass Pod-Rightsizing Helm Chart

## Overview

Kompass Pod-Rightsizing is a Kubernetes resource optimization solution that helps with pod rightsizing. It consists of two main components:

1. **Recommendations Maker**: Analyzes resource usage patterns and generates optimization recommendations
2. **Action Taker**: Implements the recommendations by adjusting resource allocations

The solution integrates with Victoria Metrics (via kube-state-metrics) to make data-driven decisions about resource optimization.

## Architecture

The Kompass Pod Rightsizing solution does the following:
1. Collects metrics from your Kubernetes cluster using kube-state-metrics
2. Analyzes resource usage patterns using the Recommendations Maker
3. Implements optimization recommendations using the Action Taker
4. [Optional] Provides visibility into recommendations and actions through Grafana dashboards

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installation

```bash
helm repo add kompass-repo https://zesty-co.github.io/kompass-pod-rightsizing
helm install pod-rightsizing kompass-repo/pod-rightsizing
```

## Adding Workloads for Pod Rightsizing

To enable Pod Rightsizing for specific workloads, update the default `AutoPilotConfig` Custom Resource (`default-pod-rightsizing-config`) under the `spec` section.

### Important Notes:

1. `applist` **Format:**

   - `appList` is a list where you need to add a separate item for each workload you want to right-size.
   - **Only include the following fields for each workload:** `kind`, `name`, `namespace`.

2. **Configuration Example:**

```yaml
appList:
  - kind: <YOUR_WORKLOAD_KIND>
    name: <YOUR_WORKLOAD_NAME>
    namespace: <YOUR_WORKLOAD_NAMESPACE>
```

3. **Removing Workloads:**\
   To exclude a workload from Pod Rightsizing, delete the corresponding entry from the `appList` in the `AutoPilotConfig` CR.

4. **Handling Multiple Configurations:**\
   If a workload exists in more than one `AutoPilotConfig`, the configuration with the highest priority will be applied.\
   **Priority Note:** Lower numbers indicate higher priority (e.g., `0` is the highest priority).

## Configuration Options

The following table lists the configurable parameters of the Kompass Pod-Rightsizing chart and their default values.

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the full name of the chart | `""` |
| `imagePullPolicy` | Image pull policy for all containers | `"Always"` |

### Service Account Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.name` | Name of the service account | `"kompass-rightsizing"` |

### Coralogix Logging

| Parameter | Description | Default |
|-----------|-------------|---------|
| `enabled` | boolean flag that determines whether the Coralogix logging feature is enabled or not | `false` |
| `clusterName` | Cluster identifier name for Zesty analysis | `""` |
| `apiKey` | Specify the API key required for authenticating in Coralogix | `""` |

### Action Taker Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `actionTaker.name` | Name of the action taker component | `"action-taker"` |
| `actionTaker.image.name` | Image name for action taker | `"/pod-rightsizing/action-taker"` |
| `actionTaker.image.tag` | Image tag for action taker | `"latest"` |

### Recommendations Maker Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `recommendationsMaker.name` | Name of the recommendations maker component | `"recommendations-maker"` |
| `recommendationsMaker.image.name` | Image name for recommendations maker | `"/pod-rightsizing/recommendations-maker"` |
| `recommendationsMaker.image.tag` | Image tag for recommendations maker | `"latest"` |
| `recommendationsMaker.port` | Port for the recommendations maker service | `8088` |

### Pod Rightsizing Config

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podRightsizingConfig.name` | Name of the pod rightsizing ConfigMap | `""` (uses default "kompass-pod-rightsizing-config") |

### Victoria Metrics Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `victoriaMetrics.storageClassName` | Name of the storage class for VM | `ebs-sc` |
| `victoriaMetrics.volumeSize` | Size of the storage for VM | `30Gi` |
| `victoriaMetrics.resources.requests.memory` | Memory request for Victoria Metrics container | `2Gi` |
| `victoriaMetrics.resources.requests.cpu` | CPU request for Victoria Metrics container | `2` |
| `victoriaMetrics.resources.limits.memory` | Memory limit for Victoria Metrics container | `` |
| `victoriaMetrics.resources.limits.cpu` | CPU limit for Victoria Metrics container | `` |

### Cert Manager Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cert-manager.enabled` | Enable cert-manager installation | `true` |
| `cert-manager.namespace` | Namespace for cert-manager | `` |
| `cert-manager.crds.enabled` | Enable cert-manager CRDs | `true` |

### Kube State Metrics Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kube-state-metrics.enabled` | Enable kube-state-metrics installation | `true` |
| `kube-state-metrics.fullnameOverride` | Override the full name of kube-state-metrics | `zesty-kompass-pod-rightsizing-kube-state-metrics` |
| `kube-state-metrics.namespaceOverride` | Override the namespace of kube-state-metrics | `` |
| `kube-state-metrics.extraArgs` | Extra arguments for kube-state-metrics | `["--metric-annotations-allowlist=pods=[*]"]` |

### Grafana Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `grafana.enabled` | Enable Grafana | `true` |
| `grafana.namespace` | Namespace for Grafana | `` |
| `grafana.replicaCount` | Number of Grafana replicas | `1` |
| `grafana.image.repository` | Grafana image repository | `nginx` |
| `grafana.image.pullPolicy` | Grafana image pull policy | `IfNotPresent` |
| `grafana.image.tag` | Grafana image tag | `""` |
| `grafana.service.type` | Grafana service type | `ClusterIP` |
| `grafana.service.port` | Grafana service port | `80` |
| `grafana.ingress.enabled` | Enable Grafana ingress | `false` |

## Dependencies

The Kompass Pod-Rightsizing chart depends on the following charts:

- **victoria metrics**: For time-series data storage and querying of resource utilization metrics
- **kube-state-metrics**: For collecting metrics from Kubernetes objects
- **grafana**: For visualization of recommendations and actions
- **cert-manager**: For TLS certificate management

## Usage Examples

### Basic Installation

```bash
helm install pod-rightsizing kompass-repo/pod-rightsizing
```

### Custom Configuration

```bash
helm install pod-rightsizing kompass-repo/pod-rightsizing \
  --set recommendationsMaker.image.tag=v1.2.3 \
  --set actionTaker.image.tag=v1.2.3
```

### Using a Custom Values File

```bash
helm install pod-rightsizing kompass-repo/pod-rightsizing -f custom-values.yaml
```

## Monitoring and Dashboards

Kompass Pod-Rightsizing includes Grafana dashboards for monitoring the performance and recommendations of the system. These dashboards are automatically installed when the `grafana.enabled` parameter is set to `true`.

## Troubleshooting

### Common Issues

1. **Recommendations not being generated**:
   - Ensure kube-state-metrics is properly configured
   - Check the logs of the recommendations-maker pod

2. **Actions not being taken**:
   - Verify the action-taker has proper permissions
   - Check the logs of the action-taker pod

3. **Service account issues**:
   - The default service account name is "kompass-rightsizing"
   - You can customize it using `serviceAccount.name`
   - Make sure the service account has the necessary RBAC permissions