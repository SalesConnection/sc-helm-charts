{{/*
Expand the name of the chart.
*/}}
{{- define "caction.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "caction.fullname" -}}
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
{{- define "caction.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "caction.labels" -}}
helm.sh/chart: {{ include "caction.chart" . }}
{{ include "caction.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "caction.selectorLabels" -}}
app.kubernetes.io/name: {{ include "caction.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "caction.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "caction.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Default datadog annotation
*/}}
{{- define "caction.datadogAnnotation" -}}
ad.datadoghq.com/{{ .Chart.Name }}.logs: |
  [
    {"source":"container","service":"Laravel-log"}
  ]
{{- end }}

{{/*
ConfigMap name
*/}}
{{- define "caction.configMapName" -}}
{{- default (printf "%s-%s" .Release.Name "config") .Values.configMap.name }}
{{- end }}

{{/*
Secret name
*/}}
{{- define "caction.secretName" -}}
{{- default (printf "%s-%s" .Release.Name "secret") .Values.secret.name }}
{{- end }}

{{/*
ConfigMap name for file based config
*/}}
{{- define "caction.fileBasedConfigMapName" -}}
{{- printf "%s-%s" (include "caction.configMapName" .) "file" }}
{{- end }}

{{/*
Reloader annotation
*/}}
{{- define "caction.reloaderAnnotation" -}}
configmap.reloader.stakater.com/reload: "{{ (printf "%s,%s" (include "caction.configMapName" .) "robots-configmap") }}"
{{- end }}

{{/*
Cronjob name
*/}}
{{- define "caction.cronJobName" -}}
{{- default (printf "%s-%s" .Release.Name "cron") .Values.cron.name }}
{{- end }}
