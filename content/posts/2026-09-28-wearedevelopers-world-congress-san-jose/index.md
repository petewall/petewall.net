---
title: "WeAreDevelopers World Congress: San Jose Trip Report"
date: "2026-09-28T12:00:00.000Z"
slug: "wearedevelopers-world-congress-san-jose"
draft: true
tags:
  - "talks"
summary: "WeAreDevelopers World Congress 2026 Trip Report"
cover:
  image: duck.jpg
  alt: "The outdoor stage at WeAreDevelopers World Congress North America 2026, with conference logos on a large, red, inflatable \"rubber\" duck."
---
This past week, I attended WeAreDevelopers World Congress in San Jose, California. This was the first time this conference has been held in North America and they started with a huge offering, stating 10,000 attendees! I am fortunate enough to get a budget from my work for learning and professional development, and I was looking for a way to learn about the most up-to-date strategies for being an effective software engineer in the industry today. I'm happy to say that this conference achieved that, along with providing the opportunity to meet many great new people.

{{< figure src="wearedevelopers.jpg" alt="Chris Heilmann from WeAreDevelopers on the mainstage wearing a robe." caption="Chris Heilmann from WeAreDevelopers opening the conference." >}}

Like any software conference these days, so much of the content was focussed on AI. One one hand, it's having such a large impact on everything that you cannot escape it. It must be acknowledged and discussed. On the few occasions where I attended a talk that didn't mention AI, it was refreshing, but also felt lacking. To not talk about AI in a dev conference session is like not talking about ___ (need anecdote here. I was going to say GLP-1s when discussing weight loss, but that might be sensative to some people). The interesting thing I found was about half of the sessions talked about safety and health, either how to run AIs more securely, or how to interact with them in a more healthy way. The other half of the sessions were about how to use AI even more.

I saw a few talks that mentioned the phases of AI development, and where we are along the path.

// can I do an inline chart?
|  * Autocomplete, coding, teams, automatic coding, "dark factories"

We all were amazed with Copilot a few years ago because of the code auto-complete. Now, most of us are well beyond that into coding agents. It's no longer auto complete, it's just "complete". The next phase, where some are in, but most are not, is in teams of agents....

Interestingly, a lot of 'obvious' statements, but ones that really were worth restating
* Plan early. 30 minutes more of early planning can save hours or days of rework later
* The best way to have confidence in AI agent output is to add testing
* AI native engineering orgs and "Dark Factories"
  * The goal is to generate a PR by "fire and forget"

Some big ideas:

Producing code is no longer the bottlenect
  Dsign, compliance, acceptance, risk tolerance and rollback capabilities
We will quickly no longer write code, but we will write documentation for agents to code

...

On the safety side, the big standout was [Docker Sandboxes](https://www.docker.com/products/docker-sandboxes/) (aka SBX), which is a way to run coding agents inside of secure, isolated MicroVMs. This promises to empower us to run their agents to do their work and be super effective. It also lets us to trust that those agents will not be able to access the rest of the computer, because of the file system sandboxing, or collude by resurrecting a [long-dormant German wiki site](https://mashable.com/tech/rogue-ai-agents-commandeered-german-website-and-used-it-as-a-messaging), because of network access restrictions. I'm very curious about SBX and would love to see if I can run sandboxed agents by default whenever I invoke a coding agent. If I can get the safety and control without too much added friction, it might be nice.

{{< figure src="trust.jpg" alt="??? on stage in front of a screen with the words \"Do you trust your agents?\"" caption="??? from Docker giving a keynote talk about sandboxes." >}}

During the workshops explaining sandboxes, I built a sandbox "kit" (an extension of sorts) to run my coding agent with Grafana's new [agento11y](https://github.com/grafana/agento11y/blob/8c953faa3a14837ada38219f0ae3f1fca51d5679/plugins/agento11y/README.md) CLI to capture the conversations, tool calls, and processing the agent does and save it to my Grafana Cloud account. You can [try it for yourself](https://github.com/petewall/agento11y-kit)! Massive shoutout to [Oleg Šelajev](https://github.com/shelajev) and [Michael Irwin](https://mikesir87.io/), both from Docker, for giving great workshops that inspired me to get hands on with the project.

The other half of safety is the human side. How can we protect ourselves from feeling burned out, from feeling aimless, like we've lost something about what made us software engineers? Someone said "it's easy to feel like we're losing what made us special when now anyone can generate code." It's not the code that make software engineers special, its our reasoning ability, our systematic knowlege, and our approach to problem solving that does. Unfortunately, that's still hard to grasp all that when someone says "what do you do?"

[Cassidy Williams](https://cassidoo.co/) gave [an excellent mainstage talk](https://www.youtube.com/watch?v=O42bV8AnvFM) about keeping our brains healthy as we shift more and more of the work to AI. One of the biggest things is to regularly put into place activities that encourages us to learn. I've found that AI can be super helpful for learning, but it can also be super helpful for simply replacing effort. For example, I've used LLM agents a ton to learn about new CNCF technologies, why someone would learn one over the other. That was so useful when preparing for the certification exams. I've also used LLMs to simply "create an ___ that does ___". Nothing gets learned there. The latter is not "wrong", but it doesn't engage our brain like the first one does.

Finally, the health aspect also touches on the importance of community. Gwyneth Peña-Siguenza [gave a talk](https://www.youtube.com/watch?v=pmNhUr9WwIo) about how agent skills helped scale the repositories she was working on, but what stuck out to me was at the end where she emphasized giving to the community.

> When you have the ability to help, you have the responsibility to do so.

I was also inspired by [a talk](https://www.youtube.com/watch?v=-zHvJHX_IKc) by Steve Chen, exectutive director & founder of [Code & Coffee](https://codeandcoffee.org/), who talked about the importance of gathering in-person. I've always loved the community aspect of open source software and about conferences, and I especially love how happy people are when we talk about Grafana. I've kicked around the idea of trying to initiate a developers meetup here in Rochester. Maybe someday... 

{{< figure src="coffee.jpg" alt="Pete holding a small cup of coffee." caption="Conference fuel." >}}

I'd be remiss if I didn't mention being in the Bay Area again. It's been roughly seven years since I had been there and it was great to be back. The weather is perfect, the tech community is unparalleled, and the energy for learning is strong. My wife jokes that whenever I go, I'm visiting the "mother ship". I mean... she's not wrong. I can't deny the excitement I get when I go there, and feel a bit like I'm missing out by being in Minnesota. There's just so much innovation and enthusiasm that it feels infectious.

San Jose itself was a lovely city, and I wish I was able to have seen more of it. It's also just nice to be in a city that's very walkable when the weather's nice. Every morning, I would stop by [Voltaire Coffee Roasters](https://www.voltairecoffeeroasters.com/) and grab an espresso on my walk to the venue. On the the last day, I went to San Pedro Square Market and got an amazing pizza, which was a killer recommendation from the security guard there!

{{< figure src="sanpedro.jpg" alt="A building with a sign that says San Pedro Square Market." caption="San Pedro Square Market." >}}

I'm seriously considering returning to this conference next year. I hope it continues to grow and attract more excellent content.
