# CKS-crunch

Practical hands-on exercises and study materials for the Certified Kubernetes Security Specialist (CKS) exam.
to minimize requirements and setups minikube was used as default cluster.

## Overview

This repository collects labs, practice scenarios and helper scripts focused on Kubernetes security topics that commonly appear on the CKS exam: admission controllers, Pod security, network policies, TLS and certificate handling, RBAC, secrets management, runtime security and more.

Content is organized as bite-sized practice labs with step-by-step instructions, broken manifests to fix, and verification commands so you can reproduce exam-style troubleshooting in a local Minikube environment.

## Included labs (examples)

- Admissionwebhook/
- etcd
- host-hardening
- image-hardening
- rbac

## How to lab
there are two types of quesction in each section:
- wamrup 
- 1,2,3 challenge

a warmup is a 101 introduction into topic, so I recommend to do it first.
1,2,3 practise labs are divide into sections A,B,C, where:
- A - problem statement, faulty files -> apply this file to your configuration
- B - steps to verify if problem was resolved
- C - sample solution 

## Quick start

1. Install Minikube and kubectl.
2. Start a Minikube cluster: `minikube start`
3. Inspect a lab folder
4. Follow the lab instructions:

## Best practices covered

- Correctly set `apiGroups` for core resources (use `""` not `"core"`)
- Provide `clientConfig.caBundle` (base64-encoded CA) in webhook configurations
- Ensure Service targetPort matches container port and readiness is healthy
- Use `failurePolicy: Fail` for validating webhooks that must block insecure resources
- Allow API server ingress in NetworkPolicy when webhooks run in-cluster
- Increase `timeoutSeconds` for webhooks to avoid intermittent timeouts

## Contributing

Contributions, bug reports and new practice labs are welcome. Please open an issue describing the lab or improvement, or submit a pull request with a new lab file.

## License

Check the `LICENSE` file (if present) or assume personal use. If you'd like a permissive license added, request one and it can be added to the repo.
