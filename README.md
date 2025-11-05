# helm-paperless-ngx

Helm chart for deploying Paperless-ngx and its optional dependencies (PostgreSQL, Redis, Gotenberg, Tika).

## Repository Structure

- `charts/paperless-ngx/` — the main Helm chart
- `.github/workflows/` — CI workflows to lint and release the chart

## Quickstart

Install from local checkout:

```bash
helm install paperless ./charts/paperless-ngx \
  --set paperless.image.tag=2.19.4 \
  --set postgresql.image.tag=18.0 \
  --set redis.image.tag=8.2.3
```

Enable Ingress (example with cert-manager):

```bash
helm upgrade --install paperless ./charts/paperless-ngx \
  --set paperless.ingress.enabled=true \
  --set paperless.ingress.className=nginx \
  --set-string paperless.ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set paperless.ingress.hosts[0].host=paperless-ngx.example.com \
  --set paperless.ingress.hosts[0].paths[0].path=/ \
  --set paperless.ingress.hosts[0].paths[0].pathType=Prefix \
  --set paperless.ingress.tls[0].secretName=paperless-ngx-tls \
  --set paperless.ingress.tls[0].hosts[0]=paperless-ngx.example.com
```

## Releasing

The GitHub Actions workflow "Release Helm Chart" packages and publishes the chart. It is triggered manually or when PRs to `master` are merged (per workflow conditions). The action pushes the chart via `helm cm-push` using repository credentials provided as GitHub Secrets.

## Contributing

- Open an issue or PR with your changes.
- Keep image tags pinned to specific versions.
- Run `helm lint charts/paperless-ngx` before submitting.

## License

MIT
