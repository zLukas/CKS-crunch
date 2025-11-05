# setup

1. create `.minikube` directory
``` 
 $ mkdir $USER/.minikube
 $ sudo chown -R $USER $HOME/.minikube; chmod -R u+wrx $HOME/.minikube
```


## install ectdctl in minikube.  
1. ssh to node `minikube ssh`.  
```
# get etcd version
$ docker exec -it $(docker ps | grep 'etcd --advertise' | awk '{print $1}') etcd --version
$ ETCD_VER="x.x.x"   # Use version that matches above result
$ wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz
$ tar xvf etcd-v${ETCD_VER}-linux-amd64.tar.gz
$ sudo mv etcd-v${ETCD_VER}-linux-amd64/etcdctl /usr/local/bin/
```