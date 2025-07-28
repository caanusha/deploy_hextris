# Hextris Deployment

This project demonstrates a repeatable, automated process to deploy the **Hextris** game on a local Kubernetes cluster using **Terraform**, **Kind**, **Docker**, **Helm**, and **Makefile** automation.

## Project Structure

```text
.
├── Dockerfile            # Dockerfile to build Hextris image
├── Makefile              # Automation for build, deploy, cleanup
├── helm/
│   └── hextris/          # Helm chart directory for Hextris deployment
│       ├── templates/
│       ├── Chart.yaml
│       └── values.yaml
├── terraform/            # For creating the Kubernetes cluster (Kind)
│   └── main.tf
└── README.md             # This file
```
---

## Table of Contents

- [Prerequisites](#prerequisites)  
- [Setup Instructions](#setup-instructions)
- [Makefile Commands](#makefile-commands)
- [Cleanup](#cleanup)

---

## Prerequisites

Before you start, ensure you have the following installed on your local machine:

- Docker  
- Kind
- kubectl  
- Helm
- Terraform
- Make

Verify installations by running:

```bash
docker --version
kind --version
kubectl version --client
helm version
terraform version
make --version
````

---

## Setup Instructions

1. **Clone this repository**

```bash
git clone https://github.com/caanusha/hextris_deployment.git
cd hextris_deployment
```

2. **Create the Kubernetes cluster and deploy Hextris**

Run the all-in-one command:

```bash
make all
```

This will:

* Create a Kind Kubernetes cluster (if it doesn’t already exist)
* Build the Hextris Docker image (only if it’s not already built)
* Load the Docker image into the Kind cluster
* Deploy Hextris using Helm

3. **Access Hextris (Optional)**

Expose the service using port-forward:

```bash
kubectl port-forward svc/hextris 30080:80 #this can be executed by running make test command
```

Open your browser and visit: [http://localhost:30080](http://localhost:30080)

---

## Makefile Commands

| Command                | Description                                                     |
| ---------------------- | --------------------------------------------------------------- |
| `make build`           | Build Hextris Docker image if not already present               |
| `make load`            | Load Docker image into Kind cluster                             |
| `make deploy`          | Deploy Hextris Helm chart to the Kind cluster                   |
| `make all`             | Run create-cluster, build, load, and deploy stages              |
| `make clean`           | Uninstall Helm release, delete pods, remove images              |
| `make docker-clean`    | Cleans up docker images and current & previous docker instances |
| `make test`            | Port forwards to 30080 for testing purposes                     |

---

## Cleanup

To remove all resources, run:

```bash
make clean
make docker-clean  # Optional, cleans up docker ps and images
```

---
