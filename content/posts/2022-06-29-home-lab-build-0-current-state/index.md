---
title: "Home Lab Build - #0 Current State"
date: "2022-06-29T18:10:17.000Z"
slug: "home-lab-build-0-current-state"
draft: false
tags:
  - "concourse"
  - "homelab"
  - "kubernetes"
  - "raspberrypi"
series:
  - "homelab"
featured_image: "image-0a853171-0a853171.jpg"
cover:
  image: "image-0a853171-0a853171.jpg"
summary: "The history and current state of my home lab, and why it's time to change it."
---
I've been running a small home lab in my basement for many years, as way to host little software projects, or tinker with new ideas. Lately, there's more that I want to run there, but I'm finding that I'm hitting my head on the limits of my current set up. This series will be about how I'm moving from one lab to a new one.

My lab started many years ago when I was working for a contract in which I wrote a piece of software that was deployed on a pair of servers. One server lived in a test environment, the other was a refurbished Mac Mini that I kept in my basement. Nightly, the two servers would synchronize with each other so we could examine the data coming out of the trial. After that contract ended, and later when I left the company, the little Mac stayed with me. Since then, it's mostly run a [Plex](https://www.plex.tv/) media server and also [Concourse](https://concourse-ci.org/) via docker-compose.

The lab expanded when I added a [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) that I could run Kubernetes on with [Microk8s](https://microk8s.io/). The idea was to offload the work that the Mac was doing onto the Pi, and eventually add more Pi's to form a true cluster. The reality was that this was not going to work out the way I imagined.

The problems started showing up the more workloads I wanted to run on the lab. Namely, there are four things that I want to host:

- Some networking processes (DynamicDNS, internal nginx proxy, [cert-manager](https://cert-manager.io/) to handle [Let's Encrypt](https://letsencrypt.org/) for me)
- Concourse, my thing-doer, which I use to build and deploy other projects.
- A set of services to handle the firmware for various Arduino projects.
- This blog

The first problem that really started showing up was the fact that Raspberry Pis run ARM processors. That means that not everything will run on them. Concourse, for example, does not support ARM, so the web and worker processes ran on the Mac (still using docker-compose) and the database was on the Pi. Some clever ingress routing got the networking correct.

Second, the Pi's limited memory also caused trouble. I wanted to run a certain database, but the container image weighed in at several hundred megabytes. That's a bunch of memory to consume on the little machine.

The third and final reason I knew this current lab was not going to last happened on the Mac. I couldn't run Kubernetes on the Mac natively and connect them to the Pi's cluster, so everything ran in Docker. Then I updated Docker Desktop. The most important workload I had there, Concourse, did not work with the Cgroups v2.

So, I started looking into building a new lab, one with real computers running x86 processors. The next posts will cover the hardware that I purchased, how I set it up, and the new cluster that I'll get running there.
