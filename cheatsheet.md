# terminal setup 

export pods-logs-dir="cd /var/log/pod"
export container-logs="cd /var/log/container"
export kubelet-logs="journalctl -u kubelet"
export static-manifests="cd /etc/kubernetes/manifest"
export k=kubectl


# create TLS secret docs 
k create secret tls -h

# pod template create and NOT deploy:
k run --image=<image> --dry-run=true > pod.yaml

# create svr for pods/deployment:
k expose pod/deploy -h

# create ingress 
k create ingress -h

# check docker image digest
k get pod -oyaml | grep imageID 

# trivy scan image for specific CVE
trivy image <NAME> | egrep <CVE-XXX>


# find process that uses a port
netstat -tulpan | grep 1234 # list open port 
lsof -i :1234 # what process is using this port ?
ls -l /proc/PID/exe # show symlink to actulal binary
kill -9 PID
rm <binary>