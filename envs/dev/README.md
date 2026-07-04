# dev environment

Development Helm values for the URL shortener chart.

## Values file

Use `envs/dev/values.yaml` with the source repository chart:

```bash
helm template url-shorten /home/aurora/Projects/url-shorten/deploy/helm/url-shorten \
  -f envs/dev/values.yaml
```

The values intentionally keep the optional in-chart Redis, PostgreSQL, and
RabbitMQ demo dependencies disabled. The application expects external dev
services and pre-created Kubernetes Secrets.

## Required Secrets

Create this Secret in the target namespace before deploying application
workloads:

| Secret name | Key |
| --- | --- |
| `url-shorten-dev-runtime` | `URL_DSN` |
| `url-shorten-dev-runtime` | `RIVER_DSN` |
| `url-shorten-dev-runtime` | `RABBITMQ_URL` |
| `url-shorten-dev-runtime` | `VIRUSTOTAL_API_KEY` |

Optional demo dependency gates remain disabled by default. If they are enabled
for a local cluster, create:

| Secret name | Key |
| --- | --- |
| `url-shorten-dev-dependencies` | `APP_POSTGRES_PASSWORD` |
| `url-shorten-dev-dependencies` | `RIVER_POSTGRES_PASSWORD` |
| `url-shorten-dev-dependencies` | `RABBITMQ_PASSWORD` |
| `url-shorten-dev-dependencies` | `RABBITMQ_ERLANG_COOKIE` |

Do not store literal DSNs, passwords, RabbitMQ URLs, VirusTotal keys,
kubeconfigs, or tokens in this repository.
