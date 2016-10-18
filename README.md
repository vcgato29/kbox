# Kubernetes Koli cluster for macOS

## Zero to Kubernetes development environment setup under two minutes

**Kbox for macOS** is a command line utility which allows in an easy way to bootstrap and control Kubernetes cluster on a standalone [CoreOS](https://coreos.com) VM machine. VM's `docker` API is exposed to macOS, so you can build your docker images with the same app and use them with Kubernetes. The cluster is customized for running the Koli platform.

> Based on [kube-solo](https://github.com/TheNewNormal/kube-solo-osx/) project

It leverages **macOS native Hypervisor virtualisation framework** of using [corectl](https://github.com/TheNewNormal/corectl) command line tool, so there are no needs to use VirtualBox or any other virtualisation software anymore.

**Includes:** 

- [Helm Classic](https://helm.sh) / [Helm v2](https://github.com/kubernetes/helm) - The Kubernetes Package Manager
- [Calico](https://www.projectcalico.org/) - A layer 3 approach to Virtual Networking

### Download
Head over to the [Releases Page](https://github.com/TheNewNormal/kube-solo-osx/releases) to grab the latest release.


## How to install KBox

### Requirements

  - **macOS 10.10.3** Yosemite or later 
  - Mac 2010 or later for this to work.
  - **Note: [Corectl App](https://github.com/TheNewNormal/corectl.app) must be installed, which will serve as `corectld` server daemon control.**
  - [iTerm2](https://www.iterm2.com/) is required, if not found the app will install it by itself.

### Install:

- Download [Corectl App](https://github.com/TheNewNormal/corectl.app) `latest dmg` from the [Releases Page](https://github.com/TheNewNormal/corectl.app/releases) and install it to `/Applications` folder, it allows to start/stop/update [corectl](https://github.com/TheNewNormal/corectl) tools needed to run CoreOS VMs on macOS

**TODO**

**TL;DR**

- App's files are installed to `~/kube-solo` folder
- App will bootstrap `master+worker` Kubernetes cluster on the single VM
- Mac user home folder is automaticly mounted via NFS (it has to work on Mac end of course) to `/Users/my_user`:`/Users/my_user` on each VM boot, check the [PV example](https://github.com/TheNewNormal/kube-solo-osx/blob/master/examples/pv/nfs-pv-mount-on-pod.md) how to use Persistent Volumes.
- macOS `docker` client is installed to `~/kube-solo/bin` and preset in `OS shell` to be used from there, so you can build `docker` images on the VM and use with Kubernetes
- After successful install you can control `kube-solo` VM via `kbox` cli as well. Cli resides in `~/kube-solo/bin` and `~/bin`folders and has simple commands: `kbox setup|up|halt|destroy|status|ip|ssh|shell`, just add `~/bin` to your pre-set path.

**The install will do the following:**

* All dependent files/folders will be put under `~/kube-solo` folder in the user's home folder e.g `/Users/someuser/kube-solo`. 
* Will download latest CoreOS ISO image (if there is no such one) and run `corectl` to initialise VM 
* When you first time do install or `Up` after destroying Kube-Solo setup, k8s binary files (with the version which was available when the App was built) get copied to VM, this allows to speed up Kubernetes setup.
* It will install `docker, helmc, helm, deis and kubectl` clients to `~/kube-solo/bin/`
* [Kubernetes Dashboard](http://kubernetes.io/docs/user-guide/ui/) and  [DNS](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns) will be installed as add-ons
* Via assigned static IP (it will be shown in first boot and will survive VM's reboots) you can access any port on CoreOS VM
* Persistent sparse disk (QCow2) `data.img` will be created and mounted to `/data` for these mount binds and other folders:

```
/data/var/lib/docker -> /var/lib/docker
/data/var/lib/rkt -> /var/lib/rkt
/var/lib/kubelet sym linked to /data/kubelet
/data/opt/bin
/data/var/lib/etcd2
/data/kubernetes
```

###kbox cli options:

* `kbox setup` will start the configuration wizard (it will remove the ~/kube-solo folder) 
* `kbox up` will start k8solo-01 VM and shell environment will be pre-set as above.
* `kbox halt` will halt the VM
* `kbox destroy` remove the VM
* `kbox status`will show VM's status
* `kbox ip` will show VM's IP
* `kbox ssh` will ssh to VM
* `kbox shell` will open pre-set shell

