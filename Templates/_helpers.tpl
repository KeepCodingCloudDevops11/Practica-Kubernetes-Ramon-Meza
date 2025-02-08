{{/*
Expand the name of the chart.
*/}}
{{- define "practica-ramon-keepcoding.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "practica-ramon-keepcoding.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{- default (printf "%s-%s" .Release.Name .Chart.Name) .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "practica-ramon-keepcoding.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "practica-ramon-keepcoding.labels" -}}
helm.sh/chart: {{ include "practica-ramon-keepcoding.chart" . }}
{{ include "practica-ramon-keepcoding.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "practica-ramon-keepcoding.selectorLabels" -}}
app.kubernetes.io/name: {{ include "practica-ramon-keepcoding.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "practica-ramon-keepcoding.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "practica-ramon-keepcoding.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
