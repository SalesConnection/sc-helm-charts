# Structure

Helm chart monorepo. Each chart is a self-contained directory under `charts/`.

```
charts/
  <chart>/
    Chart.yaml            # metadata: name, version, appVersion, dependencies
    values.yaml           # default values
    values.schema.json    # optional JSON Schema (e.g. batch-reminder)
    templates/
      _helpers.tpl        # per-chart named template helpers
      *.yaml              # Kubernetes manifests
.github/workflows/release.yml   # chart-releaser pipeline
```

## Charts

All charts are `type: application`.

- `batch-reminder`, `caction`, `caction-website`, `messenger`, `microservice`,
  `noti`, `qr-generator`, `repeat-job`, `salesconnection`, `srv-change-status`.

## Relationships

- `caction` is an **umbrella chart**: it declares `repeat-job`, `noti`, and
  `qr-generator` as dependencies (from this same published repo), pins them in
  `charts/caction/Chart.lock`, and vendors them as `.tgz` archives under
  `charts/caction/charts/`.
- `salesconnection` is an **aggregate chart**: it deploys the whole platform
  directly from its own templates rather than via subchart dependencies.

## Untracked local files

Root-level `*.yml` / `*.yaml` files (e.g. `br-values.yaml`, `sc-values.yml`) are
local, environment-specific values files. They are untracked and not part of the
chart source. Do not add, edit, or rely on them unless explicitly asked.
