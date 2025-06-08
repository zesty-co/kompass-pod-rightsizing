{{/*
Expand the name of the chart.
*/}}
{{- define "pod-rightsizing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "prefix.name" -}}
{{- default "zesty-kompass" .Values.prefix | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "name" -}}
{{- printf "%s-%s" (include "prefix.name" .) .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the recommendations-maker
*/}}
{{- define "recommendations-maker.name" -}}
{{- .Values.recommendationsMaker.fullnameOverride | default (printf "%s-%s" (include "name" .) .Values.recommendationsMaker.name | trunc 63 | trimSuffix "-") }}
{{- end }}

{{/*
Create the name of the action-taker
*/}}
{{- define "action-taker.name" -}}
{{- .Values.actionTaker.fullnameOverride | default (printf "%s-%s" (include "name" .) .Values.actionTaker.name | trunc 63 | trimSuffix "-") }}
{{- end }}

{{/*
Create the name of the kompass rightsizing config map
*/}}
{{- define "kompass-pod-rightsizing-config.name" -}}
{{- printf "%s-%s" (include "name" .) "config" }}
{{- end }}

{{/*
Create the name of the kompass rightsizing config map
*/}}
{{- define "kompass-webhook-svc.name" -}}
{{- printf "%s-%s" (include "name" .) "webhook-service" }}
{{- end }}

{{- define "kube-state-metrics.serviceName" -}}
{{- if (index .Values "kube-state-metrics" "enabled") }}
{{- index .Values "kube-state-metrics" "fullnameOverride" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- index .Values "kube-state-metrics" "serviceName" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "vmagent.scrapeInterval" -}}
{{- default "30s" .Values.victoriaMetrics.vmagent.scrapeInterval -}}
{{- end }}

{{/*
Create the name of the service account to use for the system
*/}}
{{- define "pod-rightsizing.serviceAccountName" -}}
{{- default "zesty-kompass-rightsizing" .Values.serviceAccount.name }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pod-rightsizing.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pod-rightsizing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pod-rightsizing.labels" -}}
helm.sh/chart: {{ include "pod-rightsizing.chart" . }}
{{ include "pod-rightsizing.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pod-rightsizing.selectorLabels" -}}
app.kubernetes.io/name: pod-rightsizing # Don't change this, since the component monitor uses this value to identify the component
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}