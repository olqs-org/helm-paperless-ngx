# Paperless-ngx Helm Chart

This Helm chart deploys the Paperless-ngx application along with its optional dependencies to Kubernetes. It includes:

- Paperless-ngx web application
- PostgreSQL database (optional, enabled by default)
- Redis (optional, enabled by default)
- Gotenberg (optional, enabled by default) for document conversions
- Apache Tika (optional, enabled by default) for content extraction

## Prerequisites

- Kubernetes cluster v1.23+
- Helm v3.10+
- Persistent volumes available if persistence is enabled
- Ingress controller if you enable the Ingress

## Default Container Images and Versions

The default images and tags are configured in `values.yaml`:

- Paperless-ngx: `:2.19.4`
- PostgreSQL: `docker.io/library/postgres:`
- Redis: `docker.io/library/redis:`
- Gotenberg: `docker.io/gotenberg/gotenberg:`
- Apache Tika: `docker.io/apache/tika:`

You can override these through the `values.yaml` file or with `--set` flags.

## Installation

```bash
helm repo add <your-repo> <repo-url>
helm install paperless <your-repo>/paperless-ngx
```

Or from the local chart directory:

```bash
helm install paperless ./charts/paperless-ngx
```

## Configuration

Key settings are shown below. See `values.yaml` for the full list.

- paperless.image.repository, paperless.image.tag, paperless.image.pullPolicy
- paperless.service.type, paperless.service.port
- paperless.env.existingSecret (for DB password) and paperless.env.values
- paperless.persistence.* (data, media, export, consume)
- postgresql.enabled, redis.enabled, gotenberg.enabled, tika.enabled
- ingress settings under `paperless.ingress.*`

### Ingress

Example enabling Ingress with TLS (Cert-Manager):

```yaml
paperless:
  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: paperless-ngx.example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: paperless-ngx-tls
        hosts:
          - paperless-ngx.example.com
```

## Persistence

Each persistent volume claim can be configured or replaced with an existing claim. See `paperless.persistence.*` and `postgresql.persistence`, `redis.persistence` for details.

## Upgrading

The chart automatically bumps the chart version on release. For application upgrades, pin the image tag rather than using `latest` for reproducible deployments.

## Uninstalling

```bash
helm uninstall paperless
```

This removes all Kubernetes resources created by the chart. Persistent volumes are not deleted by default.
