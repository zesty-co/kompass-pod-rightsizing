# Kompass Pod-Rightsizing Helm Chart

## Overview

Autopilot is a Kubernetes resource optimization solution that helps with pod rightsizing. It consists of two main components:

1. **Recommendations Maker**: Analyzes resource usage patterns and generates optimization recommendations
2. **Action Taker**: Implements the recommendations by adjusting resource allocations

The solution integrates with Prometheus metrics (via kube-state-metrics) to make data-driven decisions about resource optimization.

## Architecture

Autopilot works by:
1. Collecting metrics from your Kubernetes cluster using kube-state-metrics
2. Analyzing resource usage patterns with the Recommendations Maker
3. Implementing optimizations through the Action Taker component
4. Providing visibility into recommendations and actions through Grafana dashboards

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- A working Prometheus installation (optional, but recommended for full functionality)

## Installation

```bash
helm repo add autopilot-repo <repository-url>
helm install autopilot autopilot-repo/autopilot
```

## Configuration Options

The following table lists the configurable parameters of the Autopilot chart and their default values.

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
`podRightsizingConfig.name` | Name of the pod rightsizing ConfigMap | `""` (uses default "kompass-pod-rightsizing-config") |

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
| `kube-state-metrics.fullnameOverride` | Override the full name of kube-state-metrics | `pilot-kube-state-metrics` |
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

### Testing Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tests.enabled` | Enable test components | `false` |
| `tests.dev_env` | Enable development environment for tests | `false` |
| `tests.recommendation_maker_dry_run` | Enable dry run mode for recommendation maker | `false` |
| `tests.values.recommendation_maker_dry_run` | Enable dry run mode for recommendation maker (passed to subchart) | `false` |

## Dependencies

The Autopilot chart depends on the following charts:

- **kube-state-metrics**: For collecting metrics from Kubernetes objects
- **grafana**: For visualization of recommendations and actions
- **cert-manager**: For TLS certificate management
- **tests**: For testing components (optional)

## Usage Examples

### Basic Installation

```bash
helm install autopilot autopilot-repo/autopilot
```

### Custom Configuration

```bash
helm install autopilot autopilot-repo/autopilot \
  --set recommendationsMaker.image.tag=v1.2.3 \
  --set actionTaker.image.tag=v1.2.3 \
  --set tests.enabled=true
```

### Using a Custom Values File

```bash
helm install autopilot autopilot-repo/autopilot -f custom-values.yaml
```

## Monitoring and Dashboards

Autopilot includes Grafana dashboards for monitoring the performance and recommendations of the system. These dashboards are automatically installed when the `grafana.enabled` parameter is set to `true`.

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