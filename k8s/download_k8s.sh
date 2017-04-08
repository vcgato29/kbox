#!/bin/bash
set -eo pipefail

BASEPATH=/opt/kbox/k8s/kube

echo "Downloading server binaries ..."
curl --progress-bar -L https://dl.k8s.io/$1/kubernetes-server-linux-amd64.tar.gz -o /tmp/kube-linux-amd64-$1.tar.gz
echo "Downloading kubectl binary for mac ..."
curl --progress-bar -L https://dl.k8s.io/$1/kubernetes-client-darwin-amd64.tar.gz -o /tmp/kubectl.tar.gz
echo "Downloading calico/cni binaries ..."
curl --progress-bar -L https://github.com/projectcalico/calicoctl/releases/download/v1.1.1/calicoctl -o $BASEPATH/calicoctl
curl --progress-bar -L https://github.com/projectcalico/cni-plugin/releases/download/v1.6.2/calico -o $BASEPATH/calico
curl --progress-bar -L https://github.com/projectcalico/cni-plugin/releases/download/v1.6.2/calico-ipam -o $BASEPATH/calico-ipam
curl --progress-bar -L https://github.com/containernetworking/cni/releases/download/v0.3.0/cni-v0.3.0.tgz -o /tmp/cni-v0.3.0.tgz

tar -xvf /tmp/kubectl.tar.gz -C $BASEPATH
tar -xvf /tmp/kube-linux-amd64-$1.tar.gz -C $BASEPATH
tar -xvf /tmp/cni-v0.3.0.tgz -C $BASEPATH

mv $BASEPATH/kubernetes/server/bin/kube-apiserver $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-controller-manager $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-proxy $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-scheduler $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kubelet $BASEPATH/
mv $BASEPATH/kubernetes/client/bin/kubectl /opt/kbox/k8s/kubectl

# Clean unused binaries from cni
rm -f $BASEPATH/cnitool
rm -f $BASEPATH/tuning
rm -f $BASEPATH/bridge
rm -f $BASEPATH/ipvlan
rm -f $BASEPATH/macvlan
rm -f $BASEPATH/ptp
rm -f $BASEPATH/dhcp

# Clean before packing it
rm -f /opt/kbox/k8s/kube.tgz
rm -rf $BASEPATH/kubernetes
chmod +x /opt/kbox/k8s/kubectl

echo ""
echo "Packing it ..."
COPYFILE_DISABLE=1 tar -czf /opt/kbox/k8s/kube.tgz -C kube .

echo ""
echo "Clean up ..."
rm -f $BASEPATH/flannel
rm -f $BASEPATH/loopback
rm -f $BASEPATH/host-local
rm -f $BASEPATH/calico*
rm -f $BASEPATH/kube-apiserver
rm -f $BASEPATH/kube-controller-manager
rm -f $BASEPATH/kube-proxy
rm -f $BASEPATH/kube-scheduler
rm -f $BASEPATH/kubelet
rm -f $BASEPATH/calicoctl
echo "Done."
