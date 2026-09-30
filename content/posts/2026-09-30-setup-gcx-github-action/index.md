---
title: "Writing a GitHub Action: setup-gcx"
date: "2026-09-30T12:00:00.000Z"
slug: "setup-gcx-github-action"
draft: true
tags:
  - "github-actions"
  - "grafana"
  - "gcx"
  - "ci-cd"
summary: "I built grafana/setup-gcx, a small GitHub action for installing the gcx CLI in workflows."
cover:
  image: gcx.jpg
  alt: "The word GCX in a bold, circuit-trace style font, with the label 'Grafana CLI' below it."
---
At work, we created [`gcx`](https://github.com/grafana/gcx), a CLI for managing Grafana and Grafana Cloud resources. You can use it to deploy resources as code, or make changes imperatively, or even easily connect it as a skill to your agents. It's a super-useful tool and I've enjoyed incorporating it into my demo repositories to automatically set up OSS Grafana instances. Recently, we've started using it in the testing of the [Kubernetes Monitoring Helm chart](https://github.com/grafana/k8s-monitoring-helm), and since we heavily utilize GitHub Workflows to test them, we needed to install `gcx` into the GitHub runners.

This was before:

```yaml
- name: Install gcx
  if: ${{ startsWith(matrix.test, 'grafana-cloud/ihub') }}
  env:
    GCX_VERSION: 1.1.1
    GCX_SHA256: 7fe8778f5a67e8b60576baa99c39d2eef692082985019b53a57889bde03fb5ed
  run: |
    tarball="gcx_${GCX_VERSION}_linux_amd64.tar.gz"
    url="https://github.com/grafana/gcx/releases/download/v${GCX_VERSION}/${tarball}"
    cd /tmp
    curl -sSL --fail-with-body "${url}" -o "${tarball}"
    echo "${GCX_SHA256}  ${tarball}" | sha256sum -c -
    tar -xzf "${tarball}" gcx
    sudo install -m 0755 gcx /usr/local/bin/gcx
    gcx --version
```

Oof. That's a bit much for a simple task. So... we made our own GitHub Action! One of the things I really like about Grafana Labs is its commitment to open source. We like to say "[Open source is in our DNA](https://grafana.com/oss/)". I love that I'm given the freedom to simply create something useful that should exist! The first version of my `setup-gcx` was released yesterday, and now, all you have to do is:

```yaml
- name: Install gcx
  uses: grafana/setup-gcx@bdf13767f415608f4c1f1940251ce4c5d34dd36b  # v1.0.0
  with:
    version: v1.1.1
```

Much cleaner!

