# Product

`sc-helm-charts` is the Helm chart monorepo for SalesConnection's Kubernetes
workloads. It packages and publishes the charts used to deploy the
SalesConnection platform and its supporting services.

The charts are served as a public Helm repository at
`https://salesconnection.github.io/sc-helm-charts`, published automatically from
this repo.

## What the charts deploy

- **salesconnection** — aggregate chart for the full platform (web app,
  messenger, worker, notifications, QR generator, repeat jobs, reminders,
  external secrets).
- **caction / caction-website** — the Caction application and its website.
- **microservice** — a generic, reusable microservice chart (deployment,
  service, ingress, HPA, config/secret, optional PVC).
- **messenger, noti, qr-generator, repeat-job, batch-reminder,
  srv-change-status** — individual supporting services. `noti`, `qr-generator`,
  and `repeat-job` also serve as subcharts of `caction`.

## Audience

Internal platform/DevOps engineers who install and operate these charts against
SalesConnection's Kubernetes clusters.
