# ETCD Practice — Warmup

This README converts the ETCD warmup practice questions into a concise guide for hands-on CKS preparation. The exercises assume a local Minikube control plane and cover encryption at rest, backup & restore, and certificate rotation for etcd.

## Q1 — Enable and Verify ETCD Encryption at Rest

Scenario
: Your Minikube control plane has no data encryption enabled. Configure encryption at rest for Kubernetes Secrets using the `aesgcm` (or `aescbc`) provider.

Tasks

1. Generate a 32-byte base64-encoded encryption key.

   Example:

   ```bash
   head -c 32 /dev/urandom | base64
   ```

2. [Write an encryption configuration file](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#write-an-encryption-configuration-file) at `/etc/kubernetes/encryption-config.yaml` using `aescbc` or `aesgcm`.

   Example file (aesgcm):

   ```yaml
   apiVersion: apiserver.config.k8s.io/v1
   kind: EncryptionConfiguration
   resources:
     - resources:
       - secrets
       providers:
         - aescbc:
             keys:
               - name: key1
                 secret: <BASE64_KEY_HERE>
         - identity: {}
   ```

3.  [Use the new encryption configuration file](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#use-the-new-encryption-configuration-file) in `/etc/kubernetes/manifests/kube-apiserver.yaml`.  

4. Restart the control plane (Minikube will normally restart static pods automatically after file changes).  
`$ watch crictl ps`

5. [Verify encryption](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#verifying-that-data-is-encrypted)(tricky on minikube as etcdctl is not shipped by default, needs extra work):

   ```bash
   kubectl create secret generic test-secret --from-literal=pass=ckstest

   sudo ETCDCTL_API=3 etcdctl get /registry/secrets/default/test-secret \
       --endpoints=https://127.0.0.1:2379 \
       --cacert=/etc/kubernetes/pki/etcd/ca.crt \
       --cert=/etc/kubernetes/pki/etcd/server.crt \
       --key=/etc/kubernetes/pki/etcd/server.key | hexdump -C
   ```

   Expected: an encrypted blob (not readable plaintext) is returned.

---

## Q2 — Backup and Restore ETCD Data

Scenario
: Before upgrading Kubernetes, back up and restore etcd data.

Tasks

1. [Take a snapshot](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#snapshot-using-etcdctl-options):

   ```bash
   sudo ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
       --endpoints=https://127.0.0.1:2379 \
       --cacert=/etc/kubernetes/pki/etcd/ca.crt \
       --cert=/etc/kubernetes/pki/etcd/server.crt \
       --key=/etc/kubernetes/pki/etcd/server.key
   ```

2. [Verify snapshot integrity](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#built-in-snapshot):

   ```bash
   ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db
   ```

3. [Restore from backup](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#restoring-an-etcd-cluster) (example sequence — adjust paths for your system):

   ```bash
   sudo systemctl stop kubelet
   sudo mv /var/lib/etcd /var/lib/etcd.old
   ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
       --data-dir=/var/lib/etcd
   sudo systemctl start kubelet
   ```

4. Confirm cluster returns healthy:

   ```bash
   kubectl get nodes
   ETCDCTL_API=3 etcdctl endpoint health
   ```

Expected: cluster components recover and etcd endpoints report healthy.

---

## Q3 — Rotate ETCD Certificates

Scenario
: ETCD certificates are expiring soon. Rotate and verify them.

Tasks

1. Generate new etcd certificates and place them under `/etc/kubernetes/pki/etcd/`.

2. Update kube-apiserver and etcd static pod manifests to reference the new certificate files.
3. Restart the static pods (Minikube will usually handle restarts when manifest files change) and verify etcd health:

   ```bash
   ETCDCTL_API=3 etcdctl endpoint health
   ```

4. Confirm Kubernetes can still read/write secrets and that pods return to Ready state.

Expected: all pods become Ready and etcdctl operations succeed.

---

## Notes & Tips

- Always keep backups of original manifest and key files before making changes.
- When operating in Minikube, many control-plane artifacts live under `/etc/kubernetes/` on the VM/node — use `minikube ssh` to inspect and modify them.
- Use `ETCDCTL_API=3` when invoking etcdctl for v3 commands.
- For encryption provider selection: `aesgcm` is recommended where available; `aescbc` is commonly used in older examples.

## References

- Kubernetes docs: Encrypting Secrets at Rest
- etcdctl documentation
- Minikube: control plane file locations
