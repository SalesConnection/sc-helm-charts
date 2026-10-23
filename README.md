# sc-helm-charts

Helm chart monorepo for SalesConnection's Kubernetes workloads. Charts are
packaged and published automatically to GitHub Pages via
[`helm/chart-releaser-action`](https://github.com/helm/chart-releaser-action)
and served from the Helm repository below.

Repository URL: `https://salesconnection.github.io/sc-helm-charts`

## Using the charts

Add the repository and install any chart from it:

```bash
helm repo add sc https://salesconnection.github.io/sc-helm-charts
helm repo update

# list available charts
helm search repo sc

# install a chart
helm install my-release sc/microservice -f my-values.yaml
```

## Charts

All charts live under `charts/` and are `application` type.

| Chart | Version | App version | Description |
|-------|---------|-------------|-------------|
| `batch-reminder` | 1.1.1 | v1.0.3 | Batch reminder service |
| `caction` | 1.1.4 | v9.1.4 | Caction app (umbrella chart; depends on `repeat-job`, `noti`, `qr-generator`) |
| `caction-website` | 1.0.3 | 1.16.0 | Caction website |
| `messenger` | 1.1.1 | v1.2.0 | Messenger service |
| `microservice` | 1.3.0 | 1.0.0 | Generic microservice chart (deployment, service, ingress, HPA, config/secret, PVC) |
| `noti` | 0.1.2 | 1.16.0 | Notification service (also a `caction` subchart) |
| `qr-generator` | 0.1.1 | 1.16.0 | QR code generator (also a `caction` subchart) |
| `repeat-job` | 0.1.2 | 1.0.0 | Repeat/recurring job runner (also a `caction` subchart) |
| `salesconnection` | 0.14.2 | v8.2.7 | Aggregate chart bundling the SalesConnection platform (web, messenger, worker, noti, qr-generator, repeat-job, reminders, external secrets) |
| `srv-change-status` | 1.0.2 | v1.0.0 | Change-status microservice |

Versions above reflect the current state of each `Chart.yaml` and may change as
charts are updated.

### Chart relationships

- `caction` is an umbrella chart. It declares `repeat-job`, `noti`, and
  `qr-generator` as dependencies (pulled from this same published repo) and
  vendors them as `.tgz` archives under `charts/caction/charts/`. Dependency
  versions are pinned in `charts/caction/Chart.lock`.
- `salesconnection` is a self-contained aggregate chart whose templates deploy
  the full platform directly, rather than via subchart dependencies.

## Local development

```bash
cd charts/<chart>

# lint
helm lint .

# render templates locally
helm template my-release . -f values.yaml

# for charts with dependencies (e.g. caction), refresh subcharts first
helm dependency update .
```

Some charts ship a `values.schema.json` (for example `batch-reminder`), which
validates values at install/template time.

## Release process

Releases are automated by `.github/workflows/release.yml`, which runs on every
push to `main`:

1. Bump the `version` field in the affected chart's `Chart.yaml` (SemVer). The
   release action only packages a chart when its version is new — if you change
   a chart but forget to bump `version`, it will not be released.
2. Merge the change to `main`.
3. `chart-releaser-action` packages each changed chart, publishes the `.tgz`
   plus an updated `index.yaml` to the `gh-pages` branch, and creates a Git tag
   per released chart (e.g. `microservice-1.3.0`).

The workflow also adds the `stakater` and `sc` Helm repos so build-time
dependencies resolve.

## Conventions

- Bump a chart's `version` (SemVer) on any change to its templates or values.
- Set `appVersion` to the version of the application being deployed; it does not
  need to follow SemVer.
- Template helpers follow the standard Helm chart pattern, namespaced per chart
  (e.g. `microservice.fullname`, `microservice.labels` in `_helpers.tpl`).
