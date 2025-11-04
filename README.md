# CKS-crunch

Practical hands-on exercises and study materials for the Certified Kubernetes Security Specialist (CKS) exam.
to minimize requirements and setups minikube was used as default cluster.

## Overview

This repository collects labs, practice scenarios and helper scripts focused on Kubernetes security topics that commonly appear on the CKS exam: admission controllers, Pod security, network policies, TLS and certificate handling, RBAC, secrets management, runtime security and more.

Content is organized as bite-sized practice labs with step-by-step instructions, broken manifests to fix, and verification commands so you can reproduce exam-style troubleshooting in a local Minikube environment.

## Included labs (examples)

- Admissionwebhook/
  - `practise-lab-warmup.txt` - warmup exercises for admission webhooks and TLS setup
  - `practise-lab-1-normal.txt` - validating webhook troubleshooting lab (deny pods running as root)
  - `practise-lab-2-hard.txt` - mutating + validating webhooks (mutate labels, deny root)
  - `practise-lab-3-nightmare.txt` - advanced scenario combining webhooks with NetworkPolicy

Each lab contains:
- broken or incomplete YAML manifests to fix
- commands to generate certificates, create secrets and deploy resources
- verification steps to test admission behavior and troubleshooting tips

## Quick start

1. Install Minikube and kubectl.
2. Start a Minikube cluster: `minikube start`
3. Inspect a lab folder, e.g.:
   - `cd Admissionwebhook`
   - Read the lab file: `less practise-lab-warmup.txt`
4. Follow the lab instructions:

Common commands used in labs:
- Create namespace: `kubectl create namespace <name>`
- Create tls secret: `kubectl create secret tls webhook-certs --cert=tls.crt --key=tls.key -n <namespace>`
- Apply manifests: `kubectl apply -f <manifest.yaml>`
- Test webhook behavior: create pods with `runAsNonRoot` true/false and observe admission responses

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
