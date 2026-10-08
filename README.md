# platform-gitops

The desired state of every cluster. Argo CD watches this repo and makes each cluster match it.

See [platform-bootstrap](https://github.com/mjbrian/platform-bootstrap) for how this repo fits with the others.

## What lives here

| Path | Purpose |
| --- | --- |
| `bootstrap/` | Argo CD install values and the root Applications |
| `clusters/local/`, `clusters/aws/` | Everything each cluster runs |
| `platform/` | Shared components, such as cert-manager, Kyverno, monitoring |
| `apps/<name>/` | A wrapper chart per app, pinning its chart version, with values per cluster |
| `runbooks/`, `docs/adr/` | Runbooks linked from alerts, and decision records |

## How changes ship

- App releases arrive as promotion pull requests that change an image tag in `apps/<name>/values-*.yaml`. Local merges automatically. AWS needs a human merge and sync.
- Platform changes are normal pull requests. CI renders every chart and validates the output.

To roll back, revert the commit. Changes made directly in a cluster get reverted by Argo CD.

## Relates to

- Charts and images come from GHCR, published by `sample-service` and `platform-tools`.
- `platform-bootstrap` runs `bootstrap/bootstrap-local.sh` through `task cluster:up`.
