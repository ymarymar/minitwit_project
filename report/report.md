---
title: "DevOps, Software Evolution & Software Maintenance"
course: "KSDSESM1KU"
date: "May 2026"
students:
  - name: "Corbijn Bulsink"
    email: "jbul@itu.dk"
  - name: "Kasper Larsson"
    email: "kasla@itu.dk"
  - name: "Ymir Arnarson"
    email: "ymar@itu.dk"
  - name: "Magnus Bergstedt"
    email: "magnb@itu.dk"
  - name: "Mathias Søgaard"
    email: "msoeg@itu.dk"
---
 
<!--
Your final report should be maximum 2500 words long, approx 5-6. So, try to be brief and concise, but be sure to include all necessary information listed below. Note, images do not count as words.

Make sure that you link all artifacts that you consider constitutional to your projects together with short descriptions of the linked artifacts from your reports, i.e., link all necessary repositories, issue trackers, monitoring/logging systems, etc.

Since this is a group project and the report is written by a group make sure to indicate for each section the respective author(s).

Build:  ./build-report.sh
-->
 
# Systems Perspective

*Written by Insert Name*

A description and illustration of the:

- Design and architecture of your ITU-MiniTwit systems.
- All dependencies of your ITU-MiniTwit systems on all levels of abstraction and development stages. That is, list and briefly describe all technologies and tools you applied and depend on.
- Describe the current state of your systems, for example using results of static analysis and quality assessments.

## Technology & System choice (Magnus tries to write something that may or may not make sense)

Our system runs across five servers: 
- 3 **Swarm nodes** - Two of these runs both backend, frontend and nginx while one node only has nginx on it. This was done as an extra load balancer within the swarm itself making it the entry point for all trafic entering a node
- 1 **Database server** - Runs PostgreSQL with a dedicated volume from DigitalOcean
- 1 **Monitoring server** - Collects each of the docker containers' logs, as well as metrics via prometheus and  which then is viewable at the Grafana dashboard.  
  
Java was chosen as the backend language due to the team's prior familiarity with it. For the web framework we chose Javalin, a lightweight alternative to larger frameworks like Spring Boot (this was a consideration in terms of the scope of the project in general **THOUGHTS AROUND THIS?**) — it requires far less configuration and setup, which suited the scope of having 5 nodes in total. **(feel free to change this if there are any one who disagrees)**

For container orchestration we used Docker Swarm rather than Kubernetes. Swarm is simpler to operate and sufficient for the scale of this project. The group did also consider Kubernetes but this was scraped due to complexity **(OR WHAT WOULD BE SMART TO WRITE?)**. For cloud hosting we chose DigitalOcean, as the team had access to credits through GitHub Education.

In the early stages of the course, virtual machines were provisioned using Vagrant with a DigitalOcean provider and configured via a provision.sh script. In the latter half of the course, the group migrated over to OpenTofu (*an open-source version of Terraform*) and Ansible for configuration management due to Ansible's promise of idempotency (meaning applying the same operation several times does not affect the system) ( <-- **Arrrgh! I want a better sentence or something!**). The reason for this change to Ansible was that we were able to use Ansible's Vault for storing environment variable instead of having a `.env` file which had to manually edited on each computer as to not accidentally publish keys or other confidential information. 

### Dependencies 
The diagram below shows the dependencies across the project such as build tools, libraries and images for docker containers.

![Dependency diagram](images/dependency-diagram.svg)

`Minitwit-java` uses the `pom.xml` file for managing its dependencies whereas the Svelte frontend uses npm (node package manager) to manage its dependencies. The infrastructure of the VMs is being handled by Terraform which creates the necessary droplets and volumes (for data storage) through the `main.tf` script - Ansible is then provisioning each machine with `base.yml` - installing all the shared dependencies across nodes - and then, depending on the VM, provisions the VM with either `swarm.yml`, `db.yml`, `monitoring.yml`. Then the final *playbook* `deploy.yml` deploys the docker swarm/stack. 

By using OpenTofu in conjunction with Ansible, we have been able to more easily provision each machine an ensure idempotency across the nodes. This also has provided us with an more streamlined approach to initialising new machines.


\newpage

# Process Perspective

*Written by Insert Name*

This perspective should clarify how code or other artifacts come from idea into the running system and everything that happens on the way.

In particular, the following descriptions should be included:

- A complete description and illustration of stages and tools included in the CI/CD pipelines, including deployment and release of your systems.
- How do you monitor your systems and what precisely do you monitor?
- What do you log in your systems and how do you aggregate logs?
- Brief description of how you security hardened your systems.
- How do you handle availability and scaling in your systems?

# Reflection Perspective

*Written by Insert Name*

Describe the biggest issues, how you solved them, and which are major lessons learned with regards to:

- evolution and refactoring
- operation, and
- maintenance

of your ITU-MiniTwit systems. Link back to respective commit messages, issues, tickets, etc. to illustrate these.

Also reflect and describe what was the "DevOps" style of your work. For example, what did you do differently to previous development projects and how did it work?

# Use of Generative AI

*Written by Claude*

ITU's rules on the use of generative AI apply for this report too. They are described here and in detail here. Please follow them. For your report that means that you have to state which generative AI tools have been used for which task(s) in your projects. Additionally, describe how generative AI tools have been used and briefly reflect and discuss how they supported or hindered your work process.