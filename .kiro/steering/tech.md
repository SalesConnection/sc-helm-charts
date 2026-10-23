# Tech & Workflow

## Stack

- **Helm 3** charts (`apiVersion: v2`), rendered to Kubernetes manifests.
- Standard Helm templating: `_helpers.tpl` named templates, `values.yaml`
  inputs, optional `values.schema.json` validation.
- Release automation via `helm/chart-releaser-action` on GitHub Actions.

## Common commands

Run from the chart directory being worked on:

```bash
helm lint .                              # lint a chart
helm template test-release . -f values.yaml   # render locally
helm dependency update .                 # refresh subcharts (umbrella charts, e.g. caction)
```

## Release pipeline

`.github/workflows/release.yml` runs on every push to `main`:

1. Checks out the repo, installs Helm, adds the `stakater` and `sc` Helm repos.
2. `chart-releaser-action` packages each chart whose `Chart.yaml` `version` is
   new, publishes the package and an updated `index.yaml` to the `gh-pages`
   branch, and creates a per-chart tag (e.g. `microservice-1.3.0`).

A chart is only released when its `version` changes. Always bump `version`
(SemVer) when changing a chart, or the change will not be published.

## Verification

Before committing chart changes, run `helm lint` and `helm template` for the
affected chart and confirm it renders without errors. For umbrella charts, run
`helm dependency update` first.
