---
title: "Home Lab Revisited: Fully GitOps with Flux"
date: "2026-09-12T12:00:00.000Z"
slug: "home-lab-gitops-flux"
draft: false
tags:
  - "homelab"
  - "kubernetes"
  - "gitops"
  - "flux"
  - "microk8s"
series:
  - "homelab"
summary: "My home lab cluster is now genuinely GitOps-driven with Flux. Here's how the repo is laid out and what it's like to live with."
cover:
  image: cover.jpg
  alt: "A close-up of an aircraft turbine engine, densely wrapped in metal piping and fittings."
---
Back when I [deployed the platform](/home-lab-build-5-deploying-the-platform/) a few years ago, I said I wanted to "rely on Git-ops." That was... mostly true. It was true that everything was committed to a git repository. However, it really was mostly a pile of YAML files that I'd need to go into every directory and `kubectl apply -f` 'em. On the plus side, it was fast to iterate; imperative deployments always are. However, it wasn't true GitOps, where what was in the repository, what was declared to be the desired state, was what was in the cluster. So, I'd rely on my own memory of what was applied and what was pending.

The cluster has changed a *lot* since then, but likely the biggest change is that the whole thing is now genuinely GitOps driven. The [`cluster`](https://github.com/petewall/cluster) repository is now the actual source of truth. If it isn't in `main`, it isn't in the cluster. If I merge it to `main`, it *is* in the cluster, usually within a minute or two, whether I'm at my desk or not.

The tool doing the reconciling is [Flux](https://fluxcd.io/).

![The Flux logo](flux-logo.png)

<small>Logo by the [Flux project](https://fluxcd.io/), licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).</small>

There are a lot of GitOps tools out there, but I had already narrowed it down to either Flux or ArgoCD. Both are Kubernetes-native and CNCF-graduated, which means they'll fit right in on the cluster and they'll have a lot of support. I went with Flux because it's more focused on headless action, and I had been using it at work in the [Helm Chart Toolbox](https://github.com/grafana/helm-chart-toolbox) project. ArgoCD comes with more features that I wouldn't use, like the user interface and multi-cluster support. I see why it's popular, but it was too much for my homelab.

## The mental model

The old way was more imperative: I told the cluster what to *do* ("apply this", "delete that"). The problem with imperative changes is that they don't leave a trail, and the cluster's actual state can easily drift over time away from what was supposed to be there.

The declarative model with Flux flips this around. I declare the state I *want* in Git, and a set of controllers running inside the cluster continuously pull that repo and make reality match it. Delete a Deployment by hand? Flux notices it's missing and puts it back. Remove a file from Git? Flux prunes the corresponding resource from the cluster.

The README at the top of the repo sums up the whole contract in four lines:

> This repository is the source of truth for my Kubernetes cluster. Flux runs
> in the cluster and reconciles state from `main` — anything merged here lands
> on the cluster within a minute or two.

## Bootstrapping

Getting Flux into a cluster is a one-time manual step called *bootstrap*. It's the one imperative command left in the whole workflow, and even it is committed to the repo as a `make bootstrap` target so I don't have to remember the flags:

```bash
flux bootstrap github \
  --owner=petewall \      # The GitHub organization
  --repository=cluster \  # The GitHub repository
  --branch=main \         # The branch to use
  --path=cluster \        # The directory inside of the repo to use
  --personal \            # Use a personal access token
  --components-extra=image-reflector-controller,image-automation-controller \
  --read-write-key
```

That command installs the Flux controllers, creates a deploy key on the GitHub repo, and — this is the clever part — commits Flux's *own* manifests into the repo under `cluster/flux-system/`. From that moment on, Flux manages Flux. Even upgrading the controllers is just a matter of re-running bootstrap, which bumps the versions of the committed manifests, which Flux then applies to itself.

The `--components-extra` flag pulls in the image-reflector and image-automation controllers. They're how the blog you're reading right now deploys itself. I'll come back to those in detail later.

## How the repo is laid out

Flux is pointed at the `cluster/` directory and the files in there tell it what to deploy:

```
cluster/           Flux entrypoint (Kustomization CRs, one per logical unit)
infrastructure/    Cluster-wide controllers and supporting resources
apps/              Workloads I run on the cluster
setup/             Manual steps for provisioning new nodes
```

The `cluster/` directory doesn't contain any actual workloads. It contains two tiny Flux `Kustomization` objects that act as pointers to the two directories where the real content lives. Here's the whole of `cluster/infrastructure.yaml`:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure
  namespace: flux-system
spec:
  interval: 10m
  retryInterval: 1m
  timeout: 10m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure
  prune: true
  wait: true
```

Two things worth calling out:

- **`prune: true`** is what turns "add a file to deploy something" into "delete a file to undeploy something." Removing a resource from Git removes it from the cluster. This is the property that makes Git a true source of truth rather than an append-only wishlist.
- **`wait: true`** makes Flux block until every resource in this Kustomization is actually healthy before it considers the reconcile a success.

The `apps` Kustomization is nearly identical, but with one addition:

```yaml
spec:
  dependsOn:
    - name: infrastructure
```

That `dependsOn` encodes the ordering that used to live in my head. Apps need things like the storage drivers, cert-manager, and the Istio control plane to exist first, so `infrastructure` reconciles fully — `wait: true` — before `apps` is even attempted. No more deploying an app only to watch it `CrashLoop` because the CRD it depends on isn't installed yet.

## What actually lives in the cluster

The `infrastructure/` and `apps/` directories are plain [Kustomize](https://kustomize.io/) overlays. Each has a `kustomization.yaml` that just lists its children. Infrastructure looks like this:

```yaml
resources:
  - sealed-secrets
  - cert-manager
  - databases
  - dynamic-dns
  - istio
  - metrics-server
  - synology-csi
```

And apps:

```yaml
resources:
  - homeassistant
  - krr
  - mealie
  - monitoring
  - ollama
  - petewall-net
```

Adding something new to the cluster is now genuinely a two-line pull request: drop a directory in, add its name to the list. Flux takes it from there.

Most of these directories deploy upstream software through a Flux `HelmRelease`, which allows for using Helm charts without doing the imperative `helm install`, or rendering with `helm template` to a file before committing to the repo. Flux watches the chart repo, and when I bump a version number in Git it performs the upgrade. Here's the entire definition for the Istio control plane, pinned to a specific version:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: istiod
  namespace: istio-system
spec:
  interval: 1h
  dependsOn:
    - name: istio-base
  chart:
    spec:
      chart: istiod
      version: 1.30.4
      sourceRef:
        kind: HelmRepository
        name: istio
  values:
    pilot:
      resources:
        requests:
          cpu: 100m
          memory: 256Mi
        limits:
          memory: 512Mi
```

That `values:` block is exactly what you'd otherwise pass as a `values.yaml` to Helm.

## Living with it day-to-day

The nicest thing about all this is how little I do. A normal change is: edit YAML, open a PR, watch the linters run (that's a whole post of its own <!-- TODO: link to the linting and Renovate post once it's published (/home-lab-linting-and-renovate/) -->), merge. Done. The cluster catches up on its own. I do really like how this means that simple PRs will automatically reconcile. On the other hand, it took a while to realize that I won't `kubectl apply` anything anymore. Simple hacks aren't a thing anymore. Maybe that's a good thing, though.

## The payoff

The concrete win showed up the first time a node got wedged and I had to do a full MicroK8s stop/start on the control-plane node to recover it. In the old world that would have been an afternoon of "wait, what was supposed to be running here?" In the GitOps world it was a non-event: the node came back, Flux reconciled, and every workload returned to exactly the state described in `main`. I didn't apply a single manifest by hand.

That's the whole pitch, really. The cluster is no longer a pet I've lovingly hand-configured and am terrified to reboot. It's a deterministic function of a Git repo. And that repo is the thing the next two posts are about — how traffic gets into it with Istio <!-- TODO: link to the Istio networking post once it's published (/home-lab-istio-networking/) -->, and how I keep the whole thing honest with linting and Renovate <!-- TODO: link to the linting and Renovate post once it's published (/home-lab-linting-and-renovate/) -->.

Cover photo by [ahmet hamdi](https://unsplash.com/@neyn?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/gF_f5jz_gbs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
