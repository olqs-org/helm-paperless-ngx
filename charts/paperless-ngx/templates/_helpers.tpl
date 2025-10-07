{{- define "paperless-ngx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "paperless-ngx.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "paperless-ngx.labels" -}}
helm.sh/chart: {{ include "paperless-ngx.chart" . }}
{{ include "paperless-ngx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "paperless-ngx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paperless-ngx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "paperless-ngx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "paperless-ngx.volumeClaim" -}}
{{- $root := index . 0 -}}
{{- $name := index . 1 -}}
{{- $config := index . 2 -}}
{{- if and $config.enabled (not $config.existingClaim) -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ printf "%s-%s" (include "paperless-ngx.fullname" $root) $name }}
  labels:
    {{- include "paperless-ngx.labels" $root | nindent 4 }}
spec:
  accessModes:
    {{- toYaml $config.accessModes | nindent 4 }}
  resources:
    requests:
      storage: {{ $config.size }}
  {{- if $config.storageClass }}
  storageClassName: {{ $config.storageClass | quote }}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "paperless-ngx.claimName" -}}
{{- $root := index . 0 -}}
{{- $name := index . 1 -}}
{{- $config := index . 2 -}}
{{- if $config.existingClaim -}}
{{- $config.existingClaim -}}
{{- else -}}
{{- printf "%s-%s" (include "paperless-ngx.fullname" $root) $name -}}
{{- end -}}
{{- end -}}
