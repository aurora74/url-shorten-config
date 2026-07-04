# url-shorten-config

Environment configuration for the URL shortener Helm chart.

This repository stores non-secret deployment configuration only. Runtime
credentials must be created in the target cluster by a secret manager or a
separate manual process and referenced by Kubernetes Secret name/key.

## Layout

- `envs/dev/values.yaml` - development Helm values for
  `deploy/helm/url-shorten` in the source repository.
- `scripts/update-image-tags.sh` - CI helper that replaces the four workload
  image tags in an environment values file.

## Development render

From the source repository:

```bash
helm lint deploy/helm/url-shorten
helm template url-shorten deploy/helm/url-shorten \
  -f /home/aurora/Projects/url-shorten-config/envs/dev/values.yaml
```

## Updating image tags

Jenkins can update all application workload tags before rendering or syncing:

```bash
IMAGE_TAG=v0.0.0 scripts/update-image-tags.sh envs/dev/values.yaml
```

The script updates:

- `frontend.image.tag`
- `api.image.tag`
- `backgroundWorker.image.tag`
- `fraudWorker.image.tag`

## Secret policy

Do not commit literal DSNs, passwords, API keys, kubeconfigs, private keys,
tokens, generated benchmark output, or local VM artifacts. Values files may
contain only Secret references such as:

```yaml
api:
  secrets:
    urlDsn:
      name: url-shorten-dev-runtime
      key: URL_DSN
```
