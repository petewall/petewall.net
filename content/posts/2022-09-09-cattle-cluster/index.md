---
title: "Cattle Cluster"
date: "2022-09-09T21:35:28.000Z"
slug: "cattle-cluster"
draft: false
tags:
  - "homelab"
  - "kubernetes"
  - "raspberrypi"
series:
  - "homelab"
featured_image: "image-4681fb68-4681fb68.jpg"
cover:
  image: "image-4681fb68-4681fb68.jpg"
summary: "When my cluster went down and how I didn't fix it."
---
> Running workloads in Kubernetes: 🤩\
> Keeping workloads running in Kubernetes: 😖
>
> — Pete Wall (@petewall) [September 1, 2022](https://twitter.com/petewall/status/1565345286372741120?ref_src=twsrc%5Etfw)

At the beginning of the month, I noticed that one of the nodes in my Kubernetes clusters went offline. Specifically, the Raspberry Pi. Up until now, that had been one of the most stable nodes, so this was surprising to me. After restarting it a few times, and checking journald, it was clear that it was hitting the limits of its 4GB of memory. Turns out running a [Microk8s](https://microk8s.io/) control node, with a few workloads, was too much for it.

But, a new problem arose when restarting that node several times, the Nginx ingress controller stopped working. The pods would get into restart loops, and in short-order, I saw restart counts in the thousands. This is bad, because this broke all inbound traffic, including this blog! In the past, I've fixed the ingress controller before by killing the pod and letting the daemon set rebuild it. No dice. I tried disabling and re-enabling the [ingress add-on](https://microk8s.io/docs/ingress). It got stuck where it couldn't remove the namespace.

After hours of "fixing" and not getting anywhere, I remembered the old adage:

Treat the cluster like [cattle](https://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/), not like a pet

Rather than trying to troubleshoot each individual issue, pulling pod logs, editing labels, adding `-f` to every `kubectl delete` call, I should save myself the time and energy and rebuild the cluster. So that's what I did. The only PVC, the true data on disk, that I couldn't easily rebuild was this blog. I found the actual volume mount data on the drive, tar'd it, saved it in three places. Then proceeded with the rebuild.

I am so glad that I documented the process that I used to create the cluster and deploy the standard workloads. Once the cluster was online, the workloads were back running within minutes. Carefully extracting the tar'd PVC data, and it was all back online.

What did I learn through this process?

1.  Having the [cluster](https://github.com/petewall/cluster/tree/main/setup) and [workload](https://github.com/petewall/cluster/tree/main/deployments) deployments documented and made into one liner `make deploy` commands made getting things back easy. I felt confident that I didn't forget a step because every change was kept in code.
2.  A 4GB Raspberry Pi is a great tool, but not meant to be part of a highly-available Kubernetes control plane node. It's still a node in the cluster, but only a worker node.
3.  I really need a better backup and restore solution for PVCs. I got lucky that I could `tar -c` and `tar -x` the data that I cared about, but if in the future, the drive crashes, I'm sunk.
4.  I might also prioritize some lightweight monitoring tools. Something that can show the CPU, memory, and disk usage on each node. Ideally having alerts that notify me when the cluster is down or inaccessible.
5.  Finally: treat the cluster like cattle and not like a pet. Always write code with the idea that I'll need to deploy it again in the future.
