---
title: "Portfolio"
date: "2022-09-29T18:29:50.000Z"
slug: "portfolio"
draft: false
---
This is a collection of examples of my work in software. I consider it to be a good representation of both my development abilities as well as my use of software development practices like CI/CD and test automation.

## Professional work

The following have been developed to support the ISV partners during my time at both Pivotal and VMware. Much of this work is closed source and proprietary, but the following is representative of my open source work:

### [Marketplace CLI](https://github.com/vmware-labs/marketplace-cli)

A command-line interface for the VMware Marketplace, enabling automation for both users downloading software and publishers updating their products. I led the design, development in Golang, and user studies. The development is covered by CI/CD pipelines to continuously test all possible product types and functionality.

### [Needs](https://github.com/cf-platform-eng/needs)

A command-line utility that is used in long-running container images as a generalized method to assert that all required inputs are defined and validated at the beginning of execution. I led the design and development, written in Node.js. This is used in our continuous testing system to assert the quality of Tanzu Application Service partner integrations.

### [Self Service CLI](https://github.com/cf-platform-eng/selfservice)

A simple BASH implementation of the REST API for the Self Service system, which allows ISV partners to claim environments for their own learning and testing.

### [Asset Relocation Tool for Kubernetes](https://github.com/vmware-tanzu/asset-relocation-tool-for-kubernetes)

A tool (also called “relok8s”) that rewrites Helm Charts with modified image registry rules. This is used by our Marketplace to copy the chart and all possible images referenced by it to a remote registry.

### [Validated Tanzu Partner Solutions](https://github.com/vmware-tanzu-labs/validated-tanzu-partner-solutions)

A repository to collect reference architectures and deployment automation for VMware ISV partners. I created Tekton pipelines and tasks to deploy Redis Enterprise on Tanzu Kubernetes Grid clusters. These were validated by both VMware and Redis and have been used in co-selling opportunities.

## Personal projects

The following are a collection of a few personal projects that I created to pursue various hobbies and interests. I employ the same enterprise-grade development techniques to ensure the quality of my code.

### [Home Lab Kubernetes Cluster](https://github.com/petewall/cluster)

This summer, I started a new home lab, running Canonical Microk8s to create a 3-node Kubernetes cluster. This cluster is used for deploying a Ghost-based blog, various networking utilities, a Concourse CI/CD system, a set of monitoring solutions including Telegraf, InfluxDB and Grafana. The process for deploying the node operating systems and the Kubernetes workloads are committed and made public to ensure repeatability and reliability.

### [eInk Radiator](https://github.com/petewall/eink-radiator)

This is a Raspberry Pi based firmware to run an eInk screen that can display a variety of slides. Originally written in Python, but in the process of being rearchitected in various languages to support plugins.

### [ESPete](https://github.com/ESPete)

This is a collection of firmware libraries, written in C++ for the ESP8266 platform, to simplify the design and development of other projects.

### [Personal website](__GHOST_URL__/)

My personal website, deployed on the Home Lab cluster using the Ghost platform. I use this to document, describe, and add additional context for the things I am working on. I balance detailed technical information with an approachable style and helpful visuals.
